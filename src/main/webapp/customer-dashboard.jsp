<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
</head>
<body>

<h1>Customer Dashboard</h1>

<h2>Welcome, ${sessionScope.username}!</h2>

<p>You are logged in as: ${sessionScope.role}</p>

<hr>

<h3>Customer Functions</h3>

<ul>
    <li>Browse Products</li>
    <li>Search Products</li>
    <li>View Product Details</li>
    <li>Add Products to Cart</li>
    <li>Place Orders</li>
    <li>View My Orders</li>
</ul>

<a href="logout">Logout</a>

</body>
</html>