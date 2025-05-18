<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
  <head>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />

    <title>Register - Restaurant Management</title>
  </head>
  <body>
    <div class="register-container">
      <h2>Register New Account</h2>
      <c:if test="${not empty error}">
        <div class="error">${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="success">${success}</div>
      </c:if>
      <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
          <label for="username">Username:</label>
          <input type="text" id="username" name="username" required />
        </div>
        <div class="form-group">
          <label for="fullName">Full Name:</label>
          <input type="text" id="fullName" name="fullName" required />
        </div>
        <div class="form-group">
          <label for="email">Email:</label>
          <input type="email" id="email" name="email" required />
        </div>
        <div class="form-group">
          <label for="phone">Phone:</label>
          <input type="tel" id="phone" name="phone" />
        </div>
        <div class="form-group">
          <label for="password">Password:</label>
          <input
            type="password"
            id="password"
            name="password"
            required
            minlength="8"
          />
        </div>
        <div class="form-group">
          <label for="confirmPassword">Confirm Password:</label>
          <input
            type="password"
            id="confirmPassword"
            name="confirmPassword"
            required
            minlength="8"
          />
        </div>
        <button type="submit">Register</button>
      </form>
      <p style="text-align: center; margin-top: 1rem">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login">Login here</a>
      </p>
    </div>
  </body>
</html>
