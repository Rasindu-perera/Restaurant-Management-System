<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Restaurant System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            background-image: url('../images/restaurant-background.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 0;
        }
        .login-container {
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 450px;
            padding: 35px;
        }
        .logo-container {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo-container h3 {
            color: #2c3e50;
            font-weight: 700;
        }
        .error-alert {
            color: #fff;
            background-color: #dc3545;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            text-align: center;
        }
        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
        }
        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
        }
        .btn-primary:hover {
            background-color: #3a5ecc;
            border-color: #3a5ecc;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo-container">
            <h3>Restaurant Admin</h3>
            <p class="text-muted">Enter your credentials to access admin panel</p>
        </div>

        <%
        String errorMsg = (String) request.getAttribute("error");
        if (errorMsg != null && !errorMsg.isEmpty()) {
        %>
        <div class="error-alert">
            <i class="fas fa-exclamation-triangle me-2"></i> <%= errorMsg %>
        </div>
        <% } %>

        

        <form action="${pageContext.request.contextPath}/admin/login" method="post">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
                
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="fas fa-sign-in-alt me-2"></i> Login
                </button>
            </div>
        </form>
        
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/" class="text-decoration-none">
                Back to Restaurant
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>