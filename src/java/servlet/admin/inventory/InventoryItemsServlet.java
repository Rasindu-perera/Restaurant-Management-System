package servlet.admin.inventory;

import dao.inventory.InventoryItemDAO;
import dao.inventory.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.InventoryItem;

@WebServlet("/admin/inventory/items")
public class InventoryItemsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get all inventory items
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        List<InventoryItem> allItems = itemDAO.getAllItems();
        
        // Get categories for filter dropdown
        CategoryDAO categoryDAO = new CategoryDAO();
        List<String> categories = categoryDAO.getAllCategoryNames();
        
        // Set attributes for the page
        request.setAttribute("inventoryItems", allItems);
        request.setAttribute("categories", categories);
        
        // Forward to the JSP
        request.getRequestDispatcher("/admin/inventory/items.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Handle search/filter requests
        String searchTerm = request.getParameter("search");
        String categoryFilter = request.getParameter("category");
        String sortBy = request.getParameter("sortBy");
        
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        List<InventoryItem> filteredItems;
        
        if (searchTerm != null && !searchTerm.isEmpty()) {
            // Search by name or description
            filteredItems = itemDAO.searchItems(searchTerm);
        } else if (categoryFilter != null && !categoryFilter.equals("all")) {
            // Filter by category
            filteredItems = itemDAO.getItemsByCategory(categoryFilter);
        } else {
            // Get all items with optional sorting
            filteredItems = itemDAO.getAllItems(sortBy);
        }
        
        CategoryDAO categoryDAO = new CategoryDAO();
        List<String> categories = categoryDAO.getAllCategoryNames();
        
        request.setAttribute("inventoryItems", filteredItems);
        request.setAttribute("categories", categories);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("categoryFilter", categoryFilter);
        request.setAttribute("sortBy", sortBy);
        
        request.getRequestDispatcher("/admin/inventory/items.jsp").forward(request, response);
    }
}
