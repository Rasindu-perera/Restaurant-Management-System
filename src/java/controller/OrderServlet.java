package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.CartItem;
import dao.OrderDAO;

import java.io.IOException;
import java.util.List;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/sendOrder")
public class OrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            int waiterId = (Integer) session.getAttribute("waiterId");
            int tableId = (Integer) session.getAttribute("tableId");
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
                request.setAttribute("error", "Cart is empty");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }

            OrderDAO dao = new OrderDAO();
            boolean success = dao.saveOrder(waiterId, tableId, cart);
            
            if (success) {
                session.removeAttribute("cart"); // Clear cart after order is sent
                session.setAttribute("orderSent", true); // Set flag
                request.setAttribute("successMessage", "Order sent successfully!"); // Add success message
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to save order. Please try again.");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}