
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.onlineshopping.dao.Product" %>

<%!
    // Escape product text before displaying it in HTML.
    public String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marketplace</title>

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
            gap: 15px;
            margin-bottom: 25px;
        }

        .top-section h2 {
            margin: 0;
            color: #1f2937;
        }

        .back-btn {
            display: inline-block;
            padding: 10px 18px;
            background: #6b7280;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            white-space: nowrap;
        }

        .back-btn:hover {
            background: #4b5563;
        }

        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
        }

        .search-box input {
            flex: 1;
            min-width: 0;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 15px;
        }

        .search-btn {
            padding: 12px 20px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .search-btn:hover {
            background: #1d4ed8;
        }

        .clear-btn {
            display: inline-block;
            padding: 12px;
            color: #374151;
            text-decoration: none;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 22px;
        }

        .product-card {
            background: white;
            padding: 22px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: transform 0.2s;
        }

        .product-card:hover {
            transform: translateY(-3px);
        }

        .product-name {
            font-size: 20px;
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .category {
            display: inline-block;
            padding: 5px 10px;
            background: #e0e7ff;
            color: #3730a3;
            border-radius: 15px;
            font-size: 12px;
            margin-bottom: 12px;
        }

        .description {
            color: #6b7280;
            min-height: 45px;
            margin-bottom: 15px;
        }

        .price {
            font-size: 22px;
            font-weight: bold;
            color: #059669;
            margin-bottom: 8px;
        }

        .stock {
            color: #374151;
            font-size: 14px;
            margin-bottom: 18px;
        }

        .details-btn {
            display: block;
            padding: 11px;
            background: #2563eb;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 6px;
        }

        .details-btn:hover {
            background: #1d4ed8;
        }

        .empty {
            background: white;
            padding: 40px 20px;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

        .empty h3 {
            color: #374151;
        }

        .empty p {
            color: #6b7280;
        }

        @media (max-width: 600px) {
            .header {
                padding: 20px;
            }

            .top-section {
                align-items: flex-start;
                flex-direction: column;
            }

            .search-box {
                flex-wrap: wrap;
            }

            .search-btn {
                flex: 1;
            }
        }
    </style>
</head>

<body>

    <div class="header">
        <h1>Online Shopping Marketplace</h1>
    </div>

   
<div class="top-section">
    <h2>Products Near You</h2>

    <div style="display:flex; gap:10px; flex-wrap:wrap;">
        <a href="${pageContext.request.contextPath}/cart"
           class="back-btn"
           style="background:#059669;">
            🛒 View Cart
        </a>

        <a href="${pageContext.request.contextPath}/customer-dashboard.jsp"
           class="back-btn">
            ← Dashboard
        </a>
    </div>
</div>


        <!-- Search products -->
        <form class="search-box"
              action="${pageContext.request.contextPath}/customer-marketplace"
              method="get">

            <input type="text"
                   name="search"
                   placeholder="Search products by name..."
                   value="<%= escapeHtml(request.getParameter("search")) %>">

            <button type="submit" class="search-btn">
                Search
            </button>

            <a class="clear-btn"
               href="${pageContext.request.contextPath}/customer-marketplace">
                Clear
            </a>
        </form>

        <%
            List<Product> products =
                (List<Product>) request.getAttribute("products");

            String search = request.getParameter("search");
        %>

        <% if (search != null && !search.trim().isEmpty()) { %>
            <p>
                Search results for:
                <strong><%= escapeHtml(search.trim()) %></strong>
            </p>
        <% } %>

        <% if (products != null && !products.isEmpty()) { %>

            <div class="product-grid">

                <% for (Product product : products) { %>

                    <div class="product-card">

                        <div class="product-name">
                            <%= escapeHtml(product.getProductName()) %>
                        </div>

                        <div class="category">
                            <%= escapeHtml(product.getCategoryName()) %>
                        </div>

                        <div class="description">
                            <%= escapeHtml(product.getDescription()) %>
                        </div>

                        <div class="price">
                            ₹<%= String.format("%.2f", product.getPrice()) %>
                        </div>

                        <div class="stock">
                            Available Stock:
                            <strong><%= product.getStockQuantity() %></strong>
                        </div>

                        <a class="details-btn"
                           href="${pageContext.request.contextPath}/product-details?id=<%= product.getProductId() %>">
                            View Product Details
                        </a>

                    </div>

                <% } %>

            </div>

        <% } else { %>

            <div class="empty">
                <h3>No Products Found</h3>

                <p>
                    <% if (search != null && !search.trim().isEmpty()) { %>
                        No matching products were found in your city.
                        Try another product name.
                    <% } else { %>
                        There are currently no products available
                        from sellers in your city.
                    <% } %>
                </p>
            </div>

        <% } %>

    </div>

</body>
</html>
