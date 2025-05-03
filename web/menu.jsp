<%@ page import="model.MenuItem" %>
<%@ page import="java.util.List" %>
<%
    List<MenuItem> foodItems = (List<MenuItem>) request.getAttribute("foodItems");
    List<MenuItem> drinkItems = (List<MenuItem>) request.getAttribute("drinkItems");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Menu</title>
</head>
<body>
    <h2>Restaurant Menu</h2>

    <form action="cart" method="post">
        <h3>Food Items</h3>
        <% if (foodItems != null) {
            for (MenuItem item : foodItems) {
        %>
            <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
                <img src="images/<%= item.getImageUrl() %>" alt="<%= item.getName() %>" width="100"><br>
                <strong><%= item.getName() %></strong><br>
                Rs. <%= item.getPrice() %><br>
                Quantity:
                <input type="number" name="quantity_<%= item.getId() %>" value="0" min="0" />
                <input type="hidden" name="itemIds" value="<%= item.getId() %>" />
            </div>
        <%  } } %>

        <h3>Drink Items</h3>
        <% if (drinkItems != null) {
            for (MenuItem item : drinkItems) {
        %>
            <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
                <img src="images/<%= item.getImageUrl() %>" alt="<%= item.getName() %>" width="100"><br>
                <strong><%= item.getName() %></strong><br>
                Rs. <%= item.getPrice() %><br>
                Quantity:
                <input type="number" name="quantity_<%= item.getId() %>" value="0" min="0" />
                <input type="hidden" name="itemIds" value="<%= item.getId() %>" />
            </div>
        <%  } } %>

        <br>
        <input type="submit" value="Add to Cart">
    </form>

    <br>
    <a href="cart.jsp">Go to My Cart</a>
</body>
</html>
