<%-- 
    Document   : orderForm
    Created on : May 17, 2025, 1:27:29 PM
    Author     : MASTER LK
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>New Order - Hotel Management System</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f2f2;
            padding: 40px;
        }

        .container {
            max-width: 450px;
            margin: auto;
            background: #fff;
            padding: 25px;
            box-shadow: 0 0 12px rgba(0,0,0,0.15);
            border-radius: 10px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 10px 12px;
            margin: 10px 0 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        input[type="submit"] {
            width: 100%;
            background-color: #28a745;
            border: none;
            padding: 12px;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }

        .message {
            text-align: center;
            color: #28a745;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Place New Order</h2>
    <form method="post" action="AddOrderServlet">
        <label>Table Number:</label>
        <input type="number" name="tableNumber" required>

        <label>Item Name:</label>
        <input type="text" name="itemName" required>

        <label>Quantity:</label>
        <input type="number" name="quantity" required>

        <input type="submit" value="Add Order">
    </form>

    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if ("true".equals(success)) {
    %>
        <p class="message">Order added successfully!</p>
    <%
        } else if ("true".equals(error)) {
    %>
        <p class="error">Failed to add order. Please try again.</p>
    <%
        }
    %>
</div>
</body>
</html>