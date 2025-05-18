package dao;

import util.DBConnection;
import model.MenuItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class MenuItemDAO {

    // Add new menu item
    public void addMenuItem(MenuItem item) {
        String sql = "INSERT INTO menu_items (name, price, category_id, image_url) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, item.getName());
            stmt.setDouble(2, item.getPrice());
            stmt.setInt(3, item.getCategoryId());
            stmt.setString(4, item.getImageUrl()); // Just filename, e.g., burger.jpg

            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error adding menu item: " + e.getMessage());
        }
    }

    // Get all menu items
    public List<MenuItem> getAllMenuItems() {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT * FROM menu_items";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setImageUrl(rs.getString("image_url")); // Stored as filename only

                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching menu items: " + e.getMessage());
        }

        return items;
    }

    // Delete menu item by ID
    public void deleteMenuItem(int id) {
        String sql = "DELETE FROM menu_items WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting menu item: " + e.getMessage());
        }
    }

    public MenuItem getMenuItemById(int id) {
        MenuItem item = null;
        String sql = "SELECT item_id, name, price, category_id, image_url FROM menu_items WHERE item_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                item = new MenuItem();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setImageUrl(rs.getString("image_url"));
            }
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error fetching menu item by ID: " + e.getMessage());
        }

        return item;
    }

    // Get all categories
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, name FROM categories";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
            rs.close();
        } catch (SQLException e) {
            System.err.println("Error fetching all categories: " + e.getMessage());
        }

        return categories;
    }

    // Update menu item
    public void updateMenuItem(MenuItem item) {
        String sql = "UPDATE menu_items SET name = ?, price = ?, category_id = ?, image_url = ? WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, item.getName());
            stmt.setDouble(2, item.getPrice());
            stmt.setInt(3, item.getCategoryId());
            stmt.setString(4, item.getImageUrl());
            stmt.setInt(5, item.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating menu item: " + e.getMessage());
        }
    }
}

