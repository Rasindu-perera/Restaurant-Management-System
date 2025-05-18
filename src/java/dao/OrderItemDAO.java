package dao;

import model.MenuItem;
import util.DBConnection;
import model.OrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderItemDAO {

    public Map<MenuItem, Integer> getOrderItemsWithDetails(int orderId) {
        Map<MenuItem, Integer> itemMap = new HashMap<>();

        String sql = "SELECT oi.quantity, mi.item_id, mi.name, mi.price, mi.image_url " +
                     "FROM order_items oi " +
                     "JOIN menu_items mi ON oi.item_id = mi.item_id " +
                     "WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setImageUrl(rs.getString("image_url"));

                int quantity = rs.getInt("quantity");
                itemMap.put(item, quantity);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return itemMap;
    }
    public List<OrderItem> getItemsByOrderId(int orderId) {
    List<OrderItem> items = new ArrayList<>();
    String sql = """
        SELECT oi.*, mi.name as item_name, mi.price 
        FROM order_items oi 
        JOIN menu_items mi ON oi.item_id = mi.item_id 
        WHERE oi.order_id = ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, orderId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            OrderItem item = new OrderItem();
            item.setOrderId(orderId);  // Set the order ID
            item.setItemId(rs.getInt("item_id"));
            item.setItemName(rs.getString("item_name"));
            item.setPrice(rs.getDouble("price"));
            item.setQuantity(rs.getInt("quantity"));
            items.add(item);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return items;
}

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setItemName(rs.getString("item_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                orderItems.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItems;
    }

}

