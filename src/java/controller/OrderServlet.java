package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.CartItem;
import dao.OrderDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/sendOrder")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        int waiterId = (Integer) session.getAttribute("waiterId");
        int tableId = (Integer) session.getAttribute("tableId");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && !cart.isEmpty()) {
            OrderDAO dao = new OrderDAO();
            dao.saveOrder(waiterId, tableId, cart);
            session.removeAttribute("cart"); // Clear cart after order is sent
            session.setAttribute("orderSent", true); // Set flag
        }

        response.sendRedirect("cart.jsp");
    }
}
