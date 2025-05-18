<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Items - Restaurant</title>
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
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        .action-buttons {
            white-space: nowrap;
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
            <h4>Inventory Items</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/inventory/item/add" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> Add New Item
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

        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="message" scope="session" />
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="error" scope="session" />
        </c:if>

        <!-- Filters Section -->
        <div class="filters-section">
            <form action="${pageContext.request.contextPath}/admin/inventory/items" method="post" class="row g-3">
                <div class="col-md-4">
                    <label for="search" class="form-label">Search</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="search" name="search" 
                              placeholder="Search by name or description" value="${searchTerm}">
                        <button class="btn btn-outline-secondary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
                <div class="col-md-3">
                    <label for="category" class="form-label">Category</label>
                    <select class="form-select" id="category" name="category" onchange="this.form.submit()">
                        <option value="all">All Categories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category}" ${categoryFilter == category ? 'selected' : ''}>
                                ${category}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="sortBy" class="form-label">Sort By</label>
                    <select class="form-select" id="sortBy" name="sortBy" onchange="this.form.submit()">
                        <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Name (A-Z)</option>
                        <option value="category" ${sortBy == 'category' ? 'selected' : ''}>Category</option>
                        <option value="stock" ${sortBy == 'stock' ? 'selected' : ''}>Stock Level</option>
                        <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Unit Price</option>
                        <option value="value" ${sortBy == 'value' ? 'selected' : ''}>Total Value</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label d-block">&nbsp;</label>
                    <a href="${pageContext.request.contextPath}/admin/inventory/items" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>
            </form>
        </div>

        <!-- Inventory Items List -->
        <div class="card">
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty inventoryItems}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Category</th>
                                        <th>Current Stock</th>
                                        <th>Unit</th>
                                        <th>Unit Price</th>
                                        <th>Total Value</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${inventoryItems}">
                                        <tr>
                                            <td>
                                                <strong>${item.name}</strong>
                                                <c:if test="${item.currentQuantity <= item.minStockLevel}">
                                                    <span class="low-stock-badge ms-2">Low Stock</span>
                                                </c:if>
                                            </td>
                                            <td>${item.category.name}</td>
                                            <td>${item.currentQuantity} ${item.unit}</td>
                                            <td>${item.unit}</td>
                                            <td>Rs:<fmt:formatNumber value="${item.costPerUnit}" pattern="#,##0.00"/></td>
                                            <td>Rs:<fmt:formatNumber value="${item.getTotalStockValue()}" pattern="#,##0.00"/></td>
                                            <td class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/admin/inventory/item/view?id=${item.itemId}" 
                                                   class="btn btn-sm btn-info" title="View Details">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/inventory/item/edit?id=${item.itemId}" 
                                                   class="btn btn-sm btn-primary" title="Edit">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/inventory/purchase/add?itemId=${item.itemId}" 
                                                   class="btn btn-sm btn-success" title="Add Stock">
                                                    <i class="bi bi-plus-circle"></i>
                                                </a>
                                                <button class="btn btn-sm btn-danger" onclick="confirmDelete(${item.itemId}, '${item.name}')" 
                                                        title="Delete">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No inventory items found. 
                            <a href="${pageContext.request.contextPath}/admin/inventory/item/add">Add your first item</a>.
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
                    Are you sure you want to delete <span id="itemName" class="fw-bold"></span>?
                    This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/inventory/item/delete" method="post">
                        <input type="hidden" id="deleteItemId" name="itemId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Delete confirmation
        function confirmDelete(id, name) {
            document.getElementById('itemName').textContent = name;
            document.getElementById('deleteItemId').value = id;
            
            // Initialize and show the modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>