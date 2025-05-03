<%-- 
    Author     : RasinduPerera
--%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Final Bill</title>
    <style>
        body { font-family: Arial; padding: 40px; text-align: center; }
        ul {
            list-style: none;
            padding: 0;
            width: 300px;
            margin: 0 auto;
        }
        li {
            padding: 10px;
            border-bottom: 1px dashed #aaa;
        }
    </style>
</head>
<body>
    <h2>Final Bill</h2>
    <% if (cart != null && !cart.isEmpty()) { %>
        <ul>
        <% for (CartItem item : cart) {
            double sub = item.getQuantity() * item.getItem().getPrice();
            total += sub;
        %>
            <li><%= item.getItem().getName() %> x <%= item.getQuantity() %> = Rs. <%= sub %></li>
        <% } %>
        </ul>
        <p><strong>Total Price: Rs. <%= total %></strong></p>
        <p>Thank you for dining with us!</p>
    <% } else { %>
        <p>No items to display in the bill.</p>
    <% } %>
</body>
</html>
