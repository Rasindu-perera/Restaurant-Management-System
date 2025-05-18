package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InventoryDBConnection {
    private static final Logger LOGGER = Logger.getLogger(InventoryDBConnection.class.getName());
    
    // JDBC URL, username and password
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/restaurant_inventory";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = ""; // Empty string if no password
    
    static {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found", e);
        }
    }
    
    // Get database connection
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error connecting to database", e);
            throw e;
        }
    }
}
