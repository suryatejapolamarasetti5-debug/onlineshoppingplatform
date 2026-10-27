
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            color: #1f2937;
        }
        .header {
            background: #1f2937;
            color: white;
            padding: 20px 40px;
        }
        .container {
            max-width: 650px;
            width: 90%;
            margin: 35px auto;
        }
        .card {
            background: white;
            padding: 28px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        .category {
            color: #3730a3;
            background: #e0e7ff;
            padding: 6px 12px;
            border-radius: 15px;
            display: inline-block;
        }
        .price {
            font-size: 26px;
            color: #059669;
            font-weight: bold;
        }
        .btn {
            display: inline-block;
            padding: 12px 18px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 12px;
        }
        .back {
            background: #6b7280;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Product Details</h1>
    </div>

    <div class="container">
        <div class="card">
            <h2>${productName}</h2>
            <p><span class="category">${category}</span></p>
            <p>${description}</p>

            <p class="price">₹${price}</p>
            <p>Available stock: <strong>${stock}</strong></p>
            <p>Sold by: <strong>${shopName}</strong></p>

            <a href="${pageContext.request.contextPath}/cart?action=add&amp;productId=${productId}">
    Add to Cart
</a>

            <br>

            <a class="btn back"
               href="${pageContext.request.contextPath}/customer-marketplace">
                Back to Marketplace
            </a>
        </div>
    </div>
</body>
</html>
