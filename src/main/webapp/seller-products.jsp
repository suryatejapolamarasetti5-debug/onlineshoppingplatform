
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.onlineshopping.dao.Product" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Products</title>

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
            width: 95%;
            max-width: 1200px;
            margin: 30px auto;
        }

        .top-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .top-section h2 {
            margin: 0;
            color: #1f2937;
        }

        .btn {
            display: inline-block;
            padding: 10px 18px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .table-box {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #1f2937;
            color: white;
            padding: 13px;
            text-align: left;
        }

        td {
            padding: 13px;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background: #f8fafc;
        }

        .price {
            font-weight: bold;
        }

        .stock {
            font-weight: bold;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .back {
            display: inline-block;
            margin-top: 20px;
            color: #2563eb;
            text-decoration: none;
        }

      .edit-btn,
.delete-btn {
    display: inline-block;
    width: 70px;
    padding: 7px 0;
    text-align: center;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    box-sizing: border-box;
}

.edit-btn {
    background: #f59e0b;
}

.edit-btn:hover {
    background: #d97706;
}

.delete-btn {
    background: #dc2626;
    margin-top: 2px;
}

.delete-btn:hover {
    background: #b91c1c;
}
    </style>

</head>

<body>

    <div class="header">

        <h1>Seller Dashboard</h1>

    </div>


    <div class="container">

        <div class="top-section">

            <h2>My Products</h2>

            <a href="add-product.jsp" class="btn">
                + Add Product
            </a>

        </div>


        <div class="table-box">

            <%
                List<Product> products =
                    (List<Product>) request.getAttribute("products");

                if (products != null && !products.isEmpty()) {
            %>

                <table>

                    <thead>

                        <tr>

                            <th>ID</th>
                            <th>Product Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Action</th>

                        </tr>

                    </thead>

                    <tbody>

                    <%
                        for (Product product : products) {
                    %>

                        <tr>

                            <td>
                                <%= product.getProductId() %>
                            </td>

                            <td>
                                <strong>
                                    <%= product.getProductName() %>
                                </strong>
                            </td>

                            <td>
                                <%= product.getCategoryName() %>
                            </td>

                            <td>
                                <%= product.getDescription() %>
                            </td>

                            <td class="price">
                                ₹<%= String.format("%.2f",
                                    product.getPrice()) %>
                            </td>

                            <td class="stock">
                                <%= product.getStockQuantity() %>
                            </td>

                           <td>

    <a href="edit-product-page?id=<%= product.getProductId() %>"
       class="edit-btn">
        Edit
    </a>

    <a href="delete-product?id=<%= product.getProductId() %>"
       class="delete-btn"
       onclick="return confirm('Are you sure you want to delete this product?');">
        Delete
    </a>

</td>
                        </tr>

                    <%
                        }
                    %>

                    </tbody>

                </table>

            <%
                } else {
            %>

                <div class="empty">

                    <h3>No Products Found</h3>

                    <p>
                        You haven't added any products yet.
                    </p>

                    <a href="add-product.jsp" class="btn">
                        Add Your First Product
                    </a>

                </div>

            <%
                }
            %>

        </div>


        <a href="seller-dashboard.jsp" class="back">
            ← Back to Seller Dashboard
        </a>

    </div>

</body>

</html>
