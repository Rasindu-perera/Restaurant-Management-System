package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.BillDAO;
import dao.TableDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import java.util.ArrayList;
import model.Bill;
import model.Table;
import model.Order;
import model.OrderItem;
import java.sql.Timestamp;
import util.DBConnection;

@WebServlet("/ViewBillServlet")
public class ViewBillServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            request.setAttribute("error", "Session expired. Please login again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Table ID is required.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        int tableId;
        try {
            tableId = Integer.parseInt(tableIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid table ID format.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        System.out.println("Viewing bill for table: " + tableId);
        
        BillDAO billDAO = new BillDAO();
        TableDAO tableDAO = new TableDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();

        Table table = tableDAO.getTableById(tableId);
        if (table == null) {
            System.out.println("Table not found: " + tableId);
            request.setAttribute("error", "Invalid table number");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        // Get orders for this table that are after table creation time
        List<Order> orders = orderDAO.getOrdersByTableAfterTime(tableId, table.getCreatedAt());
        
        // Get bill data for this table
        List<Bill> bills = billDAO.getBillsByTable(tableId);
        double total = billDAO.getTotalBillAmount(tableId);

        // Set all necessary attributes for the JSP
        request.setAttribute("table", table);
        request.setAttribute("tableId", tableId);
        request.setAttribute("orders", orders);
        request.setAttribute("bills", bills);
        request.setAttribute("total", total);
        
        if (!bills.isEmpty()) {
            Timestamp latestTime = billDAO.getLatestBillTime(tableId);
            if (latestTime != null) {
                request.setAttribute("billTime", latestTime.toString());
            }
        }
        
        request.getRequestDispatcher("view_bill.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            request.setAttribute("error", "Session expired. Please login again.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Table ID is required.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        int tableId;
        try {
            tableId = Integer.parseInt(tableIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid table ID format.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        BillDAO billDAO = new BillDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();
        TableDAO tableDAO = new TableDAO();

        Table table = tableDAO.getTableById(tableId);
        if (table == null) {
            request.setAttribute("error", "Invalid table number");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        // Get orders for this table that are after table creation time
        List<Order> orders = orderDAO.getOrdersByTableAfterTime(tableId, table.getCreatedAt());
        
        boolean success = true;
        for (Order order : orders) {
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
            for (OrderItem item : orderItems) {
                // Create bill entry for each order item
                if (!billDAO.saveBill(tableId, order.getOrderId(), item.getItemName(), 
                                    item.getQuantity(), item.getPrice())) {
                    success = false;
                    break;
                }
            }
            if (!success) break;
        }

        if (success) {
            // Update order status to indicate it's been billed
            for (Order order : orders) {
                orderDAO.updateOrderStatus(order.getOrderId(), "BILLED");
            }
            // Redirect back to the bill view with the updated data
            response.sendRedirect("ViewBillServlet?tableId=" + tableId);
        } else {
            request.setAttribute("error", "Failed to process payment. Please try again.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}