package controller;

import dao.TableDAO;
import dao.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/releaseTable")
public class ReleaseTableServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ReleaseTableServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get table ID from session
        Integer tableId = (Integer) session.getAttribute("tableId");
        if (tableId == null) {
            LOGGER.log(Level.WARNING, "Table ID not found in session");
            request.setAttribute("error", "Table ID not found. Please try again.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }
        
        LOGGER.log(Level.INFO, "Processing table release for table ID: {0}", tableId);
        
        // Update table status to Available and reset reserved_by and created_at
        TableDAO tableDAO = new TableDAO();
        boolean result = tableDAO.releaseTableCompletely(tableId);  // Use the new method instead of updateTableStatus
        
        if (result) {
            LOGGER.log(Level.INFO, "Table {0} successfully released", tableId);
            
            // Clean up session
            session.removeAttribute("tableId");
            session.removeAttribute("cart");
            session.removeAttribute("orderSent");
            
            // Invalidate session
            session.invalidate();
            
            // Redirect to login page
            response.sendRedirect("login.jsp");
        } else {
            LOGGER.log(Level.WARNING, "Failed to release table {0}", tableId);
            request.setAttribute("error", "Failed to release table. Please try again.");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}