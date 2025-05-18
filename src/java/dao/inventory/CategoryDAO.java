package dao.inventory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.inventory.Category;
import util.InventoryDBConnection;

public class CategoryDAO {
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());
    
    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, name FROM categories ORDER BY name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getLong("category_id"));
                category.setName(rs.getString("name"));
                categories.add(category);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all categories: " + e.getMessage(), e);
        }
        
        return categories;
    }
    
    /**
     * Get all category names as strings
     */
    public List<String> getAllCategoryNames() {
        List<String> categoryNames = new ArrayList<>();
        String sql = "SELECT name FROM categories ORDER BY name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                categoryNames.add(rs.getString("name"));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting category names", e);
        }
        
        return categoryNames;
    }
    
    // Get category by ID
    public Category getCategoryById(long categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getLong("category_id"));
                    category.setName(rs.getString("name"));
                    
                    return category;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving category with ID: " + categoryId, e);
        }
        
        return null;
    }
    
    // Add new category - remove description field
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, category.getName());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setCategoryId(generatedKeys.getLong(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding category", e);
        }
        
        return false;
    }
    
    // Update category
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ? WHERE category_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category.getName());
            stmt.setLong(2, category.getCategoryId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating category", e);
            return false;
        }
    }
    
    // Delete category
    public boolean deleteCategory(long categoryId) {
        // First check if the category is in use
        String checkSql = "SELECT COUNT(*) FROM inventory_items WHERE category_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection()) {
            
            // Check if category is in use
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setLong(1, categoryId);
                
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Category is in use, cannot delete
                        return false;
                    }
                }
            }
            
            // If not in use, proceed with deletion
            String deleteSql = "DELETE FROM categories WHERE category_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setLong(1, categoryId);
                
                int rowsAffected = deleteStmt.executeUpdate();
                return rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting category", e);
            return false;
        }
    }
    
    // Get total category count
    public int getTotalCategoryCount() {
        String sql = "SELECT COUNT(*) FROM categories";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
             
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting category count", e);
        }
        
        return 0;
    }
}
