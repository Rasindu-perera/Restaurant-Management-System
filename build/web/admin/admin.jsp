<%-- 
    Document   : admin
    Created on : May 4, 2025, 11:16:37?AM
    Author     : RasinduPerera
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .stat-card {
            border-left: 4px solid;
            margin-bottom: 20px;
        }
        .stat-card.primary {
            border-left-color: #4e73df;
        }
        .stat-card.success {
            border-left-color: #1cc88a;
        }
        .stat-card.warning {
            border-left-color: #f6c23e;
        }
        .stat-card.danger {
            border-left-color: #e74a3b;
        }
        .stat-card-body {
            padding: 20px;
        }
        .stat-card-title {
            text-transform: uppercase;
            color: #5a5c69;
            font-weight: 700;
            font-size: 0.8rem;
            margin-bottom: 5px;
        }
        .stat-card-value {
            color: #333;
            font-size: 1.5rem;
            font-weight: 700;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        .action-buttons {
            text-align: right;
        }
        .action-buttons a {
            margin-left: 5px;
        }
        .inventory-menu {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .inventory-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 5px;
            display: inline-block;
            margin-right: 10px;
        }
        .inventory-menu a:hover, .inventory-menu a.active {
            background-color: #e9ecef;
        }
        .low-stock-badge {
            background-color: #e74a3b;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h4 class="text-center mb-4">Admin Panel</h4>
        <a href="tables.jsp" class="active">Manage Tables</a>
        <a href="waiters">Manage Waiters</a>
        <a href="categories">Manage Categories</a>
        <a href="menu_items">Manage Menu Items</a>
        <a href="${pageContext.request.contextPath}/admin/DailySalesServlet">Daily Sales</a>
        <a href="${pageContext.request.contextPath}/admin/FeedbackDashboardServlet">Customer Feedback</a>
        <a href="${pageContext.request.contextPath}/admin/inventory/dashboard">Inventory Management</a>
        <a href="logout.jsp" class="mt-5">Logout</a>
    </div>

    <div class="content">
        <div class="header">
            <h4>Welcome, Admin</h4>
        </div>

        <div class="container mt-4">
            <div class="alert alert-info text-center">
                Select an option from the sidebar to manage the restaurant system.
            </div>

            <div class="row text-center mt-5">
                <div class="col-md-4">
                    <div class="card p-3 shadow">
                        <h5>Manage Tables</h5>
                        <p>Add or remove table entries.</p>
                        <a href="tables.jsp" class="btn btn-primary">Go</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 shadow">
                        <h5>Manage Waiters</h5>
                        <p>Handle waiter records.</p>
                        <a href="waiters" class="btn btn-primary">Go</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 shadow">
                        <h5>Daily Sales</h5>
                        <p>View completed income.</p>
                        <a href="${pageContext.request.contextPath}/admin/DailySalesServlet" class="btn btn-primary">Go</a>
                    </div>
                </div>
            </div>

            <div class="row text-center mt-4">
                <div class="col-md-6">
                    <div class="card p-3 shadow">
                        <h5>Manage Categories</h5>
                        <p>Add or remove menu categories.</p>
                        <a href="categories" class="btn btn-secondary">Go</a>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card p-3 shadow">
                        <h5>Manage Menu Items</h5>
                        <p>Create or update food & drink items.</p>
                        <a href="menu_items" class="btn btn-secondary">Go</a>
                    </div>
                </div>
            </div>

            <div class="row text-center mt-4">
                <div class="col-md-6">
                    <div class="card p-3 shadow">
                        <h5>Customer Feedback</h5>
                        <p>View customer ratings & feedback.</p>
                        <a href="${pageContext.request.contextPath}/admin/FeedbackDashboardServlet" class="btn btn-info">Go</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card p-3 shadow">
                        <h5>Inventory Management</h5>
                        <p>Manage restaurant stock and supplies.</p>
                        <a href="${pageContext.request.contextPath}/admin/inventory/dashboard" class="btn btn-success">Go</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
