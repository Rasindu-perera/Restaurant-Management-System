<%--
    Document     : edit_menu_item
    Created on : May 4, 2025, 12:16:55 PM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.MenuItem, model.Category, java.util.List" %>
<%
    MenuItem item = (MenuItem) request.getAttribute("item");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Menu Item</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3>Edit Menu Item</h3>
    <% if (item != null) { %>
    <form action="editMenuItem" method="post" enctype="multipart/form-data">  <input type="hidden" name="id" value="<%= item.getId() %>" />
        <div class="mb-3">
            <label class="form-label">Name:</label>
            <input type="text" name="name" class="form-control" value="<%= item.getName() %>" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Price:</label>
            <input type="number" step="0.01" name="price" class="form-control" value="<%= item.getPrice() %>" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Category:</label>
            <select name="category_id" class="form-control" required>
                <% if (categories != null) { %>
                    <% for (Category cat : categories) { %>
                        <option value="<%= cat.getCategoryId() %>"
                            <%= (item.getCategoryId() == cat.getCategoryId()) ? "selected" : "" %>>
                            <%= cat.getName() %>
                        </option>
                    <% } %>
                <% } else { %>
                     <option value="">No categories available</option>
                <% } %>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Image:</label>
            <input type="file" name="image" class="form-control" accept="image/*"/>
            <small class="text-muted">Choose a new image to update, or leave blank to keep the current image.</small>
            <img src="images/<%= item.getImageUrl() %>" alt="Current Image" style="max-width: 100px; margin-top: 10px;">
        </div>
        <button type="submit" class="btn btn-primary">Update Item</button>
        <a href="menu_items" class="btn btn-secondary">Cancel</a>
    </form>
     <% } else { %>
        <div class="alert alert-danger">
          <strong>Error:</strong> No menu item data found.  Please ensure you are accessing this page with a valid item ID.
        </div>
        <a href="menu_items" class="btn btn-secondary">Back to Menu Items</a>
    <% } %>
</div>
</body>
</html>