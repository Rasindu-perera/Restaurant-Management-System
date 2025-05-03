package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;
import model.MenuItem;
import dao.MenuDAO;

import java.io.IOException;
import java.util.*;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        MenuDAO dao = new MenuDAO();
        String[] itemIds = request.getParameterValues("itemIds");

        if (itemIds != null) {
            for (String itemIdStr : itemIds) {
                int itemId = Integer.parseInt(itemIdStr);
                String qtyStr = request.getParameter("quantity_" + itemId);
                int quantity = 0;

                if (qtyStr != null && !qtyStr.isEmpty()) {
                    quantity = Integer.parseInt(qtyStr);
                }

                if (quantity > 0) {
                    MenuItem item = dao.getMenuItemById(itemId);

                    boolean exists = false;
                    for (CartItem ci : cart) {
                        if (ci.getItem().getId() == itemId) {
                            ci.setQuantity(ci.getQuantity() + quantity);
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        CartItem newItem = new CartItem();
                        newItem.setItem(item);
                        newItem.setQuantity(quantity);
                        cart.add(newItem);
                    }
                }
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("cart.jsp");
    }
}
