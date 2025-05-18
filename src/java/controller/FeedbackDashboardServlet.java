package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/FeedbackDashboardServlet")
public class FeedbackDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Forward to the feedback dashboard JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("feedback_dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
