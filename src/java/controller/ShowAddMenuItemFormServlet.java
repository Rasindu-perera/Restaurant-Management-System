package controller;

import dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Category;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/showAddMenuItem")
public class ShowAddMenuItemFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("categories", categories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/add_menu_item.jsp");
        dispatcher.forward(request, response);
    }
}
