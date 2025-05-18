package com.restaurant.rms.controller;

import com.restaurant.rms.dao.UserDAO;
import com.restaurant.rms.model.User;
import com.restaurant.rms.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AuthServlet", value = { "/login", "/logout", "/register", "/verify" })
public class AuthServlet extends HttpServlet {
    private final AuthService authService;
    private final UserDAO userDAO;

    public AuthServlet() {
        this.authService = new AuthService();
        this.userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/logout":
                handleLogout(request, response);
                break;
            case "/register":
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
                break;
            case "/verify":
                handleEmailVerification(request, response);
                break;
            default:
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                handleLogin(request, response);
                break;
            case "/register":
                handleRegistration(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authService.authenticate(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30-minute session

            // Redirect to the dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Clear session cookie
        Cookie sessionCookie = new Cookie("RMS_SESSION", "");
        sessionCookie.setMaxAge(0);
        sessionCookie.setHttpOnly(true);
        sessionCookie.setSecure(request.isSecure());
        sessionCookie.setPath(request.getContextPath());
        response.addCookie(sessionCookie);

        response.sendRedirect(request.getContextPath() + "/login");
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            if (!password.equals(confirmPassword)) {
                throw new IllegalArgumentException("Passwords do not match");
            }

            authService.registerUser(username, password, fullName, email, phone);

            request.setAttribute("success", "Registration successful! Please check your email to verify your account.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }

    private void handleEmailVerification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String token = request.getParameter("token");
        if (authService.verifyEmail(token)) {
            response.sendRedirect(request.getContextPath() + "/login?verified=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_token");
        }
    }
}