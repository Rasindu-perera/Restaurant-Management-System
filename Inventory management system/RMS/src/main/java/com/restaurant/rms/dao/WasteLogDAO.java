package com.restaurant.rms.dao;

import com.restaurant.rms.model.WasteLog;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class WasteLogDAO {
    public void save(WasteLog wasteLog) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(wasteLog);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<WasteLog> findAll() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            TypedQuery<WasteLog> query = em.createQuery(
                    "SELECT w FROM WasteLog w JOIN FETCH w.item", WasteLog.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}