<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Stock Usage History</title>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Stock Usage History</h1>

      <a
        href="${pageContext.request.contextPath}/inventory?action=daily-usage"
        class="btn btn-success"
        >Record New Usage</a
      >
    </header>

    <main>
      <div class="date-selector">
        <form
          method="get"
          action="${pageContext.request.contextPath}/inventory"
        >
          <input type="hidden" name="action" value="usage-history" />
          <label for="date">Select Date:</label>
          <input
            type="date"
            id="date"
            name="date"
            value="<fmt:formatDate value='${selectedDate}' pattern='yyyy-MM-dd' />"
          />
          <button type="submit" class="btn btn-sm btn-primary">View</button>
        </form>
      </div>

      <table class="usage-table">
        <thead>
          <tr>
            <th>Date</th>
            <th>Item</th>
            <th>Quantity Used</th>
            <th>Recorded By</th>
            <th>Notes</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="log" items="${usageLogs}">
            <tr>
              <td>
                <fmt:formatDate value="${log.usageDate}" pattern="yyyy-MM-dd" />
              </td>
              <td>${log.item.name} (${log.item.unit})</td>
              <td>${log.quantityUsed}</td>
              <td>${log.recordedBy.fullName}</td>
              <td>${log.notes}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </main>
  </body>
</html>
