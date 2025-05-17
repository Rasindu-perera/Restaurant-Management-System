<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <title>User Management</title>
    <style>
      /* Add consistent styles for buttons and table */
      .btn {
        padding: 5px 10px;
        font-size: 0.9rem;
        border-radius: 5px;
        text-decoration: none;
        color: #ffffff;
        margin-right: 5px;
      }

      .btn-primary {
        background-color: #007bff;
      }

      .btn-primary:hover {
        background-color: #0056b3;
      }

      .btn-danger {
        background-color: #dc3545;
      }

      .btn-danger:hover {
        background-color: #a71d2a;
      }

      .table-container {
        overflow-x: auto; /* Add horizontal scroll for the table */
        margin-top: 20px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        margin: 1rem 0;
        background-color: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      table th,
      table td {
        padding: 0.75rem;
        text-align: center;
        border: 1px solid #dee2e6;
        font-size: 0.9rem;
      }

      table thead th {
        background-color: #007bff;
        color: #ffffff;
        text-transform: uppercase;
        font-weight: bold;
        font-size: 0.85rem;
      }

      table tbody tr:nth-child(even) {
        background-color: #f8f9fa;
      }

      table tbody tr:hover {
        background-color: #e9ecef;
      }

      h1 {
        text-align: center;
        margin-top: 20px;
      }

      .add-user {
        display: inline-block;
        margin: 20px auto;
        padding: 10px 20px;
        background-color: #28a745;
        color: #ffffff;
        text-decoration: none;
        border-radius: 5px;
        text-align: center;
      }

      .add-user:hover {
        background-color: #218838;
      }

      .btn-group {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 5px;
      }

      .btn-group .btn {
        padding: 5px 10px;
        font-size: 0.8rem;
        border-radius: 3px;
        text-decoration: none;
        text-align: center;
        display: inline-block;
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <h1>User Management</h1>
    <a
      href="${pageContext.request.contextPath}/admin/users?action=new"
      class="add-user"
      >Add New User</a
    >

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="user" items="${users}">
            <tr>
              <td>${user.id}</td>
              <td>${user.username}</td>
              <td>${user.role}</td>
              <td>
                <div class="btn-group">
                  <a
                    href="${pageContext.request.contextPath}/admin/users?action=edit&id=${user.id}"
                    class="btn btn-primary"
                    >Edit</a
                  >
                  <form
                    action="${pageContext.request.contextPath}/admin/users"
                    method="post"
                    style="display: inline"
                  >
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="id" value="${user.id}" />
                    <button type="submit" class="btn btn-danger">Delete</button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </body>
</html>
