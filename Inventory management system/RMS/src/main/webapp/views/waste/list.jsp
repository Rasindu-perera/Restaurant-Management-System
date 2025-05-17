<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <title>Waste Logs</title>
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
        text-align: left;
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

      .action-buttons {
        margin-top: 20px;
        text-align: center;
      }

      .action-buttons a {
        padding: 10px 15px;
        background-color: #007bff;
        color: #ffffff;
        text-decoration: none;
        border-radius: 5px;
        font-size: 0.9rem;
      }

      .action-buttons a:hover {
        background-color: #0056b3;
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Waste Logs</h1>
    </header>

    <main>
      <div class="action-buttons">
        <a href="${pageContext.request.contextPath}/waste?action=new"
          >Log New Waste</a
        >
      </div>

      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>Item</th>
              <th>Quantity</th>
              <th>Reason</th>
              <th>Date</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="log" items="${wasteLogs}">
              <tr>
                <td>${log.item.name}</td>
                <td>${log.quantity}</td>
                <td>${log.reason}</td>
                <td>${log.wasteDate}</td>
                <td>${log.notes}</td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </main>
  </body>
</html>
