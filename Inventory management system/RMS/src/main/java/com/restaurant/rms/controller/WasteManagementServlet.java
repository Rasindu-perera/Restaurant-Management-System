package com.restaurant.rms.controller;

import com.restaurant.rms.dao.InventoryDAO;
import com.restaurant.rms.dao.WasteLogDAO;
import com.restaurant.rms.model.InventoryItem;
import com.restaurant.rms.model.WasteLog;
import com.restaurant.rms.util.AuthUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "WasteManagementServlet", value = "/waste")
public class WasteManagementServlet extends HttpServlet {
    private final WasteLogDAO wasteLogDAO;
    private final InventoryDAO inventoryDAO;

    public WasteManagementServlet() {
        this.wasteLogDAO = new WasteLogDAO();
        this.inventoryDAO = new InventoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listWasteLogs(request, response);
        } else if (action.equals("new")) {
            showNewWasteForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action.equals("save")) {
            saveWasteLog(request, response);
        }
    }

    private void listWasteLogs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<WasteLog> wasteLogs = wasteLogDAO.findAll();
        request.setAttribute("wasteLogs", wasteLogs);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/waste/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewWasteForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<InventoryItem> items = inventoryDAO.findAll();
        request.setAttribute("items", items);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/waste/form.jsp");
        dispatcher.forward(request, response);
    }

    private void saveWasteLog(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long itemId = Long.parseLong(request.getParameter("item_id"));
        double quantity = Double.parseDouble(request.getParameter("quantity"));
        String reason = request.getParameter("reason");
        String notes = request.getParameter("notes");

        // Create a new WasteLog entry
        WasteLog wasteLog = new WasteLog();
        wasteLog.setItemId(itemId);
        wasteLog.setQuantity(quantity);
        wasteLog.setReason(WasteLog.WasteReason.valueOf(reason));
        wasteLog.setNotes(notes);
        wasteLog.setWasteDate(new Date());
        wasteLog.setRecordedBy(AuthUtil.getCurrentUserId(request.getSession()));

        // Deduct the wasted quantity from the inventory
        InventoryItem item = inventoryDAO.findById(itemId);
        if (item != null) {
            double newQuantity = item.getCurrentQuantity() - quantity;
            if (newQuantity < 0) {
                newQuantity = 0; // Prevent negative stock
            }
            item.setCurrentQuantity(newQuantity);
            inventoryDAO.update(item);
        }

        // Save the waste log
        wasteLogDAO.save(wasteLog);

        response.sendRedirect(request.getContextPath() + "/waste");
    }
}