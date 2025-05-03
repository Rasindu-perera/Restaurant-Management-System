<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Waiter Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="login" method="post">
        Waiter ID: <input type="text" name="waiterId" required><br><br>
        Table ID: <input type="text" name="tableId" required><br><br>
        <input type="submit" value="Login">
    </form>
    <% String msg = (String) request.getAttribute("message"); %>
<% if (msg != null) { %>
    <p style="color:green;"><%= msg %></p>
<% } %>

</body>
</html>
