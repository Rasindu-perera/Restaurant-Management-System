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
        <p><strong>Total: Rs. <%= total %></strong></p>
        <p>Thank you for dining with us!</p>
    <% } else { %>
        <p>No items to display in the bill.</p>
    <% } %>
</body>
</html>
