/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.OrderDAO;
import model.Order;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.annotation.*;


public class KitchenDisplayServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Order> kitchenOrders = new OrderDAO().getOrdersByStatus("Sent to Kitchen");
            request.setAttribute("orders", kitchenOrders);
            RequestDispatcher rd = request.getRequestDispatcher("kitchen.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}