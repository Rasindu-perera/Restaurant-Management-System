package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CartItem;
import model.Order;
import util.DBConnection;

public class OrderDAO {
    
    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());

    // Helper to normalize status strings
    private String normalizeStatus(String status) {
        return status != null ? status.trim().toUpperCase() : "UNKNOWN";
    }

    public boolean saveOrder(int waiterId, int tableId, List<CartItem> cart) {
        String insertOrder = "INSERT INTO orders (waiter_id, table_id, status, created_at) VALUES (?, ?, 'SENT', ?)";
        String insertOrderItem = "INSERT INTO order_items (order_id, item_id, quantity) VALUES (?, ?, ?)";
        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                LOGGER.log(Level.SEVERE, "Failed to obtain database connection for saveOrder.");
                return false;
            }
            conn.setAutoCommit(false);
            
            int orderId;
            try (PreparedStatement stmtOrder = conn.prepareStatement(insertOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmtOrder.setInt(1, waiterId);
                stmtOrder.setInt(2, tableId);
                stmtOrder.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                int rowsAffected = stmtOrder.executeUpdate();
                
                if (rowsAffected == 0) {
                    throw new SQLException("Creating order failed, no rows affected (orders table).");
                }
                
                try (ResultSet rs = stmtOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained from orders table.");
                    }
                }
            }
            
            if (cart != null && !cart.isEmpty()) {
                try (PreparedStatement stmtItems = conn.prepareStatement(insertOrderItem)) {
                    for (CartItem item : cart) {
                        stmtItems.setInt(1, orderId);
                        stmtItems.setInt(2, item.getItemId());
                        stmtItems.setInt(3, item.getQuantity());
                        stmtItems.addBatch();
                    }
                    stmtItems.executeBatch();
                }
            }
            
            conn.commit();
            LOGGER.log(Level.INFO, "Order saved successfully with ID: {0}", orderId);
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    LOGGER.log(Level.WARNING, "Attempting to rollback transaction for saveOrder due to error: {0}", e.getMessage());
                    conn.rollback();
                    LOGGER.log(Level.INFO, "Transaction successfully rolled back for saveOrder.");
                } catch (SQLException exRollback) {
                    LOGGER.log(Level.SEVERE, "Critical error: Failed to rollback transaction for saveOrder.", exRollback);
                }
            }
            if (e instanceof java.sql.BatchUpdateException bue) {
                LOGGER.log(Level.SEVERE, "Error saving order items (BatchUpdateException) for waiterId " + waiterId + ", tableId " + tableId, bue);
            } else {
                LOGGER.log(Level.SEVERE, "Error saving order (SQLException) for waiterId " + waiterId + ", tableId " + tableId, e);
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection or resetting auto-commit in saveOrder.", e);
                }
            }
        }
    }

    public Order getCurrentOrderByTable(int tableId) {
        String sql = """
            SELECT o.* 
            FROM orders o 
            WHERE o.table_id = ? 
            AND UPPER(TRIM(o.status)) = 'SENT' 
            ORDER BY o.created_at DESC 
            LIMIT 1
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setTableId(rs.getInt("table_id"));
                    order.setWaiterId(rs.getInt("waiter_id"));
                    order.setStatus(normalizeStatus(rs.getString("status")));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    return order;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting current order by tableId: " + tableId, e);
        }
        return null;
    }

    public List<Order> getOrdersByTable(int tableId) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.* 
            FROM orders o 
            WHERE o.table_id = ? 
            AND UPPER(TRIM(o.status)) = 'SENT' 
            ORDER BY o.created_at DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setTableId(rs.getInt("table_id"));
                    order.setWaiterId(rs.getInt("waiter_id"));
                    order.setStatus(normalizeStatus(rs.getString("status")));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting orders by tableId: " + tableId, e);
        }
        return orders;
    }

    public List<Order> getOrdersByTableAfterTime(int tableId, Timestamp afterTime) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT * FROM orders 
            WHERE table_id = ? AND created_at > ? 
            ORDER BY created_at DESC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tableId);
            stmt.setTimestamp(2, afterTime);
            try (ResultSet rs = stmt.executeQuery()) {
            
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setTableId(rs.getInt("table_id"));
                    order.setWaiterId(rs.getInt("waiter_id"));
                    order.setStatus(normalizeStatus(rs.getString("status")));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting orders by table after time for tableId: " + tableId, e);
        }
        return orders;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        String normalizedNewStatus = normalizeStatus(status);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, normalizedNewStatus);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} status updated to {1}", new Object[]{orderId, normalizedNewStatus});
                return true;
            } else {
                LOGGER.log(Level.WARNING, "Failed to update status for order {0} to {1}. Order not found or status unchanged.", new Object[]{orderId, normalizedNewStatus});
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException updating order status for orderId: " + orderId + " to " + normalizedNewStatus, e);
            return false;
        }
    }

    /**
     * Updates the status of an order to a new value
     * 
     * @param orderId The ID of the order to update
     * @param newStatus The new status value (must be a valid enum value in the database)
     * @param chefId The ID of the chef making the change
     * @return true if the update was successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String newStatus, int chefId) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newStatus);
            stmt.setInt(2, orderId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Order> getActiveOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, oi.item_id, oi.quantity, i.name as item_name, i.price 
            FROM orders o
            JOIN order_items oi ON o.order_id = oi.order_id
            JOIN items i ON oi.item_id = i.item_id 
            WHERE UPPER(TRIM(o.status)) IN ('SENT', 'CONFIRMED') 
            ORDER BY o.created_at DESC, o.order_id ASC 
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                Order currentOrder = null;
                int currentOrderId = -1;
            
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                
                    if (currentOrder == null || currentOrderId != orderId) {
                        if (currentOrder != null) {
                            orders.add(currentOrder);
                        }
                    
                        currentOrder = new Order();
                        currentOrder.setOrderId(orderId);
                        currentOrderId = orderId;
                        currentOrder.setTableId(rs.getInt("table_id"));
                        currentOrder.setWaiterId(rs.getInt("waiter_id"));
                        currentOrder.setStatus(normalizeStatus(rs.getString("status")));
                        currentOrder.setCreatedAt(rs.getTimestamp("created_at"));
                        currentOrder.setItems(new ArrayList<>());
                    }
                
                    if (rs.getObject("item_id") != null && rs.getInt("item_id") > 0) {
                        CartItem item = new CartItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setItemName(rs.getString("item_name"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        if (currentOrder != null) {
                           currentOrder.getItems().add(item);
                        }
                    }
                }
            
                if (currentOrder != null) {
                    orders.add(currentOrder);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving active orders", e);
        }
        return orders;
    }

    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} deleted from 'orders' table.", orderId);
                return true;
            } else {
                LOGGER.log(Level.WARNING, "Order {0} not found in 'orders' table for deletion.", orderId);
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting order {0} from 'orders' table.", new Object[]{orderId, e});
            return false;
        }
    }

    public Order getOrderById(int orderId) {
        String sql = """
            SELECT o.*, oi.item_id, oi.quantity, mi.name as item_name, mi.price 
            FROM orders o
            LEFT JOIN order_items oi ON o.order_id = oi.order_id
            LEFT JOIN menu_items mi ON oi.item_id = mi.item_id 
            WHERE o.order_id = ?
        """;
        
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            LOGGER.log(Level.FINER, "DEBUG: Retrieving order with ID: {0}", orderId);
            stmt.setInt(1, orderId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                List<CartItem> items = new ArrayList<>();
                while (rs.next()) {
                    if (order == null) {
                        order = new Order();
                        order.setOrderId(rs.getInt("order_id"));
                        order.setTableId(rs.getInt("table_id"));
                        order.setWaiterId(rs.getInt("waiter_id"));
                        order.setStatus(normalizeStatus(rs.getString("status")));
                        order.setCreatedAt(rs.getTimestamp("created_at"));
                    }
                
                    if (rs.getObject("item_id") != null && rs.getInt("item_id") > 0) {
                        CartItem item = new CartItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setItemName(rs.getString("item_name"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        items.add(item);
                    }
                }
                if (order != null) {
                    order.setItems(items);
                    LOGGER.log(Level.FINER, "DEBUG: Order ID {0} retrieved successfully with {1} items", new Object[]{orderId, items.size()});
                } else {
                    LOGGER.log(Level.WARNING, "DEBUG: No order found with ID: {0}", orderId);
                }
            }
            return order;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "ERROR: Failed to retrieve order ID " + orderId, e);
            return null;
        }
    }

    public List<Order> getPendingOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, oi.item_id, oi.quantity, mi.name as item_name, mi.price 
            FROM orders o
            JOIN order_items oi ON o.order_id = oi.order_id
            JOIN menu_items mi ON oi.item_id = mi.item_id 
            WHERE UPPER(TRIM(o.status)) IN ('SENT', 'CONFIRMED', 'READY')
            ORDER BY o.created_at ASC, o.order_id ASC
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            LOGGER.log(Level.FINER, "DEBUG: Retrieving pending orders...");
            try (ResultSet rs = stmt.executeQuery()) {
                Order currentOrder = null;
                int currentOrderId = -1;
            
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                
                    if (currentOrder == null || currentOrderId != orderId) {
                        if (currentOrder != null) {
                            LOGGER.log(Level.FINEST, "DEBUG: Adding order to list - ID: {0}, Status: ''{1}'', Items: {2}", 
                                       new Object[]{currentOrder.getOrderId(), currentOrder.getStatus(), currentOrder.getItems().size()});
                            orders.add(currentOrder);
                        }
                    
                        currentOrder = new Order();
                        currentOrder.setOrderId(orderId);
                        currentOrderId = orderId;
                        currentOrder.setTableId(rs.getInt("table_id"));
                        currentOrder.setWaiterId(rs.getInt("waiter_id"));
                        currentOrder.setStatus(normalizeStatus(rs.getString("status")));
                        currentOrder.setCreatedAt(rs.getTimestamp("created_at"));
                        currentOrder.setItems(new ArrayList<>());
                    
                        LOGGER.log(Level.FINEST, "DEBUG: Processing new order - ID: {0}, Status: ''{1}'', Table: {2}, Waiter: {3}", 
                                   new Object[]{orderId, currentOrder.getStatus(), currentOrder.getTableId(), currentOrder.getWaiterId()});
                    }
                
                    if (rs.getObject("item_id") != null && rs.getInt("item_id") > 0) {
                        CartItem item = new CartItem();
                        item.setItemId(rs.getInt("item_id"));
                        item.setItemName(rs.getString("item_name"));
                        item.setQuantity(rs.getInt("quantity"));
                        item.setPrice(rs.getDouble("price"));
                        if (currentOrder != null) {
                            currentOrder.getItems().add(item);
                        }
                    }
                }
            
                if (currentOrder != null) {
                    LOGGER.log(Level.FINEST, "DEBUG: Adding final order to list - ID: {0}, Status: ''{1}'', Items: {2}", 
                               new Object[]{currentOrder.getOrderId(), currentOrder.getStatus(), currentOrder.getItems().size()});
                    orders.add(currentOrder);
                }
            }
            
            LOGGER.log(Level.FINER, "DEBUG: Retrieved {0} pending orders", orders.size());
            if (LOGGER.isLoggable(Level.FINEST)) {
                for (Order order : orders) {
                    LOGGER.log(Level.FINEST, "  Order ID: {0}, Status: ''{1}'', Items: {2}", 
                                 new Object[]{order.getOrderId(), order.getStatus(), order.getItems().size()});
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "ERROR: Error retrieving pending orders", e);
        }
        return orders;
    }

    public boolean confirmOrder(int orderId, int chefId) {
        String sql = "UPDATE orders SET status = 'READY', chef_id = ? WHERE order_id = ? AND UPPER(TRIM(status)) = 'SENT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, chefId);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} marked as READY by chef {1}", new Object[]{orderId, chefId});
                return true;
            } else {
                String currentDbStatus = getOrderStatusFromDB(orderId);
                LOGGER.log(Level.WARNING, "Mark order as READY: 0 rows affected for orderId {0}, chefId {1}. Expected status 'SENT', actual DB status: ''{2}''", new Object[]{orderId, chefId, currentDbStatus});
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in confirmOrder (SENT to READY) for orderId " + orderId, e);
            return false;
        }
    }

    public boolean markOrderAsConfirmedByChef(int orderId, int chefId) {
        String sql = "UPDATE orders SET status = 'CONFIRMED', chef_id = ? WHERE order_id = ? AND UPPER(TRIM(status)) = 'SENT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, chefId);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} marked as CONFIRMED by chef {1}", new Object[]{orderId, chefId});
                return true;
            } else {
                String currentDbStatus = getOrderStatusFromDB(orderId);
                LOGGER.log(Level.WARNING, "Mark order as CONFIRMED: 0 rows affected for orderId {0}, chefId {1}. Expected status 'SENT', actual DB status: ''{2}''", new Object[]{orderId, chefId, currentDbStatus});
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in markOrderAsConfirmedByChef for orderId " + orderId, e);
            return false;
        }
    }

    private String getOrderStatusFromDB(int orderId) {
        String sql = "SELECT status FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
            
                if (rs.next()) {
                    String status = rs.getString("status");
                    LOGGER.log(Level.FINEST, "DEBUG: Raw status from database for order {0}: ''{1}''", new Object[]{orderId, status});
                    return normalizeStatus(status);
                }
            }
            LOGGER.log(Level.WARNING, "DEBUG: No status found in DB for order {0}", orderId);
            return "UNKNOWN";
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "ERROR: Failed to get order status from DB for orderId " + orderId, e);
            return "DB_ERROR";
        }
    }

    private boolean checkAndFixOrderStatus(int orderId) {
        String currentStatusInDB = getOrderStatusFromDB(orderId);
        LOGGER.log(Level.INFO, "DEBUG: Checking order status for ID {0}. Current DB status: ''{1}''", new Object[]{orderId, currentStatusInDB});

        if ("UNKNOWN".equals(currentStatusInDB) || currentStatusInDB.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "DEBUG: Status for order ID {0} is ''{1}''. Attempting to set to 'SENT'.", new Object[]{orderId, currentStatusInDB});
            String updateSql = "UPDATE orders SET status = 'SENT' WHERE order_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, orderId);
                int rowsAffected = updateStmt.executeUpdate();
                if (rowsAffected > 0) {
                    LOGGER.log(Level.INFO, "DEBUG: Fixed status for order ID {0} to 'SENT'. Rows affected: {1}", new Object[]{orderId, rowsAffected});
                    return true;
                } else {
                    LOGGER.log(Level.WARNING, "DEBUG: Failed to fix status for order ID {0}. Update affected 0 rows.", orderId);
                    return false;
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "ERROR: Failed to execute fix for order status for ID " + orderId, e);
                return false;
            }
        }
        LOGGER.log(Level.INFO, "DEBUG: Status for order ID {0} is ''{1}'', no fix needed by this method's logic.", new Object[]{orderId, currentStatusInDB});
        return true;
    }

    public boolean completeOrder(int orderId) {
        String sql = """
            UPDATE orders 
            SET status = 'READY', 
                completed_at = ? 
            WHERE order_id = ? AND UPPER(TRIM(status)) = 'COMPLETED'
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} marked as READY (from CONFIRMED) successfully.", orderId);
                return true;
            } else {
                String currentDbStatus = getOrderStatusFromDB(orderId);
                LOGGER.log(Level.WARNING, "Mark order READY (from CONFIRMED): 0 rows affected for orderId {0}. Expected 'COMPLETED', actual DB status: ''{1}''", new Object[]{orderId, currentDbStatus});
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in completeOrder (CONFIRMED to READY) for orderId " + orderId, e);
            return false;
        }
    }

    public boolean markOrderAsCompleted(int orderId) {
        String sql = """
            UPDATE orders 
            SET status = 'COMPLETED', 
                completed_at = ? 
            WHERE order_id = ? AND UPPER(TRIM(status)) = 'READY'
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Order {0} marked as COMPLETED.", orderId);
                return true;
            } else {
                String currentStatus = getOrderStatusFromDB(orderId);
                LOGGER.log(Level.WARNING, "Mark order COMPLETED: 0 rows affected for orderId {0}. Expected 'READY', actual DB status: ''{1}''", new Object[]{orderId, currentStatus});
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in markOrderAsCompleted for orderId " + orderId, e);
            return false;
        }
    }

    /**
     * Gets orders by their status
     * @param statuses Array of status values to filter by
     * @return List of orders with the specified statuses
     */
    public List<Order> getOrdersByStatus(String[] statuses) {
        List<Order> orders = new ArrayList<>();
        
        if (statuses == null || statuses.length == 0) {
            return orders;
        }
        
        // Build the SQL with placeholders for each status
        StringBuilder sqlBuilder = new StringBuilder(
            "SELECT * FROM orders WHERE status IN ("
        );
        
        for (int i = 0; i < statuses.length; i++) {
            sqlBuilder.append("?");
            if (i < statuses.length - 1) {
                sqlBuilder.append(",");
            }
        }
        sqlBuilder.append(") ORDER BY table_id, created_at");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {
            
            // Set the status values as parameters
            for (int i = 0; i < statuses.length; i++) {
                stmt.setString(i + 1, statuses[i]);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setWaiterId(rs.getInt("waiter_id"));
                    order.setTableId(rs.getInt("table_id"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching orders by status", e);
        }
        
        return orders;
    }
}