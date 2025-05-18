<%-- 
    Document   : waiters
    Created on : May 4, 2025, 12:03:01 PM
    Author     : RasinduPerera
--%>

<%@ page import="java.util.List" %>
<%@ page import="model.Waiter" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="admin_header.jsp" />

<h2 class="mt-4">Manage Waiters</h2>
<a href="add_waiter.jsp" class="btn btn-success mb-3">Add New Waiter</a>

<table class="table table-bordered">
    <thead>
        <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
    </thead>
    <tbody>
        <% 
        List<Waiter> waiters = (List<Waiter>) request.getAttribute("waiters");
        if (waiters != null && !waiters.isEmpty()) {
            for (Waiter w : waiters) {
        %>
        <tr>
            <td><%= w.getWaiterId() %></td>
            <td><%= w.getName() %></td>
            <td>
      
                <a href="delete_waiter?id=<%= w.getWaiterId() %>" class="btn btn-danger btn-sm">Delete</a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="3" class="text-center text-danger">No waiters found.</td>
        </tr>
        <%
        }
        %>
    </tbody>
</table>

<jsp:include page="admin_footer.jsp" />
