<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${item.name} - Inventory Details</title>
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
        .detail-label {
            font-weight: 600;
            color: #495057;
        }
        .low-stock-badge {
            background-color: #e74a3b;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        .stock-info-card {
            background-color: #f8f9fa;
            border-left: 4px solid #4e73df;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    

    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Item Details: ${item.name}</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/inventory/item/edit?id=${item.itemId}" class="btn btn-primary">
                    <i class="bi bi-pencil"></i> Edit Item
                </a>
                <a href="${pageContext.request.contextPath}/admin/inventory/items" class="btn btn-outline-secondary ms-2">
                    <i class="bi bi-arrow-left"></i> Back to Items
                </a>
            </div>
        </div>

        <!-- Inventory Management Menu -->
        <div class="inventory-menu mt-3">
            <a href="${pageContext.request.contextPath}/admin/inventory/dashboard">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/items" class="active">
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

        <!-- Item Details -->
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0">Basic Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-4 detail-label">Item ID:</div>
                            <div class="col-md-8">${item.itemId}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 detail-label">Name:</div>
                            <div class="col-md-8">${item.name}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 detail-label">Category:</div>
                            <div class="col-md-8">${item.category.name}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-4 detail-label">Storage Location:</div>
                            <div class="col-md-8">${item.storageLocation != null ? item.storageLocation : 'Not specified'}</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0">Stock Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="stock-info-card">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="mb-0">Current Stock:</h4>
                                    <h2 class="mb-0 mt-2">
                                        ${item.currentQuantity} ${item.unit}
                                        <c:if test="${item.currentQuantity <= item.minStockLevel}">
                                            <span class="low-stock-badge ms-2">Low Stock</span>
                                        </c:if>
                                    </h2>
                                </div>
                                <div class="col-md-4 text-end">
                                    <a href="${pageContext.request.contextPath}/admin/inventory/purchase/add?itemId=${item.itemId}" 
                                       class="btn btn-success">
                                        <i class="bi bi-plus-circle"></i> Add Stock
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-5 detail-label">Minimum Stock Level:</div>
                            <div class="col-md-7">${item.minStockLevel} ${item.unit}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-5 detail-label">Unit of Measurement:</div>
                            <div class="col-md-7">${item.unit}</div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-5 detail-label">Cost Per Unit:</div>
                            <div class="col-md-7">Rs:<fmt:formatNumber value="${item.costPerUnit}" pattern="#,##0.00"/></div>
                        </div>
                        <div class="row">
                            <div class="col-md-5 detail-label">Total Stock Value:</div>
                            <div class="col-md-7">Rs:<fmt:formatNumber value="${item.getTotalStockValue()}" pattern="#,##0.00"/></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Purchase History -->
        <div class="card mt-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Recent Purchase History</h5>
                <a href="${pageContext.request.contextPath}/admin/inventory/purchases?itemId=${item.itemId}" class="btn btn-sm btn-outline-primary">
                    View All Purchases
                </a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty recentPurchases}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No purchase history found for this item.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Supplier</th>
                                        <th>Quantity</th>
                                        <th>Unit Price</th>
                                        <th>Total Cost</th>
                                        <th>Invoice #</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="purchase" items="${recentPurchases}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${purchase.purchase.purchaseDate}" pattern="dd MMM yyyy" />
                                            </td>
                                            <td>${purchase.purchase.supplier.name}</td>
                                            <td>${purchase.quantity} ${item.unit}</td>
                                            <td>Rs:<fmt:formatNumber value="${purchase.unitPrice}" pattern="#,##0.00"/></td>
                                            <td>Rs:<fmt:formatNumber value="${purchase.quantity * purchase.unitPrice}" pattern="#,##0.00"/></td>
                                            <td>${purchase.purchase.invoiceNumber}</td>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>