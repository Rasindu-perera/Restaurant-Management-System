package controller;

import dao.WaiterDAO;
import model.Waiter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/waiters")
public class WaiterListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        WaiterDAO dao = new WaiterDAO();
        List<Waiter> waiters = dao.getAllWaiters();

        request.setAttribute("waiters", waiters);
        request.getRequestDispatcher("/admin/waiters.jsp").forward(request, response);
    }
}
