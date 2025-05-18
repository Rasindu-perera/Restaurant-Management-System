package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.AdminUser;
import util.DBConnection;
import util.PasswordUtil;

public class AdminUserDAO {
    
    private static final Logger LOGGER = Logger.getLogger(AdminUserDAO.class.getName());
    
    // Check if admin_users table exists
    public boolean ensureTableExists() {
        String checkTableSql = "SHOW TABLES LIKE 'admin_users'";
        String createTableSql = 
            "CREATE TABLE admin_users (" +
            "id INT AUTO_INCREMENT PRIMARY KEY, " +
            "username VARCHAR(50) NOT NULL UNIQUE, " +
            "password VARCHAR(255) NOT NULL, " +
            "email VARCHAR(100), " +
            "full_name VARCHAR(100), " +
            "role VARCHAR(20) DEFAULT 'admin', " +
            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
            "last_login TIMESTAMP NULL, " +
            "active BOOLEAN DEFAULT TRUE)";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Check if table exists
            ResultSet rs = stmt.executeQuery(checkTableSql);
            if (!rs.next()) {
                // Table doesn't exist, create it
                LOGGER.log(Level.INFO, "Creating admin_users table");
                stmt.executeUpdate(createTableSql);
                
                // Insert default admin user
                ensureDefaultAdminExists();
                return true;
            }
            return true;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking/creating admin_users table", e);
            return false;
        }
    }
    
    // Ensure default admin user exists
    public boolean ensureDefaultAdminExists() {
        String checkSql = "SELECT COUNT(*) FROM admin_users WHERE username = 'admin'";
        String insertSql = "INSERT INTO admin_users (username, password, email, full_name, role, active) " +
                          "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if admin exists
            try (Statement checkStmt = conn.createStatement();
                 ResultSet rs = checkStmt.executeQuery(checkSql)) {
                
                if (rs.next() && rs.getInt(1) == 0) {
                    // Admin doesn't exist, create it
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        String hashedPassword = PasswordUtil.hashPassword("admin123");
                        
                        insertStmt.setString(1, "admin");
                        insertStmt.setString(2, hashedPassword);
                        insertStmt.setString(3, "admin@restaurant.com");
                        insertStmt.setString(4, "System Administrator");
                        insertStmt.setString(5, "super_admin");
                        insertStmt.setBoolean(6, true);
                        
                        insertStmt.executeUpdate();
                        LOGGER.log(Level.INFO, "Default admin user created with hash: {0}", hashedPassword);
                        return true;
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error ensuring default admin exists", e);
            return false;
        }
    }
    
    // Authenticate admin user
    public AdminUser authenticate(String username, String password) {
        String sql = "SELECT * FROM admin_users WHERE username = ? AND active = true";
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    
                    // Log for debugging
                    LOGGER.log(Level.INFO, "Stored password hash: {0}", storedPassword);
                    LOGGER.log(Level.INFO, "Input password: {0}", password);
                    LOGGER.log(Level.INFO, "Hashed input: {0}", PasswordUtil.hashPassword(password));
                    
                    // Verify password - with explicit string comparison
                    String hashedInput = PasswordUtil.hashPassword(password);
                    boolean passwordsMatch = (hashedInput != null && hashedInput.equals(storedPassword));
                    
                    if (passwordsMatch) {
                        AdminUser user = new AdminUser();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        user.setFullName(rs.getString("full_name"));
                        user.setRole(rs.getString("role"));
                        user.setActive(rs.getBoolean("active"));
                        
                        // Update last login time
                        updateLastLogin(user.getId());
                        
                        return user;
                    } else {
                        LOGGER.log(Level.WARNING, "Password mismatch for {0}", username);
                    }
                } else {
                    LOGGER.log(Level.WARNING, "No active user found with username: {0}", username);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during authentication", e);
        }
        
        return null;
    }
    
    // Update last login timestamp
    private void updateLastLogin(int userId) {
        String sql = "UPDATE admin_users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to update last login time", e);
        }
    }
    
    // Get admin user by ID
    public AdminUser getAdminUserById(int id) {
        String sql = "SELECT * FROM admin_users WHERE id = ?";
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    AdminUser user = new AdminUser();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setLastLogin(rs.getTimestamp("last_login"));
                    user.setActive(rs.getBoolean("active"));
                    
                    return user;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving admin user by ID: " + id, e);
        }
        
        return null;
    }
    
    // Get all admin users
    public List<AdminUser> getAllAdminUsers() {
        List<AdminUser> users = new ArrayList<>();
        String sql = "SELECT * FROM admin_users ORDER BY id";
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                AdminUser user = new AdminUser();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setLastLogin(rs.getTimestamp("last_login"));
                user.setActive(rs.getBoolean("active"));
                
                users.add(user);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all admin users", e);
        }
        
        return users;
    }
    
    // Add new admin user
    public boolean addAdminUser(AdminUser user) {
        String sql = "INSERT INTO admin_users (username, password, email, full_name, role, active) VALUES (?, ?, ?, ?, ?, ?)";
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            
            // Hash the password if it's provided
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                stmt.setString(2, PasswordUtil.hashPassword(user.getPassword()));
            } else {
                // Default password if none is provided
                stmt.setString(2, PasswordUtil.hashPassword("changeme"));
            }
            
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding new admin user", e);
            return false;
        }
    }
    
    // Update admin user
    public boolean updateAdminUser(AdminUser user) {
        // Start with the fields that are always updated
        StringBuilder sql = new StringBuilder("UPDATE admin_users SET username = ?, email = ?, full_name = ?, role = ?, active = ?");
        
        // Only include password in update if it's provided
        boolean updatePassword = (user.getPassword() != null && !user.getPassword().isEmpty());
        if (updatePassword) {
            sql.append(", password = ?");
        }
        
        sql.append(" WHERE id = ?");
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isActive());
            
            int paramIndex = 6;
            
            // Add password parameter if it's being updated
            if (updatePassword) {
                stmt.setString(paramIndex++, PasswordUtil.hashPassword(user.getPassword()));
            }
            
            // Set the ID as the last parameter
            stmt.setInt(paramIndex, user.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating admin user with ID: " + user.getId(), e);
            return false;
        }
    }
    
    // Delete admin user
    public boolean deleteAdminUser(int id) {
        String sql = "DELETE FROM admin_users WHERE id = ?";
        
        // Ensure table exists first
        ensureTableExists();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting admin user with ID: " + id, e);
            return false;
        }
    }
}