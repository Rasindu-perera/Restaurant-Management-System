<%--
    Document     : menu_items
    Created on : May 4, 2025, 12:03:57 PM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.MenuItem" %>
<%@ page import="model.Category" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="admin_header.jsp" />

<h2 class="mt-4">Manage Menu Items</h2>
<a href="showAddMenuItem" class="btn btn-success mb-3">Add New Item</a>

<table class="table table-bordered">
    <thead>
        <tr><th>ID</th><th>Name</th><th>Category</th><th>Price</th><th>Actions</th></tr>
    </thead>
    <tbody>
        <%
        List<MenuItem> items = (List<MenuItem>)(request.getAttribute("menuItems")); //Added explicit cast
        if (items != null && !items.isEmpty()) { // Added null and empty check
            for (MenuItem m : items) {
%>
<tr>
    <td><%= m.getId() %></td>
    <td><%= m.getName() %></td>
    <td><%= m.getCategoryId() %></td>
    <td>Rs. <%= m.getPrice() %></td>
    <td>
        <a href="editMenuItem?id=<%= m.getId() %>" class="btn btn-warning btn-sm">Edit</a>
        <a href="deleteMenuItem?id=<%= m.getId() %>"
   onclick="return confirm('Are you sure you want to delete this item?');"
   class="btn btn-danger btn-sm">
   Delete
</a>



    </td>
    </tr>
    <%
            }
        } else {
%>
    <tr>
        <td colspan="5" class="text-center text-danger">No menu items found.</td>
    </tr>
    <% } %>
    </tbody>
</table>

<jsp:include page="admin_footer.jsp" />
