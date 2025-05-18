<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Menu Item</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h3>Add New Menu Item</h3>
    <!-- ✅ Note enctype for file upload -->
    <form action="add_Menu_Item" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label class="form-label">Name:</label>
            <input type="text" name="name" class="form-control" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Price:</label>
            <input type="number" step="0.01" name="price" class="form-control" required />
        </div>

        <!-- ✅ File Upload for Image -->
        <div class="mb-3">
            <label class="form-label">Image:</label>
            <input type="file" name="image" class="form-control" accept="image/*" required />
        </div>

        <div class="mb-3">
            <label class="form-label">Category:</label>
            <select name="category_id" class="form-control" required>
                <option value="">-- Select Category --</option>
                <% if (categories != null && !categories.isEmpty()) {
                       for (Category cat : categories) { %>
                           <option value="<%= cat.getCategoryId() %>"><%= cat.getName() %></option>
                <%     }
                   } else { %>
                       <option disabled>-- No categories available --</option>
                <% } %>
            </select>
        </div>

        <button type="submit" class="btn btn-success">Add Item</button>
        <a href="menu_items" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
