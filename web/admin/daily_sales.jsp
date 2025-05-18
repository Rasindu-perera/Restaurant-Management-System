<%-- 
    Document   : daily_sales
    Created on : May 17, 2025, 10:48:41 AM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Bill, java.text.SimpleDateFormat" %>
<%@ page import="com.google.gson.Gson" %>

<%
    List<Bill> dailySales = (List<Bill>) request.getAttribute("dailySales");
    Map<String, Integer> itemSales = (Map<String, Integer>) request.getAttribute("itemSales");
    Map<String, Double> itemSalesPercentages = (Map<String, Double>) request.getAttribute("itemSalesPercentages");
    double dailyIncome = (Double) request.getAttribute("dailyIncome");
    String selectedDate = (String) request.getAttribute("selectedDate");
    Map<String, Integer> popularItems = (Map<String, Integer>) request.getAttribute("popularItems");
    
    // For JSON conversion
    Gson gson = new Gson();
    String itemLabels = gson.toJson(itemSales.keySet());
    String itemData = gson.toJson(itemSales.values());
    String percentageData = gson.toJson(itemSalesPercentages.values());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Daily Sales Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .card {
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            border-radius: 15px 15px 0 0 !important;
            background-color: #f8f9fa;
        }
        .stat-card {
            text-align: center;
            padding: 20px;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
    </style>
</head>
<body>
<jsp:include page="admin_header.jsp" />

<div class="container-fluid mt-4">
    <div class="row mb-4">
        <div class="col">
            <h2>Daily Sales Dashboard</h2>
        </div>
        <div class="col-auto">
            <form action="DailySalesServlet" method="get" class="d-flex">
                <input type="date" name="date" value="<%= selectedDate %>" class="form-control me-2">
                <button type="submit" class="btn btn-primary">View</button>
            </form>
        </div>
    </div>
    
    <!-- Stats Cards -->
    <div class="row mb-4">
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="stat-value">Rs. <%= String.format("%.2f", dailyIncome) %></div>
                <div class="stat-label">DAILY INCOME</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="stat-value"><%= dailySales != null ? dailySales.size() : 0 %></div>
                <div class="stat-label">ITEMS SOLD</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="stat-value"><%= itemSales != null ? itemSales.size() : 0 %></div>
                <div class="stat-label">UNIQUE ITEMS</div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <!-- Item Sales Chart -->
        <div class="col-lg-6 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Item Sales Distribution</h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="itemChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Popular Items Table -->
        <div class="col-lg-6 mb-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Most Popular Items</h5>
                </div>
                <div class="card-body">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th class="text-end">Quantity Sold</th>
                                <th class="text-end">Percentage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (itemSales != null && !itemSales.isEmpty()) {
                                for (Map.Entry<String, Integer> entry : itemSales.entrySet()) {
                                    String itemName = entry.getKey();
                                    int qty = entry.getValue();
                                    double percentage = itemSalesPercentages.get(itemName);
                            %>
                            <tr>
                                <td><%= itemName %></td>
                                <td class="text-end"><%= qty %></td>
                                <td class="text-end"><%= percentage %>%</td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="3" class="text-center">No items sold on this date</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Daily Sales Details -->
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Daily Sales Details</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Bill ID</th>
                                    <th>Table</th>
                                    <th>Order ID</th>
                                    <th>Item</th>
                                    <th class="text-end">Quantity</th>
                                    <th class="text-end">Price</th>
                                    <th class="text-end">Total</th>
                                    <th>Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (dailySales != null && !dailySales.isEmpty()) {
                                    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
                                    for (Bill bill : dailySales) {
                                %>
                                <tr>
                                    <td><%= bill.getBillId() %></td>
                                    <td><%= bill.getTableId() %></td>
                                    <td><%= bill.getOrderId() %></td>
                                    <td><%= bill.getItemName() %></td>
                                    <td class="text-end"><%= bill.getQty() %></td>
                                    <td class="text-end">Rs. <%= String.format("%.2f", bill.getPrice()) %></td>
                                    <td class="text-end">Rs. <%= String.format("%.2f", bill.getTotal()) %></td>
                                    <td><%= bill.getTime() != null ? timeFormat.format(bill.getTime()) : "N/A" %></td>
                                </tr>
                                <% 
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="8" class="text-center">No sales data available for this date</td>
                                </tr>
                                <% } %>
                            </tbody>
                            <tfoot>
                                <tr class="fw-bold">
                                    <td colspan="6" class="text-end">Total Income:</td>
                                    <td class="text-end">Rs. <%= String.format("%.2f", dailyIncome) %></td>
                                    <td></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Item Sales Chart
    const ctx = document.getElementById('itemChart').getContext('2d');
    const itemLabels = <%= itemLabels %>;
    const itemData = <%= itemData %>;
    const percentageData = <%= percentageData %>;
    
    // Generate random colors for the chart
    function generateColors(count) {
        const colors = [];
        const baseColors = [
            '#4CAF50', // Green
            '#FFC107', // Yellow
            '#F44336', // Red
            '#2196F3', // Blue
            '#9C27B0', // Purple
            '#FF9800', // Orange
            '#607D8B'  // Blue Grey
        ];
        
        for (let i = 0; i < count; i++) {
            colors.push(baseColors[i % baseColors.length]);
        }
        
        return colors;
    }
    
    const backgroundColors = generateColors(itemLabels.length);
    
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: itemLabels,
            datasets: [{
                data: percentageData,
                backgroundColor: backgroundColors,
                borderColor: '#ffffff',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        boxWidth: 15,
                        padding: 15
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.formattedValue || '';
                            const quantity = itemData[context.dataIndex];
                            return `${label}: ${value}% (${quantity} items)`;
                        }
                    }
                }
            }
        }
    });
</script>

</body>
</html>