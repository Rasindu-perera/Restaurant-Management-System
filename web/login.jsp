<%-- 
    Author     : RasinduPerera
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Waiter Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
        }
        form {
            display: inline-block;
            padding: 30px;
            border: 1px solid #ccc;
            border-radius: 12px;
            background-color: #f9f9f9;
        }
        input[type=text], input[type=submit] {
            padding: 10px;
            margin: 10px 0;
            width: 100%;
        }
        input[type=submit] {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>Login</h2>
    <form action="login" method="post">
        Waiter ID: <input type="text" name="waiterId" required><br>
        Table ID: <input type="text" name="tableId" required><br>
        <input type="submit" value="Login">
    </form>
    <% String msg = (String) request.getAttribute("message"); %>
    <% if (msg != null) { %>
        <p style="color:green;"><%= msg %></p>
    <% } %>
</body>
</html>
