
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.MenuItem;
import dao.MenuDAO;
import java.io.IOException;
import java.util.List;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MenuDAO dao = new MenuDAO();
        List<MenuItem> foodItems = dao.getItemsByCategory("food");
        List<MenuItem> drinkItems = dao.getItemsByCategory("drink");

        request.setAttribute("foodItems", foodItems);
        request.setAttribute("drinkItems", drinkItems);

        RequestDispatcher dispatcher = request.getRequestDispatcher("menu.jsp");
        dispatcher.forward(request, response);
    }
}

