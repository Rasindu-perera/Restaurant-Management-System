package com.restaurant.rms.dao;

import com.restaurant.rms.model.InventoryItem;
import com.restaurant.rms.model.WasteLog;
import com.restaurant.rms.util.AuthUtil;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class InventoryDAO {
    public void addItem(InventoryItem item) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin(); // Start a transaction
            em.persist(item); // Persist the item
            em.getTransaction().commit(); // Commit the transaction
        } catch (Exception e) {
            em.getTransaction().rollback(); // Rollback in case of an error
            throw e;
        } finally {
            em.close(); // Close the EntityManager
        }
    }

    public List<InventoryItem> getAllItems() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            TypedQuery<InventoryItem> query = em.createQuery(
                    "SELECT i FROM InventoryItem i ORDER BY i.name", InventoryItem.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Find an inventory item by its ID.
     *
     * @param id The ID of the inventory item.
     * @return The inventory item, or null if not found.
     */
    public InventoryItem findById(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.find(InventoryItem.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Update an inventory item in the database.
     *
     * @param item The inventory item to update.
     */
    public void update(InventoryItem item) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(item);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void delete(Long itemId) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            InventoryItem item = em.find(InventoryItem.class, itemId);
            if (item != null) {
                em.remove(item);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void updateStock(Long itemId, Double quantityChange) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            InventoryItem item = em.find(InventoryItem.class, itemId);
            if (item != null) {
                item.setCurrentQuantity(item.getCurrentQuantity() + quantityChange);
                em.merge(item);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<InventoryItem> searchItems(String query, String category) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            String jpql = "SELECT i FROM InventoryItem i WHERE " +
                    "(LOWER(i.name) LIKE LOWER(:query) OR " +
                    "LOWER(i.category) LIKE LOWER(:query)) ";

            if (category != null && !category.isEmpty()) {
                jpql += "AND i.category = :category ";
            }

            jpql += "ORDER BY i.name";

            TypedQuery<InventoryItem> typedQuery = em.createQuery(jpql, InventoryItem.class)
                    .setParameter("query", "%" + query + "%");

            if (category != null && !category.isEmpty()) {
                typedQuery.setParameter("category", category);
            }

            return typedQuery.getResultList();
        } finally {
            em.close();
        }
    }

    public List<InventoryItem> getLowStockItems() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT i FROM InventoryItem i " +
                            "WHERE i.minStockLevel IS NOT NULL " +
                            "AND i.currentQuantity <= i.minStockLevel " +
                            "ORDER BY i.currentQuantity ASC",
                    InventoryItem.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<InventoryItem> findAll() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.createQuery("SELECT i FROM InventoryItem i", InventoryItem.class).getResultList();
        } finally {
            em.close();
        }
    }

    private void saveWasteLog(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();

            Long itemId = Long.parseLong(request.getParameter("item_id"));
            double quantity = Double.parseDouble(request.getParameter("quantity"));
            String reason = request.getParameter("reason");
            String notes = request.getParameter("notes");

            // Create a new WasteLog entry
            WasteLog wasteLog = new WasteLog();
            wasteLog.setItemId(itemId);
            wasteLog.setQuantity(quantity);
            wasteLog.setReason(WasteLog.WasteReason.valueOf(reason));
            wasteLog.setNotes(notes);
            wasteLog.setWasteDate(new java.util.Date()); // Use java.util.Date here
            wasteLog.setRecordedBy(AuthUtil.getCurrentUserId(request.getSession()));

            // Deduct the wasted quantity from the inventory
            InventoryItem item = em.find(InventoryItem.class, itemId);
            if (item != null) {
                double newQuantity = item.getCurrentQuantity() - quantity;
                if (newQuantity < 0) {
                    newQuantity = 0; // Prevent negative stock
                }
                item.setCurrentQuantity(newQuantity);
                em.merge(item);
            }

            // Save the waste log
            em.persist(wasteLog);

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new IOException("Error saving waste log", e);
        } finally {
            em.close();
        }

        response.sendRedirect(request.getContextPath() + "/waste");
    }

    public InventoryItem getItemById(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.find(InventoryItem.class, id);
        } finally {
            em.close();
        }
    }

    public void updateItem(InventoryItem item) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(item);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}