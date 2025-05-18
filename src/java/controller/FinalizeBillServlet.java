package controller;

import dao.OrderDAO;
import dao.TableDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import model.Order;

@WebServlet("/finalizeBill")
public class FinalizeBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Connection conn = null;
        
        try {
            // Check if session exists
            if (session == null) {
                request.setAttribute("error", "Session expired. Please login again.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Get and validate tableId from session
            Integer tableId = (Integer) session.getAttribute("tableId");
            if (tableId == null) {
                request.setAttribute("error", "Table information not found. Please select a table first.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // Check if order exists for the table
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getCurrentOrderByTable(tableId);
            if (order == null) {
                request.setAttribute("error", "No active order found for this table.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // Validate order status
            if ("completed".equalsIgnoreCase(order.getStatus())) {
                request.setAttribute("error", "This order has already been completed.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Calculate total
            double total = calculateOrderTotal(order.getOrderId(), conn);
            if (total <= 0) {
                throw new ServletException("Invalid order total. Please check the order items.");
            }
            
            // Insert payment with default payment method
            String insertPayment = "INSERT INTO payments (order_id, amount, payment_method, paid_at) VALUES (?, ?, 'Cash', ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertPayment)) {
                stmt.setInt(1, order.getOrderId());
                stmt.setDouble(2, total);
                stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected == 0) {
                    throw new SQLException("Failed to insert payment record.");
                }
            }

            // Save bill data
            String insertBill = """
                INSERT INTO bill (table_id, order_id, item_name, qty, price)
                SELECT o.table_id, o.order_id, mi.name, oi.quantity, mi.price
                FROM orders o
                JOIN order_items oi ON o.order_id = oi.order_id
                JOIN menu_items mi ON oi.item_id = mi.item_id
                WHERE o.order_id = ?
            """;
            try (PreparedStatement stmt = conn.prepareStatement(insertBill)) {
                stmt.setInt(1, order.getOrderId());
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected == 0) {
                    throw new SQLException("Failed to save bill data.");
                }
            }

            // Update order status to 'completed'
            String updateOrderSql = "UPDATE orders SET status = 'completed' WHERE order_id = ? AND status = 'READY'";
            try (PreparedStatement stmt = conn.prepareStatement(updateOrderSql)) {
                stmt.setInt(1, order.getOrderId());
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected == 0) {
                    throw new SQLException("Failed to update order status. Order might have been already completed or doesn't exist.");
                }
            }

            // Update table status with created_at
            String updateTableSql = "UPDATE tables SET status = 'available', reserved_by = NULL, created_at = CURRENT_TIMESTAMP WHERE table_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateTableSql)) {
                stmt.setInt(1, tableId);
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected == 0) {
                    throw new SQLException("Failed to update table status.");
                }
            }

            conn.commit(); // Commit transaction
            
            // Clear session attributes
            session.removeAttribute("orderSent");
            session.removeAttribute("cart");
            session.removeAttribute("tableId");
            
            // Set success message
            request.setAttribute("message", "Payment successful! Table released.");
            request.getRequestDispatcher("success.jsp").forward(request, response);
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    System.err.println("Error during rollback: " + ex.getMessage());
                }
            }
            System.err.println("Error processing payment: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error processing payment: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    private double calculateOrderTotal(int orderId, Connection conn) throws SQLException {
        double total = 0;
        String sql = """
            SELECT oi.quantity, mi.price
            FROM order_items oi
            JOIN menu_items mi ON oi.item_id = mi.item_id
            WHERE oi.order_id = ?
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                total += rs.getInt("quantity") * rs.getDouble("price");
            }
        }
        return total;
    }
}