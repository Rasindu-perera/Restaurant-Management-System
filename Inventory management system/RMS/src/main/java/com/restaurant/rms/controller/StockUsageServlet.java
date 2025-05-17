package com.restaurant.rms.controller;

import com.restaurant.rms.model.*;
import com.restaurant.rms.service.InventoryService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "StockUsageServlet", value = "/stock-usage")
public class StockUsageServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(StockUsageServlet.class.getName());
    private final InventoryService inventoryService;

    public StockUsageServlet() {
        this.inventoryService = new InventoryService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<InventoryItem> items = inventoryService.getAllItems();
            request.setAttribute("items", items);
            request.getRequestDispatcher("/views/inventory/daily-usage.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to load stock usage form", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load stock usage form");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<StockUsageLog> usageLogs = parseUsageLogsFromRequest(request);
            inventoryService.recordDailyUsage(usageLogs, getCurrentUser(request));

            // Redirect to the daily usage page with a success message
            response.sendRedirect(request.getContextPath()
                    + "/inventory?action=daily-usage&message=Stock+usage+recorded+successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error recording stock usage", e);
            request.setAttribute("error", "Failed to record usage: " + e.getMessage());
            doGet(request, response); // Redisplay the form with an error message
        }
    }

    private List<StockUsageLog> parseUsageLogsFromRequest(HttpServletRequest request) {
        List<StockUsageLog> logs = new ArrayList<>();
        String[] itemIds = request.getParameterValues("itemId");
        String[] quantities = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("notes");

        if (itemIds == null || quantities == null) {
            return logs;
        }

        for (int i = 0; i < itemIds.length; i++) {
            try {
                double qty = Double.parseDouble(quantities[i]);
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

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new IllegalStateException("User session is invalid or expired");
        }
        return (User) session.getAttribute("user");
    }
}