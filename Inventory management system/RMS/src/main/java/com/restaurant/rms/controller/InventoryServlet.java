package com.restaurant.rms.controller;

import com.restaurant.rms.model.*;
import com.restaurant.rms.service.InventoryService;
import com.restaurant.rms.service.CategoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "InventoryServlet", value = "/inventory")
public class InventoryServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(InventoryServlet.class.getName());
    private final InventoryService inventoryService;
    private final CategoryService categoryService;

    public InventoryServlet() {
        this.inventoryService = new InventoryService();
        this.categoryService = new CategoryService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            action = action == null ? "list" : action;

            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteItem(request, response);
                    break;
                case "search":
                    searchItems(request, response);
                    break;
                case "low-stock":
                    showLowStockItems(request, response);
                    break;
                case "daily-usage":
                    showDailyUsageForm(request, response);
                    break;
                case "usage-history":
                    showUsageHistory(request, response);
                    break;
                case "add-new-item": // Ensure this action is handled
                    showAddNewItemForm(request, response);
                    break;
                default:
                    listItems(request, response);
                    break;
            }
        } catch (Exception ex) {
            handleError(request, response, "Failed to process request", ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String action = request.getParameter("action");
            if ("create".equals(action)) {
                createItem(request, response);
            } else if ("update".equals(action)) {
                updateItem(request, response);
            } else if ("adjust".equals(action)) {
                adjustStock(request, response);
            } else if ("save-daily-usage".equals(action)) {
                saveDailyUsage(request, response);
            } else if ("delete".equals(action)) {
                deleteItem(request, response);
            } else if ("add-new-item".equals(action)) {
                addNewItem(request, response);
            }
        } catch (Exception ex) {
            handleError(request, response, "Failed to save item", ex);
        }
    }

    private boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
    }

    private void showAddNewItemForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/inventory/add-new-item.jsp").forward(request, response);
    }

    private void addNewItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        InventoryItem item = new InventoryItem();
        try {
            item.setName(request.getParameter("name"));
            item.setMinStockLevel(Double.parseDouble(request.getParameter("minStock")));
            item.setStorageLocation(request.getParameter("location"));
            Long categoryId = Long.parseLong(request.getParameter("category"));
            item.setCategory(categoryService.getCategoryById(categoryId));
            item.setCurrentQuantity(0.0); // Initialize with 0 quantity
            item.setUnit(request.getParameter("unit"));

            inventoryService.saveItem(item);
            response.sendRedirect(request.getContextPath() + "/inventory?message=Item+added+successfully");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("item", item);
            showAddNewItemForm(request, response);
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> categories = categoryService.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/inventory/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        InventoryItem item = inventoryService.getItemById(id);
        if (item != null) {
            List<Category> categories = categoryService.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("item", item);
            request.getRequestDispatcher("/views/inventory/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/inventory?error=Item+not+found");
        }
    }

    private void showDailyUsageForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> items = inventoryService.getAllItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("/views/inventory/daily-usage.jsp").forward(request, response);
    }

    private void showUsageHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dateParam = request.getParameter("date");
        java.sql.Date date = dateParam != null ? java.sql.Date.valueOf(dateParam)
                : new java.sql.Date(System.currentTimeMillis());

        List<StockUsageLog> usageLogs = inventoryService.getDailyUsageReport(date);
        request.setAttribute("usageLogs", usageLogs);
        request.setAttribute("selectedDate", date);
        request.getRequestDispatcher("/views/inventory/usage-history.jsp").forward(request, response);
    }

    private void saveDailyUsage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?expired=true");
            return;
        }

        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null || currentUser.getId() == null) {
                throw new IllegalStateException("Invalid user session");
            }

            List<StockUsageLog> logs = parseUsageLogsFromRequest(request);

            if (logs.isEmpty()) {
                request.setAttribute("warning", "No valid usage quantities entered");
                showDailyUsageForm(request, response);
                return;
            }

            inventoryService.recordDailyUsage(logs, currentUser);
            response.sendRedirect(request.getContextPath() +
                    "/inventory?message=Daily+usage+recorded+successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error recording daily usage: " + e.getMessage(), e);
            request.setAttribute("error", "Failed to record usage: " + e.getMessage());
            showDailyUsageForm(request, response);
        }
    }

    private List<StockUsageLog> parseUsageLogsFromRequest(HttpServletRequest request) {
        List<StockUsageLog> logs = new java.util.ArrayList<>();
        String[] itemIds = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("notes");

        if (itemIds == null || quantities == null) {
            return logs;
        }

        for (int i = 0; i < itemIds.length; i++) {
            try {
                double qty = quantities[i] != null && !quantities[i].isEmpty() ? Double.parseDouble(quantities[i])
                        : 0.0;
                if (qty > 0) {
                    StockUsageLog log = new StockUsageLog();
                    InventoryItem item = new InventoryItem();
                    item.setId(Long.parseLong(itemIds[i]));
                    log.setItem(item);
                    log.setQuantityUsed(qty);
                    log.setNotes(notes != null && i < notes.length ? notes[i] : null);
                    logs.add(log);
                }
            } catch (NumberFormatException e) {
                logger.warning("Invalid quantity value for item " + itemIds[i]);
            }
        }
        return logs;
    }

    private void createItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        InventoryItem item = new InventoryItem();
        try {
            populateItemFromRequest(item, request); // Populate item details from the request
            inventoryService.saveItem(item); // Save the item using the service
            response.sendRedirect(request.getContextPath() + "/inventory?message=Item+created+successfully");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("item", item); // Pass the item back to the form for correction
            showNewForm(request, response); // Show the form again with the error message
        }
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        Long id = Long.parseLong(request.getParameter("id"));
        InventoryItem item = inventoryService.getItemById(id);
        if (item == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Item not found");
            return;
        }

        try {
            populateItemFromRequest(item, request);
            inventoryService.saveItem(item);
            response.sendRedirect("inventory?message=Item+updated+successfully");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("item", item);
            showEditForm(request, response);
        }
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String itemIdParam = request.getParameter("itemId"); // Use "itemId" instead of "id"
            if (itemIdParam == null || itemIdParam.isEmpty()) {
                response.sendRedirect("inventory?error=Item+ID+is+missing");
                return;
            }

            Long itemId = Long.parseLong(itemIdParam);
            inventoryService.deleteItem(itemId);
            response.sendRedirect("inventory?message=Item+deleted+successfully");
        } catch (NumberFormatException e) {
            response.sendRedirect("inventory?error=Invalid+item+ID");
        } catch (Exception e) {
            response.sendRedirect("inventory?error=Failed+to+delete+item");
        }
    }

    private void searchItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("query");
        String category = request.getParameter("category");

        List<InventoryItem> items = inventoryService.searchItems(query, category);
        request.setAttribute("items", items);
        request.setAttribute("searchQuery", query);
        request.setAttribute("searchCategory", category);
        request.getRequestDispatcher("/views/inventory/list.jsp").forward(request, response);
    }

    private void showLowStockItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> items = inventoryService.getLowStockItems();
        request.setAttribute("items", items);
        request.setAttribute("lowStockView", true);
        request.getRequestDispatcher("/views/inventory/list.jsp").forward(request, response);
    }

    private void adjustStock(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long itemId = Long.parseLong(request.getParameter("id"));
            Double adjustment = Double.parseDouble(request.getParameter("adjustment"));
            String notes = request.getParameter("notes");

            inventoryService.adjustStock(itemId, adjustment, notes);
            response.sendRedirect("inventory?message=Stock+adjusted+successfully");
        } catch (NumberFormatException e) {
            logger.warning("Invalid stock adjustment parameters: " + e.getMessage());
            response.sendRedirect("inventory?error=Invalid+stock+adjustment+parameters");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response,
            String message, Exception ex) throws ServletException, IOException {
        logger.log(Level.SEVERE, message, ex);
        request.setAttribute("error", message + ": " + ex.getMessage());
        request.getRequestDispatcher("/views/inventory/list.jsp").forward(request, response);
    }

    private void populateItemFromRequest(InventoryItem item, HttpServletRequest request) {
        item.setName(validateName(request.getParameter("name")));

        // Fetch the category object using the category ID
        String categoryIdParam = request.getParameter("category");
        if (categoryIdParam == null || categoryIdParam.trim().isEmpty()) {
            throw new IllegalArgumentException("Category is required");
        }
        Long categoryId;
        try {
            categoryId = Long.parseLong(categoryIdParam);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid category ID");
        }
        Category category = categoryService.getCategoryById(categoryId);
        if (category == null) {
            throw new IllegalArgumentException("Category not found");
        }
        item.setCategory(category);

        item.setCurrentQuantity(validateQuantity(request.getParameter("quantity")));
        item.setUnit(validateUnit(request.getParameter("unit")));

        String minStock = request.getParameter("minStock");
        if (minStock != null && !minStock.isEmpty()) {
            item.setMinStockLevel(validateQuantity(minStock));
        }

        item.setStorageLocation(request.getParameter("location"));

        String cost = request.getParameter("cost");
        if (cost != null && !cost.isEmpty()) {
            item.setCostPerUnit(validateCost(cost));
        }
    }

    private String validateName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Item name is required");
        }
        return name.trim();
    }

    private double validateQuantity(String quantity) {
        if (quantity == null || quantity.trim().isEmpty()) {
            throw new IllegalArgumentException("Quantity is required");
        }
        try {
            BigDecimal value = new BigDecimal(quantity);
            if (value.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Quantity cannot be negative");
            }
            return value.doubleValue();
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid quantity value");
        }
    }

    private String validateUnit(String unit) {
        if (unit == null || unit.trim().isEmpty()) {
            throw new IllegalArgumentException("Unit is required");
        }
        return unit.trim();
    }

    private double validateCost(String cost) {
        if (cost == null || cost.trim().isEmpty()) {
            throw new IllegalArgumentException("Cost is required");
        }
        try {
            BigDecimal value = new BigDecimal(cost);
            if (value.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Cost cannot be negative");
            }
            return value.doubleValue();
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid cost value");
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch all inventory items
        List<InventoryItem> items = inventoryService.getAllItems();

        // Set the items as a request attribute to be used in the JSP
        request.setAttribute("items", items);

        // Forward the request to the inventory list JSP
        request.getRequestDispatcher("/views/inventory/list.jsp").forward(request, response);
    }
}