<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Seller Dashboard</title>
</head>
<body>

<h1>Seller Dashboard</h1>

<h2>Welcome, ${sessionScope.username}!</h2>

<p>You are logged in as: ${sessionScope.role}</p>

<hr>

<h3>Seller Functions</h3>

<ul>
    <li>Add Product</li>
    <li>View My Products</li>
    <li>Update Product</li>
    <li>Manage Stock</li>
    <li>View Customer Orders</li>
</ul>

<a href="logout">Logout</a>

</body>
</html>