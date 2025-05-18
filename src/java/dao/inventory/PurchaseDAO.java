package dao.inventory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.inventory.Purchase;
import model.inventory.PurchaseItem;
import model.inventory.Supplier;
import model.inventory.InventoryItem;
import util.InventoryDBConnection;

public class PurchaseDAO {
    private static final Logger LOGGER = Logger.getLogger(PurchaseDAO.class.getName());
    
    // Get all purchases
    public List<Purchase> getAllPurchases() {
        List<Purchase> purchases = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                     "FROM purchases p " +
                     "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                     "ORDER BY p.purchase_date DESC";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Purchase purchase = mapResultSetToPurchase(rs);
                
                // Get purchase items
                purchase.setItems(getPurchaseItemsForPurchase(purchase.getPurchaseId()));
                
                purchases.add(purchase);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving purchases", e);
        }
        
        return purchases;
    }
    
    // Get purchase by ID
    public Purchase getPurchaseById(long purchaseId) {
        String sql = "SELECT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                     "FROM purchases p " +
                     "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                     "WHERE p.purchase_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, purchaseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Purchase purchase = mapResultSetToPurchase(rs);
                    
                    // Get purchase items
                    purchase.setItems(getPurchaseItemsForPurchase(purchaseId));
                    
                    return purchase;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving purchase with ID: " + purchaseId, e);
        }
        
        return null;
    }
    
    // Get purchase items for a purchase
    private List<PurchaseItem> getPurchaseItemsForPurchase(long purchaseId) {
        List<PurchaseItem> items = new ArrayList<>();
        // Check if your actual table has "id" or "purchase_item_id"
        String sql = "SELECT pi.*, i.name as item_name, i.unit, i.category_id " +
                     "FROM purchase_items pi " +
                     "JOIN inventory_items i ON pi.item_id = i.item_id " +
                     "WHERE pi.purchase_id = ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, purchaseId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PurchaseItem item = new PurchaseItem();
                    item.setId(rs.getLong("purchase_item_id"));
                    item.setPurchaseId(rs.getLong("purchase_id"));
                    item.setItemId(rs.getLong("item_id"));
                    item.setQuantity(rs.getDouble("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    item.setExpiryDate(rs.getDate("expiry_date"));
                    item.setBatchNumber(rs.getString("batch_number"));
                    
                    // Set inventory item
                    InventoryItem inventoryItem = new InventoryItem();
                    inventoryItem.setItemId(rs.getLong("item_id"));
                    inventoryItem.setName(rs.getString("item_name"));
                    inventoryItem.setUnit(rs.getString("unit"));
                    inventoryItem.setCategoryId(rs.getLong("category_id"));
                    item.setItem(inventoryItem);
                    
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving purchase items for purchase ID: " + purchaseId, e);
        }
        
        return items;
    }
    
    // Add new purchase with items
    public boolean addPurchase(Purchase purchase) {
        Connection conn = null;
        try {
            conn = InventoryDBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Insert purchase
            String purchaseSql = "INSERT INTO purchases (supplier_id, purchase_date, purchase_time, " +
                               "invoice_number, total_cost, notes, created_by) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(purchaseSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setLong(1, purchase.getSupplierId());
                stmt.setTimestamp(2, purchase.getPurchaseDate());
                stmt.setTime(3, purchase.getPurchaseTime());
                stmt.setString(4, purchase.getInvoiceNumber());
                stmt.setDouble(5, purchase.getTotalCost());
                stmt.setString(6, purchase.getNotes());
                
                if (purchase.getCreatedBy() > 0) {
                    stmt.setLong(7, purchase.getCreatedBy());
                } else {
                    stmt.setNull(7, java.sql.Types.BIGINT);
                }
                
                int affectedRows = stmt.executeUpdate();
                
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            long purchaseId = generatedKeys.getLong(1);
                            purchase.setPurchaseId(purchaseId);
                            
                            // Insert purchase items
                            boolean itemsAdded = addPurchaseItems(conn, purchase);
                            
                            if (itemsAdded) {
                                // Update inventory quantities
                                boolean inventoryUpdated = updateInventoryForPurchase(conn, purchase);
                                
                                if (inventoryUpdated) {
                                    conn.commit();
                                    return true;
                                } else {
                                    conn.rollback();
                                    LOGGER.log(Level.SEVERE, "Failed to update inventory quantities");
                                }
                            } else {
                                conn.rollback();
                                LOGGER.log(Level.SEVERE, "Failed to add purchase items");
                            }
                        }
                    }
                }
            }
            
            conn.rollback();
            return false;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new purchase", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection", e);
                }
            }
        }
        
        return false;
    }
    
    // Add purchase items
    private boolean addPurchaseItems(Connection conn, Purchase purchase) throws SQLException {
        String sql = "INSERT INTO purchase_items (purchase_id, item_id, quantity, unit_price, " +
                     "expiry_date, batch_number) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (PurchaseItem item : purchase.getItems()) {
                stmt.setLong(1, purchase.getPurchaseId());
                stmt.setLong(2, item.getItemId());
                stmt.setDouble(3, item.getQuantity());
                stmt.setDouble(4, item.getUnitPrice());
                
                if (item.getExpiryDate() != null) {
                    stmt.setDate(5, item.getExpiryDate());
                } else {
                    stmt.setNull(5, java.sql.Types.DATE);
                }
                
                stmt.setString(6, item.getBatchNumber());
                
                stmt.addBatch();
            }
            
            int[] batchResults = stmt.executeBatch();
            
            // Check if all inserts were successful
            for (int result : batchResults) {
                if (result <= 0) {
                    return false;
                }
            }
            
            return true;
        }
    }
    
    // Update inventory quantities for a purchase
    private boolean updateInventoryForPurchase(Connection conn, Purchase purchase) throws SQLException {
        String sql = "UPDATE inventory_items SET current_quantity = current_quantity + ? " +
                     "WHERE item_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (PurchaseItem item : purchase.getItems()) {
                stmt.setDouble(1, item.getQuantity());
                stmt.setLong(2, item.getItemId());
                
                stmt.addBatch();
            }
            
            int[] batchResults = stmt.executeBatch();
            
            // Check if all updates were successful
            for (int result : batchResults) {
                if (result <= 0) {
                    return false;
                }
            }
            
            return true;
        }
    }
    
    // Helper method to map ResultSet to Purchase
    private Purchase mapResultSetToPurchase(ResultSet rs) throws SQLException {
        Purchase purchase = new Purchase();
        purchase.setPurchaseId(rs.getLong("purchase_id"));
        purchase.setSupplierId(rs.getLong("supplier_id"));
        purchase.setPurchaseDate(rs.getTimestamp("purchase_date"));
        purchase.setPurchaseTime(rs.getTime("purchase_time"));
        purchase.setInvoiceNumber(rs.getString("invoice_number"));
        purchase.setTotalCost(rs.getDouble("total_cost"));
        purchase.setNotes(rs.getString("notes"));
        
        // Get created_by if it's not null
        long createdBy = rs.getLong("created_by");
        if (!rs.wasNull()) {
            purchase.setCreatedBy(createdBy);
        }
        
        // Set supplier
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getLong("supplier_id"));
        supplier.setName(rs.getString("supplier_name"));
        supplier.setContactPerson(rs.getString("contact_person"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        purchase.setSupplier(supplier);
        
        return purchase;
    }
    
    // Get purchases by supplier
    public List<Purchase> getPurchasesBySupplier(String supplierName) {
        List<Purchase> purchases = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                    "FROM purchases p " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "WHERE s.name LIKE ? " +
                    "ORDER BY p.purchase_date DESC";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + supplierName + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Purchase purchase = mapResultSetToPurchase(rs);
                    
                    // Get purchase items
                    purchase.setItems(getPurchaseItemsForPurchase(purchase.getPurchaseId()));
                    
                    purchases.add(purchase);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting purchases by supplier", e);
        }
        
        return purchases;
    }

    // Get purchases by date range
    public List<Purchase> getPurchasesByDateRange(String startDate, String endDate) {
        List<Purchase> purchases = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                    "FROM purchases p " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "WHERE p.purchase_date BETWEEN ? AND ? " +
                    "ORDER BY p.purchase_date DESC";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Add time to make the range inclusive
            stmt.setString(1, startDate + " 00:00:00");
            stmt.setString(2, endDate + " 23:59:59");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Purchase purchase = mapResultSetToPurchase(rs);
                    
                    // Get purchase items
                    purchase.setItems(getPurchaseItemsForPurchase(purchase.getPurchaseId()));
                    
                    purchases.add(purchase);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting purchases by date range", e);
        }
        
        return purchases;
    }

    // Get purchases by item ID
    public List<Purchase> getPurchasesByItemId(long itemId) {
        List<Purchase> purchases = new ArrayList<>();
        String sql = "SELECT DISTINCT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                    "FROM purchases p " +
                    "JOIN purchase_items pi ON p.purchase_id = pi.purchase_id " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "WHERE pi.item_id = ? " +
                    "ORDER BY p.purchase_date DESC";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, itemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Purchase purchase = mapResultSetToPurchase(rs);
                    
                    // Get purchase items for this purchase
                    List<PurchaseItem> items = getPurchaseItemsForPurchase(purchase.getPurchaseId());
                    purchase.setItems(items);
                    
                    // Set summary fields for specific item if found
                    for (PurchaseItem item : items) {
                        if (item.getItemId() == itemId) {
                            purchase.setItemId(itemId);
                            purchase.setQuantity(item.getQuantity());
                            purchase.setUnitPrice(item.getUnitPrice());
                            purchase.setItemName(item.getItem().getName());
                            purchase.setUnit(item.getItem().getUnit());
                            break;
                        }
                    }
                    
                    purchases.add(purchase);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting purchases by item ID: " + itemId, e);
        }
        
        return purchases;
    }

    // Get all suppliers
    public List<String> getAllSuppliers() {
        List<String> suppliers = new ArrayList<>();
        String sql = "SELECT DISTINCT name FROM suppliers ORDER BY name";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                suppliers.add(rs.getString("name"));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all suppliers", e);
        }
        
        return suppliers;
    }

    // Get recent purchases
    public List<Purchase> getRecentPurchases(int limit) {
        List<Purchase> purchases = new ArrayList<>();
        String sql = "SELECT p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                    "FROM purchases p " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "ORDER BY p.purchase_date DESC " +
                    "LIMIT ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Purchase purchase = new Purchase();
                    purchase.setPurchaseId(rs.getLong("purchase_id"));
                    purchase.setSupplierId(rs.getLong("supplier_id"));
                    purchase.setPurchaseDate(rs.getTimestamp("purchase_date"));
                    purchase.setPurchaseTime(rs.getTime("purchase_time"));
                    purchase.setInvoiceNumber(rs.getString("invoice_number"));
                    purchase.setTotalCost(rs.getDouble("total_cost"));
                    purchase.setNotes(rs.getString("notes"));
                    
                    // Created by could be null
                    long createdBy = rs.getLong("created_by");
                    if (!rs.wasNull()) {
                        purchase.setCreatedBy(createdBy);
                    }
                    
                    // Set supplier info
                    Supplier supplier = new Supplier();
                    supplier.setSupplierId(rs.getLong("supplier_id"));
                    supplier.setName(rs.getString("supplier_name"));
                    supplier.setContactPerson(rs.getString("contact_person"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));
                    purchase.setSupplier(supplier);
                    
                    // Get purchase items
                    List<PurchaseItem> items = getPurchaseItemsForPurchase(purchase.getPurchaseId());
                    purchase.setItems(items);
                    
                    purchases.add(purchase);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent purchases", e);
        }
        
        return purchases;
    }

    /**
     * Get recent purchase items for a specific inventory item
     */
    public List<PurchaseItem> getRecentPurchaseItemsByItemId(long itemId, int limit) {
        List<PurchaseItem> items = new ArrayList<>();
        String sql = "SELECT pi.*, p.*, s.name as supplier_name, s.contact_person, s.phone, s.email " +
                    "FROM purchase_items pi " +
                    "JOIN purchases p ON pi.purchase_id = p.purchase_id " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "WHERE pi.item_id = ? " +
                    "ORDER BY p.purchase_date DESC, p.purchase_time DESC " +
                    "LIMIT ?";
        
        try (Connection conn = InventoryDBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setLong(1, itemId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PurchaseItem item = new PurchaseItem();
                    
                    // Use 'id' instead of 'purchase_item_id' to match your database
                    item.setId(rs.getLong("id"));
                    item.setPurchaseId(rs.getLong("purchase_id"));
                    item.setItemId(rs.getLong("item_id"));
                    item.setQuantity(rs.getDouble("quantity"));
                    item.setUnitPrice(rs.getDouble("unit_price"));
                    
                    // Set expiry date if not null
                    java.sql.Date expiryDate = rs.getDate("expiry_date");
                    if (expiryDate != null) {
                        item.setExpiryDate(expiryDate);
                    }
                    
                    // Set batch number if not null
                    String batchNumber = rs.getString("batch_number");
                    if (batchNumber != null) {
                        item.setBatchNumber(batchNumber);
                    }
                    
                    // Create purchase object
                    Purchase purchase = new Purchase();
                    purchase.setPurchaseId(rs.getLong("purchase_id"));
                    purchase.setSupplierId(rs.getLong("supplier_id"));
                    purchase.setPurchaseDate(rs.getTimestamp("purchase_date"));
                    purchase.setPurchaseTime(rs.getTime("purchase_time"));
                    purchase.setInvoiceNumber(rs.getString("invoice_number"));
                    purchase.setTotalCost(rs.getDouble("total_cost"));
                    purchase.setNotes(rs.getString("notes"));
                    
                    // Set created_by if not null
                    long createdBy = rs.getLong("created_by");
                    if (!rs.wasNull()) {
                        purchase.setCreatedBy(createdBy);
                    }
                    
                    // Create supplier object
                    Supplier supplier = new Supplier();
                    supplier.setSupplierId(rs.getLong("supplier_id"));
                    supplier.setName(rs.getString("supplier_name"));
                    supplier.setContactPerson(rs.getString("contact_person"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));
                    
                    // Set supplier to purchase
                    purchase.setSupplier(supplier);
                    
                    // Set purchase to purchase item - THIS WAS CAUSING THE ERROR
                    item.setPurchase(purchase);
                    
                    // Get inventory item details - do this efficiently
                    if (item.getItem() == null) {
                        InventoryItemDAO itemDAO = new InventoryItemDAO();
                        InventoryItem inventoryItem = itemDAO.getItemById(itemId);
                        item.setItem(inventoryItem);
                    }
                    
                    items.add(item);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent purchase items for item ID " + itemId + ": " + e.getMessage(), e);
        }
        
        return items;
    }
}
