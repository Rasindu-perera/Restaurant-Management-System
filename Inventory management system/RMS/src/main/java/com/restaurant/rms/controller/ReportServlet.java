package com.restaurant.rms.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ReportServlet", value = "/reports")
public class ReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportType = request.getParameter("type"); // daily, weekly, monthly, purchases

        // Check if the reportType parameter is null or empty
        if (reportType == null || reportType.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid 'type' parameter");
            return;
        }

        String query = "";

        // Determine the query based on the report type
        switch (reportType) {
            case "daily":
                query = "SELECT * FROM daily_stock_usage_report";
                break;
            case "weekly":
                query = "SELECT * FROM weekly_stock_usage_report";
                break;
            case "monthly":
                query = "SELECT * FROM monthly_stock_usage_report";
                break;
            case "purchases":
                query = "SELECT * FROM purchase_trends_report";
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid report type");
                return;
        }

        try (Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/restaurant_inventory", // Change "mariadb" to "mysql"
                "root", // Replace with your MySQL username
                ""  // Replace with your MySQL password
            );
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            request.setAttribute("reportData", rs);
            request.setAttribute("reportType", reportType);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/reports.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}