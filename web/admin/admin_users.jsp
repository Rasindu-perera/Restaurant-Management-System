<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Admin Users - Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
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
            overflow-y: auto;
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
        <div class="header d-flex justify-content-between align-items-center">
            <h4>Manage Admin Users</h4>
            <a href="${pageContext.request.contextPath}/admin/AdminUsersServlet?action=new" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Add New Admin
            </a>
        </div>

        <div class="container mt-4">
            <c:if test="${message != null}">
                <div class="alert alert-success alert-dismissible fade show">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            
            <c:if test="${error != null}">
                <div class="alert alert-danger alert-dismissible fade show">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card shadow">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Last Login</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="admin" items="${adminUsers}">
                                    <tr>
                                        <td>${admin.id}</td>
                                        <td>${admin.username}</td>
                                        <td>${admin.fullName}</td>
                                        <td>${admin.email}</td>
                                        <td>
                                            <span class="badge ${admin.role == 'super_admin' ? 'bg-danger' : 'bg-primary'}">
                                                ${admin.role}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${admin.active ? 'bg-success' : 'bg-secondary'}">
                                                ${admin.active ? 'Active' : 'Inactive'}
                                            </span>
                                        </td>
                                        <td>${admin.lastLogin}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/AdminUsersServlet?action=edit&id=${admin.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/AdminUsersServlet?action=delete&id=${admin.id}" 
                                               class="btn btn-sm btn-outline-danger" 
                                               onclick="return confirm('Are you sure you want to delete this admin user?')">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>