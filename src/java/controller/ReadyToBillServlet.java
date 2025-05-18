package controller;

import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Order;

@WebServlet("/ReadyToBillServlet")
public class ReadyToBillServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReadyToBillServlet.class.getName());
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Connection conn = null;
        
        try {
            // Get tableId from request
            String tableIdParam = request.getParameter("tableId");
            if (tableIdParam == null || tableIdParam.isEmpty()) {
                LOGGER.log(Level.WARNING, "Table ID parameter is missing");
                request.setAttribute("error", "Table ID is required");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            int tableId = Integer.parseInt(tableIdParam);
            LOGGER.log(Level.INFO, "Processing ready to bill for table ID: {0}", tableId);
            
            // Get database connection
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Get all READY orders for this table
            OrderDAO orderDAO = new OrderDAO();
            List<Order> readyOrders = new ArrayList<>();
            
            // Get all orders with status READY for this table
            String getReadyOrdersSql = "SELECT * FROM orders WHERE table_id = ? AND status = 'READY'";
            try (PreparedStatement stmt = conn.prepareStatement(getReadyOrdersSql)) {
                stmt.setInt(1, tableId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Order order = new Order();
                        order.setOrderId(rs.getInt("order_id"));
                        order.setTableId(rs.getInt("table_id"));
                        order.setWaiterId(rs.getInt("waiter_id"));
                        order.setStatus(rs.getString("status"));
                        order.setCreatedAt(rs.getTimestamp("created_at"));
                        readyOrders.add(order);
                    }
                }
            }
            
            if (readyOrders.isEmpty()) {
                LOGGER.log(Level.WARNING, "No READY orders found for table ID: {0}", tableId);
                request.setAttribute("error", "No READY orders found for this table");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Process each READY order
            for (Order order : readyOrders) {
                int orderId = order.getOrderId();
                
                // Save bill data for this order
                String insertBillSql = "INSERT INTO bill (table_id, order_id, item_name, qty, price) " +
                                      "SELECT o.table_id, o.order_id, mi.name, oi.quantity, mi.price " +
                                      "FROM orders o " +
                                      "JOIN order_items oi ON o.order_id = oi.order_id " +
                                      "JOIN menu_items mi ON oi.item_id = mi.item_id " +
                                      "WHERE o.order_id = ?";
                
                try (PreparedStatement stmt = conn.prepareStatement(insertBillSql)) {
                    stmt.setInt(1, orderId);
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected == 0) {
                        LOGGER.log(Level.WARNING, "No bill items saved for order ID: {0}", orderId);
                        throw new SQLException("Failed to save bill data for order " + orderId);
                    }
                    
                    LOGGER.log(Level.INFO, "Saved {0} bill items for order ID: {1}", new Object[]{rowsAffected, orderId});
                }
                
                // Update order status to COMPLETED
                String updateOrderSql = "UPDATE orders SET status = 'COMPLETED' WHERE order_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateOrderSql)) {
                    stmt.setInt(1, orderId);
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected == 0) {
                        LOGGER.log(Level.WARNING, "Failed to mark order {0} as COMPLETED", orderId);
                        throw new SQLException("Failed to update order status for order " + orderId);
                    }
                }
                
                LOGGER.log(Level.INFO, "Order {0} successfully marked as COMPLETED", orderId);
            }
            
            conn.commit(); // Commit transaction
            
            // Redirect to the view bill page for this table
            response.sendRedirect("ViewBillServlet?tableId=" + tableId);
            
        } catch (ServletException | IOException | NumberFormatException | SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
            
            LOGGER.log(Level.SEVERE, "Error processing ready to bill", e);
            request.setAttribute("error", "Error preparing bill: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
            
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
    }
}