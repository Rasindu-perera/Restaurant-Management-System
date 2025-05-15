<%-- 
    Document   : Kitchen
    Created on : May 15, 2025, 1:42:22?AM
    Author     : MASTER LK
--%>

<%@ page import="model.Order, java.util.List" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders != null) {
        for (Order o : orders) {
%>
    <div>
        <p>Bill No: <%= o.getBillNumber() %> | Item: <%= o.getItemName() %> | Qty: <%= o.getQuantity() %></p>
        <form action="mark-ready" method="post">
            <input type="hidden" name="order_id" value="<%= o.getOrderId() %>">
            <input type="submit" value="Mark Ready">
        </form>
    </div>
<%
        }
    } else {
%>
    <p>No orders found</p>
<%
    }
%>