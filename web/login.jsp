<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Waiter Login</title>
    <link rel="apple-touch-icon" sizes="180x180" type="image/png" href="images/logo/favicon-32x32.png">
    <link rel="stylesheet" href="StyleCss/login.css">
</head>
<body>
    <form action="login" method="post">
       <img src="images/restlogo.png" alt="logo" class="logo">
            <% String msg = (String) request.getAttribute("message"); %>
            <% if (msg != null) { %>
                <p style="color:green; text-align: center;"><%= msg %></p>
            <% } %>
            <div class="login-box ">
                <h2>Login</h2>
            </div>
            <br><br>
            <div class="div1">
              <label for="waiterId" class="form-label">Waiter ID:</label>
              <input type="text" name="waiterId" class="input-box" id="waiterId" required>
            </div>
            <br><br>
            <div class="div1">
                <label for="tableId" class="form-label">Table ID: </label>
                <input type="text" name="tableId" class="input-box" id="tableId" required>
            </div>
            <br><br>
            <div class="div1">
                <div class="submit-box">
                    <input type="submit" value="Login" class="submit">
                </div>
            </div>
            
    </form>

</body>
</html>
