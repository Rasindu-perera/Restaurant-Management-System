<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Record Daily Usage</title>
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

      .form-control {
        width: 100%;
        padding: 8px;
        font-size: 0.9rem;
        border: 1px solid #dee2e6;
        border-radius: 5px;
      }

      .form-control:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
      }

      textarea.form-control {
        resize: vertical;
      }

      button[type="submit"] {
        padding: 10px 20px;
        background-color: #007bff;
        color: #ffffff;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 1rem;
      }

      button[type="submit"]:hover {
        background-color: #0056b3;
      }

      .alert {
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid transparent;
        border-radius: 5px;
      }

      .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border-color: #f5c6cb;
      }
      main {
        padding: 60px;
      }
      .search-filter {
        margin-bottom: 20px;
      }
      .search-filter input {
        width: 100%;
        padding: 10px;
        font-size: 1rem;
        border: 1px solid #ced4da;
        border-radius: 5px;
      }
      .search-filter input:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
      }
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        color: #343a40;
      }
      h1 {
        text-align: center;
        margin-top: 60px;
        font-size: 2rem;
        color: #343a40;
      }
      input[type="text"] {
        width: 100%;
        max-width: 350px; /* Limit the width for better alignment */
        padding: 10px 15px;
        margin: 20px auto; /* Center the search bar */
        display: block; /* Ensure it behaves like a block element */
        border: 1px solid #ced4da;
        border-radius: 8px;
        font-size: 1rem;
        color: #495057;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
      }

      input[type="text"]::placeholder {
        color: #adb5bd;
      }

      input[type="text"]:focus {
        border-color: #007bff;
        outline: none;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
      }
    </style>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Record Daily Stock Usage</h1>
    </header>

    <main>
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <div class="search-filter">
        <input
          type="text"
          id="itemSearch"
          placeholder="Search items..."
          class="form-control"
        />
      </div>

      <form action="${pageContext.request.contextPath}/inventory" method="post">
        <input type="hidden" name="action" value="save-daily-usage" />

        <div class="table-container">
          <table class="usage-table">
            <thead>
              <tr>
                <th>Item</th>
                <th>Current Stock</th>
                <th>Quantity Used</th>
                <th>Notes</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${items}">
                <tr class="item-row">
                  <td>
                    ${item.name} (${item.category.name})
                    <input type="hidden" name="itemId" value="${item.id}" />
                  </td>
                  <td>${item.currentQuantity} ${item.unit}</td>
                  <td>
                    <input
                      type="number"
                      name="quantity"
                      class="form-control quantity-input"
                      min="0"
                      max="${item.currentQuantity}"
                      step="0.01"
                      value="0"
                      required
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      name="notes"
                      class="form-control"
                      placeholder="Reason for usage"
                    />
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <div class="submit-section">
          <button type="submit" class="btn btn-primary">
            Save Daily Usage Records
          </button>
        </div>
      </form>
    </main>

    <script>
      document
        .getElementById("itemSearch")
        .addEventListener("input", function (e) {
          const searchTerm = e.target.value.toLowerCase();
          document.querySelectorAll(".item-row").forEach((row) => {
            const itemText = row.cells[0].textContent.toLowerCase();
            row.style.display = itemText.includes(searchTerm) ? "" : "none";
          });
        });
    </script>
  </body>
</html>
