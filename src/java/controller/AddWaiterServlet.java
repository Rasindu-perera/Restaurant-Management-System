package controller;

import model.Waiter;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/admin/addWaiter")
public class AddWaiterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Handles POST request to add a waiter
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get waiter_id and name from form
        String waiterIdStr = request.getParameter("waiter_id");
        String name = request.getParameter("name");

        try {
            int waiterId = Integer.parseInt(waiterIdStr);

            int rowsInserted;
            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO waiters (waiter_id, name) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, waiterId);
                    stmt.setString(2, name);
                    rowsInserted = stmt.executeUpdate();
                }
            }

            if (rowsInserted > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/waiters");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/add_waiter.jsp?error=insert_failed");
            }

        } catch (IOException | NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/add_waiter.jsp?error=exception");
        }
    }
}
