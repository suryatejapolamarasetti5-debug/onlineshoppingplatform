<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seller Registration - CityShop</title>
</head>
<body>

    <h1>Register as a Seller</h1>

    <% if ("1".equals(request.getParameter("error"))) { %>
        <p style="color:red;">
            Registration failed. Check your details or contact support.
        </p>
    <% } %>

    <% if ("exists".equals(request.getParameter("error"))) { %>
        <p style="color:red;">
            That username or email may already be registered.
        </p>
    <% } %>

    <form action="<%= request.getContextPath() %>/seller-register"
          method="post">

        <label>Username:</label>
        <input type="text" name="username" maxlength="50" required>
        <br><br>

        <label>Password:</label>
        <input type="password" name="password" required>
        <br><br>

        <label>Owner Name:</label>
        <input type="text" name="ownerName" maxlength="100" required>
        <br><br>

        <label>Business / Shop Name:</label>
        <input type="text" name="businessName" maxlength="100" required>
        <br><br>

        <label>Email:</label>
        <input type="email" name="email" maxlength="100" required>
        <br><br>

        <label>Phone:</label>
        <input type="tel" name="phone" maxlength="15">
        <br><br>

        <label>City:</label>
        <select name="cityId" required>
            <option value="">-- Select City --</option>
            <option value="1">Visakhapatnam</option>
            <option value="2">Vijayawada</option>
            <option value="3">Hyderabad</option>
            <option value="14">Bengaluru</option>
            <option value="15">Chennai</option>
        </select>
        <br><br>

        <button type="submit">Register as Seller</button>
    </form>

    <br>
    <a href="<%= request.getContextPath() %>/login.jsp">
        Already have an account? Login
    </a>

</body>
</html>