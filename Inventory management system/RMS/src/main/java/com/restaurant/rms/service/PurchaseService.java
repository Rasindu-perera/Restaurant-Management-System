package com.restaurant.rms.service;

import com.restaurant.rms.dao.PurchaseDAO;
import com.restaurant.rms.model.InventoryItem;
import com.restaurant.rms.model.Purchase;
import com.restaurant.rms.model.PurchaseItem;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;

import java.util.List;

import org.hibernate.Hibernate;

public class PurchaseService {
    private final PurchaseDAO purchaseDAO;

    public PurchaseService() {
        this.purchaseDAO = new PurchaseDAO();
    }

    public void savePurchase(Purchase purchase) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();

            // Save the purchase
            for (PurchaseItem item : purchase.getItems()) {
                item.setPurchase(purchase); // Link purchase items to the purchase
            }
            em.persist(purchase);

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public Purchase getPurchaseById(Long id) {
        return purchaseDAO.getPurchaseById(id);
    }

    public List<Purchase> getAllPurchases() {
        List<Purchase> purchases = purchaseDAO.getAllPurchases();
        for (Purchase purchase : purchases) {
            Hibernate.initialize(purchase.getItems()); // Initialize the items collection
        }
        return purchases;
    }
}