<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase History - Restaurant</title>
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
        .filters-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
   

    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Purchase History</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/inventory/purchase/add" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> New Purchase
                </a>
                
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
            <a href="${pageContext.request.contextPath}/admin/inventory/purchases" class="active">
                <i class="bi bi-bag-plus"></i> Purchases
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/categories">
                <i class="bi bi-tags"></i> Categories
            </a>
            <a href="${pageContext.request.contextPath}/admin/inventory/reports">
                <i class="bi bi-file-earmark-bar-graph"></i> Reports
            </a>
        </div>

        <!-- Stats Overview -->
        <div class="row mt-4">
            <div class="col-xl-6 col-md-6">
                <div class="card stat-card primary">
                    <div class="stat-card-body">
                        <div class="stat-card-title">Total Purchases</div>
                        <div class="stat-card-value">${totalPurchases}</div>
                        <div class="small text-muted mt-2">
                            <i class="bi bi-clock-history"></i> Total purchase records
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-6 col-md-6">
                <div class="card stat-card success">
                    <div class="stat-card-body">
                        <div class="stat-card-title">Total Value</div>
                        <div class="stat-card-value">Rs:<fmt:formatNumber value="${totalPurchaseValue}" pattern="#,##0.00"/></div>
                        <div class="small text-muted mt-2">
                            <i class="bi bi-currency-dollar"></i> Total purchase value
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters Section -->
        <div class="filters-section">
            <form action="${pageContext.request.contextPath}/admin/inventory/purchases" method="get" id="filterForm" class="row g-3">
                <div class="col-md-3">
                    <label for="itemId" class="form-label">Item</label>
                    <select class="form-select" id="itemId" name="itemId" onchange="this.form.submit()">
                        <option value="">All Items</option>
                        <c:forEach var="item" items="${items}">
                            <option value="${item.itemId}" ${selectedItemId == item.itemId ? 'selected' : ''}>
                                ${item.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="supplier" class="form-label">Supplier</label>
                    <select class="form-select" id="supplier" name="supplier" onchange="this.form.submit()">
                        <option value="">All Suppliers</option>
                        <c:forEach var="supplier" items="${suppliers}">
                            <option value="${supplier}" ${selectedSupplier == supplier ? 'selected' : ''}>
                                ${supplier}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate" value="${startDate}">
                </div>
                <div class="col-md-2">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                </div>
                <div class="col-md-2">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary">Filter</button>
                    <a href="${pageContext.request.contextPath}/admin/inventory/purchases" class="btn btn-outline-secondary">
                        Reset
                    </a>
                </div>
            </form>
        </div>

        <!-- Purchases Table -->
        <div class="card">
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty purchases}">
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
                                        <th>Actions</th>
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
                                            <td>${purchase.supplier}</td>
                                            <td>${purchase.receiptNumber}</td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <a href="${pageContext.request.contextPath}/admin/inventory/purchase/view?id=${purchase.id}" 
                                                       class="btn btn-info" title="View Details">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    <button class="btn btn-danger" onclick="confirmDelete(${purchase.id})" 
                                                            title="Delete">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No purchase records found.
                            <a href="${pageContext.request.contextPath}/admin/inventory/purchase/add">Add a purchase</a>.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this purchase record?
                    This may affect inventory stock levels.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/inventory/purchase/delete" method="post">
                        <input type="hidden" id="deletePurchaseId" name="id">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Date range validation
        document.getElementById('filterForm').addEventListener('submit', function(e) {
            var startDate = document.getElementById('startDate').value;
            var endDate = document.getElementById('endDate').value;
            
            if ((startDate && !endDate) || (!startDate && endDate)) {
                e.preventDefault();
                alert('Please select both start and end dates');
            }
            
            if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                e.preventDefault();
                alert('End date must be greater than or equal to start date');
            }
        });
        
        // Delete confirmation
        function confirmDelete(id) {
            document.getElementById('deletePurchaseId').value = id;
            
            // Initialize and show the modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>