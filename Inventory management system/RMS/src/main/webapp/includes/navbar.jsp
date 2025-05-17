<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <!-- Include Bootstrap CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container-fluid">
        <a
          class="navbar-brand"
          href="${pageContext.request.contextPath}/dashboard"
          >RMS</a
        >
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
          aria-controls="navbarNav"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav me-auto">
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/inventory"
                >Inventory</a
              >
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/suppliers"
                >Suppliers</a
              >
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/purchases"
                >Purchases</a
              >
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/waste"
                >Waste Logs</a
              >
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/reports?type=daily"
                >Reports</a
              >
            </li>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
              <li class="nav-item">
                <a
                  class="nav-link"
                  href="${pageContext.request.contextPath}/admin/users"
                  >User Management</a
                >
              </li>
            </c:if>
          </ul>
          <ul class="navbar-nav">
            <li class="nav-item">
              <a
                class="nav-link"
                href="${pageContext.request.contextPath}/logout"
                >Logout</a
              >
            </li>
          </ul>
        </div>
      </div>
    </nav>
  </body>
</html>
