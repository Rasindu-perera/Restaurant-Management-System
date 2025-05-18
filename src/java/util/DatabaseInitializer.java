package util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseInitializer {
    
    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializer.class.getName());
    
    public static void initializeAdminUser() {
        try (Connection conn = DBConnection.getConnection()) {
            // Check if admin user exists
            String checkSql = "SELECT COUNT(*) FROM admin_users WHERE username = 'admin'";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    // Admin user doesn't exist, create it
                    String insertSql = "INSERT INTO admin_users (username, password, email, full_name, role) " +
                                      "VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, "admin");
                        insertStmt.setString(2, PasswordUtil.hashPassword("admin123"));
                        insertStmt.setString(3, "admin@restaurant.com");
                        insertStmt.setString(4, "Administrator");
                        insertStmt.setString(5, "super_admin");
                        insertStmt.executeUpdate();
                        LOGGER.log(Level.INFO, "Default admin user created successfully");
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error initializing admin user", e);
        }
    }
}
