<%-- 
    Document   : success
    Created on : May 8, 2025, 8:30:14 PM
    Author     : RasinduPerera
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Success</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-success" role="alert">
            <h4 class="alert-heading">Success!</h4>
            <p>${message}</p>
        </div>
        <a href="login.jsp" class="btn btn-primary">Return to login</a>
    </div>
</body>
</html>