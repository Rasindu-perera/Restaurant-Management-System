package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;

import java.io.IOException;
import java.util.List;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/updateCart")
public class UpdateCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] itemIds = request.getParameterValues("itemIds");
        String[] quantities = request.getParameterValues("quantities");

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && itemIds != null && quantities != null) {
            for (int i = 0; i < itemIds.length; i++) {
                int itemId = Integer.parseInt(itemIds[i]);
                int newQty = Integer.parseInt(quantities[i]);

                for (CartItem item : cart) {
                    if (item.getItem().getId() == itemId) {
                        item.setQuantity(newQty);
                        break;
                    }
                }
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }
}
