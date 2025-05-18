package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.ChefDAO;
import model.Chef;

import java.io.IOException;

@WebServlet("/chef/login")
public class ChefLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String chefIdStr = request.getParameter("chefId");

        // Check if parameter is null or empty
        if (chefIdStr == null || chefIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please enter Chef ID");
            request.getRequestDispatcher("chef_login.jsp").forward(request, response);
            return;
        }

        try {
            int chefId = Integer.parseInt(chefIdStr);
            ChefDAO chefDAO = new ChefDAO();
            Chef chef = chefDAO.getChefById(chefId);

            if (chef == null) {
                request.setAttribute("error", "Invalid Chef ID");
                request.getRequestDispatcher("chef_login.jsp").forward(request, response);
                return;
            }

            // Set session
            HttpSession session = request.getSession();
            session.setAttribute("chefId", chefId);
            session.setAttribute("chefName", chef.getName());

            response.sendRedirect(request.getContextPath() + "/chef/dashboard");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid ID format. Please enter numbers only.");
            request.getRequestDispatcher("chef_login.jsp").forward(request, response);
        }
    }
} 