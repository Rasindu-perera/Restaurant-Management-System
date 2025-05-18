package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Redirect to the appropriate login page based on the role
        String role = request.getParameter("role");
        if ("chef".equals(role)) {
            response.sendRedirect("chef_login.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
} 