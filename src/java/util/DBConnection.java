package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
/**
 *
 * @author RasinduPerera
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/restaurant_schema";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // 🔁 Replace with your actual MySQL password

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // For MySQL 8.x
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}
