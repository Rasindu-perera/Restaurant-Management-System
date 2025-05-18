package dao;

import model.Bill;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class BillDAO {
    
    public boolean saveBill(int tableId, int orderId, String itemName, int qty, double price) {
        String sql = "INSERT INTO bill (table_id, order_id, item_name, qty, price, total) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            double total = qty * price;
            stmt.setInt(1, tableId);
            stmt.setInt(2, orderId);
            stmt.setString(3, itemName);
            stmt.setInt(4, qty);
            stmt.setDouble(5, price);
            stmt.setDouble(6, total);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Bill> getBillsByTable(int tableId) {
        List<Bill> bills = new ArrayList<>();
        String sql = """
            SELECT b.*, o.created_at as order_time
            FROM bill b
            JOIN orders o ON b.order_id = o.order_id
            WHERE b.table_id = ?
            ORDER BY o.created_at DESC, b.bill_id DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setTableId(rs.getInt("table_id"));
                bill.setOrderId(rs.getInt("order_id"));
                bill.setTime(rs.getTimestamp("order_time"));
                bill.setItemName(rs.getString("item_name"));
                bill.setQty(rs.getInt("qty"));
                bill.setPrice(rs.getDouble("price"));
                bill.setTotal(rs.getDouble("total"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }
    
    public Timestamp getLatestBillTime(int tableId) {
        String sql = """
            SELECT MAX(o.created_at) as latest_time 
            FROM bill b
            JOIN orders o ON b.order_id = o.order_id
            WHERE b.table_id = ?
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getTimestamp("latest_time");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public double getTotalBillAmount(int tableId) {
        String sql = "SELECT SUM(total) as total_amount FROM bill WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total_amount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Gets daily sales data for a specific date
     * @param date The date to get sales for (format: yyyy-MM-dd)
     * @return List of bills for that day
     */
    public List<Bill> getDailySales(String date) {
        List<Bill> bills = new ArrayList<>();
        String sql = """
            SELECT b.*, o.created_at as order_time
            FROM bill b
            JOIN orders o ON b.order_id = o.order_id
            WHERE DATE(o.created_at) = ?
            ORDER BY o.created_at
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, date);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setTableId(rs.getInt("table_id"));
                bill.setOrderId(rs.getInt("order_id"));
                bill.setTime(rs.getTimestamp("order_time"));
                bill.setItemName(rs.getString("item_name"));
                bill.setQty(rs.getInt("qty"));
                bill.setPrice(rs.getDouble("price"));
                bill.setTotal(rs.getDouble("total"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    /**
     * Gets item sales summary for a specific date
     * @param date The date to get sales for (format: yyyy-MM-dd)
     * @return Map with item name as key and total quantity sold as value
     */
    public Map<String, Integer> getItemSalesByDate(String date) {
        Map<String, Integer> itemSales = new HashMap<>();
        String sql = """
            SELECT b.item_name, SUM(b.qty) as total_qty
            FROM bill b
            JOIN orders o ON b.order_id = o.order_id
            WHERE DATE(o.created_at) = ?
            GROUP BY b.item_name
            ORDER BY total_qty DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, date);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                itemSales.put(rs.getString("item_name"), rs.getInt("total_qty"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemSales;
    }

    /**
     * Gets daily total income
     * @param date The date to calculate income for (format: yyyy-MM-dd)
     * @return Total income for that day
     */
    public double getDailyIncome(String date) {
        String sql = """
            SELECT SUM(b.total) as daily_income
            FROM bill b
            JOIN orders o ON b.order_id = o.order_id
            WHERE DATE(o.created_at) = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, date);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("daily_income");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Gets most popular items across all time
     * @param limit Maximum number of items to return
     * @return Map with item name as key and total quantity sold as value
     */
    public Map<String, Integer> getMostPopularItems(int limit) {
        Map<String, Integer> popularItems = new LinkedHashMap<>(); // preserve insertion order
        String sql = """
            SELECT item_name, SUM(qty) as total_qty
            FROM bill
            GROUP BY item_name
            ORDER BY total_qty DESC
            LIMIT ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                popularItems.put(rs.getString("item_name"), rs.getInt("total_qty"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return popularItems;
    }
}