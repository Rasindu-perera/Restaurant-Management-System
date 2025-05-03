
package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.CartItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        double total = 0;
        if (cart != null) {
            for (CartItem item : cart) {
                total += item.getQuantity() * item.getItem().getPrice();
            }
        }

        request.setAttribute("total", total);
        RequestDispatcher dispatcher = request.getRequestDispatcher("bill.jsp");
        dispatcher.forward(request, response);
    }
}
