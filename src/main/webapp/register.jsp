
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Registration - ShopEase</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f1f5f9;
    color: #1e293b;
}

.navbar {
    background: #172554;
    color: white;
    padding: 18px 8%;
    font-size: 22px;
    font-weight: bold;
}

.register-container {
    width: 90%;
    max-width: 430px;
    margin: 45px auto;
    padding: 30px;
    background: white;
    border-radius: 14px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.10);
}

h2 {
    text-align: center;
    margin-bottom: 8px;
    color: #172554;
}

.subtitle {
    text-align: center;
    color: #64748b;
    margin-bottom: 25px;
    font-size: 14px;
}

label {
    display: block;
    margin: 15px 0 7px;
    font-weight: bold;
    font-size: 14px;
}

input {
    width: 100%;
    padding: 12px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    font-size: 15px;
}

input:focus {
    outline: none;
    border-color: #2563eb;
    box-shadow: 0 0 0 2px #dbeafe;
}

button {
    width: 100%;
    margin-top: 22px;
    padding: 13px;
    background: #2563eb;
    color: white;
    border: none;
    border-radius: 7px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    background: #1d4ed8;
}

.login-link {
    text-align: center;
    margin-top: 20px;
    font-size: 14px;
}

a {
    color: #2563eb;
    text-decoration: none;
    font-weight: bold;
}

a:hover {
    text-decoration: underline;
}

.message {
    text-align: center;
    color: #b91c1c;
    background: #fef2f2;
    padding: 10px;
    border-radius: 6px;
    margin-bottom: 15px;
    font-size: 14px;
}

@media (max-width: 480px) {
    .register-container {
        padding: 22px;
        margin: 25px auto;
    }

    .navbar {
        padding: 16px 5%;
    }
}
</style>
</head>

<body>

<div class="navbar">ShopEase</div>

<div class="register-container">
    <h2>Create Account</h2>
    <p class="subtitle">Register as a customer to start shopping.</p>

    <% if ("1".equals(request.getParameter("error"))) { %>
        <p class="message">Registration failed. The username may already exist, or the details may be invalid.</p>
    <% } %>

    <% if ("password".equals(request.getParameter("error"))) { %>
        <p class="message">Passwords do not match. Please try again.</p>
    <% } %>

    <form action="${pageContext.request.contextPath}/register"
          method="post">

        <label for="username">Username</label>
        <input type="text" id="username" name="username"
               maxlength="50" autocomplete="username" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password"
               minlength="8" autocomplete="new-password" required>

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword"
               name="confirmPassword" minlength="8"
               autocomplete="new-password" required>

        <button type="submit">Create Account</button>
    </form>

    <p class="login-link">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login.jsp">
            Login here
        </a>
    </p>
</div>

</body>
</html>