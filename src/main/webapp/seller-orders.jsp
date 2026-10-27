
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.math.BigDecimal,java.sql.Timestamp,java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String cp = request.getContextPath();

    List<Map<String, Object>> orders =
        (List<Map<String, Object>>) request.getAttribute("orders");

    if (orders == null) {
        orders = new ArrayList<>();
    }

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    java.text.NumberFormat currency =
        java.text.NumberFormat.getCurrencyInstance(
            java.util.Locale.forLanguageTag("en-IN"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Customer Orders | CityShop</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f3f6fb;
    color: #1e293b;
}

.navbar {
    background: #142b4a;
    color: white;
    padding: 18px 5%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}

.brand {
    font-size: 25px;
    font-weight: 800;
}

.brand span {
    color: #38bdf8;
}

.nav-links {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.nav-links a {
    color: #e2e8f0;
    text-decoration: none;
    padding: 11px 13px;
    border-radius: 7px;
    font-size: 14px;
    font-weight: 600;
}

.nav-links a:hover,
.nav-links a.active {
    background: #294766;
    color: white;
}

.nav-links .logout {
    background: #dc2626;
}

.container {
    width: 92%;
    max-width: 1150px;
    margin: 32px auto;
}

.heading {
    margin-bottom: 25px;
}

.heading h1 {
    font-size: 29px;
    margin-bottom: 8px;
}

.heading p {
    color: #64748b;
    line-height: 1.6;
}

.orders {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(290px, 1fr));
    gap: 20px;
}

.order-card {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 14px;
    padding: 24px;
    box-shadow: 0 4px 12px rgba(15, 23, 42, 0.04);
    transition: transform .2s, box-shadow .2s;
}

.order-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
}

.order-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 18px;
}

.order-number {
    font-size: 18px;
    font-weight: 750;
}

.status {
    display: inline-block;
    padding: 6px 11px;
    border-radius: 20px;
    background: #dbeafe;
    color: #1d4ed8;
    font-size: 12px;
    font-weight: 700;
}

.status.placed {
    background: #dbeafe;
    color: #1d4ed8;
}

.status.delivered {
    background: #d1fae5;
    color: #047857;
}

.status.cancelled {
    background: #fee2e2;
    color: #b91c1c;
}

.status.processing {
    background: #fef3c7;
    color: #92400e;
}

.order-date {
    color: #64748b;
    font-size: 13px;
    margin-bottom: 20px;
}

.detail {
    margin: 13px 0;
    line-height: 1.6;
    overflow-wrap: anywhere;
}

.detail-label {
    display: block;
    font-size: 12px;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: .5px;
    margin-bottom: 4px;
}

.products {
    background: #f8fafc;
    padding: 13px;
    border-radius: 9px;
    font-size: 14px;
}

.total {
    border-top: 1px solid #e2e8f0;
    margin-top: 20px;
    padding-top: 16px;
    display: flex;
    justify-content: space-between;
    gap: 12px;
    font-size: 14px;
}

.total strong {
    font-size: 17px;
    color: #047857;
}

.note {
    color: #64748b;
    font-size: 12px;
    margin-top: 10px;
    line-height: 1.5;
}

.empty {
    background: white;
    text-align: center;
    padding: 55px 20px;
    border-radius: 15px;
    border: 1px solid #e2e8f0;
}

.empty .icon {
    font-size: 45px;
    margin-bottom: 15px;
}

.empty h2 {
    margin-bottom: 10px;
}

.empty p {
    color: #64748b;
    margin-bottom: 22px;
}

.btn {
    display: inline-block;
    padding: 11px 17px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 650;
}

.btn:hover {
    background: #1d4ed8;
}

.footer {
    text-align: center;
    color: #64748b;
    padding: 25px;
    margin-top: 35px;
    border-top: 1px solid #e2e8f0;
    font-size: 13px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 18px 4%;
    }

    .nav-links a {
        padding: 9px;
        font-size: 12px;
    }

    .container {
        margin: 23px auto;
    }

    .heading h1 {
        font-size: 25px;
    }

    .orders {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>

<nav class="navbar">
    <div class="brand">City<span>Shop</span></div>

    <div class="nav-links">
        <a href="<%= cp %>/seller-dashboard.jsp">Dashboard</a>
        <a href="<%= cp %>/seller-products">My Products</a>
        <a href="<%= cp %>/add-product.jsp">Add Product</a>
        <a class="active" href="<%= cp %>/seller-orders">Orders</a>
        <a class="logout" href="<%= cp %>/logout">Logout</a>
    </div>
</nav>

<main class="container">

    <section class="heading">
        <h1>Customer Orders 🛍️</h1>
        <p>View orders that contain products from your shop.</p>
    </section>

    <% if (orders.isEmpty()) { %>

        <section class="empty">
            <div class="icon">📦</div>
            <h2>No Orders Yet</h2>
            <p>
                Orders containing your products will appear here
                when customers place them.
            </p>
            <a class="btn" href="<%= cp %>/seller-products">
                View My Products
            </a>
        </section>

    <% } else { %>

        <section class="orders">

        <% for (Map<String, Object> order : orders) {
            Object statusValue = order.get("status");
            String status = statusValue == null
                ? "PLACED" : statusValue.toString();

            String statusClass = "placed";
            String normalizedStatus = status.toUpperCase(Locale.ROOT);

            if (normalizedStatus.contains("DELIVER")) {
                statusClass = "delivered";
            } else if (normalizedStatus.contains("CANCEL")) {
                statusClass = "cancelled";
            } else if (normalizedStatus.contains("PROCESS")
                    || normalizedStatus.contains("SHIP")) {
                statusClass = "processing";
            }

            Object orderDate = order.get("orderDate");
            String formattedDate = orderDate instanceof Timestamp
                ? dateFormat.format((Timestamp) orderDate)
                : "Date unavailable";

            Object productsValue = order.get("products");
            String products = productsValue == null
                ? "Product details unavailable"
                : productsValue.toString();
        %>

            <article class="order-card">

                <div class="order-top">
                    <div class="order-number">
                        Order #<%= order.get("orderId") %>
                    </div>

                    <span class="status <%= statusClass %>">
                        <%= status %>
                    </span>
                </div>

                <div class="order-date">
                    📅 <%= formattedDate %>
                </div>

                <div class="detail">
                    <span class="detail-label">Your Products</span>
                    <div class="products"><%= products %></div>
                </div>

                <div class="detail">
                    <span class="detail-label">Product Types</span>
                    <%= order.get("productCount") %>
                </div>

                <div class="detail">
                    <span class="detail-label">Total Quantity</span>
                    <%= order.get("quantity") %>
                </div>

                <div class="total">
                    <span>Your products' subtotal</span>
                    <strong>
                        <%= currency.format(
                            (BigDecimal) order.get("sellerSubtotal")) %>
                    </strong>
                </div>

                <p class="note">
                    This subtotal covers your products only.
                    The full order total may include products from
                    other sellers.
                </p>

            </article>

        <% } %>

        </section>

    <% } %>

</main>

<footer class="footer">
    &copy; 2026 CityShop. Seller Order Management.
</footer>

</body>
</html>
