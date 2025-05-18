package controller;

import dao.BillDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Bill;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/admin/DailySalesServlet")
public class DailySalesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get the date parameter, default to today if not provided
        String dateParam = request.getParameter("date");
        if (dateParam == null || dateParam.isEmpty()) {
            dateParam = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        }
        
        BillDAO billDAO = new BillDAO();
        
        // Get daily sales data
        List<Bill> dailySales = billDAO.getDailySales(dateParam);
        
        // Get item-wise sales data for pie chart
        Map<String, Integer> itemSales = billDAO.getItemSalesByDate(dateParam);
        
        // Get daily income
        double dailyIncome = billDAO.getDailyIncome(dateParam);
        
        // Get most popular items (top 5)
        Map<String, Integer> popularItems = billDAO.getMostPopularItems(5);
        
        // Set attributes for the JSP
        request.setAttribute("dailySales", dailySales);
        request.setAttribute("itemSales", itemSales);
        request.setAttribute("dailyIncome", dailyIncome);
        request.setAttribute("selectedDate", dateParam);
        request.setAttribute("popularItems", popularItems);
        
        // Calculate item sales percentages for the pie chart
        Map<String, Double> itemSalesPercentages = calculatePercentages(itemSales);
        request.setAttribute("itemSalesPercentages", itemSalesPercentages);
        
        // Forward to the daily sales JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("daily_sales.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Calculates percentages for each item based on total quantity
     */
    private Map<String, Double> calculatePercentages(Map<String, Integer> itemSales) {
        Map<String, Double> percentages = new LinkedHashMap<>();
        
        // Calculate total quantities
        int totalQty = 0;
        for (int qty : itemSales.values()) {
            totalQty += qty;
        }
        
        // Calculate percentages if total is not zero
        if (totalQty > 0) {
            for (Map.Entry<String, Integer> entry : itemSales.entrySet()) {
                double percentage = (entry.getValue() * 100.0) / totalQty;
                percentages.put(entry.getKey(), Math.round(percentage * 10) / 10.0); // Round to 1 decimal place
            }
        }
        
        return percentages;
    }
}
