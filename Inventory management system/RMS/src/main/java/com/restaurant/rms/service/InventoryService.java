package com.restaurant.rms.service;

import com.restaurant.rms.dao.InventoryDAO;
import com.restaurant.rms.dao.StockUsageLogDAO;
import com.restaurant.rms.model.*;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InventoryService {
    private static final Logger logger = Logger.getLogger(InventoryService.class.getName());
    private final InventoryDAO inventoryDAO;
    private final StockUsageLogDAO stockUsageLogDAO;

    public InventoryService() {
        this.inventoryDAO = new InventoryDAO();
        this.stockUsageLogDAO = new StockUsageLogDAO();
    }

    public List<InventoryItem> getAllItems() {
        return inventoryDAO.getAllItems();
    }

    public InventoryItem getItemById(Long id) {
        return inventoryDAO.getItemById(id);
    }

    public void saveItem(InventoryItem item) {
        validateInventoryItem(item); // Validate the item before saving
        if (item.getId() == null) { // If the item is new (no ID), add it
            inventoryDAO.addItem(item);
        } else { // If the item already exists, update it
            inventoryDAO.updateItem(item);
        }
    }

    public void deleteItem(Long id) {
        inventoryDAO.delete(id);
    }

    public void updateStock(Long itemId, Double quantityChange) {
        inventoryDAO.updateStock(itemId, quantityChange);
    }

    public List<InventoryItem> searchItems(String query, String category) {
        return inventoryDAO.searchItems(query, category);
    }

    public List<InventoryItem> getLowStockItems() {
        return inventoryDAO.getLowStockItems();
    }

    public void adjustStock(Long itemId, Double adjustment, String notes) {
        inventoryDAO.updateStock(itemId, adjustment);
    }

    public void recordDailyUsage(List<StockUsageLog> logs, User recordedBy) {
        if (logs == null || recordedBy == null || recordedBy.getId() == null) {
            throw new IllegalArgumentException("Invalid input parameters");
        }

        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();

            User managedUser = em.find(User.class, recordedBy.getId());
            if (managedUser == null) {
                throw new IllegalArgumentException("User not found in database");
            }

            for (StockUsageLog log : logs) {
                // Validate quantity - ensure it's not null and positive
                if (log.getQuantityUsed() == null || log.getQuantityUsed() <= 0) {
                    continue;
                }

                InventoryItem item = em.find(InventoryItem.class, log.getItem().getId());
                if (item == null) {
                    logger.warning("Item not found: " + log.getItem().getId());
                    continue;
                }

                if (item.getCurrentQuantity() < log.getQuantityUsed()) {
                    throw new IllegalArgumentException("Insufficient stock for item: " + item.getName());
                }

                item.setCurrentQuantity(item.getCurrentQuantity() - log.getQuantityUsed());
                em.merge(item);

                // Create new usage log with all required fields
                StockUsageLog usageLog = new StockUsageLog();
                usageLog.setItem(item);
                usageLog.setQuantityUsed(log.getQuantityUsed());
                usageLog.setRecordedBy(managedUser);
                usageLog.setNotes(log.getNotes());
                usageLog.setUsageDate(new Date());

                em.persist(usageLog);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            logger.log(Level.SEVERE, "Failed to record daily usage", e);
            throw new RuntimeException("Failed to record daily usage: " + e.getMessage(), e);
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<StockUsageLog> getDailyUsageReport(Date date) {
        return stockUsageLogDAO.getUsageLogsByDate(date);
    }

    private void validateInventoryItem(InventoryItem item) {
        if (item.getName() == null || item.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Item name is required");
        }
        if (item.getCategory() == null) {
            throw new IllegalArgumentException("Category is required");
        }
        if (item.getMinStockLevel() != null && item.getMinStockLevel() < 0) {
            throw new IllegalArgumentException("Minimum stock level cannot be negative");
        }
        if (item.getCostPerUnit() != null && item.getCostPerUnit() < 0) {
            throw new IllegalArgumentException("Cost per unit cannot be negative");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            String itemIdParam = request.getParameter("itemId");
            if (itemIdParam != null) {
                try {
                    Long itemId = Long.parseLong(itemIdParam);
                    InventoryService inventoryService = new InventoryService();
                    inventoryService.deleteItem(itemId);
                    response.sendRedirect("list.jsp?success=Item deleted successfully");
                } catch (NumberFormatException e) {
                    response.sendRedirect("list.jsp?error=Invalid item ID");
                }
            } else {
                response.sendRedirect("list.jsp?error=Item ID is missing");
            }
        }
    }
}