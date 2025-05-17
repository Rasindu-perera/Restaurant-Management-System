<%-- 
    Document   : Kitchen
    Created on : May 15, 2025, 1:42:22?AM
    Author     : MASTER LK
--%>

<%@ page import="java.util.*, model.Order" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Kitchen Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f9f9f9;
            padding: 30px;
        }

        h2 {
            text-align: center;
            color: #444;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        form {
            margin: 0;
        }

        .btn {
            padding: 8px 14px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #218838;
        }

        .no-orders {
            text-align: center;
            color: #999;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<h2>Orders in Kitchen</h2>

<%
    if (orders == null || orders.isEmpty()) {
%>
    <div class="no-orders">No orders to show.</div>
<%
    } else {
%>
    <table>
        <tr>
            <th>Order ID</th>
            <th>Table No.</th>
            <th>Item</th>
            <th>Quantity</th>
            <th>Status</th>
            <th>Mark Ready</th>
        </tr>
        <%
            for (Order o : orders) {
        %>
        <tr>
            <td><%= o.getId() %></td>
            <td><%= o.getTableNumber() %></td>
            <td><%= o.getItemName() %></td>
            <td><%= o.getQuantity() %></td>
            <td><%= o.getStatus() %></td>
            <td>
                <form method="post" action="MarkReadyServlet">
                    <input type="hidden" name="orderId" value="<%= o.getId() %>" />
                    <input type="submit" class="btn" value="Ready" />
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

</body>
</html>