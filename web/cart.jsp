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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cart</title>
    <link rel="stylesheet" type="text/css" href="StyleCss/cart.css">
    

</head>
<body>
    <div class="container">
            <div class="cart-header"><h2>My Cart</h2></div>
        
        <% if (cart != null && !cart.isEmpty()) { %>
        <form action="updateCart" method="post">
            <div class="cart-box">
                <table class="cart-table">
                    <tr>
                        <th><div class="text1">Item</div></th>
                        <th><div class="text1">Price</div></th>
                        <th><div class="text1">Quantity</div></th>
                        <th><div class="text1">Subtotal</div></th>
                        <th><div class="text1">Action</div></th>
                    </tr>
                    <% for (CartItem item : cart) {
                        double sub = item.getQuantity() * item.getItem().getPrice();
                        total += sub;
                    %>
                    <tr>
                        <td class="datacell">
                            <div class="item"><%= item.getItem().getName() %></div>
                        </td>
                        <td class="datacell">
                            <div class="price">Rs. <%= item.getItem().getPrice() %></div>
                        </td>
                        <td class="datacell">
                            <input type="number" name="quantities" value="<%= item.getQuantity() %>" min="1" class="input-box" />
                            <input type="hidden" name="itemIds" value="<%= item.getItem().getId() %>" />
                        </td>
                        <td class="datacell">
                            <div class="subtotal">Rs. <%= sub %></div>
                        </td>
                        <td class="datacell">
                            <button type="submit" formaction="removeFromCart" formmethod="post" name="itemId" value="<%= item.getItem().getId() %>" class="remove-button">Remove</button>
                        </td>
                    </tr>
                    
                    <% } %>
                </table>
                
            </div>
            <br>
            <div style="text-align: center;">
                <input type="submit" value="Update Quantities" class="update-button" />
            </div>
        </form>
        <br><br>
        <div class="total-box">
            <p><strong>Total: Rs.</strong><span class="total"><%= total %></span></p>
        </div>
        <table class="button-form">
            <tr>
                <td>
                    <form action="sendOrder" method="post">
                        <input type="submit" value="Send Order" class="button1"/>
                    </form>
        <% } else { %>
                    <p style="color: rgb(65, 123, 6); text-align: center; font-weight: bold; border: 3px solid rgb(65, 123, 6); border-radius: 50px; background-color: aliceblue;">Your cart is empty.</p>
        <% } %>
                </td>
                <td>
                    <% if (orderSent) { %>
                        <form action="finalizeBill" method="post">
                            <input type="submit" value="Ready to Bill" class="button2" />
                        </form>
                    <% } %>
                </td>
                <td>
                    <form action="menu" method="get">
                        <input type="submit" value="Back to Menu" class="button3"/>
                    </form>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>