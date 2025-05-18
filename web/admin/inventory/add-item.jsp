<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Inventory Item - Restaurant</title>
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
    </style>
</head>
<body>
   

    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Add New Inventory Item</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/inventory/items" class="btn btn-outline-secondary">
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

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Add Item Form -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/inventory/item/add" method="post">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label">Item Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name" value="${item.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="categoryId" class="form-label">Category</label>
                            <select class="form-select" id="categoryId" name="categoryId">
                                <option value="">-- Select Category --</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}" ${item.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3">${item.description}</textarea>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-3">
                            <label for="currentStock" class="form-label">Current Stock</label>
                            <input type="number" class="form-control" id="currentStock" name="currentStock" 
                                   value="${item.currentStock}" step="0.01" min="0">
                        </div>
                        <div class="col-md-3">
                            <label for="minStockLevel" class="form-label">Minimum Stock Level</label>
                            <input type="number" class="form-control" id="minStockLevel" name="minStockLevel" 
                                   value="${item.minStockLevel}" step="0.01" min="0">
                        </div>
                        <div class="col-md-3">
                            <label for="unit" class="form-label">Unit</label>
                            <select class="form-select" id="unit" name="unit">
                                <option value="kg" ${item.unit == 'kg' ? 'selected' : ''}>Kilogram (kg)</option>
                                <option value="g" ${item.unit == 'g' ? 'selected' : ''}>Gram (g)</option>
                                <option value="L" ${item.unit == 'L' ? 'selected' : ''}>Liter (L)</option>
                                <option value="ml" ${item.unit == 'ml' ? 'selected' : ''}>Milliliter (ml)</option>
                                <option value="pcs" ${item.unit == 'pcs' ? 'selected' : ''}>Pieces (pcs)</option>
                                <option value="box" ${item.unit == 'box' ? 'selected' : ''}>Box</option>
                                <option value="bottle" ${item.unit == 'bottle' ? 'selected' : ''}>Bottle</option>
                                <option value="pkg" ${item.unit == 'pkg' ? 'selected' : ''}>Package</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="unitPrice" class="form-label">Unit Price</label>
                            <div class="input-group">
                                <span class="input-group-text">Rs:</span>
                                <input type="number" class="form-control" id="unitPrice" name="unitPrice" 
                                       value="${item.unitPrice}" step="0.01" min="0">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Save Item
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/inventory/items" class="btn btn-outline-secondary ms-2">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>