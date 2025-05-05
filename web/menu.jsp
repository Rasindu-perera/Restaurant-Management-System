<%-- 
    Author     : RasinduPerera
--%>
<%@ page import="java.util.*" %>
<%@ page import="model.MenuItem" %>
<%
    Map<String, List<MenuItem>> categorizedMenu = (Map<String, List<MenuItem>>) request.getAttribute("categorizedMenu");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Menu</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 20px; }
        .item-box {
            display: inline-block;
            border: 1px solid #ccc;
            padding: 10px;
            margin: 8px;
            width: 180px;
            background: #fdfdfd;
            border-radius: 10px;
        }
        .item-box img {
            width: 100px; height: 100px;
        }
        input[type=number] {
            width: 50px;
        }
        input[type=submit], a {
            padding: 10px 20px;
            margin: 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>Restaurant Menu</h2>

    <form action="cart" method="post">
        <% if (categorizedMenu != null) {
            for (Map.Entry<String, List<MenuItem>> entry : categorizedMenu.entrySet()) {
                String categoryName = entry.getKey();
                List<MenuItem> items = entry.getValue();
        %>
            <h3><%= categoryName %></h3>
            <% for (MenuItem item : items) { %>
                <div class="item-box">
                    <img src="images/<%= item.getImageUrl() %>" alt="<%= item.getName() %>">
                    <div><strong><%= item.getName() %></strong></div>
                    <div>Rs. <%= item.getPrice() %></div>
                    <div>
                        Q: <input type="number" name="quantity_<%= item.getId() %>" value="0" min="0" />
                        <input type="hidden" name="itemIds" value="<%= item.getId() %>" />
                    </div>
                </div>
            <% } %>
        <% } } %>

        <div>
            <input type="submit" value="Add to Cart">
        </div>
    </form>

    <a href="cart.jsp">Go to My Cart</a>
</body>
</html>
