Rasindu Perera\Documents\NetBeansProjects\RestaurantSystem_Updated\web\admin\admin_user_form.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${adminUser != null ? 'Edit' : 'Add'} Admin User - Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            min-width: 250px;
            background-color: #343a40;
            color: white;
            padding: 20px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
        }
        .content {
            flex-grow: 1;
            padding: 30px;
        }
        .header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #ddd;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h4 class="text-center mb-4">Admin Panel</h4>
        <a href="tables.jsp">Manage Tables</a>
        <a href="waiters">Manage Waiters</a>
        <a href="categories">Manage Categories</a>
        <a href="menu_items">Manage Menu Items</a>
        <a href="${pageContext.request.contextPath}/admin/DailySalesServlet">Daily Sales</a>
        <a href="${pageContext.request.contextPath}/admin/FeedbackDashboardServlet">Customer Feedback</a>
        <a href="${pageContext.request.contextPath}/admin/AdminUsersServlet" class="active">Manage Admins</a>
        <a href="${pageContext.request.contextPath}/admin/logout" class="mt-5">Logout</a>
    </div>

    <div class="content">
        <div class="header">
            <h4>${adminUser != null ? 'Edit' : 'Add New'} Admin User</h4>
        </div>

        <div class="container mt-4">
            <div class="card shadow">
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/AdminUsersServlet">
                        <input type="hidden" name="action" value="${adminUser != null ? 'update' : 'create'}">
                        <c:if test="${adminUser != null}">
                            <input type="hidden" name="id" value="${adminUser.id}">
                        </c:if>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       value="${adminUser != null ? adminUser.username : ''}" required>
                            </div>
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${adminUser != null ? adminUser.fullName : ''}" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${adminUser != null ? adminUser.email : ''}">
                            </div>
                            <div class="col-md-6">
                                <label for="role" class="form-label">Role</label>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="admin" ${adminUser != null && adminUser.role == 'admin' ? 'selected' : ''}>Admin</option>
                                    <option value="super_admin" ${adminUser != null && adminUser.role == 'super_admin' ? 'selected' : ''}>Super Admin</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="password" class="form-label">
                                    ${adminUser != null ? 'New Password (leave blank to keep current)' : 'Password'}
                                </label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       ${adminUser == null ? 'required' : ''}>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch mt-4">
                                    <input class="form-check-input" type="checkbox" id="active" name="active" 
                                           ${adminUser == null || adminUser.active ? 'checked' : ''}>
                                    <label class="form-check-label" for="active">Active</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary">
                                ${adminUser != null ? 'Update' : 'Create'} Admin User
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/AdminUsersServlet" class="btn btn-secondary ms-2">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>