package servlet.admin.inventory;

import dao.inventory.InventoryItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/inventory/item/delete")
public class DeleteItemServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DeleteItemServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String itemIdStr = request.getParameter("itemId");
        
        if (itemIdStr != null && !itemIdStr.isEmpty()) {
            try {
                long itemId = Long.parseLong(itemIdStr);
                
                // Delete the item
                InventoryItemDAO itemDAO = new InventoryItemDAO();
                boolean success = itemDAO.deleteItem(itemId);
                
                if (success) {
                    // Set success message
                    request.getSession().setAttribute("message", "Item deleted successfully");
                } else {
                    // Set error message
                    request.getSession().setAttribute("error", "Failed to delete item. It may be referenced by purchases or other records.");
                }
                
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid item ID format: {0}", itemIdStr);
                request.getSession().setAttribute("error", "Invalid item ID");
            }
        } else {
            request.getSession().setAttribute("error", "Item ID is required");
        }
        
        // Redirect back to inventory items list
        response.sendRedirect(request.getContextPath() + "/admin/inventory/items");
    }
}
