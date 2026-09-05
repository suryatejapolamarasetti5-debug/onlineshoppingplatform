<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seller Registration</title>
</head>

<body>

<h1>Seller Registration</h1>

<form action="seller-register" method="post">

    <label>Username:</label>
    <input type="text" name="username" required>
    <br><br>

    <label>Password:</label>
    <input type="password" name="password" required>
    <br><br>

    <label>Business Name:</label>
    <input type="text" name="businessName" required>
    <br><br>

    <label>Phone:</label>
    <input type="text" name="phone" required>
    <br><br>

    <label>Address:</label>
    <textarea name="address" required></textarea>
    <br><br>

    <label>City:</label>

    <select name="cityId" required>

        <option value="">-- Select City --</option>

        <option value="1">Hyderabad</option>
        <option value="2">Visakhapatnam</option>
        <option value="3">Vijayawada</option>
        <option value="4">Bengaluru</option>
        <option value="5">Chennai</option>

    </select>

    <br><br>

    <button type="submit">Register as Seller</button>

</form>

<br>

<a href="login.jsp">Already have an account? Login</a>

</body>
</html>