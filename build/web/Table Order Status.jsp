<%-- 
    Document   : Table Order Status
    Created on : May 15, 2025, 4:00:59 PM
    Author     : RasinduPerera
--%>

<%-- filepath: c:\Users\Rasindu Perera\Documents\NetBeansProjects\RestaurantSystem_Updated\web\table_orders_status.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Table Order Status</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        
        .tables-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
        }
        
        .table-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .table-header {
            background-color: #f8f9fa;
            padding: 10px;
            margin: -15px -15px 15px -15px;
            border-radius: 8px 8px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .table-name {
            font-weight: bold;
            font-size: 18px;
            color: #333;
        }
        
        .order-list {
            margin-top: 10px;
        }
        
        .order-item {
            background-color: #f8f9fa;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
            border-left: 4px solid #ddd;
        }
        
        .order-item.sent {
            border-left-color: #ffc107; /* yellow */
        }
        
        .order-item.ready {
            border-left-color: #28a745; /* green */
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .order-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status-sent {
            background-color: #ffeeba;
            color: #856404;
        }
        
        .status-ready {
            background-color: #c3e6cb;
            color: #155724;
        }
        
        .no-orders-msg {
            text-align: center;
            padding: 20px;
            font-style: italic;
            color: #666;
        }
    </style>
    <meta http-equiv="refresh" content="30"> <!-- Auto-refresh every 30 seconds -->
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h2>Table Order Status</h2>
            <div>
                <a href="${pageContext.request.contextPath}/chef/dashboard" class="btn btn-primary">Back to Dashboard</a>
            </div>
        </div>
        
        <div class="tables-grid">
            <c:choose>
                <c:when test="${empty ordersByTable}">
                    <div class="col-12 no-orders-msg">
                        <h3>No active orders at this time</h3>
                        <p>Tables with SENT or READY orders will appear here</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="entry" items="${ordersByTable}">
                        <c:set var="tableId" value="${entry.key}" />
                        <c:set var="tableOrders" value="${entry.value}" />
                        <c:set var="tableInfo" value="${tableDetails[tableId]}" />
                        
                        <div class="table-card">
                            <div class="table-header">
                                <span class="table-name">
                                    Table #${tableId}
                                    <c:if test="${not empty tableInfo.tableName}">
                                        - ${tableInfo.tableName}
                                    </c:if>
                                </span>
                                <span class="badge ${tableInfo.status eq 'Reserved' ? 'bg-warning' : 'bg-success'}">
                                    ${tableInfo.status}
                                </span>
                            </div>
                            
                            <div class="order-list">
                                <c:forEach var="order" items="${tableOrders}">
                                    <div class="order-item ${order.status.toLowerCase()}">
                                        <div class="order-header">
                                            <span class="fw-bold">Order #${order.orderId}</span>
                                            <span class="order-status ${order.status eq 'SENT' ? 'status-sent' : 'status-ready'}">
                                                ${order.status}
                                            </span>
                                        </div>
                                        
                                        <p class="text-muted small">
                                            <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                        </p>
                                        
                                        <div class="order-items mt-2">
                                            <table class="table table-sm">
                                                <tbody>
                                                    <c:forEach var="item" items="${order.items}">
                                                        <tr>
                                                            <td>${item.itemName}</td>
                                                            <td class="text-end">${item.quantity}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>