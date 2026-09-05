<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>

<h1>Admin Dashboard</h1>

<h2>Welcome, ${sessionScope.username}!</h2>

<p>You are logged in as: ${sessionScope.role}</p>

<hr>

<h3>Admin Functions</h3>

<ul>
    <li>Manage Sellers</li>
    <li>Manage Customers</li>
    <li>Manage Products</li>
    <li>Manage Categories</li>
    <li>View Orders</li>
</ul>

<a href="logout">Logout</a>

</body>
</html>