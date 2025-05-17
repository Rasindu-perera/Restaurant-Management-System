<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <%@ include file="/includes/navbar.jsp" %>

  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Dashboard - Restaurant Management System</title>
  </head>
  <body>
    <main class="dashboard-container">
      <h2 class="dashboard-title">Welcome to the Dashboard</h2>
      <div class="dashboard-grid">
        <div class="dashboard-card">
          <h3>Inventory Management</h3>
          <p>View and manage stock items.</p>
          <a href="${pageContext.request.contextPath}/inventory"
            >Go to Inventory</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Supplier Management</h3>
          <p>View and manage suppliers.</p>
          <a href="${pageContext.request.contextPath}/suppliers"
            >Go to Suppliers</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Purchases</h3>
          <p>Manage and record purchases.</p>
          <a href="${pageContext.request.contextPath}/purchases"
            >Go to Purchases</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Stock Usage</h3>
          <p>Record and view stock usage.</p>
          <a
            href="${pageContext.request.contextPath}/inventory?action=daily-usage"
            >Record Usage</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Usage History</h3>
          <p>View past stock usage records.</p>
          <a
            href="${pageContext.request.contextPath}/inventory?action=usage-history"
            >View Usage History</a
          >
        </div>
        <c:if test="${sessionScope.user.role == 'ADMIN'}">
          <div class="dashboard-card">
            <h3>User Management</h3>
            <p>Manage user accounts and roles.</p>
            <a href="${pageContext.request.contextPath}/admin/users">
              Go to Users</a
            >
          </div>
        </c:if>

        <div class="dashboard-card">
          <h3>Waste Management</h3>
          <p>Record and view waste logs.</p>
          <a href="${pageContext.request.contextPath}/waste"
            >Go to Waste Logs</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Reports</h3>
          <p>Generate and view reports.</p>
          <a href="${pageContext.request.contextPath}/reports?type=daily"
            >Go to Reports</a
          >
        </div>
        <div class="dashboard-card">
          <h3>Purchase History</h3>
          <p>View past purchase records.</p>
          <a
            href="${pageContext.request.contextPath}/purchases?action=purchase-history"
            >View Purchase History</a
          >
        </div>
      </div>
    </main>
  </body>
</html>
