<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Reports - Restaurant</title>
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
        .report-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #ddd;
            margin-bottom: 20px;
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
        .report-options {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .low-stock-badge {
            background-color: #e74a3b;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        @media print {
            .sidebar, .inventory-menu, .report-options, .header button {
                display: none !important;
            }
            .content {
                padding: 0;
                margin: 0;
                width: 100% !important;
            }
            .header {
                text-align: center;
                border: none;
                padding-bottom: 20px;
            }
            .card {
                box-shadow: none;
                border: none;
            }
        }
    </style>
</head>
<body>
    
    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Inventory Reports</h4>
            <div>
                <button class="btn btn-outline-secondary" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>

        <!-- Inventory Management Menu -->
        <div class="inventory-menu mt-3">
            <a href="${pageContext.request.contextPath}/admin/inventory/dashboard">
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
            <a href="${pageContext.request.contextPath}/admin/inventory/reports" class="active">
                <i class="bi bi-file-earmark-bar-graph"></i> Reports
            </a>
        </div>

        <!-- Report Options -->
        <div class="report-options">
            <form action="${pageContext.request.contextPath}/admin/inventory/reports" method="get" class="row g-3">
                <div class="col-md-4">
                    <label for="reportType" class="form-label">Report Type</label>
                    <select class="form-select" id="reportType" name="type" onchange="toggleDateFields()">
                        <option value="inventory" ${reportType == 'inventory' ? 'selected' : ''}>
                            Inventory Stock Report
                        </option>
                        <option value="lowstock" ${reportType == 'lowstock' ? 'selected' : ''}>
                            Low Stock Report
                        </option>
                        <option value="purchases" ${reportType == 'purchases' ? 'selected' : ''}>
                            Purchases Report
                        </option>
                        <option value="category" ${reportType == 'category' ? 'selected' : ''}>
                            Category-based Report
                        </option>
                        <option value="value" ${reportType == 'value' ? 'selected' : ''}>
                            Top Value Items Report
                        </option>
                    </select>
                </div>
                <div class="col-md-3" id="startDateField">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                </div>
                <div class="col-md-3" id="endDateField">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                </div>
                <div class="col-md-2">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary">Generate Report</button>
                </div>
            </form>
        </div>

        <!-- Report Content -->
        <div class="card">
            <div class="card-body">
                <!-- Report Header - changes based on report type -->
                <div class="report-header">
                    <c:choose>
                        <c:when test="${reportType == 'inventory'}">
                            <h5 class="mb-0">Inventory Stock Report</h5>
                            <p class="text-muted mb-0">Current inventory status as of <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" /></p>
                        </c:when>
                        <c:when test="${reportType == 'lowstock'}">
                            <h5 class="mb-0">Low Stock Report</h5>
                            <p class="text-muted mb-0">Items below minimum stock level as of <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" /></p>
                        </c:when>
                        <c:when test="${reportType == 'purchases'}">
                            <h5 class="mb-0">Purchases Report</h5>
                            <p class="text-muted mb-0">
                                Purchase transactions from 
                                <fmt:parseDate value="${startDate}" pattern="yyyy-MM-dd" var="parsedStartDate" />
                                <fmt:parseDate value="${endDate}" pattern="yyyy-MM-dd" var="parsedEndDate" />
                                <fmt:formatDate value="${parsedStartDate}" pattern="MMMM dd, yyyy" /> to 
                                <fmt:formatDate value="${parsedEndDate}" pattern="MMMM dd, yyyy" />
                            </p>
                        </c:when>
                        <c:when test="${reportType == 'category'}">
                            <h5 class="mb-0">Category-based Inventory Report</h5>
                            <p class="text-muted mb-0">Inventory broken down by category as of <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" /></p>
                        </c:when>
                        <c:when test="${reportType == 'value'}">
                            <h5 class="mb-0">Top Value Items Report</h5>
                            <p class="text-muted mb-0">Items with highest inventory value as of <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" /></p>
                        </c:when>
                    </c:choose>
                </div>

                <!-- Inventory Stock Report -->
                <c:if test="${reportType == 'inventory'}">
                    <div class="row mb-4">
                        <div class="col-md-12 text-end">
                            <h5>Total Inventory Value: Rs:<fmt:formatNumber value="${totalInventoryValue}" pattern="#,##0.00"/></h5>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Item</th>
                                    <th>Category</th>
                                    <th>Current Stock</th>
                                    <th>Unit</th>
                                    <th>Unit Price</th>
                                    <th>Total Value</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${inventoryItems}">
                                    <tr>
                                        <td>${item.name}</td>
                                        <td>${item.category}</td>
                                        <td>
                                            ${item.currentStock}
                                            <c:if test="${item.currentStock <= item.minStockLevel}">
                                                <span class="low-stock-badge ms-2">Low</span>
                                            </c:if>
                                        </td>
                                        <td>${item.unit}</td>
                                        <td>Rs:<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                        <td>Rs:<fmt:formatNumber value="${item.getTotalStockValue()}" pattern="#,##0.00"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Low Stock Report -->
                <c:if test="${reportType == 'lowstock'}">
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="alert ${lowStockItems.size() > 0 ? 'alert-warning' : 'alert-success'}">
                                <i class="${lowStockItems.size() > 0 ? 'bi bi-exclamation-triangle' : 'bi bi-check-circle'}"></i>
                                ${lowStockItems.size()} items found below minimum stock level.
                            </div>
                        </div>
                    </div>
                    <c:if test="${lowStockItems.size() > 0}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Item</th>
                                        <th>Category</th>
                                        <th>Current Stock</th>
                                        <th>Minimum Required</th>
                                        <th>Unit</th>
                                        <th>Shortage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${lowStockItems}">
                                        <tr>
                                            <td>${item.name}</td>
                                            <td>${item.category}</td>
                                            <td><span class="low-stock-badge">${item.currentStock}</span></td>
                                            <td>${item.minStockLevel}</td>
                                            <td>${item.unit}</td>
                                            <td>${item.minStockLevel - item.currentStock} ${item.unit}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </c:if>

                <!-- Purchases Report -->
                <c:if test="${reportType == 'purchases'}">
                    <div class="row mb-4">
                        <div class="col-md-12 text-end">
                            <h5>Total Purchase Value: Rs:<fmt:formatNumber value="${totalPurchaseValue}" pattern="#,##0.00"/></h5>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Item</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th>Supplier</th>
                                    <th>Receipt #</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="purchase" items="${purchases}">
                                    <tr>
                                        <td><fmt:formatDate value="${purchase.purchaseDate}" pattern="dd MMM yyyy" /></td>
                                        <td>${purchase.itemName}</td>
                                        <td>${purchase.quantity} ${purchase.unit}</td>
                                        <td>Rs:<fmt:formatNumber value="${purchase.unitPrice}" pattern="#,##0.00"/></td>
                                        <td>Rs:<fmt:formatNumber value="${purchase.quantity * purchase.unitPrice}" pattern="#,##0.00"/></td>
                                        <td>${purchase.supplier.name}</td>
                                        <td>${purchase.invoiceNumber}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Category-based Report -->
                <c:if test="${reportType == 'category'}">
                    <div class="row mb-4">
                        <c:forEach var="category" items="${categories}">
                            <div class="col-md-4 mb-3">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h5 class="card-title">${category.name}</h5>
                                        <hr>
                                        <p><strong>Total Items:</strong> ${categoryItemCounts[category.categoryId] != null ? categoryItemCounts[category.categoryId] : 0}</p>
                                        <p><strong>Total Value:</strong> Rs:<fmt:formatNumber value="${categoryValues[category.categoryId] != null ? categoryValues[category.categoryId] : 0}" pattern="#,##0.00"/></p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <h5 class="mb-3 mt-4">Items by Category</h5>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Item</th>
                                    <th>Current Stock</th>
                                    <th>Unit</th>
                                    <th>Unit Price</th>
                                    <th>Total Value</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <c:set var="categoryPrinted" value="false" />
                                    <c:forEach var="item" items="${allItems}">
                                        <c:if test="${item.categoryId == category.categoryId}">
                                            <tr>
                                                <c:if test="${categoryPrinted == 'false'}">
                                                    <td rowspan="${categoryItemCounts[category.categoryId]}">${category.name}</td>
                                                    <c:set var="categoryPrinted" value="true" />
                                                </c:if>
                                                <c:if test="${categoryPrinted == 'true' && item.categoryId == category.categoryId}">
                                                    <td>${item.name}</td>
                                                    <td>${item.currentStock}</td>
                                                    <td>${item.unit}</td>
                                                    <td>Rs:<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                                    <td>Rs:<fmt:formatNumber value="${item.getTotalStockValue()}" pattern="#,##0.00"/></td>
                                                </c:if>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Value Report -->
                <c:if test="${reportType == 'value'}">
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <h5 class="mb-3">Top Value Items</h5>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Rank</th>
                                    <th>Item</th>
                                    <th>Category</th>
                                    <th>Current Stock</th>
                                    <th>Unit</th>
                                    <th>Unit Price</th>
                                    <th>Total Value</th>
                                    <th>% of Inventory</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${valueItems}" varStatus="status">
                                    <c:if test="${status.index < 10}"> <!-- Show top 10 items -->
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td>${item.name}</td>
                                            <td>${item.category}</td>
                                            <td>${item.currentStock}</td>
                                            <td>${item.unit}</td>
                                            <td>Rs:<fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/></td>
                                            <td>Rs:<fmt:formatNumber value="${item.getTotalStockValue()}" pattern="#,##0.00"/></td>
                                            <td>
                                                <fmt:formatNumber value="${(item.getTotalStockValue() / totalInventoryValue) * 100}" pattern="#,##0.0"/>%
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle date fields visibility based on report type
        function toggleDateFields() {
            var reportType = document.getElementById('reportType').value;
            var dateFields = document.getElementById('startDateField').parentNode;
            
            if (reportType === 'purchases') {
                document.getElementById('startDateField').style.display = 'block';
                document.getElementById('endDateField').style.display = 'block';
            } else {
                document.getElementById('startDateField').style.display = 'none';
                document.getElementById('endDateField').style.display = 'none';
            }
        }
        
        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            toggleDateFields();
        });
    </script>
</body>
</html>