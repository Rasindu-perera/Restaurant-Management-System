<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Purchase - Restaurant</title>
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
        .item-row {
            border: 1px solid #e2e8f0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            background-color: #f8fafc;
        }
        .total-section {
            background-color: #eef2ff;
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    
    <!-- Main Content -->
    <div class="content">
        <!-- Header -->
        <div class="header">
            <h4>Add New Purchase</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/inventory/purchases" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Purchases
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

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Add Purchase Form -->
        <div class="card">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/inventory/purchase/add" method="post" id="purchaseForm">
                    <!-- Purchase Details -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <label for="purchaseDate" class="form-label">Purchase Date</label>
                            <input type="date" class="form-control" id="purchaseDate" name="purchaseDate" 
                                   value="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd'/>">
                        </div>
                        <div class="col-md-3">
                            <label for="supplierId" class="form-label">Supplier</label>
                            <select class="form-select" id="supplierId" name="supplierId">
                                <option value="">-- Select Supplier --</option>
                                <c:forEach var="supplier" items="${suppliers}">
                                    <option value="${supplier.supplierId}">${supplier.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="receiptNumber" class="form-label">Invoice #</label>
                            <input type="text" class="form-control" id="receiptNumber" name="receiptNumber">
                        </div>
                        <div class="col-md-3">
                            <label for="notes" class="form-label">Notes</label>
                            <input type="text" class="form-control" id="notes" name="notes">
                        </div>
                    </div>

                    <h5 class="mb-3">Purchase Items</h5>
                    
                    <!-- Item Container -->
                    <div id="itemsContainer">
                        <!-- First item row (always present) -->
                        <div class="item-row" id="item-1">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="itemId_1" class="form-label">Item</label>
                                    <select class="form-select item-select" id="itemId_1" name="itemId" required>
                                        <option value="">-- Select Item --</option>
                                        <c:forEach var="item" items="${inventoryItems}">
                                            <option value="${item.itemId}" data-unit="${item.unit}" data-cost="${item.costPerUnit}">
                                                ${item.name} (${item.unit})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <label for="quantity_1" class="form-label">Quantity</label>
                                    <input type="number" class="form-control item-quantity" id="quantity_1" name="quantity" 
                                           step="0.01" min="0.01" required>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <label for="unit_1" class="form-label">Unit</label>
                                    <input type="text" class="form-control item-unit" id="unit_1" readonly>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="unitPrice_1" class="form-label">Unit Price (Rs:)</label>
                                    <input type="number" class="form-control item-price" id="unitPrice_1" name="unitPrice" 
                                           step="0.01" min="0.01" required>
                                </div>
                                <div class="col-md-1 mb-3 d-flex align-items-end">
                                    <button type="button" class="btn btn-danger" onclick="removeItem(1)" disabled>
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 text-end">
                                    <b>Item Total:</b> Rs:<span class="item-total">0.00</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Add More Items Button -->
                    <div class="d-flex justify-content-end mb-4">
                        <button type="button" class="btn btn-success" onclick="addItem()">
                            <i class="bi bi-plus-circle"></i> Add Another Item
                        </button>
                    </div>
                    
                    <!-- Total Section -->
                    <div class="total-section">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Purchase Summary</h5>
                                <p class="mb-0">Total Items: <span id="totalItems">1</span></p>
                            </div>
                            <div class="col-md-6 text-end">
                                <h5>Grand Total: Rs:<span id="grandTotal">0.00</span></h5>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Submit Button -->
                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-save"></i> Save Purchase
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/inventory/purchases" class="btn btn-outline-secondary ms-2">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global variables
        let itemCount = 1;
        
        // Initialize event listeners for the first item row
        document.addEventListener('DOMContentLoaded', function() {
            setupItemListeners(1);
            calculateTotals();
        });
        
        // Add new item row
        function addItem() {
            itemCount++;
            
            // Create new item row
            const newRow = document.createElement('div');
            newRow.className = 'item-row';
            newRow.id = 'item-' + itemCount;
            
            newRow.innerHTML = `
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="itemId_${itemCount}" class="form-label">Item</label>
                        <select class="form-select item-select" id="itemId_${itemCount}" name="itemId" required>
                            <option value="">-- Select Item --</option>
                            <c:forEach var="item" items="${inventoryItems}">
                                <option value="${item.itemId}" data-unit="${item.unit}" data-cost="${item.costPerUnit}">
                                    ${item.name} (${item.unit})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="quantity_${itemCount}" class="form-label">Quantity</label>
                        <input type="number" class="form-control item-quantity" id="quantity_${itemCount}" name="quantity" 
                               step="0.01" min="0.01" required>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label for="unit_${itemCount}" class="form-label">Unit</label>
                        <input type="text" class="form-control item-unit" id="unit_${itemCount}" readonly>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label for="unitPrice_${itemCount}" class="form-label">Unit Price (Rs:)</label>
                        <input type="number" class="form-control item-price" id="unitPrice_${itemCount}" name="unitPrice" 
                               step="0.01" min="0.01" required>
                    </div>
                    <div class="col-md-1 mb-3 d-flex align-items-end">
                        <button type="button" class="btn btn-danger" onclick="removeItem(${itemCount})">
                            <i class="bi bi-trash"></i>
                        </button>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 text-end">
                        <b>Item Total:</b> Rs:<span class="item-total">0.00</span>
                    </div>
                </div>
            `;
            
            // Add to container
            document.getElementById('itemsContainer').appendChild(newRow);
            
            // Setup listeners for the new row
            setupItemListeners(itemCount);
            
            // Enable delete button on first row if more than one row
            if (itemCount === 2) {
                document.querySelector('#item-1 button').disabled = false;
            }
            
            // Update totals
            updateTotalItems();
            
            return false;
        }
        
        // Remove item row
        function removeItem(id) {
            document.getElementById('item-' + id).remove();
            itemCount = document.querySelectorAll('.item-row').length;
            
            // Disable delete button if only one row left
            if (itemCount === 1) {
                document.querySelector('.item-row button').disabled = true;
            }
            
            // Update totals
            updateTotalItems();
            calculateTotals();
            
            return false;
        }
        
        // Setup event listeners for an item row
        function setupItemListeners(id) {
            // Item selection changes
            const itemSelect = document.getElementById('itemId_' + id);
            itemSelect.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const unitField = document.getElementById('unit_' + id);
                const unitPriceField = document.getElementById('unitPrice_' + id);
                
                if (selectedOption.value) {
                    unitField.value = selectedOption.getAttribute('data-unit');
                    
                    // Only set the unit price if it's empty or zero
                    if (!unitPriceField.value || parseFloat(unitPriceField.value) === 0) {
                        const suggestedPrice = selectedOption.getAttribute('data-cost');
                        if (suggestedPrice && parseFloat(suggestedPrice) > 0) {
                            unitPriceField.value = suggestedPrice;
                        }
                    }
                } else {
                    unitField.value = '';
                }
                
                calculateItemTotal(id);
            });
            
            // Quantity or price changes
            const quantityField = document.getElementById('quantity_' + id);
            const priceField = document.getElementById('unitPrice_' + id);
            
            quantityField.addEventListener('input', function() {
                calculateItemTotal(id);
            });
            
            priceField.addEventListener('input', function() {
                calculateItemTotal(id);
            });
        }
        
        // Calculate total for an item
        function calculateItemTotal(id) {
            const quantityField = document.getElementById('quantity_' + id);
            const priceField = document.getElementById('unitPrice_' + id);
            const totalSpan = document.querySelector('#item-' + id + ' .item-total');
            
            const quantity = parseFloat(quantityField.value) || 0;
            const price = parseFloat(priceField.value) || 0;
            const total = quantity * price;
            
            totalSpan.textContent = total.toFixed(2);
            
            calculateTotals();
        }
        
        // Calculate grand total
        function calculateTotals() {
            let grandTotal = 0;
            
            document.querySelectorAll('.item-total').forEach(function(element) {
                grandTotal += parseFloat(element.textContent) || 0;
            });
            
            document.getElementById('grandTotal').textContent = grandTotal.toFixed(2);
        }
        
        // Update total items count
        function updateTotalItems() {
            const count = document.querySelectorAll('.item-row').length;
            document.getElementById('totalItems').textContent = count;
        }
        
        // Form validation before submit
        document.getElementById('purchaseForm').addEventListener('submit', function(e) {
            let valid = true;
            let message = '';
            
            // Check if at least one item is selected
            const selectedItems = document.querySelectorAll('.item-select');
            let hasItem = false;
            
            for (let i = 0; i < selectedItems.length; i++) {
                if (selectedItems[i].value) {
                    hasItem = true;
                    break;
                }
            }
            
            if (!hasItem) {
                valid = false;
                message = 'Please select at least one item for purchase';
            }
            
            // Check if grand total is greater than zero
            const grandTotal = parseFloat(document.getElementById('grandTotal').textContent) || 0;
            if (grandTotal <= 0) {
                valid = false;
                message = 'Total purchase amount must be greater than zero';
            }
            
            if (!valid) {
                e.preventDefault();
                alert(message);
            }
        });
    </script>
</body>
</html>
``` 