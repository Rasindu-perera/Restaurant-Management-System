package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.TableDAO;
import util.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.*;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/finalizeBill")
public class FinalizeBillServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer tableId = (Integer) session.getAttribute("tableId");

        if (tableId == null) {
            request.setAttribute("message", "Session expired or invalid table.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Get latest order ID for this table
            int orderId = 0;
            String findOrder = "SELECT order_id FROM orders WHERE table_id = ? ORDER BY created_at DESC LIMIT 1";
            try (PreparedStatement stmt = conn.prepareStatement(findOrder)) {
                stmt.setInt(1, tableId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    orderId = rs.getInt("order_id");
                } else {
                    request.setAttribute("message", "No recent order found for this table.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }

            // 2. Calculate total from order_items + menu_items
            double total = 0;
            String calcTotal = """
                SELECT oi.quantity, mi.price
                FROM order_items oi
                JOIN menu_items mi ON oi.item_id = mi.item_id
                WHERE oi.order_id = ?
            """;
            try (PreparedStatement stmt = conn.prepareStatement(calcTotal)) {
                stmt.setInt(1, orderId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    int qty = rs.getInt("quantity");
                    double price = rs.getDouble("price");
                    total += qty * price;
                }
            }

            // 3. Insert into payments
            String insertPayment = "INSERT INTO payments (order_id, amount, payment_method, paid_at) VALUES (?, ?, 'Cash', ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertPayment)) {
                stmt.setInt(1, orderId);
                stmt.setDouble(2, total);
                stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                stmt.executeUpdate();
            }

            // 4. Release table
            TableDAO tableDAO = new TableDAO();
            tableDAO.releaseTable(tableId);

            // 5. Clear session flag
            session.removeAttribute("orderSent");

            // 6. Forward with message
            request.setAttribute("message", "Payment successful! Table released.");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error while finalizing bill.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
