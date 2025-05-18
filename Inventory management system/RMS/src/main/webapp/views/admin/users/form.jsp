<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <title>User Form</title>
</head>
<body>
    <%@ include file="/includes/navbar.jsp" %>
<h1>User Form</h1>
<form action="${pageContext.request.contextPath}/admin/users" method="post">
    <input type="hidden" name="action" value="save">
    <input type="hidden" name="id" value="${user.id}">
    <label for="username">Username:</label>
    <input type="text" name="username" id="username" value="${user.username}" required>
    <br>
    <label for="password">Password:</label>
    <input type="password" name="password" id="password">
    <br>
    <label for="role">Role:</label>
    <select name="role" id="role">
        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
        <option value="MANAGER" ${user.role == 'MANAGER' ? 'selected' : ''}>Manager</option>
        <option value="STAFF" ${user.role == 'STAFF' ? 'selected' : ''}>Staff</option>
    </select>
    <br>
    <button type="submit">Save</button>
</form>
</body>
</html>