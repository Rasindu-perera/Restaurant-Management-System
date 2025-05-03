package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.TableDAO;
import dao.WaiterDAO;
import model.Waiter;

import java.io.IOException;
/**
 *
 * @author RasinduPerera
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int waiterId = Integer.parseInt(request.getParameter("waiterId"));
        int tableId = Integer.parseInt(request.getParameter("tableId"));

        TableDAO tableDAO = new TableDAO();
        WaiterDAO waiterDAO = new WaiterDAO();

        Waiter waiter = waiterDAO.getWaiterById(waiterId);

        if (waiter == null) {
            request.setAttribute("error", "Invalid Waiter ID");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String status = tableDAO.getTableStatus(tableId);
        if (status == null) {
            request.setAttribute("error", "Invalid Table ID");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (status.equals("available")) {
            // Reserve the table
            tableDAO.reserveTable(tableId, waiterId);
        } else if (tableDAO.isTableReservedByAnotherWaiter(tableId, waiterId)) {
            request.setAttribute("error", "This table is already reserved by another waiter.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Set session
        HttpSession session = request.getSession();
        session.setAttribute("waiterId", waiterId);
        session.setAttribute("tableId", tableId);

        response.sendRedirect("menu"); // go to MenuServlet
    }
}
