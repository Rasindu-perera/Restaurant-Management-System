package listener;

import dao.AdminUserDAO;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebListener
public class AppInitListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppInitListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.log(Level.INFO, "Application starting up - initializing database");
        
        try {
            // Ensure admin user table exists and has default admin
            AdminUserDAO adminDAO = new AdminUserDAO();
            boolean success = adminDAO.ensureTableExists();
            
            if (success) {
                LOGGER.log(Level.INFO, "Admin user table and default admin account checked successfully");
            } else {
                LOGGER.log(Level.SEVERE, "Failed to initialize admin user table");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during application initialization", e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.log(Level.INFO, "Application shutting down");
    }
}