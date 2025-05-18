package servlet.admin.inventory;

import dao.inventory.InventoryItemDAO;
import dao.inventory.PurchaseDAO;
import dao.inventory.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.inventory.InventoryItem;
import model.inventory.Purchase;
import model.inventory.PurchaseItem;
import model.inventory.Supplier;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/inventory/purchase/add")
public class AddPurchaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get inventory items for dropdown
        InventoryItemDAO itemDAO = new InventoryItemDAO();
        List<InventoryItem> inventoryItems = itemDAO.getAllItems();
        
        // Get suppliers for dropdown
        SupplierDAO supplierDAO = new SupplierDAO();
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        
        // Set attributes for the form
        request.setAttribute("inventoryItems", inventoryItems);
        request.setAttribute("suppliers", suppliers);
        
        // Forward to the add purchase form
        request.getRequestDispatcher("/admin/inventory/add-purchase.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String purchaseDateStr = request.getParameter("purchaseDate");
        String supplierIdStr = request.getParameter("supplierId");
        String invoiceNumber = request.getParameter("receiptNumber");
        String notes = request.getParameter("notes");
        
        // Item details (can be multiple)
        String[] itemIds = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        
        try {
            // Create purchase object
            Purchase purchase = new Purchase();
            
            // Set purchase date
            if (purchaseDateStr != null && !purchaseDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date purchaseDate = sdf.parse(purchaseDateStr);
                purchase.setPurchaseDate(new Timestamp(purchaseDate.getTime()));
            } else {
                purchase.setPurchaseDate(new Timestamp(System.currentTimeMillis()));
            }
            
            // Set supplier
            if (supplierIdStr != null && !supplierIdStr.isEmpty()) {
                try {
                    long supplierId = Long.parseLong(supplierIdStr);
                    purchase.setSupplierId(supplierId);
                    
                    // Get supplier details
                    SupplierDAO supplierDAO = new SupplierDAO();
                    Supplier supplier = supplierDAO.getSupplierById(supplierId);
                    if (supplier != null) {
                        purchase.setSupplier(supplier);
                    }
                } catch (NumberFormatException e) {
                    // Handle invalid supplier ID
                    request.setAttribute("error", "Invalid supplier ID");
                    doGet(request, response);
                    return;
                }
            }
            
            // Set other purchase details
            purchase.setInvoiceNumber(invoiceNumber);
            purchase.setNotes(notes);
            purchase.setPurchaseTime(new java.sql.Time(System.currentTimeMillis()));
            
            // Create purchase items
            List<PurchaseItem> purchaseItems = new ArrayList<>();
            
            // Only process if we have items
            if (itemIds != null && itemIds.length > 0) {
                for (int i = 0; i < itemIds.length; i++) {
                    // Skip empty items
                    if (itemIds[i] == null || itemIds[i].isEmpty()) {
                        continue;
                    }
                    
                    PurchaseItem item = new PurchaseItem();
                    
                    // Set item ID
                    long itemId = Long.parseLong(itemIds[i]);
                    item.setItemId(itemId);
                    
                    // Get item details
                    InventoryItemDAO itemDAO = new InventoryItemDAO();
                    InventoryItem inventoryItem = itemDAO.getItemById(itemId);
                    if (inventoryItem != null) {
                        item.setItem(inventoryItem);
                    }
                    
                    // Set quantity
                    if (quantities != null && i < quantities.length) {
                        double quantity = Double.parseDouble(quantities[i]);
                        item.setQuantity(quantity);
                    }
                    
                    // Set unit price
                    if (unitPrices != null && i < unitPrices.length) {
                        double unitPrice = Double.parseDouble(unitPrices[i]);
                        item.setUnitPrice(unitPrice);
                    }
                    
                    purchaseItems.add(item);
                }
            }
            
            // Set items to purchase
            purchase.setItems(purchaseItems);
            
            // Calculate total cost based on items
            double totalCost = 0;
            for (PurchaseItem item : purchaseItems) {
                totalCost += item.getQuantity() * item.getUnitPrice();
            }
            purchase.setTotalCost(totalCost);
            
            // Save the purchase
            PurchaseDAO purchaseDAO = new PurchaseDAO();
            boolean success = purchaseDAO.addPurchase(purchase);
            
            if (success) {
                // Set success message and redirect to purchases list
                request.getSession().setAttribute("message", "Purchase added successfully");
                response.sendRedirect(request.getContextPath() + "/admin/inventory/purchases");
            } else {
                // Set error message and show form again
                request.setAttribute("error", "Failed to add purchase");
                doGet(request, response);
            }
            
        } catch (NumberFormatException | ParseException e) {
            // Handle invalid input
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            doGet(request, response);
        }
    }
}
