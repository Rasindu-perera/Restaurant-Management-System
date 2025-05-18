<%-- 
    Document   : categories
    Created on : May 4, 2025, 12:03:36 PM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="admin_header.jsp" />

<h2 class="mt-4">Manage Categories</h2>
<a href="add_category.jsp" class="btn btn-success mb-3">Add New Category</a>

<table class="table table-bordered">
    <thead>
        <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
    </thead>
    <tbody>
        <%
            List<Category> cats = (List<Category>) request.getAttribute("categories");
            if (cats != null) {
                for (Category c : cats) {
        %>
        <tr>
            <td><%= c.getCategoryId() %></td>
            <td><%= c.getName() %></td>
            <td>
                <!-- Edit / Delete can be added later -->
                <a href="deleteCategory?id=<%= c.getCategoryId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="3" class="text-danger text-center">No categories found.</td>
        </tr>
        <% } %>
    </tbody>
</table>
<br>
<jsp:include page="admin_footer.jsp" />
