package controller;

import dao.MenuItemDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/deleteMenuItem")
public class DeleteMenuItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                MenuItemDAO dao = new MenuItemDAO();
                dao.deleteMenuItem(id);

                System.out.println("Deleted item with ID: " + id);
            } catch (NumberFormatException e) {
                System.err.println("Invalid item ID: " + idParam);
            }
        } else {
            System.err.println("ID param is missing or empty.");
        }

        response.sendRedirect("menu_items"); // Make sure menu_items.jsp is in /admin folder
    }
}
