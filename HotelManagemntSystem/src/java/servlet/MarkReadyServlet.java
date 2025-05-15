/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Order;
import dao.OrderDAO;

@WebServlet("/mark-ready")
public class MarkReadyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("order_id"));
        try {
            new OrderDAO().updateOrderStatus(orderId, "Ready");
            response.sendRedirect("kitchen.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
