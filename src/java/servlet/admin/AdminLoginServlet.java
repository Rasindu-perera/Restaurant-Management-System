package servlet.admin;

import dao.AdminUserDAO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AdminUser;
import util.PasswordUtil;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminLoginServlet.class.getName());
    private static final boolean ENABLE_DIRECT_LOGIN = true; // TEMPORARY FIX - set to false after system is working

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            // Already logged in, redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
        } else {
            // Show login page
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Log attempt
        LOGGER.log(Level.INFO, "Login attempt for username: {0}", username);
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // TEMPORARY DIRECT LOGIN - Remove this block after fixing the issue
            if (ENABLE_DIRECT_LOGIN && "admin".equals(username) && "admin123".equals(password)) {
                LOGGER.log(Level.WARNING, "Using direct login bypass - REMOVE IN PRODUCTION");
                
                // Create a temporary admin user
                AdminUser directUser = new AdminUser();
                directUser.setId(1);
                directUser.setUsername("admin");
                directUser.setFullName("System Administrator");
                directUser.setRole("super_admin");
                directUser.setActive(true);
                
                // Create session
                HttpSession session = request.getSession(true);
                session.setAttribute("adminUser", directUser);
                session.setAttribute("adminUsername", directUser.getUsername());
                session.setAttribute("adminRole", directUser.getRole());
                
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
                return;
            }
            
            // Print hash for debugging
            if (username.equals("admin") && password.equals("admin123")) {
                String hash = PasswordUtil.hashPassword("admin123");
                LOGGER.log(Level.INFO, "Expected hash: {0}", hash);
            }
            
            // Authenticate user
            AdminUserDAO adminUserDAO = new AdminUserDAO();
            AdminUser user = adminUserDAO.authenticate(username, password);
            
            if (user != null) {
                // Create session
                HttpSession session = request.getSession(true);
                session.setAttribute("adminUser", user);
                session.setAttribute("adminUsername", user.getUsername());
                session.setAttribute("adminRole", user.getRole());
                
                // Log success
                LOGGER.log(Level.INFO, "Successful login for user: {0}", username);
                
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");
            } else {
                LOGGER.log(Level.WARNING, "Failed login attempt for user: {0}", username);
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during login", e);
            request.setAttribute("error", "System error: " + e.getMessage());
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
