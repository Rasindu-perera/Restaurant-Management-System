<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Log Waste</title>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <h1>Log Waste</h1>
    <form action="${pageContext.request.contextPath}/waste" method="post">
      <input type="hidden" name="action" value="save" />
      <label for="item_id">Item:</label>
      <select name="item_id" id="item_id" required>
        <c:forEach var="item" items="${items}">
          <option value="${item.id}">${item.name}</option>
        </c:forEach>
      </select>
      <br />
      <label for="quantity">Quantity:</label>
      <input type="number" name="quantity" id="quantity" step="0.01" required />
      <br />
      <label for="reason">Reason:</label>
      <select name="reason" id="reason" required>
        <option value="SPOILAGE">Spoilage</option>
        <option value="OVER_PREPARATION">Over Preparation</option>
        <option value="ACCIDENT">Accident</option>
        <option value="OTHER">Other</option>
      </select>
      <br />
      <label for="notes">Notes:</label>
      <textarea name="notes" id="notes"></textarea>
      <br />
      <button type="submit">Log Waste</button>
    </form>
  </body>
</html>
