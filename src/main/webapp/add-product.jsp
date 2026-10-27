<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Add Product</title>

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
            margin: 35px auto;
        }

        .form-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .form-box h2 {
            margin-top: 0;
            color: #1f2937;
        }

        label {
            display: block;
            margin-top: 18px;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input,
        textarea,
        select {
            width: 100%;
            padding: 11px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 15px;
        }

        textarea {
            height: 120px;
            resize: vertical;
        }

        .btn {
            margin-top: 25px;
            padding: 12px 22px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 15px;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .back {
            display: inline-block;
            margin-top: 15px;
            color: #2563eb;
            text-decoration: none;
        }

    </style>

</head>

<body>

    <div class="header">

        <h1>Seller Dashboard</h1>

    </div>


    <div class="container">

        <div class="form-box">

            <h2>Add New Product</h2>

            <p>
                Add a product to your shop.
            </p>


            <form action="add-product" method="post">

                <label for="productName">
                    Product Name
                </label>

                <input
                    type="text"
                    id="productName"
                    name="productName"
                    placeholder="Enter product name"
                    required
                >


                <label for="description">
                    Description
                </label>

                <textarea
                    id="description"
                    name="description"
                    placeholder="Enter product description"
                ></textarea>


                <label for="categoryId">
                    Category
                </label>

                <select
                    id="categoryId"
                    name="categoryId"
                    required
                >

                    <option value="">
                        Select Category
                    </option>

                    <option value="1">
                        Electronics
                    </option>

                    <option value="2">
                        Clothing
                    </option>

                    <option value="3">
                        Groceries
                    </option>

                    <option value="4">
                        Home & Kitchen
                    </option>

                    <option value="5">
                        Books
                    </option>

                    <option value="6">
                        Beauty & Personal Care
                    </option>

                    <option value="7">
                        Sports & Fitness
                    </option>

                </select>


                <label for="price">
                    Price
                </label>

                <input
                    type="number"
                    id="price"
                    name="price"
                    step="0.01"
                    min="0"
                    placeholder="Enter price"
                    required
                >


                <label for="stockQuantity">
                    Stock Quantity
                </label>

                <input
                    type="number"
                    id="stockQuantity"
                    name="stockQuantity"
                    min="0"
                    placeholder="Enter available quantity"
                    required
                >


                <button type="submit" class="btn">
                    Add Product
                </button>

            </form>


            <br>

            <a href="seller-dashboard.jsp" class="back">
                ← Back to Seller Dashboard
            </a>

        </div>

    </div>

</body>

</html>