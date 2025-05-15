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

@WebServlet("/kitchen")
public class KitchenDisplayServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Order> kitchenOrders = new OrderDAO().getOrdersByStatus("Sent to Kitchen");
            request.setAttribute("orders", kitchenOrders);
            request.getRequestDispatcher("kitchen.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}