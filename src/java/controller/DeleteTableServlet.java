package controller;

import dao.TableDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/delete-table")
public class DeleteTableServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int tableId = Integer.parseInt(idParam);
                TableDAO dao = new TableDAO();
                dao.deleteTable(tableId);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                // Optionally log or handle invalid table id
            }
        }

        response.sendRedirect("tables.jsp");
    }
}
