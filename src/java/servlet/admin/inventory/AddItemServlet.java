package servlet.admin.inventory;

import dao.inventory.CategoryDAO;
import dao.inventory.InventoryItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.Category;
import model.inventory.InventoryItem;

@WebServlet("/admin/inventory/item/add")
public class AddItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all categories for dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        
        // Set attributes
        request.setAttribute("categories", categories);
        
        // Forward to the add item form
        request.getRequestDispatcher("/admin/inventory/add-item.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");
        String currentStockStr = request.getParameter("currentStock");
        String minStockLevelStr = request.getParameter("minStockLevel");
        String unitPriceStr = request.getParameter("unitPrice");
        String unit = request.getParameter("unit");
        
        // Validate required fields
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Item name is required");
            doGet(request, response);
            return;
        }
        
        try {
            // Create new item object
            InventoryItem item = new InventoryItem();
            item.setName(name);
            item.setDescription(description);
            
            // Set category if provided
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                long categoryId = Long.parseLong(categoryIdStr);
                item.setCategoryId(categoryId);
                
                // Get category name
                CategoryDAO categoryDAO = new CategoryDAO();
                Category category = categoryDAO.getCategoryById(categoryId);
                if (category != null) {
                    // Fix: Pass the Category object instead of just the name
                    item.setCategory(category);
                }
            }
            
            // Set numeric fields if provided
            if (currentStockStr != null && !currentStockStr.isEmpty()) {
                double currentStock = Double.parseDouble(currentStockStr);
                item.setCurrentQuantity(currentStock);
            } else {
                item.setCurrentQuantity(0); // Default to 0
            }
            
            if (minStockLevelStr != null && !minStockLevelStr.isEmpty()) {
                double minStockLevel = Double.parseDouble(minStockLevelStr);
                item.setMinStockLevel(minStockLevel);
            } else {
                item.setMinStockLevel(0); // Default to 0
            }
            
            if (unitPriceStr != null && !unitPriceStr.isEmpty()) {
                double unitPrice = Double.parseDouble(unitPriceStr);
                item.setCostPerUnit(unitPrice);
            } else {
                item.setCostPerUnit(0); // Default to 0
            }
            
            // Set unit if provided
            item.setUnit(unit);
            
            // Set storage location
            item.setStorageLocation(request.getParameter("storageLocation"));
            
            // Save the item
            InventoryItemDAO itemDAO = new InventoryItemDAO();
            boolean success = itemDAO.addItem(item);
            
            if (success) {
                // Set success message and redirect to items list
                request.getSession().setAttribute("message", "Item added successfully");
                response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
            } else {
                // Set error message and show form again
                request.setAttribute("error", "Failed to add item");
                request.setAttribute("item", item); // Return the filled form
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            // Handle invalid number format
            request.setAttribute("error", "Invalid number format");
            doGet(request, response);
        }
    }
}
