<%-- 
    Document   : error.jsp
    Created on : May 5, 2025, 5:43:13?PM
    Author     : RasinduPerera
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-danger">
            <h2 class="alert-heading">Error</h2>
            <%--  Check if an error message exists in the request scope --%>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <p class="mb-0"><%= request.getAttribute("errorMessage") %></p>
            <% } else { %>
                <p class="mb-0">An unexpected error occurred.</p>
            <% } %>
        </div>
        <a href="<%= request.getContextPath() %>/" class="btn btn-secondary">Back to Home</a>
    </div>
</body>
</html>
