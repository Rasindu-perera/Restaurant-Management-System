package controller;

import dao.TableDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Table;

/**
 *
 * @author RasinduPerera
 */
@WebServlet("/admin/tables")
public class TableListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TableDAO tableDAO = new TableDAO();
        List<Table> tables = tableDAO.getAllTables();  // ensure this method works properly
        request.setAttribute("tables", tables);
        request.getRequestDispatcher("/admin/tables.jsp").forward(request, response);
    }
}
