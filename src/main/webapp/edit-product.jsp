
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.onlineshopping.dao.Product" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Product</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f8;
        }

        .header {
            background: #1f2937;
            color: white;
            padding: 20px 40px;
        }

        .header h1 {
            margin: 0;
        }

        .container {
            width: 90%;
            max-width: 700px;
            margin: 30px auto;
        }

        .form-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 6px;
            font-weight: bold;
            color: #374151;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 11px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
        }

        textarea {
            height: 100px;
            resize: vertical;
        }

        .btn {
            margin-top: 25px;
            padding: 12px 22px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-size: 15px;
            cursor: pointer;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            color: #2563eb;
            text-decoration: none;
        }

        .error {
            padding: 12px;
            margin-bottom: 15px;
            background: #fee2e2;
            color: #991b1b;
            border-radius: 6px;
        }

    </style>

</head>

<body>

    <div class="header">

        <h1>Edit Product</h1>

    </div>


    <div class="container">

        <div class="form-box">

            <%
                Product product =
                    (Product) request.getAttribute("product");

                if (product == null) {
            %>

                <div class="error">
                    Product information could not be found.
                </div>

                <a href="seller-products.jsp" class="back">
                    ← Back to My Products
                </a>

            <%
                } else {
            %>

                <form action="edit-product" method="post">

                    <input type="hidden"
                           name="productId"
                           value="<%= product.getProductId() %>">


                    <label>Product Name</label>

                    <input type="text"
                           name="productName"
                           value="<%= product.getProductName() %>"
                           required>


                    <label>Description</label>

                    <textarea name="description"
                              required><%= product.getDescription() %></textarea>


                    <label>Category</label>

                    <select name="categoryId" required>

                        <option value="1">Electronics</option>
                        <option value="2">Clothing</option>
                        <option value="3">Groceries</option>
                        <option value="4">Home & Kitchen</option>
                        <option value="5">Books</option>
                        <option value="6">Beauty & Personal Care</option>
                        <option value="7">Sports & Fitness</option>

                    </select>


                    <label>Price (₹)</label>

                    <input type="number"
                           name="price"
                           step="0.01"
                           min="0"
                           value="<%= product.getPrice() %>"
                           required>


                    <label>Stock Quantity</label>

                    <input type="number"
                           name="stockQuantity"
                           min="0"
                           value="<%= product.getStockQuantity() %>"
                           required>


                    <button type="submit" class="btn">
                        Update Product
                    </button>

                </form>

            <%
                }
            %>

            <br>

            <a href="seller-products" class="back">
                ← Back to My Products
            </a>

        </div>

    </div>

</body>

</html>
