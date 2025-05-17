package com.restaurant.rms.dao;

import com.restaurant.rms.model.Supplier;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            TypedQuery<Supplier> query = em.createQuery("SELECT s FROM Supplier s ORDER BY s.name", Supplier.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    public Supplier getSupplierById(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.find(Supplier.class, id);
        } finally {
            em.close();
        }
    }

    public void saveSupplier(Supplier supplier) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(supplier);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void updateSupplier(Supplier supplier) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(supplier);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void deleteSupplier(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            Supplier supplier = em.find(Supplier.class, id);
            if (supplier != null) {
                em.remove(supplier);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}