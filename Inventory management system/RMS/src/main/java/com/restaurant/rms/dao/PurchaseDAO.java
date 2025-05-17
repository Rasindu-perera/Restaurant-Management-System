package com.restaurant.rms.dao;

import com.restaurant.rms.model.Purchase;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;

import java.util.List;

public class PurchaseDAO {
    public void savePurchase(Purchase purchase) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
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
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.find(Purchase.class, id);
        } finally {
            em.close();
        }
    }

    public List<Purchase> getAllPurchases() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT p FROM Purchase p LEFT JOIN FETCH p.items LEFT JOIN FETCH p.supplier",
                    Purchase.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}