package com.restaurant.rms.controller;

import com.restaurant.rms.model.*;
import com.restaurant.rms.service.PurchaseService;
import com.restaurant.rms.service.InventoryService;
import com.restaurant.rms.service.SupplierService;
import com.restaurant.rms.service.CategoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet(name = "PurchaseServlet", value = "/purchases")
public class PurchaseServlet extends HttpServlet {
    private final PurchaseService purchaseService;
    private final InventoryService inventoryService;
    private final SupplierService supplierService;
    private final CategoryService categoryService;

    public PurchaseServlet() {
        this.purchaseService = new PurchaseService();
        this.inventoryService = new InventoryService();
        this.supplierService = new SupplierService();
        this.categoryService = new CategoryService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list": // Handle the default action
                showPurchaseForm(request, response);
                break;
            case "purchase-history":
                showPurchaseHistory(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "The requested action is not available.");
        }
    }

    private void showPurchaseForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> items = inventoryService.getAllItems(); // Fetch all inventory items
        List<Supplier> suppliers = supplierService.getAllSuppliers(); // Fetch all suppliers
        List<Category> categories = categoryService.getAllCategories(); // Fetch all categories

        request.setAttribute("items", items);
        request.setAttribute("suppliers", suppliers); // Ensure suppliers are set
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/views/purchases/form.jsp").forward(request, response); // Forward to the form JSP
    }

    private void showPurchaseHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Purchase> purchases = purchaseService.getAllPurchases();
        request.setAttribute("purchases", purchases);
        request.getRequestDispatcher("/views/purchases/purchase-history.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String[] selectedItems = request.getParameterValues("selectedItems");
            if (selectedItems == null || selectedItems.length == 0) {
                throw new IllegalArgumentException("No items selected for purchase.");
            }

            List<PurchaseItem> purchaseItems = new ArrayList<>();
            double totalCost = 0.0;

            for (String itemIdStr : selectedItems) {
                Long itemId = Long.parseLong(itemIdStr);

                double quantity = Double.parseDouble(request.getParameter("quantity_" + itemId));
                double unitPrice = Double.parseDouble(request.getParameter("unitPrice_" + itemId));
                String expiryDateStr = request.getParameter("expiryDate_" + itemId);
                String batchNumber = request.getParameter("batchNumber_" + itemId);

                Date expiryDate = expiryDateStr != null && !expiryDateStr.isEmpty()
                        ? java.sql.Date.valueOf(expiryDateStr)
                        : null;

                InventoryItem item = inventoryService.getItemById(itemId);
                if (item == null) {
                    throw new IllegalArgumentException("Invalid item ID: " + itemId);
                }

                // Create purchase item
                PurchaseItem purchaseItem = new PurchaseItem();
                purchaseItem.setItem(item);
                purchaseItem.setQuantity(quantity);
                purchaseItem.setUnitPrice(unitPrice);
                purchaseItem.setExpiryDate(expiryDate);
                purchaseItem.setBatchNumber(batchNumber);

                purchaseItems.add(purchaseItem);

                // Update inventory quantity
                item.setCurrentQuantity(item.getCurrentQuantity() + quantity);
                inventoryService.saveItem(item);

                totalCost += quantity * unitPrice;
            }

            // Save purchase
            Purchase purchase = new Purchase();
            purchase.setPurchaseDate(new Date());
            purchase.setPurchaseTime(new Time(System.currentTimeMillis())); // Set the current time
            purchase.setItems(purchaseItems);
            purchase.setTotalCost(totalCost);
            purchase.setNotes(request.getParameter("notes")); // Get notes from the form
            purchase.setSupplier(supplierService.getSupplierById(Long.parseLong(request.getParameter("supplierId")))); // Set
                                                                                                                       // supplier
            purchase.setCreatedBy((User) request.getSession().getAttribute("loggedInUser")); // Set the logged-in user

            purchaseService.savePurchase(purchase);

            response.sendRedirect(request.getContextPath()
                    + "/purchases?action=purchase-history&message=Purchase+recorded+successfully");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}