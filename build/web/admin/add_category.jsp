<%-- 
    Document   : add_category
    Created on : May 4, 2025, 12:14:05 PM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="admin_header.jsp" />

<h2 class="mt-4">Add New Category</h2>

<form action="addCategory" method="post" class="w-50">
    <div class="mb-3">
        <label for="name" class="form-label">Category Name:</label>
        <input type="text" name="name" id="name" class="form-control" required>
    </div>
    <button type="submit" class="btn btn-primary">Add Category</button>
</form>

<jsp:include page="admin_footer.jsp" />
