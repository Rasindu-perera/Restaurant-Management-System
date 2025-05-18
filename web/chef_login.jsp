<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chef Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
            background-color: #f5f5f5;
        }
        .login-container {
            display: inline-block;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 12px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        input[type=text] {
            padding: 10px;
            margin: 10px 0;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type=submit] {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
        }
        input[type=submit]:hover {
            background-color: #45a049;
        }
        .error {
            color: #ff0000;
            margin-top: 10px;
            font-size: 14px;
        }
        .success {
            color: #4CAF50;
            margin-top: 10px;
            font-size: 14px;
        }
        .role-selector {
            margin-bottom: 20px;
        }
        .role-selector a {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            text-decoration: none;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        .role-selector a.active {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="role-selector">
        <a href="login.jsp">Waiter Login</a>
        <a href="chef_login.jsp" class="active">Chef Login</a>
    </div>
    
    <div class="login-container">
        <h2>Chef Login</h2>
        <form action="chef/login" method="post">
            <input type="text" name="chefId" placeholder="Chef ID" required><br>
            <input type="submit" value="Login">
        </form>
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        <% String message = (String) request.getAttribute("message"); %>
        <% if (message != null) { %>
            <p class="success"><%= message %></p>
        <% } %>
    </div>
</body>
</html> 