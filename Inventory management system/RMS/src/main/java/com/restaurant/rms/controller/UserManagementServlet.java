package com.restaurant.rms.controller;

import com.restaurant.rms.dao.UserDAO;
import com.restaurant.rms.model.User;
import com.restaurant.rms.util.AuthUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserManagementServlet", value = "/admin/users")
public class UserManagementServlet extends HttpServlet {
    private final UserDAO userDAO;

    public UserManagementServlet() {
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!AuthUtil.isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listUsers(request, response);
        } else if (action.equals("edit")) {
            showEditForm(request, response);
        } else if (action.equals("new")) {
            showNewForm(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!AuthUtil.isAdmin(session)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");
        if (action.equals("save")) {
            saveUser(request, response);
        } else if (action.equals("delete")) {
            deleteUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/users/list.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        User user = userDAO.findById(userId);
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/users/form.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/users/form.jsp");
        dispatcher.forward(request, response);
    }

    private void saveUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = request.getParameter("id") != null ? Long.parseLong(request.getParameter("id")) : null;
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        User user = id != null ? userDAO.findById(id) : new User();
        user.setUsername(username);
        if (password != null && !password.isEmpty()) {
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
        }
        user.setRole(User.Role.valueOf(role));

        if (id == null) {
            userDAO.save(user);
        } else {
            userDAO.update(user);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long userId = Long.parseLong(request.getParameter("id"));
        userDAO.delete(userId);
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}