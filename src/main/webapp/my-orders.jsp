
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    List<Map<String, Object>> orders =
        (List<Map<String, Object>>) request.getAttribute("orders");

    String context = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | CityShop</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #243047;
        }

        /* Navigation Bar */
        .navbar {
            background: #172554;
            color: white;
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 18px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }

        .brand {
            font-size: 24px;
            font-weight: bold;
            white-space: nowrap;
        }

        .nav-links {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 11px 14px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.2s, transform 0.2s;
        }

        .nav-links a:hover {
            background: #334e91;
            transform: translateY(-2px);
        }

        .nav-links a.active {
            background: #2563eb;
        }

        /* Main Content */
        .container {
            max-width: 1050px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        h1 {
            color: #243b70;
            margin: 0 0 8px;
        }

        .subtitle {
            color: #64748b;
            margin: 0;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            padding: 12px 18px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s;
        }

        .btn:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }

        .btn-green {
            background: #059669;
        }

        .btn-green:hover {
            background: #047857;
        }

        .btn-gray {
            background: #64748b;
        }

        .btn-gray:hover {
            background: #475569;
        }

        /* Order Card */
        .order-card {
            background: white;
            padding: 24px;
            margin-bottom: 22px;
            border-radius: 14px;
            border: 1px solid #e5eaf2;
            box-shadow: 0 5px 18px rgba(0,0,0,0.05);
            transition: box-shadow 0.2s;
        }

        .order-card:hover {
            box-shadow: 0 9px 24px rgba(0,0,0,0.09);
        }

        .order-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 14px;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 18px;
        }

        .order-number {
            font-size: 19px;
            font-weight: bold;
            color: #243b70;
        }

        .muted {
            color: #64748b;
            margin-top: 8px;
            font-size: 14px;
        }

        .status {
            display: inline-block;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 8px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .section-title {
            margin: 22px 0 10px;
            color: #334155;
        }

        .item {
            padding: 16px 0;
            border-bottom: 1px solid #eef2f7;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .item-name {
            font-weight: bold;
            color: #243047;
        }

        .item-price {
            color: #475569;
            font-size: 14px;
        }

        .total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 22px;
            padding-top: 16px;
            border-top: 1px dashed #cbd5e1;
            font-size: 20px;
            font-weight: bold;
        }

        .total-amount {
            color: #059669;
        }

        .order-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 22px;
        }

        /* Empty Orders */
        .empty {
            background: white;
            text-align: center;
            padding: 50px 20px;
            border-radius: 14px;
            box-shadow: 0 5px 18px rgba(0,0,0,0.05);
        }

        .empty-icon {
            font-size: 52px;
            margin-bottom: 15px;
        }

        .empty h2 {
            color: #243b70;
        }

        .empty p {
            color: #64748b;
            margin-bottom: 24px;
        }

        /* Responsive Design */
        @media (max-width: 700px) {
            .navbar {
                align-items: flex-start;
                flex-direction: column;
                padding: 18px;
            }

            .nav-links {
                width: 100%;
                flex-direction: column;
                align-items: stretch;
            }

            .nav-links a {
                display: block;
            }

            .container {
                margin: 25px auto;
                padding: 0 14px;
            }

            .order-card {
                padding: 18px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
            }

            .total {
                font-size: 18px;
            }
        }
    </style>
</head>

<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="brand">🛍️ CityShop</div>

    <div class="nav-links">
        <a href="<%= context %>/customer-dashboard.jsp">
            🏠 Dashboard
        </a>

        <a href="<%= context %>/customer-marketplace">
            🛒 Marketplace
        </a>

        <a href="<%= context %>/cart">
            🛍️ View Cart
        </a>

        <a class="active" href="<%= context %>/my-orders">
            📦 My Orders
        </a>
    </div>
</nav>

<main class="container">

    <header class="page-header">
        <div>
            <h1>My Orders</h1>
            <p class="subtitle">
                Track your purchases and review your order history.
            </p>
        </div>

        <a class="btn" href="<%= context %>/customer-marketplace">
            🛒 Continue Shopping
        </a>
    </header>

    <% if (orders == null || orders.isEmpty()) { %>

        <section class="empty">
            <div class="empty-icon">📦</div>
            <h2>No orders yet</h2>
            <p>Your confirmed purchases will appear here.</p>

            <a class="btn" href="<%= context %>/customer-marketplace">
                🛍️ Browse Products
            </a>
        </section>

    <% } else { %>

        <% for (Map<String, Object> order : orders) { %>

            <section class="order-card">

                <div class="order-heading">
                    <div>
                        <div class="order-number">
                            Order #<%= order.get("orderId") %>
                        </div>

                        <div class="muted">
                            📅 Order Date:
                            <%= order.get("orderDate") == null
                                ? "N/A"
                                : order.get("orderDate") %>
                        </div>
                    </div>

                    <span class="status">
                        <%= escapeHtml(
                            String.valueOf(order.get("orderStatus"))) %>
                    </span>
                </div>

                <h3 class="section-title">🛍️ Purchased Items</h3>

                <%
                    List<Map<String, Object>> items =
                        (List<Map<String, Object>>) order.get("items");
                %>

                <% if (items != null) { %>
                    <% for (Map<String, Object> item : items) { %>

                        <div class="item">
                            <div>
                                <div class="item-name">
                                    <%= escapeHtml(
                                        String.valueOf(item.get("productName"))) %>
                                </div>

                                <div class="muted">
                                    Quantity: <%= item.get("quantity") %>
                                </div>
                            </div>

                            <div class="item-price">
                                ₹<%= item.get("price") %> per item
                            </div>
                        </div>

                    <% } %>
                <% } %>

                <div class="total">
                    <span>Order Total</span>
                    <span class="total-amount">
                        ₹<%= order.get("totalAmount") %>
                    </span>
                </div>

                <div class="order-actions">
                    <a class="btn btn-green"
                       href="<%= context %>/customer-marketplace">
                        🛒 Shop More
                    </a>

                    <a class="btn btn-gray"
                       href="<%= context %>/cart">
                        View Cart →
                    </a>
                </div>

            </section>

        <% } %>

    <% } %>

</main>

</body>
</html>
