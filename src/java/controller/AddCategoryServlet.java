package controller;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Category;

import java.io.IOException;

@WebServlet("/admin/addCategory")
public class AddCategoryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");

        Category category = new Category(0, name); // ID is auto-incremented
        CategoryDAO dao = new CategoryDAO();
        dao.addCategory(category);

        response.sendRedirect("categories");
    }
}
