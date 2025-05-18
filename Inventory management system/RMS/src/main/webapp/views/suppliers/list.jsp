<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <title>Supplier List</title>
    <style>
      /* Style for Edit and Delete links */
      .action-link {
        padding: 5px 10px;
        font-size: 0.9rem;
        border-radius: 5px;
        text-decoration: none;
        color: #ffffff;
        margin-right: 5px;
      }

      .action-link.edit {
        background-color: #007bff; /* Blue for Edit */
      }

      .action-link.edit:hover {
        background-color: #0056b3; /* Darker blue on hover */
      }

      .action-link.delete {
        background-color: #dc3545; /* Red for Delete */
      }

      .action-link.delete:hover {
        background-color: #a71d2a; /* Darker red on hover */
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Supplier List</h1>
    </header>

    <main>
      <a
        href="${pageContext.request.contextPath}/suppliers?action=new"
        class="btn btn-primary"
        >Add New Supplier</a
      >
      <table border="1">
        <thead>
          <tr>
            <th>Name</th>
            <th>Contact Person</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="supplier" items="${suppliers}">
            <tr>
              <td>${supplier.name}</td>
              <td>${supplier.contactPerson}</td>
              <td>${supplier.phone}</td>
              <td>${supplier.email}</td>
              <td>
                <a
                  href="${pageContext.request.contextPath}/suppliers?action=edit&id=${supplier.id}"
                  class="action-link edit"
                  >Edit</a
                >
                <a
                  href="${pageContext.request.contextPath}/suppliers?action=delete&id=${supplier.id}"
                  class="action-link delete"
                  onclick="return confirm('Are you sure you want to delete this supplier?');"
                  >Delete</a
                >
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </main>
  </body>
</html>
