<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant System Login</title>
    <link rel="apple-touch-icon" sizes="180x180" type="image/png" href="images/logo/favicon-32x32.png">
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
            background-color: #f5f5f5;
        }
        .logo {
            max-width: 150px;
            margin-bottom: 15px;
        }
        .login-container {
            display: inline-block;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 12px;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-width: 400px;
            width: 100%;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        input[type=text] {
            padding: 12px;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        input[type=submit] {
            background-color: #4CAF50;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            margin-top: 10px;
            transition: background-color 0.3s;
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
            margin-bottom: 25px;
        }
        .role-selector a {
            display: inline-block;
            padding: 12px 25px;
            margin: 0 10px;
            text-decoration: none;
            color: #666;
            border: 1px solid #ddd;
            border-radius: 6px;
            background-color: #f9f9f9;
            transition: all 0.3s;
            font-weight: bold;
        }
        .role-selector a.active {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }
        .role-selector a:hover:not(.active) {
            background-color: #e9e9e9;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <img src="images/restlogo.png" alt="Restaurant Logo" class="logo">
        
        <div class="role-selector">
            <a href="login.jsp" class="active">Waiter Login</a>
            <a href="chef_login.jsp">Chef Login</a>
        </div>
        
        <h2>Waiter Login</h2>
        
        <form action="login" method="post">
            <div class="form-group">
                <label for="waiterId">Waiter ID:</label>
                <input type="text" name="waiterId" id="waiterId" placeholder="Enter your waiter ID" required>
            </div>
            
            <div class="form-group">
                <label for="tableId">Table ID:</label>
                <input type="text" name="tableId" id="tableId" placeholder="Enter table ID" required>
            </div>
            
            <input type="submit" value="Login">
        </form>
        
        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <p class="error"><%= error %></p>
        <% } %>
        
        <% 
           String message = (String) request.getAttribute("message");
           if (message == null) {
               message = (String) request.getAttribute("msg");
           }
        %>
        <% if (message != null) { %>
            <p class="success"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
