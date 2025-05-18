package com.restaurant.rms.dao;

import com.restaurant.rms.model.StockUsageLog;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import java.util.Date;
import java.util.List;

public class StockUsageLogDAO {
    public void saveUsageLog(StockUsageLog log) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(log);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public List<StockUsageLog> getUsageLogsByDate(Date date) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT l FROM StockUsageLog l WHERE l.usageDate = :date ORDER BY l.item.name",
                            StockUsageLog.class)
                    .setParameter("date", date)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}