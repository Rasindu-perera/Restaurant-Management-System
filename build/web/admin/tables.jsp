<%-- 
    Document   : tables
    Created on : May 4, 2025, 11:21:58 AM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Table" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="admin_header.jsp" %>

<div class="container mt-5">
    <h2>Tables</h2>
    <a href="add_table.jsp" class="btn btn-success mb-3">Add New Table</a>

    <%
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = util.DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT * FROM tables ORDER BY table_id DESC");
    %>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Table ID</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
        %>
            <tr>
                <td><%= rs.getInt("table_id") %></td>
                <td><%= rs.getString("status") %></td>
                <td>
                    
                    <a href="delete-table?id=<%= rs.getInt("table_id") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <%
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</div>

<%@ include file="admin_footer.jsp" %>
