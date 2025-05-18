package controller;

import dao.WaiterDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet("/admin/delete_waiter")
public class DeleteWaiterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        WaiterDAO waiterDAO = new WaiterDAO();
        waiterDAO.deleteWaiter(id);
        response.sendRedirect("waiters");
    }
}
