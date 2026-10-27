
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("username") == null
            || !"ADMIN".equalsIgnoreCase(
                String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> products =
        (List<Map<String, Object>>) request.getAttribute("products");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manage Products | CityShop</title>
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f4f6fb;
        color: #263247;
    }
    header {
        background: #263b80;
        color: white;
        padding: 20px 5%;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
    }
    header a, .back {
        color: white;
        text-decoration: none;
    }
    main {
        max-width: 1200px;
        margin: 30px auto;
        padding: 0 16px;
    }
    .panel {
        background: white;
        padding: 22px;
        border-radius: 12px;
        box-shadow: 0 3px 12px #0000000d;
        overflow-x: auto;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        min-width: 850px;
    }
    th, td {
        padding: 13px;
        text-align: left;
        border-bottom: 1px solid #e5e8ef;
    }
    th {
        background: #eef1fa;
    }
    .back {
        display: inline-block;
        background: #263b80;
        padding: 10px 14px;
        border-radius: 6px;
        margin-bottom: 18px;
    }
    .price {
        white-space: nowrap;
        font-weight: bold;
    }
</style>
</head>
<body>
<header>
    <h2>CityShop — Manage Products</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back"
       href="<%= request.getContextPath() %>/admin-dashboard">
       ← Back to Dashboard
    </a>

    <section class="panel">
        <h2>All Products</h2>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Product</th>
                    <th>Description</th>
                    <th>Seller</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                </tr>
            </thead>
            <tbody>
            <% if (products != null && !products.isEmpty()) {
                   for (Map<String, Object> product : products) { %>
                <tr>
                    <td><%= product.get("productId") %></td>
                    <td><%= product.get("productName") %></td>
                    <td><%= product.get("description") == null
                            ? "—" : product.get("description") %></td>
                    <td><%= product.get("shopName") == null
                            ? "Unknown" : product.get("shopName") %></td>
                    <td><%= product.get("categoryName") == null
                            ? "Uncategorized" : product.get("categoryName") %></td>
                    <td class="price">₹<%= product.get("price") %></td>
                    <td><%= product.get("stock") %></td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="7">No products found.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
