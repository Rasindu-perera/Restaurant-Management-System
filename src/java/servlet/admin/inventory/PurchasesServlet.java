package servlet.admin.inventory;

import dao.inventory.PurchaseDAO;
import dao.inventory.InventoryItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.Purchase;
import model.inventory.InventoryItem;
import model.inventory.PurchaseItem;

@WebServlet("/admin/inventory/purchases")
public class PurchasesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get filter parameters
        String itemIdStr = request.getParameter("itemId");
        String supplier = request.getParameter("supplier");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String sortBy = request.getParameter("sortBy");
        
        // Get purchase data
        PurchaseDAO purchaseDAO = new PurchaseDAO();
        List<Purchase> purchases;
        
        // Apply filters if provided
        if (itemIdStr != null && !itemIdStr.isEmpty()) {
            try {
                long itemId = Long.parseLong(itemIdStr);
                purchases = purchaseDAO.getPurchasesByItemId(itemId);
            } catch (NumberFormatException e) {
                purchases = purchaseDAO.getAllPurchases();
            }
        } else if (supplier != null && !supplier.isEmpty()) {
            purchases = purchaseDAO.getPurchasesBySupplier(supplier);
        } else if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
            purchases = purchaseDAO.getPurchasesByDateRange(startDate, endDate);
        } else {
            purchases = purchaseDAO.getAllPurchases();
        }
        
        // Get items for dropdown filter
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        List<InventoryItem> items = itemDAO.getAllItems();
        request.setAttribute("items", items);

        // If you're tracking a selected item, use the same property name
        if (itemIdStr != null && !itemIdStr.isEmpty()) {
            long selectedItemId = Long.parseLong(itemIdStr);
            request.setAttribute("selectedItemId", selectedItemId);
        }
        
        // Get unique suppliers for filter dropdown
        List<String> suppliers = purchaseDAO.getAllSuppliers();
        
        // Calculate totals
        double totalPurchaseValue = 0;
        for (Purchase purchase : purchases) {
            if (purchase != null) {
                // First try direct properties
                try {
                    double quantity = purchase.getQuantity();
                    double unitPrice = purchase.getUnitPrice();
                    totalPurchaseValue += quantity * unitPrice;
                } catch (Exception e) {
                    // If that fails, try using the items list
                    if (purchase.getItems() != null && !purchase.getItems().isEmpty()) {
                        for (PurchaseItem item : purchase.getItems()) {
                            totalPurchaseValue += item.getQuantity() * item.getUnitPrice();
                        }
                    } else if (purchase.getTotalCost() > 0) {
                        // If that fails too, use the totalCost property
                        totalPurchaseValue += purchase.getTotalCost();
                    }
                }
            }
        }
        
        // Set attributes
        request.setAttribute("purchases", purchases);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("totalPurchases", purchases.size());
        request.setAttribute("totalPurchaseValue", totalPurchaseValue);
        request.setAttribute("selectedSupplier", supplier);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("sortBy", sortBy);
        
        // Forward to JSP
        request.getRequestDispatcher("/admin/inventory/purchases.jsp").forward(request, response);
    }
}
