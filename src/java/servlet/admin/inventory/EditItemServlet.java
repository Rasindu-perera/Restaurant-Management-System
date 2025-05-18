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

@WebServlet("/admin/inventory/item/edit")
public class EditItemServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String itemIdStr = request.getParameter("id");
        
        if (itemIdStr != null && !itemIdStr.isEmpty()) {
            try {
                long itemId = Long.parseLong(itemIdStr);
                
                // Get the item details
                InventoryItemDAO itemDAO = new InventoryItemDAO();
                InventoryItem item = itemDAO.getItemById(itemId);
                
                if (item != null) {
                    // Get all categories for dropdown
                    CategoryDAO categoryDAO = new CategoryDAO();
                    List<Category> categories = categoryDAO.getAllCategories();
                    
                    // Set attributes
                    request.setAttribute("item", item);
                    request.setAttribute("categories", categories);
                    
                    // Forward to edit form
                    request.getRequestDispatcher("/admin/inventory/edit-item.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID format
                request.getSession().setAttribute("error", "Invalid item ID format");
            }
        }
        
        // If we get here, something went wrong
        request.getSession().setAttribute("error", "Item not found");
        response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String itemIdStr = request.getParameter("itemId");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String categoryIdStr = request.getParameter("categoryId");
        String currentStockStr = request.getParameter("currentStock");
        String unitStr = request.getParameter("unit");
        String costPerUnitStr = request.getParameter("costPerUnit");
        String minStockLevelStr = request.getParameter("minStockLevel");
        String storageLocation = request.getParameter("storageLocation");
        
        try {
            // Validate required fields
            if (itemIdStr == null || itemIdStr.isEmpty() || name == null || name.isEmpty()) {
                request.getSession().setAttribute("error", "Item ID and name are required");
                response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
                return;
            }
            
            long itemId = Long.parseLong(itemIdStr);
            
            // Get existing item
            InventoryItemDAO itemDAO = new InventoryItemDAO();
            InventoryItem item = itemDAO.getItemById(itemId);
            
            if (item == null) {
                request.getSession().setAttribute("error", "Item not found");
                response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
                return;
            }
            
            // Update item properties
            item.setName(name);
            
            // Set category if provided
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                long categoryId = Long.parseLong(categoryIdStr);
                item.setCategoryId(categoryId);
                
                // Get category
                CategoryDAO categoryDAO = new CategoryDAO();
                Category category = categoryDAO.getCategoryById(categoryId);
                if (category != null) {
                    item.setCategory(category);
                }
            }
            
            // Set numeric fields if provided
            if (currentStockStr != null && !currentStockStr.isEmpty()) {
                double currentStock = Double.parseDouble(currentStockStr);
                item.setCurrentQuantity(currentStock);
            }
            
            if (unitStr != null) {
                item.setUnit(unitStr);
            }
            
            if (costPerUnitStr != null && !costPerUnitStr.isEmpty()) {
                double costPerUnit = Double.parseDouble(costPerUnitStr);
                item.setCostPerUnit(costPerUnit);
            }
            
            if (minStockLevelStr != null && !minStockLevelStr.isEmpty()) {
                double minStockLevel = Double.parseDouble(minStockLevelStr);
                item.setMinStockLevel(minStockLevel);
            }
            
            if (storageLocation != null) {
                item.setStorageLocation(storageLocation);
            }
            
            // Debug logging
            System.out.println("Updating item: " + item.getItemId());
            System.out.println("Name: " + item.getName());
            System.out.println("Category ID: " + item.getCategoryId());
            System.out.println("Current Quantity: " + item.getCurrentQuantity());
            System.out.println("Unit: " + item.getUnit());
            System.out.println("Cost Per Unit: " + item.getCostPerUnit());
            System.out.println("Min Stock Level: " + item.getMinStockLevel());
            System.out.println("Storage Location: " + item.getStorageLocation());
            
            // Update the item in database
            boolean success = itemDAO.updateItem(item);
            
            if (success) {
                request.getSession().setAttribute("message", "Item updated successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to update item");
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid number format");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error updating item: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
    }
}
