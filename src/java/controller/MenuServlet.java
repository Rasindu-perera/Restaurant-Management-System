package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Category;
import model.MenuItem;
import dao.CategoryDAO;
import dao.MenuDAO;

import java.io.IOException;
import java.util.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        MenuDAO menuDAO = new MenuDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Category> categories = categoryDAO.getAllCategories();
        Map<String, List<MenuItem>> categorizedMenu = new LinkedHashMap<>();

        for (Category category : categories) {
            List<MenuItem> items = menuDAO.getItemsByCategory(category.getName());
            categorizedMenu.put(category.getName(), items);
        }

        request.setAttribute("categorizedMenu", categorizedMenu);
        RequestDispatcher dispatcher = request.getRequestDispatcher("menu.jsp");
        dispatcher.forward(request, response);
    }
}
