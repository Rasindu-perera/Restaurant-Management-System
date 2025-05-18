package servlet.admin.inventory;

import dao.inventory.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.Category;

@WebServlet("/admin/inventory/categories")
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all categories
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        
        // For debugging
        System.out.println("Found " + categories.size() + " categories");
        for (Category category : categories) {
            System.out.println("Category: " + category.getCategoryId() + " - " + category.getName());
        }
        
        // Set as request attribute
        request.setAttribute("categories", categories);
        
        // Forward to the categories JSP page
        request.getRequestDispatcher("/admin/inventory/categories.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle category creation/editing here
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addCategory(request, response);
        } else if ("edit".equals(action)) {
            editCategory(request, response);
        } else if ("delete".equals(action)) {
            deleteCategory(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/inventory/categories");
        }
    }
    
    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        
        if (name != null && !name.trim().isEmpty()) {
            CategoryDAO categoryDAO = new CategoryDAO();
            Category category = new Category();
            category.setName(name.trim());
            
            boolean success = categoryDAO.addCategory(category);
            
            if (success) {
                request.getSession().setAttribute("message", "Category added successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to add category");
            }
        } else {
            request.getSession().setAttribute("error", "Category name is required");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/inventory/categories");
    }
    
    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdStr = request.getParameter("categoryId");
        String name = request.getParameter("name");
        
        if (categoryIdStr != null && name != null && !name.trim().isEmpty()) {
            try {
                long categoryId = Long.parseLong(categoryIdStr);
                
                CategoryDAO categoryDAO = new CategoryDAO();
                Category category = new Category();
                category.setCategoryId(categoryId);
                category.setName(name.trim());
                
                boolean success = categoryDAO.updateCategory(category);
                
                if (success) {
                    request.getSession().setAttribute("message", "Category updated successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to update category");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid category ID");
            }
        } else {
            request.getSession().setAttribute("error", "Category ID and name are required");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/inventory/categories");
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdStr = request.getParameter("categoryId");
        
        if (categoryIdStr != null) {
            try {
                long categoryId = Long.parseLong(categoryIdStr);
                
                CategoryDAO categoryDAO = new CategoryDAO();
                boolean success = categoryDAO.deleteCategory(categoryId);
                
                if (success) {
                    request.getSession().setAttribute("message", "Category deleted successfully");
                } else {
                    request.getSession().setAttribute("error", "Failed to delete category. It may be in use by inventory items.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "Invalid category ID");
            }
        } else {
            request.getSession().setAttribute("error", "Category ID is required");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/inventory/categories");
    }
}
