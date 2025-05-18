package controller;

import dao.FeedbackDAO;
import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Feedback;
import model.Order;

import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        try {
            // Get parameters from the form
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");
            
            // Get table ID from session
            Integer tableId = (Integer) session.getAttribute("tableId");
            if (tableId == null) {
                request.setAttribute("error", "Table information not found");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }
            
            // Get the current order for this table
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getCurrentOrderByTable(tableId);
            if (order == null) {
                request.setAttribute("error", "Order information not found");
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                return;
            }
            
            // Create and save the feedback
            Feedback feedback = new Feedback();
            feedback.setTableId(tableId);
            feedback.setOrderId(order.getOrderId());
            feedback.setWaiterId(order.getWaiterId());
            feedback.setRating(rating);
            feedback.setComment(comment);
            
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean success = feedbackDAO.saveFeedback(feedback);
            
            if (success) {
                request.setAttribute("successMessage", "Thank you for your feedback!");
            } else {
                request.setAttribute("error", "Failed to save your feedback. Please try again.");
            }
            
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid rating value");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}
