package com.restaurant.rms.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConnection {
    private static final Logger logger = Logger.getLogger(DatabaseConnection.class.getName());
    private static EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory("restaurantPU");
            logger.info("Database connection initialized successfully");

            // Test connection
            EntityManager em = getEntityManager();
            try {
                em.createQuery("SELECT 1").getSingleResult();
                logger.info("Database connection test successful");
            } finally {
                if (em != null)
                    em.close();
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Database initialization failed", e);
            throw new RuntimeException("Failed to initialize database connection", e);
        }
    }

    public static EntityManager getEntityManager() {
        if (emf == null || !emf.isOpen()) {
            throw new IllegalStateException("EntityManagerFactory is not initialized");
        }
        return emf.createEntityManager();
    }
}