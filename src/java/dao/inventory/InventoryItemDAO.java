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
import model.inventory.InventoryItem;
import util.InventoryDBConnection;

public class InventoryItemDAO {
    private static final Logger LOGGER = Logger.getLogger(InventoryItemDAO.class.getName());
    
    // Get all inventory items
    public List<InventoryItem> getAllItems() {
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name as category_name FROM inventory_items i " +
                     "JOIN categories c ON i.category_id = c.category_id " +
                     "ORDER BY i.name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving inventory items", e);
        }
        
        return items;
    }
    
    // Get items by category ID
    public List<InventoryItem> getItemsByCategory(long categoryId) {
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "WHERE i.category_id = ? " +
                    "ORDER BY i.name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, categoryId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = extractItemFromResultSet(rs);
                    items.add(item);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory items by category ID", e);
        }
        
        return items;
    }
    
    // Get low stock items
    public List<InventoryItem> getLowStockItems() {
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "WHERE i.current_quantity <= i.min_stock_level " +
                    "AND i.min_stock_level IS NOT NULL " + 
                    "ORDER BY i.name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                InventoryItem item = new InventoryItem();
                item.setItemId(rs.getLong("item_id"));
                item.setName(rs.getString("name"));
                item.setCurrentQuantity(rs.getDouble("current_quantity"));
                item.setUnit(rs.getString("unit"));
                item.setCostPerUnit(rs.getDouble("cost_per_unit"));
                item.setMinStockLevel(rs.getDouble("min_stock_level"));
                item.setStorageLocation(rs.getString("storage_location"));
                item.setCategoryId(rs.getLong("category_id"));
                
                // Set category name if available
                if (rs.getString("category_name") != null) {
                    Category category = new Category();
                    category.setCategoryId(rs.getLong("category_id"));
                    category.setName(rs.getString("category_name"));
                    item.setCategory(category);
                }
                
                items.add(item);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting low stock items", e);
        }
        
        return items;
    }
    
    /**
     * Get inventory item by ID
     */
    public InventoryItem getItemById(long itemId) {
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "WHERE i.item_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, itemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractItemFromResultSet(rs);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory item by ID: " + e.getMessage(), e);
        }
        
        return null;
    }
    
    // Add new inventory item
    public boolean addItem(InventoryItem item) {
        String sql = "INSERT INTO inventory_items (name, current_quantity, unit, cost_per_unit, " +
                     "min_stock_level, storage_location, category_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, item.getName());
            stmt.setDouble(2, item.getCurrentQuantity());
            stmt.setString(3, item.getUnit());
            
            if (item.getCostPerUnit() > 0) {
                stmt.setDouble(4, item.getCostPerUnit());
            } else {
                stmt.setNull(4, java.sql.Types.DOUBLE);
            }
            
            if (item.getMinStockLevel() > 0) {
                stmt.setDouble(5, item.getMinStockLevel());
            } else {
                stmt.setNull(5, java.sql.Types.DOUBLE);
            }
            
            stmt.setString(6, item.getStorageLocation());
            stmt.setLong(7, item.getCategoryId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        item.setItemId(generatedKeys.getLong(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new inventory item", e);
        }
        
        return false;
    }
    
    /**
     * Update an existing inventory item
     */
    public boolean updateItem(InventoryItem item) {
        // Check if the description field exists in your database
        String sql = "UPDATE inventory_items SET name = ?, category_id = ?, " +
                    "current_quantity = ?, unit = ?, cost_per_unit = ?, " +
                    "min_stock_level = ?, storage_location = ? " +
                    "WHERE item_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, item.getName());
            
            // Handle categoryId - set NULL if zero
            if (item.getCategoryId() > 0) {
                stmt.setLong(2, item.getCategoryId());
            } else {
                stmt.setNull(2, java.sql.Types.BIGINT);
            }
            
            // Set current quantity
            stmt.setDouble(3, item.getCurrentQuantity());
            
            // Handle unit which could be NULL
            if (item.getUnit() != null && !item.getUnit().isEmpty()) {
                stmt.setString(4, item.getUnit());
            } else {
                stmt.setNull(4, java.sql.Types.VARCHAR);
            }
            
            // Handle cost per unit - set NULL if zero or negative
            if (item.getCostPerUnit() > 0) {
                stmt.setDouble(5, item.getCostPerUnit());
            } else {
                stmt.setNull(5, java.sql.Types.DOUBLE);
            }
            
            // Handle min stock level - set NULL if zero or negative
            if (item.getMinStockLevel() > 0) {
                stmt.setDouble(6, item.getMinStockLevel());
            } else {
                stmt.setNull(6, java.sql.Types.DOUBLE);
            }
            
            // Handle storage location which could be NULL
            if (item.getStorageLocation() != null && !item.getStorageLocation().isEmpty()) {
                stmt.setString(7, item.getStorageLocation());
            } else {
                stmt.setNull(7, java.sql.Types.VARCHAR);
            }
            
            // Set item ID for WHERE clause
            stmt.setLong(8, item.getItemId());
            
            // Execute update and check if any rows were affected
            int rowsAffected = stmt.executeUpdate();
            
            // Log result
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Successfully updated item with ID: " + item.getItemId());
            } else {
                LOGGER.log(Level.WARNING, "No rows affected when updating item with ID: " + item.getItemId());
            }
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating inventory item with ID " + item.getItemId() + ": " + e.getMessage(), e);
            return false;
        }
    }
    
    // Update stock quantity
    public boolean updateStockQuantity(long itemId, double newQuantity) {
        String sql = "UPDATE inventory_items SET current_quantity = ? WHERE item_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, newQuantity);
            stmt.setLong(2, itemId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating stock quantity for item ID: " + itemId, e);
        }
        
        return false;
    }
    
    // Delete inventory item
    public boolean deleteItem(long itemId) {
        // First check if the item is referenced in purchase_items
        String checkSql = "SELECT COUNT(*) FROM purchase_items WHERE item_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection()) {
            // Check if the item is used in purchases
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setLong(1, itemId);
                
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        // Item is referenced in purchases, can't delete
                        return false;
                    }
                }
            }
            
            // If not referenced, proceed with deletion
            String deleteSql = "DELETE FROM inventory_items WHERE item_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setLong(1, itemId);
                
                int rowsAffected = deleteStmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting inventory item: " + e.getMessage(), e);
            return false;
        }
    }
    
    // Search items by name or description
    public List<InventoryItem> searchItems(String searchTerm) {
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "WHERE i.name LIKE ? OR i.description LIKE ? " +
                    "ORDER BY i.name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String term = "%" + searchTerm + "%";
            stmt.setString(1, term);
            stmt.setString(2, term);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = extractItemFromResultSet(rs);
                    items.add(item);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching inventory items", e);
        }
        
        return items;
    }
    
    // Get items by category
    public List<InventoryItem> getItemsByCategory(String category) {
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "WHERE c.name = ? " +
                    "ORDER BY i.name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    InventoryItem item = extractItemFromResultSet(rs);
                    items.add(item);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory items by category", e);
        }
        
        return items;
    }
    
    // Get all items with sorting
    public List<InventoryItem> getAllItems(String sortBy) {
        String orderBy = "i.name"; // Default sort by name
        
        if (sortBy != null) {
            switch (sortBy) {
                case "category":
                    orderBy = "c.name, i.name";
                    break;
                case "stock":
                    orderBy = "i.current_quantity";
                    break;
                case "price":
                    orderBy = "i.cost_per_unit";
                    break;
                case "value":
                    orderBy = "i.current_quantity * i.cost_per_unit DESC";
                    break;
                default:
                    orderBy = "i.name";
            }
        }
        
        List<InventoryItem> items = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM inventory_items i " +
                    "LEFT JOIN categories c ON i.category_id = c.category_id " +
                    "ORDER BY " + orderBy;
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                items.add(extractItemFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory items with sorting", e);
        }
        
        return items;
    }
    
    // Get total inventory item count
    public int getTotalItemCount() {
        String sql = "SELECT COUNT(*) FROM inventory_items";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
             
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting inventory item count", e);
        }
        
        return 0;
    }

    // Get total inventory value
    public double getTotalInventoryValue() {
        String sql = "SELECT SUM(current_quantity * cost_per_unit) FROM inventory_items WHERE cost_per_unit IS NOT NULL";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
             
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total inventory value", e);
        }
        
        return 0;
    }
    
    // Helper method to map ResultSet to InventoryItem
    private InventoryItem mapResultSetToItem(ResultSet rs) throws SQLException {
        InventoryItem item = new InventoryItem();
        item.setItemId(rs.getLong("item_id"));
        item.setName(rs.getString("name"));
        item.setCurrentQuantity(rs.getDouble("current_quantity"));
        item.setUnit(rs.getString("unit"));
        
        // Handle nullable fields
        double costPerUnit = rs.getDouble("cost_per_unit");
        if (!rs.wasNull()) {
            item.setCostPerUnit(costPerUnit);
        }
        
        double minStockLevel = rs.getDouble("min_stock_level");
        if (!rs.wasNull()) {
            item.setMinStockLevel(minStockLevel);
        }
        
        item.setStorageLocation(rs.getString("storage_location"));
        item.setCategoryId(rs.getLong("category_id"));
        
        // Set category
        Category category = new Category();
        category.setCategoryId(rs.getLong("category_id"));
        category.setName(rs.getString("category_name"));
        item.setCategory(category);
        
        return item;
    }
    
    // Helper method to extract InventoryItem from ResultSet
    private InventoryItem extractItemFromResultSet(ResultSet rs) throws SQLException {
        InventoryItem item = new InventoryItem();
        item.setItemId(rs.getLong("item_id"));
        item.setName(rs.getString("name"));
        item.setCurrentQuantity(rs.getDouble("current_quantity"));
        item.setUnit(rs.getString("unit"));
        item.setCostPerUnit(rs.getDouble("cost_per_unit"));
        item.setMinStockLevel(rs.getDouble("min_stock_level"));
        item.setStorageLocation(rs.getString("storage_location"));
        item.setCategoryId(rs.getLong("category_id"));
        
        // Set category object
        if (rs.getString("category_name") != null) {
            Category category = new Category();
            category.setCategoryId(rs.getLong("category_id"));
            category.setName(rs.getString("category_name"));
            item.setCategory(category);
        }
        
        return item;
    }
}
