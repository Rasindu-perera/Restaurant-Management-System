package servlet.admin.inventory;

import dao.inventory.InventoryItemDAO;
import dao.inventory.PurchaseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.inventory.InventoryItem;
import model.inventory.PurchaseItem;

@WebServlet("/admin/inventory/item/view")
public class ViewItemServlet extends HttpServlet {

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
                    // Get recent purchases for this item
                    PurchaseDAO purchaseDAO = new PurchaseDAO();
                    List<PurchaseItem> recentPurchases = purchaseDAO.getRecentPurchaseItemsByItemId(itemId, 5);
                    
                    // Set attributes
                    request.setAttribute("item", item);
                    request.setAttribute("recentPurchases", recentPurchases);
                    
                    // Forward to view page
                    request.getRequestDispatcher("/admin/inventory/view-item.jsp").forward(request, response);
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
}
