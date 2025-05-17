<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Purchase List</title>
  </head>
  <body>
    <%@ include file="/includes/navbar.jsp" %>

    <header>
      <h1>Purchase List</h1>
    </header>

    <main>
      <table border="1">
        <thead>
          <tr>
            <th>Purchase ID</th>
            <th>Purchase Date</th>
            <th>Total Cost</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="purchase" items="${purchases}">
            <tr>
              <td>${purchase.id}</td>
              <td>${purchase.purchaseDate}</td>
              <td>$${purchase.totalCost}</td>
              <td>
                <a
                  href="${pageContext.request.contextPath}/purchases?action=purchase-history&id=${purchase.id}"
                  >View Details</a
                >
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </main>
  </body>
</html>
