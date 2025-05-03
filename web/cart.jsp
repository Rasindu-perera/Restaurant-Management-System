<%-- 
    Author     : RasinduPerera
--%>
<%@ page import="model.CartItem" %>
<%@ page import="java.util.List" %>
<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    Boolean orderSent = (Boolean) session.getAttribute("orderSent");
    if (orderSent == null) orderSent = false;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Cart</title>
    <style>
        body { font-family: Arial; padding: 20px; text-align: center; }
        table {
            margin: auto;
            border-collapse: collapse;
            width: 80%;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }
        input[type=number], input[type=submit], button {
            padding: 6px 10px;
            border-radius: 5px;
            margin: 5px;
        }
        button, input[type=submit] {
            background: #4CAF50;
            color: white;
            border: none;
        }
    </style>
</head>
<body>
    <h2>My Cart</h2>
    

    <% if (cart != null && !cart.isEmpty()) { %>
        <form action="updateCart" method="post">
            <table>
                <tr>
                    <th>Item</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Action</th>
                </tr>
                <% for (CartItem item : cart) {
                    double sub = item.getQuantity() * item.getItem().getPrice();
                    total += sub;
                %>
                <tr>
                    <td><%= item.getItem().getName() %></td>
                    <td>Rs. <%= item.getItem().getPrice() %></td>
                    <td>
                        <input type="number" name="quantities" value="<%= item.getQuantity() %>" min="1" />
                        <input type="hidden" name="itemIds" value="<%= item.getItem().getId() %>" />
                    </td>
                    <td>Rs. <%= sub %></td>
                    <td>
                        <button type="submit" formaction="removeFromCart" formmethod="post" name="itemId" value="<%= item.getItem().getId() %>">Remove</button>
                    </td>
                </tr>
                <% } %>
            </table>
            <br>
            <input type="submit" value="Update Quantities" />
        </form>

        <p><strong>Total: Rs. <%= total %></strong></p>

        <form action="sendOrder" method="post">
            <input type="submit" value="Send Order" />
        </form>
    <% } else { %>
        <p>Your cart is empty.</p>
    <% } %>

    <% if (orderSent) { %>
        <form action="finalizeBill" method="post">
            <input type="submit" value="Ready to Bill" />
        </form>
    <% } %>

    <form action="menu" method="get">
        <input type="submit" value="Back to Menu" />
    </form>
</body>
</html>
