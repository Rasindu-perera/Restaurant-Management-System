package servlet.admin.inventory;

import dao.inventory.CategoryDAO;
import dao.inventory.InventoryItemDAO;
import dao.inventory.PurchaseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.inventory.Category;
import model.inventory.InventoryItem;
import model.inventory.Purchase;

@WebServlet("/admin/inventory/reports")
public class ReportsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get report type
        String reportType = request.getParameter("type");
        if (reportType == null) {
            reportType = "inventory"; // Default report type
        }
        
        // Get date range for reports that need it
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        // Set default date range to last 30 days if not specified
        if (startDateStr == null || endDateStr == null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Calendar cal = Calendar.getInstance();
            endDateStr = sdf.format(cal.getTime()); // Today
            
            cal.add(Calendar.DAY_OF_MONTH, -30); // 30 days ago
            startDateStr = sdf.format(cal.getTime());
        }
        
        // DAOs for data access
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        PurchaseDAO purchaseDAO = new PurchaseDAO();
        
        // Generate the requested report
        switch (reportType) {
            case "inventory":
                // Inventory Stock Report
                List<InventoryItem> inventoryItems = itemDAO.getAllItems();
                double totalInventoryValue = 0;
                for (InventoryItem item : inventoryItems) {
                    totalInventoryValue += item.getTotalStockValue();
                }
                
                request.setAttribute("inventoryItems", inventoryItems);
                request.setAttribute("totalInventoryValue", totalInventoryValue);
                break;
                
            case "lowstock":
                // Low Stock Report
                List<InventoryItem> lowStockItems = itemDAO.getLowStockItems();
                request.setAttribute("lowStockItems", lowStockItems);
                break;
                
            case "purchases":
                // Purchases Report
                List<Purchase> purchases = purchaseDAO.getPurchasesByDateRange(startDateStr, endDateStr);
                double totalPurchaseValue = 0;
                for (Purchase purchase : purchases) {
                    totalPurchaseValue += purchase.getQuantity() * purchase.getUnitPrice();
                }
                
                request.setAttribute("purchases", purchases);
                request.setAttribute("totalPurchaseValue", totalPurchaseValue);
                break;
                
            case "category":
                // Category-based Inventory Report
                List<Category> categories = categoryDAO.getAllCategories();
                Map<Long, Double> categoryValues = new HashMap<>();
                Map<Long, Integer> categoryItemCounts = new HashMap<>();
                
                // Group items by category and calculate values
                List<InventoryItem> allItems = itemDAO.getAllItems();
                for (InventoryItem item : allItems) {
                    Long categoryId = item.getCategoryId();
                    if (categoryId != null) {
                        // Add to category value
                        double itemValue = item.getTotalStockValue();
                        categoryValues.put(categoryId, 
                                categoryValues.getOrDefault(categoryId, 0.0) + itemValue);
                        
                        // Count items in category
                        categoryItemCounts.put(categoryId, 
                                categoryItemCounts.getOrDefault(categoryId, 0) + 1);
                    }
                }
                
                request.setAttribute("categories", categories);
                request.setAttribute("categoryValues", categoryValues);
                request.setAttribute("categoryItemCounts", categoryItemCounts);
                request.setAttribute("allItems", allItems);
                break;
                
            case "value":
                // Value Report - Top items by value
                List<InventoryItem> valueItems = itemDAO.getAllItems("value");
                request.setAttribute("valueItems", valueItems);
                break;
        }
        
        // Set common attributes
        request.setAttribute("reportType", reportType);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        
        // Forward to the reports JSP
        request.getRequestDispatcher("/admin/inventory/reports.jsp").forward(request, response);
    }
}
