package controller;

import dao.OrderDAO;
import dao.TableDAO;
import dao.OrderItemDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderItem;
import model.CartItem;
import model.Table;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/TableOrderStatusServlet")
public class TableOrderStatusServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TableOrderStatusServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Fetching table order status");
        
        OrderDAO orderDAO = new OrderDAO();
        TableDAO tableDAO = new TableDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();
        
        // Get all active orders (only SENT and READY status)
        List<Order> activeOrders = orderDAO.getOrdersByStatus(new String[]{"SENT", "READY"});
        
        // Group orders by table ID
        Map<Integer, List<Order>> ordersByTable = new HashMap<>();
        
        for (Order order : activeOrders) {
            int tableId = order.getTableId();
            
            // Get order items for this order
            List<OrderItem> orderItems = orderItemDAO.getOrderItemsByOrderId(order.getOrderId());
            
            // Convert OrderItem to CartItem (which Order class expects)
            List<CartItem> cartItems = new ArrayList<>();
            for (OrderItem orderItem : orderItems) {
                CartItem cartItem = new CartItem();
                // Set the properties from OrderItem to CartItem
                // NOTE: Assuming CartItem has these setter methods
                cartItem.setItemName(orderItem.getItemName());
                cartItem.setQuantity(orderItem.getQuantity());
                cartItems.add(cartItem);
            }
            
            // Now set the converted items
            order.setItems(cartItems);
            
            // Add to the table group
            if (!ordersByTable.containsKey(tableId)) {
                ordersByTable.put(tableId, new ArrayList<>());
            }
            ordersByTable.get(tableId).add(order);
        }
        
        // Get all table details
        List<Table> allTables = tableDAO.getAllTables();
        Map<Integer, Table> tableDetailsMap = new HashMap<>();
        
        for (Table table : allTables) {
            tableDetailsMap.put(table.getTableId(), table);
        }
        
        request.setAttribute("ordersByTable", ordersByTable);
        request.setAttribute("tableDetails", tableDetailsMap);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("Table Order Status.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
