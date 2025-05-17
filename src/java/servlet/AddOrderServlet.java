/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import model.Order;
import dao.OrderDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AddOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int tableNumber = Integer.parseInt(request.getParameter("tableNumber"));
            String itemName = request.getParameter("itemName");
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            Order order = new Order();
            order.setTableNumber(tableNumber);
            order.setItemName(itemName);
            order.setQuantity(quantity);

            new OrderDAO().addOrder(order);
            response.sendRedirect("orderForm.jsp?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderForm.jsp?error=true");
        }
    }
}