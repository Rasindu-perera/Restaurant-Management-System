/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.OrderDAO;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class SendToKitchenServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            new OrderDAO().updateOrderStatus(orderId, "Sent to Kitchen");
            response.sendRedirect("orderForm.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}