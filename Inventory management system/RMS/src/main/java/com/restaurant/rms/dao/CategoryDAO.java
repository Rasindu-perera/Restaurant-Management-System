package com.restaurant.rms.dao;

import com.restaurant.rms.model.Category;
import com.restaurant.rms.util.DatabaseConnection;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class CategoryDAO {

    /**
     * Fetch all categories from the database.
     *
     * @return List of categories.
     */
    public List<Category> findAll() {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            TypedQuery<Category> query = em.createQuery("SELECT c FROM Category c", Category.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Save a new category to the database.
     *
     * @param category The category to save.
     */
    public void save(Category category) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(category);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /**
     * Find a category by its ID.
     *
     * @param id The ID of the category.
     * @return The category, or null if not found.
     */
    public Category findById(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            return em.find(Category.class, id);
        } finally {
            em.close();
        }
    }

    /**
     * Delete a category by its ID.
     *
     * @param id The ID of the category to delete.
     */
    public void delete(Long id) {
        EntityManager em = DatabaseConnection.getEntityManager();
        try {
            em.getTransaction().begin();
            Category category = em.find(Category.class, id);
            if (category != null) {
                em.remove(category);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}