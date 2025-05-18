<%-- 
    Document   : cashier_dashboard.jsp
    Created on : May 6, 2025, 10:17:04 AM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.*, model.*, dao.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Cashier Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .dashboard-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .table-section {
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Cashier Dashboard</h2>
            <button onclick="window.location.reload()" class="btn btn-outline-primary">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
                    <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
                </svg>
                Refresh
            </button>
        </div>
        
        <!-- Table ID Input Section -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">View Table Bill</h5>
                <form action="ViewBillServlet" method="get" class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label for="tableId" class="form-label">Enter Table ID</label>
                        <input type="number" class="form-control" id="tableId" name="tableId" required>
                    </div>
                    <div class="col-md-6">
                        <button type="submit" class="btn btn-primary">View Bill</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Reserved Tables Section -->
        <div class="card table-section">
            <div class="card-body">
                <h5 class="card-title">Reserved Tables</h5>
                <%
                    TableDAO tableDAO = new TableDAO();
                    List<Table> reservedTables = tableDAO.getTablesByStatus("Reserved");
                    if (!reservedTables.isEmpty()) {
                %>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Table ID</th>
                                    <th>Status</th>
                                    
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Table t : reservedTables) { %>
                                    <tr>
                                        <td>Table <%= t.getTableId() %></td>
                                        <td><span class="badge bg-warning"><%= t.getStatus() %></span></td>
                                        <td>
                                            <a href="ViewBillServlet?tableId=<%= t.getTableId() %>" 
                                               class="btn btn-sm btn-info">View Details</a>
                                                                     
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="alert alert-info">
                        No reserved tables at the moment.
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Available Tables Section -->
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Available Tables</h5>
                <%
                    List<Table> availableTables = tableDAO.getTablesByStatus("Available");
                    if (!availableTables.isEmpty()) {
                %>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Table ID</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Table t : availableTables) { %>
                                    <tr>
                                        <td>Table <%= t.getTableId() %></td>
                                        <td><span class="badge bg-success"><%= t.getStatus() %></span></td>
                                        <td>
                                            <a href="ViewBillServlet?tableId=<%= t.getTableId() %>" 
                                               class="btn btn-sm btn-info">View Details</a>
                                            <form action="ReadyToBillServlet" method="post" style="display: inline-block;">
                                                <input type="hidden" name="tableId" value="<%= t.getTableId() %>">
                                                <button type="submit" class="btn btn-sm btn-warning">Ready to Bill</button>
                                            </form>
                                            
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } else { %>
                    <div class="alert alert-info">
                        No available tables at the moment.
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>

