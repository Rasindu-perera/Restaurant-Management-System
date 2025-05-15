/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Order;
import util.DBUtil;

import java.sql.*;
import java.util.*;
import model.Order;

public class OrderDAO {
    public void addOrder(Order order) throws Exception {
        String sql = "INSERT INTO orders (bill_number, item_name, quantity) VALUES (?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, order.getBillNumber());
            ps.setString(2, order.getItemName());
            ps.setInt(3, order.getQuantity());
            ps.executeUpdate();
        }
    }

    public List<Order> getOrdersByStatus(String status) throws Exception {
        String sql = "SELECT * FROM orders WHERE status = ?";
        List<Order> list = new ArrayList<>();
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setBillNumber(rs.getString("bill_number"));
                order.setItemName(rs.getString("item_name"));
                order.setQuantity(rs.getInt("quantity"));
                order.setStatus(rs.getString("status"));
                list.add(order);
            }
        }
        return list;
    }

    public void updateOrderStatus(int orderId, String status) throws Exception {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }
}