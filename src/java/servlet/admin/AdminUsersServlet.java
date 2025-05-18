package servlet.admin;

import dao.AdminUserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AdminUser;

@WebServlet("/admin/AdminUsersServlet")
public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is super_admin
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("adminRole");
        
        if (!"super_admin".equals(role)) {
            request.setAttribute("error", "You don't have permission to access this section");
            request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (null == action) {
            // List all admin users
            listAdminUsers(request, response);
        } else switch (action) {
            case "edit" -> // Show edit form
                showEditForm(request, response);
            case "new" -> // Show form to add new admin
                showNewForm(request, response);
            case "delete" -> // Delete admin user
                deleteAdminUser(request, response);
            default -> {
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is super_admin
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("adminRole");
        
        if (!"super_admin".equals(role)) {
            request.setAttribute("error", "You don't have permission to access this section");
            request.getRequestDispatcher("/admin/admin.jsp").forward(request, response);
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        
        if (action.equals("create")) {
            // Add new admin user
            createAdminUser(request, response);
        } else if (action.equals("update")) {
            // Update existing admin user
            updateAdminUser(request, response);
        }
    }
    
    private void listAdminUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        AdminUserDAO adminUserDAO = new AdminUserDAO();
        List<AdminUser> adminUsers = adminUserDAO.getAllAdminUsers();
        
        request.setAttribute("adminUsers", adminUsers);
        request.getRequestDispatcher("/admin/admin_users.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        AdminUserDAO adminUserDAO = new AdminUserDAO();
        AdminUser adminUser = adminUserDAO.getAdminUserById(id);
        
        request.setAttribute("adminUser", adminUser);
        request.getRequestDispatcher("/admin/admin_user_form.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/admin_user_form.jsp").forward(request, response);
    }
    
    private void createAdminUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        boolean active = "on".equals(request.getParameter("active"));
        
        AdminUser newUser = new AdminUser();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setEmail(email);
        newUser.setFullName(fullName);
        newUser.setRole(role);
        newUser.setActive(active);
        
        AdminUserDAO adminUserDAO = new AdminUserDAO();
        boolean success = adminUserDAO.addAdminUser(newUser);
        
        if (success) {
            request.setAttribute("message", "Admin user created successfully");
        } else {
            request.setAttribute("error", "Failed to create admin user");
        }
        
        listAdminUsers(request, response);
    }
    
    private void updateAdminUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        boolean active = "on".equals(request.getParameter("active"));
        
        AdminUser user = new AdminUser();
        user.setId(id);
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setFullName(fullName);
        user.setRole(role);
        user.setActive(active);
        
        AdminUserDAO adminUserDAO = new AdminUserDAO();
        boolean success = adminUserDAO.updateAdminUser(user);
        
        if (success) {
            request.setAttribute("message", "Admin user updated successfully");
        } else {
            request.setAttribute("error", "Failed to update admin user");
        }
        
        listAdminUsers(request, response);
    }
    
    private void deleteAdminUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Get current user's ID to prevent self-deletion
        HttpSession session = request.getSession(false);
        AdminUser currentUser = (AdminUser) session.getAttribute("adminUser");
        
        if (currentUser.getId() == id) {
            request.setAttribute("error", "You cannot delete your own account");
        } else {
            AdminUserDAO adminUserDAO = new AdminUserDAO();
            boolean success = adminUserDAO.deleteAdminUser(id);
            
            if (success) {
                request.setAttribute("message", "Admin user deleted successfully");
            } else {
                request.setAttribute("error", "Failed to delete admin user");
            }
        }
        
        listAdminUsers(request, response);
    }
}
