package com.restaurant.rms.service;

import com.restaurant.rms.dao.CategoryDAO;
import com.restaurant.rms.model.Category;

import java.util.List;

public class CategoryService {
    private final CategoryDAO categoryDAO;

    public CategoryService() {
        this.categoryDAO = new CategoryDAO();
    }

    /**
     * Fetch all categories from the database.
     *
     * @return List of categories.
     */
    public List<Category> getAllCategories() {
        return categoryDAO.findAll();
    }

    /**
     * Add a new category to the database.
     *
     * @param category The category to add.
     */
    public void addCategory(Category category) {
        categoryDAO.save(category);
    }

    /**
     * Find a category by its ID.
     *
     * @param id The ID of the category.
     * @return The category, or null if not found.
     */
    public Category getCategoryById(Long id) {
        return categoryDAO.findById(id);
    }

    /**
     * Delete a category by its ID.
     *
     * @param id The ID of the category to delete.
     */
    public void deleteCategory(Long id) {
        categoryDAO.delete(id);
    }
}