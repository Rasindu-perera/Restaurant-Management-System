<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Record Purchase</title>
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

      main {
        padding: 40px;
        background-color: #f8f9fa;
      }
      /* General Styles */
      body {
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        box-sizing: border-box; /* Ensure padding is included in the total width */
      }

      /* Center all headers */
      h1,
      h2,
      h3,
      h4,
      h5,
      h6 {
        text-align: center;
        margin-top: 60px;
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
      <h1>Record Purchase</h1>
    </header>

    <main>
      <!-- Search Filter -->
      <div class="search-filter">
        <input
          type="text"
          id="itemSearch"
          placeholder="Search items..."
          class="form-control"
        />
      </div>

      <form action="${pageContext.request.contextPath}/purchases" method="post">
        <div class="table-container">
          <table>
            <thead>
              <tr>
                <th>Select</th>
                <th>Item Name</th>
                <th>Category</th>
                <th>Supplier</th>
                <th>Quantity</th>
                <th>Unit</th>
                <th>Unit Price</th>
                <th>Expiry Date</th>
                <th>Batch Number</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="item" items="${items}">
                <tr class="item-row">
                  <td>
                    <input
                      type="checkbox"
                      name="selectedItems"
                      value="${item.id}"
                    />
                  </td>
                  <td>${item.name}</td>
                  <td>${item.category.name}</td>
                  <td>
                    <select name="supplierId" class="form-control" required>
                      <c:forEach var="supplier" items="${suppliers}">
                        <option value="${supplier.id}">${supplier.name}</option>
                      </c:forEach>
                    </select>
                  </td>
                  <td>
                    <input
                      type="number"
                      name="quantity_${item.id}"
                      step="0.01"
                      min="0"
                      class="form-control"
                    />
                  </td>
                  <td>${item.unit}</td>
                  <td>
                    <input
                      type="number"
                      name="unitPrice_${item.id}"
                      step="0.01"
                      min="0"
                      class="form-control"
                    />
                  </td>
                  <td>
                    <input
                      type="date"
                      name="expiryDate_${item.id}"
                      class="form-control"
                    />
                  </td>
                  <td>
                    <input
                      type="text"
                      name="batchNumber_${item.id}"
                      class="form-control"
                    />
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
        <div>
          <label for="notes">Notes:</label>
          <textarea
            id="notes"
            name="notes"
            rows="4"
            class="form-control"
          ></textarea>
        </div>
        <button type="submit">Save Purchase</button>
      </form>
    </main>

    <!-- JavaScript for Search Functionality -->
    <script>
      document
        .getElementById("itemSearch")
        .addEventListener("input", function (e) {
          const searchTerm = e.target.value.toLowerCase();
          document.querySelectorAll(".item-row").forEach((row) => {
            const itemText = row.cells[1].textContent.toLowerCase();
            row.style.display = itemText.includes(searchTerm) ? "" : "none";
          });
        });
    </script>
  </body>
</html>
