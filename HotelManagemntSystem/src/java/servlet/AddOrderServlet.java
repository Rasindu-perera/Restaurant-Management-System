/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package servlet;

import dao.OrderDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import model.Order;
import dao.OrderDAO;

@WebServlet("/add-order")
public class AddOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String bill = request.getParameter("bill_number");
        String item = request.getParameter("item_name");
        int qty = Integer.parseInt(request.getParameter("quantity"));

        Order order = new Order();
        order.setBillNumber(bill);
        order.setItemName(item);
        order.setQuantity(qty);

        try {
            new OrderDAO().addOrder(order);
            response.sendRedirect("confirmation.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}