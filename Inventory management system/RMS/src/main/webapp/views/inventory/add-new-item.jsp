<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Add New Inventory Item</title>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Add New Inventory Item</h1>
    </header>

    <main>
      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>
      <form action="${pageContext.request.contextPath}/inventory" method="post">
        <input type="hidden" name="action" value="add-new-item" />

        <div class="form-group">
          <label for="name">Item Name:</label>
          <input type="text" id="name" name="name" required />
        </div>

        <div class="form-group">
          <label for="category">Category:</label>
          <select id="category" name="category" required>
            <c:forEach var="category" items="${categories}">
              <option value="${category.id}">${category.name}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label for="minStock">Minimum Stock Level:</label>
          <input
            type="number"
            id="minStock"
            name="minStock"
            step="0.01"
            required
          />
        </div>

        <div class="form-group">
          <label for="location">Storage Location:</label>
          <input type="text" id="location" name="location" required />
        </div>

        <div class="form-group">
          <label for="unit">Unit:</label>
          <select id="unit" name="unit" required>
            <option value="kg">kg</option>
            <option value="g">g</option>
            <option value="lbs">lbs</option>
            <option value="oz">oz</option>
            <option value="l">liter</option>
            <option value="ml">ml</option>
            <option value="unit">unit</option>
          </select>
        </div>

        <button type="submit" class="btn btn-primary">Add Item</button>
      </form>
    </main>
  </body>
</html>
