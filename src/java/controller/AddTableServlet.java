package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.SQLException;



/**
 *
 * @author RasinduPerera
 */
@WebServlet("/admin/add-table")
public class AddTableServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int tableId = Integer.parseInt(request.getParameter("table_id"));
        
            String status = request.getParameter("table_status");
            

            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO tables (table_id, status) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, tableId);
            
            stmt.setString(2, status);
            
            stmt.executeUpdate();

            response.sendRedirect("tables.jsp?success=Table added successfully");
        } catch (IOException | NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("add_table.jsp?error=Error adding table");
        }
    }
}
