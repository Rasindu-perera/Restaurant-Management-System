<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <title>Inventory Management</title>
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

      .badge {
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 0.8rem;
        color: #ffffff;
      }

      .badge-danger {
        background-color: #dc3545;
      }

      .badge-success {
        background-color: #28a745;
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Inventory Management</h1>
    </header>

    <main>
      <!-- Search Filter -->
      <div class="search-panel">
        <input
          type="text"
          id="inventorySearch"
          placeholder="Search items..."
          class="form-control"
        />
      </div>

      <div class="action-buttons">
        <a
          href="${pageContext.request.contextPath}/inventory?action=add-new-item"
          class="btn btn-primary"
          >Add New Item</a
        >
      </div>

      <div class="table-container">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Quantity</th>
              <th>Unit</th>
              <th>Min Stock</th>
              <th>Status</th>
              <th>Location</th>
              <th>Cost/Unit</th>
              <th>Total Value</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="inventoryTable">
            <c:forEach var="item" items="${items}">
              <tr
                class="inventory-row ${item.currentQuantity <= item.minStockLevel ? 'low-stock' : ''}"
              >
                <td>${item.id}</td>
                <td>${item.name}</td>
                <td>${item.category.name}</td>
                <td>${item.currentQuantity}</td>
                <td>${item.unit}</td>
                <td>${item.minStockLevel}</td>
                <td>
                  <c:choose>
                    <c:when
                      test="${item.minStockLevel != null && item.currentQuantity <= item.minStockLevel}"
                    >
                      <span class="badge badge-danger">Low Stock</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-success">In Stock</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>${item.storageLocation}</td>
                <td>$${item.costPerUnit}</td>
                <td>$${item.costPerUnit * item.currentQuantity}</td>
                <td>
                  <div class="btn-group">
                    <a
                      href="${pageContext.request.contextPath}/inventory?action=edit&id=${item.id}"
                      class="btn btn-sm btn-primary"
                      >Edit</a
                    >
                  </div>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </main>

    <!-- JavaScript for Search Functionality -->
    <script>
      document
        .getElementById("inventorySearch")
        .addEventListener("input", function (e) {
          const searchTerm = e.target.value.toLowerCase();
          document.querySelectorAll(".inventory-row").forEach((row) => {
            const itemName = row.cells[1].textContent.toLowerCase();
            const categoryName = row.cells[2].textContent.toLowerCase();
            row.style.display =
              itemName.includes(searchTerm) || categoryName.includes(searchTerm)
                ? ""
                : "none";
          });
        });
    </script>
  </body>
</html>
