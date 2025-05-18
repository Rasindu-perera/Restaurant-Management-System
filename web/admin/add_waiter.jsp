<%-- 
    Document   : add_waiter
    Created on : May 4, 2025, 12:08:45 PM
    Author     : RasinduPerera
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Waiter</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">Add New Waiter</h2>

    <form action="${pageContext.request.contextPath}/admin/addWaiter" method="post">
        <div class="form-group">
            <label for="waiter_id">Waiter ID</label>
            <input type="number" class="form-control" id="waiter_id" name="waiter_id" required>
        </div>

        <div class="form-group">
            <label for="name">Waiter Name</label>
            <input type="text" class="form-control" id="name" name="name" required>
        </div>

        <button type="submit" class="btn btn-primary">Add Waiter</button>
        <a href="waiters" class="btn btn-secondary">Cancel</a>
    </form>

    <c:if test="${param.error == 'insert_failed'}">
        <div class="alert alert-danger mt-3">Failed to insert waiter. Please try again.</div>
    </c:if>
    <c:if test="${param.error == 'exception'}">
        <div class="alert alert-danger mt-3">An error occurred. Please check the server logs.</div>
    </c:if>
</div>

</body>
</html>
