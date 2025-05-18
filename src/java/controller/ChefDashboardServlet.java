package controller;

import dao.ChefDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Chef;
import model.Order;

@WebServlet(name = "ChefDashboardServlet", urlPatterns = {"/chef/dashboard"})
public class ChefDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ChefDashboardServlet.class.getName());
    private final ChefDAO chefDAO = new ChefDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("chefId") == null) {
            response.sendRedirect(request.getContextPath() + "/chef/login");
            return;
        }

        try {
            int chefId = (int) session.getAttribute("chefId");
            Chef chef = chefDAO.getChefById(chefId); 
            if (chef == null) {
                LOGGER.log(Level.WARNING, "Chef not found for chefId: {0}. Invalidating session.", chefId);
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/chef/login?error=invalid_chef");
                return;
            }

            List<Order> pendingOrders = orderDAO.getPendingOrders();
            LOGGER.log(Level.INFO, "Retrieved {0} pending orders for chef {1} (ID: {2})", new Object[]{pendingOrders.size(), chef.getName(), chefId});
            
            request.setAttribute("chefName", chef.getName());
            request.setAttribute("pendingOrders", pendingOrders);
            // Messages from doPost will be preserved by the forward if already set
            request.getRequestDispatcher("/chef_dashboard.jsp").forward(request, response);
            
        } catch (ServletException | IOException e) { 
            LOGGER.log(Level.SEVERE, "Error in doGet while loading chef dashboard", e);
            request.setAttribute("error", "An unexpected error occurred while loading the dashboard."); // Use "error"
            if (!response.isCommitted()) {
                request.getRequestDispatcher("/chef_dashboard.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("chefId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        
        if (action == null || orderIdStr == null || action.trim().isEmpty() || orderIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Missing required parameters (action or orderId)."); // Use "error"
            LOGGER.log(Level.WARNING, "Missing action or orderId parameter.");
            doGet(request, response); 
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr.trim());
            int chefId = (int) session.getAttribute("chefId");
            
            LOGGER.log(Level.INFO, "Processing action: ''{0}'' for order: {1} by chef: {2}", new Object[]{action, orderId, chefId});

            boolean success = false;
            String message = ""; 

            switch (action) {
                case "confirm" -> { 
                    LOGGER.log(Level.INFO, "Attempting to mark order as ready: {0}", orderId);
                    Order order = orderDAO.getOrderById(orderId); 
                    if (order == null) {
                        message = "Order (ID: " + orderId + ") does not exist.";
                        LOGGER.log(Level.WARNING, "Order not found for confirm action: {0}", orderId);
                    } else {
                        String currentStatus = order.getStatus(); 
                        LOGGER.log(Level.INFO, "Current status for order {0} before confirm: ''{1}''", new Object[]{orderId, currentStatus});
                        if (!"SENT".equals(currentStatus)) { 
                            message = "Cannot mark order as ready. Order (ID: " + orderId + ") is not in 'SENT' state. Current status: " + currentStatus;
                            LOGGER.log(Level.WARNING, message);
                        } else {
                            // Update the status directly to 'READY' instead of 'CONFIRMED'
                            success = orderDAO.updateOrderStatus(orderId, "READY", chefId); 
                            if (!success) {
                                message = "Failed to mark order (ID: " + orderId + ") as ready. Database update may have failed. Check server logs.";
                                LOGGER.log(Level.WARNING, "orderDAO.updateOrderStatus returned false for orderId: {0}", orderId);
                            } else {
                                message = "Order (ID: " + orderId + ") marked as ready successfully.";
                                LOGGER.log(Level.INFO, message);
                            }
                        }
                    }
                }
                    
                case "complete" -> { 
                    LOGGER.log(Level.INFO, "Attempting to mark order as completed: {0}", orderId);
                    Order order = orderDAO.getOrderById(orderId);
                    if (order == null) {
                        message = "Order (ID: " + orderId + ") does not exist.";
                        LOGGER.log(Level.WARNING, "Order not found for complete action: {0}", orderId);
                    } else {
                        String currentStatus = order.getStatus();
                        LOGGER.log(Level.INFO, "Current status for order {0} before complete: ''{1}''", new Object[]{orderId, currentStatus});
                        if (!"READY".equals(currentStatus)) {
                            message = "Cannot mark order as completed. Order (ID: " + orderId + ") is not in 'READY' state. Current status: " + currentStatus;
                            LOGGER.log(Level.WARNING, message);
                        } else {
                            success = orderDAO.markOrderAsCompleted(orderId); 
                            if (!success) {
                                message = "Failed to mark order (ID: " + orderId + ") as completed. Check server logs.";
                                LOGGER.log(Level.WARNING, "orderDAO.markOrderAsCompleted returned false for orderId: {0}", orderId);
                            } else {
                                message = "Order (ID: " + orderId + ") marked as completed.";
                                LOGGER.log(Level.INFO, message);
                            }
                        }
                    }
                }
                    
                case "completed" -> { 
                    LOGGER.log(Level.INFO, "Attempting to mark order as completed: {0}", orderId);
                     Order order = orderDAO.getOrderById(orderId);
                    if (order == null) {
                        message = "Order (ID: " + orderId + ") does not exist.";
                        LOGGER.log(Level.WARNING, "Order not found for completed action: {0}", orderId);
                    } else {
                        String currentStatus = order.getStatus();
                         LOGGER.log(Level.INFO, "Current status for order {0} before marking completed: ''{1}''", new Object[]{orderId, currentStatus});
                        if (!"READY".equals(currentStatus)) {
                             message = "Cannot mark order as completed. Order (ID: " + orderId + ") is not in 'READY' state. Current status: " + currentStatus;
                            LOGGER.log(Level.WARNING, message);
                        } else {
                            success = orderDAO.markOrderAsCompleted(orderId);
                            if (!success) {
                                message = "Failed to mark order (ID: " + orderId + ") as completed. Check server logs.";
                                LOGGER.log(Level.WARNING, "orderDAO.markOrderAsCompleted returned false for orderId: {0}", orderId);
                            } else {
                                message = "Order (ID: " + orderId + ") marked as completed.";
                                LOGGER.log(Level.INFO, message);
                            }
                        }
                    }
                }
                    
                default -> {
                    message = "Invalid action received: " + action;
                    LOGGER.log(Level.WARNING, "Invalid action received: ''{0}'' for order {1}", new Object[]{action, orderId});
                }
            }

            if (!message.isEmpty()) { 
                if (success) {
                    request.setAttribute("success", message); // Use "success"
                } else {
                    request.setAttribute("error", message); // Use "error"
                }
            }
            
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid order ID format: ''{0}''", orderIdStr);
            request.setAttribute("error", "Invalid order ID format: " + orderIdStr); // Use "error"
        } catch (Exception e) { 
            LOGGER.log(Level.SEVERE, "Error processing order action ''" + action + "'' for orderId ''" + orderIdStr + "''", e);
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage()); // Use "error"
        }
        
        doGet(request, response); 
    }
}