<%-- 
    Document   : add_table
    Created on : May 4, 2025, 12:05:06 PM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Table</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<%@ include file="admin_header.jsp" %>

<div class="container mt-5">
    <h2>Add New Table</h2>
    <form action="add-table" method="post">
        <div class="mb-3">
            <label for="table_id" class="form-label">Table ID</label>
            <input type="number" class="form-control" id="table_id" name="table_id" required>
        </div>
        <div class="mb-3">
            <label for="table_status" class="form-label">Status</label>
            <select class="form-select" name="table_status" required>
                <option value="available">Available</option>
                <option value="Reserved">Reserved</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Add Table</button>
    </form>
</div>

<%@ include file="admin_footer.jsp" %>

</body>
</html>
