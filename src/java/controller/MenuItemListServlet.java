package controller;


import dao.MenuItemDAO;
import dao.CategoryDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.MenuItem;
import model.Category;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/menu_items")
public class MenuItemListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MenuItemDAO menuDao = new MenuItemDAO();
        CategoryDAO categoryDao = new CategoryDAO();

        List<MenuItem> items = menuDao.getAllMenuItems();
        List<Category> categories = categoryDao.getAllCategories();
        
        request.setAttribute("menuItems", items);
        request.setAttribute("categories", categories);
        RequestDispatcher dispatcher = request.getRequestDispatcher("menu_items.jsp");
        dispatcher.forward(request, response);
    }
}
