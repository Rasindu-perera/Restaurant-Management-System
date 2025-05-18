<%-- 
    Document   : admin_header
    Created on : May 4, 2025, 1:13:04 PM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Restaurant Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="menu_items">Admin Panel</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="menu_items">Menu Items</a></li>
                <li class="nav-item"><a class="nav-link" href="categories">Categories</a></li>
                <li class="nav-item"><a class="nav-link" href="tables.jsp">Tables</a></li>
                <li class="nav-item"><a class="nav-link" href="waiters">Waiters</a></li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/DailySalesServlet">Daily Sales</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/FeedbackDashboardServlet">Customer Feedback</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/admin/inventory/dashboard">Inventory Management</a>
                </li>
                <li class="nav-item"><a class="nav-link text-danger" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
