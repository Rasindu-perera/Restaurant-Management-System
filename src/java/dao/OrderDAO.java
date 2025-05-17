/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Order;
import java.sql.*;
import java.util.*;

public class OrderDAO {
    private Connection getConnection() throws Exception {
        String url = "jdbc:mysql://localhost:3306/hotel";
        String user = "root";
        String pass = "";
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }

    public void addOrder(Order order) throws Exception {
        Connection con = getConnection();
        String sql = "INSERT INTO orders (table_number, item_name, quantity, status) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, order.getTableNumber());
        ps.setString(2, order.getItemName());
        ps.setInt(3, order.getQuantity());
        ps.setString(4, "Pending");
        ps.executeUpdate();
        con.close();
    }

    public void updateOrderStatus(int orderId, String status) throws Exception {
        Connection con = getConnection();
        String sql = "UPDATE orders SET status=? WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, orderId);
        ps.executeUpdate();
        con.close();
    }

    public List<Order> getOrdersByStatus(String status) throws Exception {
        List<Order> list = new ArrayList<>();
        Connection con = getConnection();
        String sql = "SELECT * FROM orders WHERE status=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, status);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Order order = new Order();
            order.setId(rs.getInt("id"));
            order.setTableNumber(rs.getInt("table_number"));
            order.setItemName(rs.getString("item_name"));
            order.setQuantity(rs.getInt("quantity"));
            order.setStatus(rs.getString("status"));
            list.add(order);
        }
        con.close();
        return list;
    }
}