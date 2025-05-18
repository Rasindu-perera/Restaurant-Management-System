package servlet.admin.inventory;

import dao.inventory.InventoryItemDAO;
import dao.inventory.PurchaseDAO;
import dao.inventory.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.InventoryItem;
import model.inventory.Purchase;
import model.inventory.Category;

@WebServlet("/admin/inventory/dashboard")
public class InventoryDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get inventory statistics
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        
        // Get total items count
        int totalItems = itemDAO.getTotalItemCount();
        request.setAttribute("totalItems", totalItems);
        
        // Get total categories count
        CategoryDAO categoryDAO = new CategoryDAO();
        int totalCategories = categoryDAO.getTotalCategoryCount();
        request.setAttribute("totalCategories", totalCategories);
        
        // Get inventory value
        double totalValue = itemDAO.getTotalInventoryValue();
        request.setAttribute("totalValue", totalValue);
        
        // Get low stock items
        List<InventoryItem> lowStockItems = itemDAO.getLowStockItems();
        request.setAttribute("lowStockItems", lowStockItems);
        
        // Get recent purchases - limit to 5
        PurchaseDAO purchaseDAO = new PurchaseDAO();
        List<Purchase> recentPurchases = purchaseDAO.getRecentPurchases(5);
        request.setAttribute("recentPurchases", recentPurchases);
        
        // Forward to dashboard JSP
        request.getRequestDispatcher("/admin/inventory/dashboard.jsp").forward(request, response);
    }
}