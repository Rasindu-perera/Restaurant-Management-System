<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chef Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .welcome-text {
            font-size: 24px;
            color: #333;
        }
        
        .logout-btn {
            padding: 8px 16px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .logout-btn:hover {
            background-color: #c82333;
        }
        
        .orders-section {
            margin-top: 20px;
        }
        
        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .order-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .order-id {
            font-weight: bold;
            color: #333;
        }
        
        .order-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }
        
        .status-confirmed {
            background-color: #b8daff;
            color: #004085;
        }
        
        .status-ready {
            background-color: #c3e6cb;
            color: #155724;
        }
        
        .status-completed {
            background-color: #6c757d;
            color: #ffffff;
        }
        
        .order-items {
            margin: 10px 0;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            margin: 5px 0;
            padding: 5px 0;
            border-bottom: 1px dashed #eee;
        }
        
        .order-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            flex: 1;
        }
        
        .confirm-btn {
            background-color: #28a745;
            color: white;
        }
        
        .confirm-btn:hover {
            background-color: #218838;
        }
        
        .complete-btn {
            background-color: #17a2b8;
            color: white;
        }
        
        .complete-btn:hover {
            background-color: #138496;
        }
        
        .completed-btn {
            background-color: #6c757d;
            color: white;
        }
        
        .completed-btn:hover {
            background-color: #5a6268;
        }
        
        .message {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .no-orders {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }
        
        .debug-info {
            background-color: #f8f9fa;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            white-space: pre-wrap;
        }
        
        .order-details {
            margin-top: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <div class="welcome-text">Welcome, ${sessionScope.chefName}</div>
            <div>
                <a href="${pageContext.request.contextPath}/TableOrderStatusServlet" class="action-btn" style="background-color: #007bff; color: white; text-decoration: none; padding: 8px 16px; border-radius: 4px; margin-right: 10px; display: inline-block;">View Table Status</a>
                <a href="${pageContext.request.contextPath}/admin/inventory/dashboard" class="action-btn" style="background-color: #6610f2; color: white; text-decoration: none; padding: 8px 16px; border-radius: 4px; margin-right: 10px; display: inline-block;">Inventory Management</a>
                <a href="${pageContext.request.contextPath}/logout?role=chef" class="logout-btn">Logout</a>
            </div>
        </div>
        
        <c:if test="${not empty error}">
            <div class="message error">${error}</div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="message success">${success}</div>
        </c:if>
        
        <div class="orders-section">
            <h2 class="section-title">Pending Orders</h2>
            
            <!-- Debug Information -->
            <div class="debug-info">
                <p>Number of orders: ${not empty pendingOrders ? pendingOrders.size() : 0}</p>
                <c:if test="${not empty pendingOrders}">
                    <c:forEach items="${pendingOrders}" var="order" varStatus="status">
                        <p>Order ${status.index + 1}:</p>
                        <ul>
                            <li>ID: ${order.orderId}</li>
                            <li>Status: ${order.status}</li>
                            <li>Table: ${order.tableId}</li>
                            <li>Items: ${order.items.size()}</li>
                        </ul>
                    </c:forEach>
                </c:if>
            </div>
            
            <div class="orders-grid">
                <c:choose>
                    <c:when test="${empty pendingOrders}">
                        <div class="no-orders">No pending orders at the moment.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${pendingOrders}" var="order">
                            <div class="order-card">
                                <div class="order-header">
                                    <span class="order-id">Order #${order.orderId}</span>
                                    <span class="order-status status-${order.status.toLowerCase()}">${order.status}</span>
                                </div>
                                
                                <div class="order-details">
                                    <p>Table #${order.tableId}</p>
                                    <p>Created: ${order.createdAt}</p>
                                </div>
                                
                                <div class="order-items">
                                    <c:forEach items="${order.items}" var="item">
                                        <div class="order-item">
                                            <span>${item.itemName}</span>
                                            <span>x${item.quantity}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <div class="order-actions">
                                    <c:choose>
                                        <c:when test="${order.status eq 'SENT'}">
                                            <form action="${pageContext.request.contextPath}/chef/dashboard" method="post" style="flex: 1;">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <input type="hidden" name="action" value="confirm">
                                                <button type="submit" class="action-btn confirm-btn">Mark Ready</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${order.status eq 'READY'}">
                                            <form action="${pageContext.request.contextPath}/chef/dashboard" method="post" style="flex: 1;">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <input type="hidden" name="action" value="completed">
                                                
                                            </form>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Auto-refresh the page every 30 seconds -->
    <script>
        setTimeout(function() {
            window.location.reload();
        }, 30000);
    </script>
</body>
</html>