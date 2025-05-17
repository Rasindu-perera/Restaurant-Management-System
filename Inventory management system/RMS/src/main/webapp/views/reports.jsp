<%@ page import="java.sql.ResultSet" %> <% ResultSet reportData = (ResultSet)
request.getAttribute("reportData"); String reportType = (String)
request.getAttribute("reportType"); %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <title>Reports</title>
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

      .report-links {
        margin-top: 20px;
        display: flex;
        gap: 10px;
        justify-content: center;
      }

      .report-links a {
        padding: 10px 15px;
        background-color: #007bff;
        color: #ffffff;
        text-decoration: none;
        border-radius: 5px;
        font-size: 0.9rem;
      }

      .report-links a:hover {
        background-color: #0056b3;
      }

      h1 {
        text-align: center;
        margin-top: 20px;
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>
        <%= reportType.substring(0, 1).toUpperCase() + reportType.substring(1)
        %> Report
      </h1>
    </header>

    <main>
      <div class="table-container">
        <table>
          <thead>
            <tr>
              <% if (reportType.equals("daily")) { %>
              <th>Date</th>
              <th>Item Name</th>
              <th>Total Quantity Used</th>
              <% } else if (reportType.equals("weekly")) { %>
              <th>Year</th>
              <th>Week</th>
              <th>Item Name</th>
              <th>Total Quantity Used</th>
              <% } else if (reportType.equals("monthly")) { %>
              <th>Year</th>
              <th>Month</th>
              <th>Item Name</th>
              <th>Total Quantity Used</th>
              <% } else if (reportType.equals("purchases")) { %>
              <th>Year</th>
              <th>Month</th>
              <th>Item Name</th>
              <th>Total Quantity Purchased</th>
              <th>Total Cost</th>
              <% } %>
            </tr>
          </thead>
          <tbody>
            <% while (reportData.next()) { %>
            <tr>
              <% if (reportType.equals("daily")) { %>
              <td><%= reportData.getString("date") %></td>
              <td><%= reportData.getString("item_name") %></td>
              <td><%= reportData.getDouble("total_quantity_used") %></td>
              <% } else if (reportType.equals("weekly")) { %>
              <td><%= reportData.getInt("year") %></td>
              <td><%= reportData.getInt("week") %></td>
              <td><%= reportData.getString("item_name") %></td>
              <td><%= reportData.getDouble("total_quantity_used") %></td>
              <% } else if (reportType.equals("monthly")) { %>
              <td><%= reportData.getInt("year") %></td>
              <td><%= reportData.getInt("month") %></td>
              <td><%= reportData.getString("item_name") %></td>
              <td><%= reportData.getDouble("total_quantity_used") %></td>
              <% } else if (reportType.equals("purchases")) { %>
              <td><%= reportData.getInt("year") %></td>
              <td><%= reportData.getInt("month") %></td>
              <td><%= reportData.getString("item_name") %></td>
              <td><%= reportData.getDouble("total_quantity_purchased") %></td>
              <td><%= reportData.getDouble("total_cost") %></td>
              <% } %>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <div class="report-links">
        <a href="${pageContext.request.contextPath}/reports?type=daily"
          >Daily Report</a
        >
        <a href="${pageContext.request.contextPath}/reports?type=weekly"
          >Weekly Report</a
        >
        <a href="${pageContext.request.contextPath}/reports?type=monthly"
          >Monthly Report</a
        >
        <a href="${pageContext.request.contextPath}/reports?type=purchases"
          >Purchase Trends Report</a
        >
      </div>
    </main>
  </body>
</html>
