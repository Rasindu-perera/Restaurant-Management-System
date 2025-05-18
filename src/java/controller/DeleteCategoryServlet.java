package controller;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/deleteCategory")
public class DeleteCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int categoryId = Integer.parseInt(idParam);

                CategoryDAO dao = new CategoryDAO();
                dao.deleteCategory(categoryId);

            } catch (NumberFormatException e) {
                e.printStackTrace();
                // Optionally: Log error or show message to admin
            }
        }

        response.sendRedirect("categories");
    }
}
