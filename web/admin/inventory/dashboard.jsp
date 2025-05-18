<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Dashboard - Restaurant</title>
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
            padding: 20px;
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
        .stat-card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .stat-card-title {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 5px;
        }
        .stat-card-value {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .stat-card-icon {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .bg-primary-light {
            background-color: #e6f2ff;
        }
        .bg-success-light {
            background-color: #e6fff2;
        }
        .bg-warning-light {
            background-color: #fff9e6;
        }
        .bg-info-light {
            background-color: #e6f9ff;
        }
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #ddd;
            padding: 15px;
            border-radius: 10px 10px 0 0 !important;
        }
        .low-stock-badge {
            background-color: #e74a3b;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
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
    </style>
</head>
<body>
    
    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Inventory Dashboard</h4>
            <div>
                <span class="text-muted me-3">Last updated: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd MMM yyyy, hh:mm a" /></span>
                <button class="btn btn-sm btn-outline-secondary" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
            </div>
        </div>
        
        <!-- Inventory Management Menu -->
        <div class="inventory-menu mt-3">
            <a href="${pageContext.request.contextPath}/admin/inventory/dashboard" class="active">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/items">
                <i class="bi bi-box-seam"></i> Inventory Items
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/purchases">
                <i class="bi bi-bag-plus"></i> Purchases
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/categories">
                <i class="bi bi-tags"></i> Categories
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/reports">
                <i class="bi bi-file-earmark-bar-graph"></i> Reports
            </a>
        </div>
        
        <!-- Stats Cards -->
        <div class="row mb-4">
            <div class="col-xl-3 col-md-6 mb-3">
                <div class="stat-card bg-primary-light">
                    <div class="stat-card-icon text-primary">
                        <i class="bi bi-box-seam"></i>
                    </div>
                    <div class="stat-card-title">Total Items</div>
                    <div class="stat-card-value">${totalItems}</div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/inventory/items" class="btn btn-sm btn-primary">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
                <div class="stat-card bg-success-light">
                    <div class="stat-card-icon text-success">
                        <i class="bi bi-tags"></i>
                    </div>
                    <div class="stat-card-title">Categories</div>
                    <div class="stat-card-value">${totalCategories}</div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/inventory/categories" class="btn btn-sm btn-success">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
                <div class="stat-card bg-warning-light">
                    <div class="stat-card-icon text-warning">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <div class="stat-card-title">Inventory Value</div>
                    <div class="stat-card-value">Rs:<fmt:formatNumber value="${totalValue}" pattern="#,##0.00"/></div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/inventory/reports?type=value" class="btn btn-sm btn-warning">View Report</a>
                    </div>
                </div>
            </div>
            <div class="col-xl-3 col-md-6 mb-3">
                <div class="stat-card bg-info-light">
                    <div class="stat-card-icon text-info">
                        <i class="bi bi-exclamation-triangle"></i>
                    </div>
                    <div class="stat-card-title">Low Stock Items</div>
                    <div class="stat-card-value">${lowStockItems.size()}</div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/inventory/reports?type=lowstock" class="btn btn-sm btn-info">View Report</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Main Dashboard Content -->
        <div class="row">
            <!-- Low Stock Items -->
            <div class="col-xl-6 mb-4">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Low Stock Items</h5>
                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href='${pageContext.request.contextPath}/admin/inventory/purchase/add'">
                            <i class="bi bi-plus-circle"></i> Add Purchase
                        </button>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty lowStockItems}">
                                <div class="text-center py-5">
                                    <i class="bi bi-check-circle text-success" style="font-size: 3rem;"></i>
                                    <p class="mt-3">All items are stocked properly.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Item</th>
                                                <th>Stock</th>
                                                <th>Min Level</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${lowStockItems}" begin="0" end="4">
                                                <tr>
                                                    <td>${item.name}</td>
                                                    <td><span class="low-stock-badge">${item.currentQuantity}</span> ${item.unit}</td>
                                                    <td>${item.minStockLevel} ${item.unit}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/admin/inventory/purchase/add?itemId=${item.itemId}" class="btn btn-sm btn-primary">
                                                            <i class="bi bi-plus-circle"></i> Add Purchase
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <c:if test="${lowStockItems.size() > 5}">
                                    <div class="text-center mt-3">
                                        <a href="${pageContext.request.contextPath}/admin/inventory/reports?type=lowstock" class="btn btn-sm btn-outline-primary">View All ${lowStockItems.size()} Low Stock Items</a>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <!-- Recent Purchases -->
            <div class="col-xl-6 mb-4">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Recent Purchases</h5>
                        <button class="btn btn-sm btn-outline-primary" onclick="window.location.href='${pageContext.request.contextPath}/admin/inventory/purchases'">
                            <i class="bi bi-list"></i> View All
                        </button>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty recentPurchases}">
                                <div class="text-center py-5">
                                    <i class="bi bi-bag-dash text-muted" style="font-size: 3rem;"></i>
                                    <p class="mt-3">No recent purchases found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Item</th>
                                                <th>Supplier</th>
                                                <th>Cost</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="purchase" items="${recentPurchases}">
                                                <tr>
                                                    <td>
                                                        <fmt:formatDate value="${purchase.purchaseDate}" pattern="dd MMM yyyy" />
                                                    </td>
                                                    <td>
                                                        <!-- Handle displaying purchase items -->
                                                        <c:choose>
                                                            <c:when test="${empty purchase.items}">
                                                                <span class="text-muted">Multiple items</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="item" items="${purchase.items}" varStatus="status">
                                                                    <c:if test="${status.index == 0}">
                                                                        ${item.item.name} 
                                                                        <c:if test="${purchase.items.size() > 1}">
                                                                            <span class="text-muted">(+${purchase.items.size()-1} more)</span>
                                                                        </c:if>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${purchase.supplier.name}</td>
                                                    <td>Rs:<fmt:formatNumber value="${purchase.totalCost}" pattern="#,##0.00"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>