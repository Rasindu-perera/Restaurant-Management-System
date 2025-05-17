<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
</head>
    <title>Login - Restaurant Management</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
  </head>
  <body>
    <div class="login-container">
      <h2>Restaurant Management System</h2>
      <c:if test="${not empty error}">
        <div class="error">${error}</div>
      </c:if>
      <c:if test="${not empty expired}">
        <div class="error">Your session has expired. Please login again.</div>
      </c:if>
      <c:if test="${not empty verified}">
        <div class="success">
          Email verified successfully! You can now login.
        </div>
      </c:if>
      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
          <label for="username">Username:</label>
          <input type="text" id="username" name="username" required />
        </div>
        <div class="form-group">
          <label for="password">Password:</label>
          <input type="password" id="password" name="password" required />
        </div>
        <button type="submit">Login</button>
      </form>
      <!--<div class="register-link">
    Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
  </div>-->
    </div>
  </body>
</html>
