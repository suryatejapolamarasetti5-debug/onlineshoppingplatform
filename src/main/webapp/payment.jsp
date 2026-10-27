<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.onlineshopping.controller.CheckoutServlet.CartProduct" %> 
 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"CUSTOMER".equalsIgnoreCase(role)) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp");
        return;
    }

    List<CartProduct> items =
        (List<CartProduct>) request.getAttribute("cartItems");

    BigDecimal total =
        (BigDecimal) request.getAttribute("cartTotal");

    Integer cityId =
        (Integer) request.getAttribute("customerCityId");

    if (items == null || items.isEmpty() || total == null
            || total.compareTo(BigDecimal.ZERO) <= 0) {
        response.sendRedirect(
            request.getContextPath() + "/checkout?error=empty");
        return;
    }

    boolean validCart = cityId != null;

    for (CartProduct item : items) {
        if (item.getSellerCityId() != cityId
                || item.getQuantity() < 1
                || item.getQuantity() > item.getStock()) {
            validCart = false;
        }
    }

    if (!validCart) {
        response.sendRedirect(
            request.getContextPath() + "/checkout?error=stock");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CityShop | Payment</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f3f6fb;
    color: #1e293b;
}

.navbar {
    background: #0f766e;
    color: white;
    padding: 18px 7%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.brand {
    font-size: 23px;
    font-weight: bold;
}

.navbar a {
    color: white;
    text-decoration: none;
    font-size: 14px;
}

.page {
    max-width: 950px;
    margin: 38px auto;
    padding: 0 18px;
}

.heading {
    text-align: center;
    margin-bottom: 25px;
}

.heading h1 {
    margin-bottom: 8px;
    font-size: 30px;
}

.heading p {
    color: #64748b;
    margin-top: 0;
}

.payment-layout {
    display: grid;
    grid-template-columns: 1.3fr 1fr;
    gap: 22px;
}

.card {
    background: white;
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 8px 28px rgba(15, 23, 42, 0.07);
}

.card h2 {
    margin-top: 0;
    font-size: 19px;
}

.demo-badge {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    background: #fef3c7;
    color: #92400e;
    font-size: 12px;
    font-weight: bold;
    margin-bottom: 15px;
}

.method {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 15px;
    margin-top: 12px;
    border: 1px solid #dbe3ee;
    border-radius: 12px;
    cursor: pointer;
}

.method:has(input:checked) {
    border-color: #0f766e;
    background: #f0fdfa;
}

.method input {
    accent-color: #0f766e;
}

.method strong {
    display: block;
    margin-bottom: 4px;
}

.method small {
    color: #64748b;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    gap: 12px;
    margin: 18px 0;
    color: #475569;
}

.total {
    border-top: 1px solid #e2e8f0;
    padding-top: 18px;
    font-weight: bold;
    color: #0f172a;
    font-size: 19px;
}

.pay-btn {
    display: block;
    width: 100%;
    margin-top: 22px;
    padding: 14px;
    border: none;
    border-radius: 10px;
    background: #0f766e;
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.pay-btn:hover {
    background: #115e59;
}

.notice {
    margin-top: 15px;
    font-size: 12px;
    line-height: 1.6;
    color: #64748b;
}

footer {
    text-align: center;
    padding: 24px;
    color: #64748b;
    font-size: 13px;
}

@media (max-width: 680px) {
    .payment-layout {
        grid-template-columns: 1fr;
    }

    .page {
        margin-top: 25px;
    }

    .heading h1 {
        font-size: 25px;
    }
}
</style>
</head>

<body>

<header class="navbar">
    <div class="brand">🛍 CityShop</div>
    <a href="<%= request.getContextPath() %>/customer-marketplace">
        ← Back to Shopping
    </a>
</header>

<main class="page">

    <div class="heading">
        <h1>Secure Checkout</h1>
        <p>Review your order and choose a payment method.</p>
    </div>

    <div class="payment-layout">

        <section class="card">
            <span class="demo-badge">DEMO MODE</span>
            <h2>Choose Payment Method</h2>

            <label class="method">
                <input type="radio" name="paymentMethod"
                       value="UPI" checked>
                <span>
                    <strong>📱 UPI</strong>
                    <small>Google Pay, PhonePe, BHIM and other UPI apps</small>
                </span>
            </label>

            <label class="method">
                <input type="radio" name="paymentMethod"
                       value="COD">
                <span>
                    <strong>💵 Cash on Delivery</strong>
                    <small>Pay when your order arrives</small>
                </span>
            </label>

            <button type="button" class="pay-btn"
                    onclick="showDemoMessage()">
                Continue
            </button>

            <p class="notice">
                This is a demonstration page only. No payment is
                processed, no bank account is accessed, and no money
                is transferred.
            </p>
        </section>

        <aside class="card">
           
<h2>Order Summary</h2>

<% for (CartProduct item : items) { %>
    <div class="summary-row">
        <span>
            <%= item.getName() %>
            × <%= item.getQuantity() %>
        </span>
        <span>
            ₹<%= item.getPrice()
                .multiply(BigDecimal.valueOf(item.getQuantity()))
                .toPlainString() %>
        </span>
    </div>
<% } %>

<div class="summary-row total">
    <span>Total</span>
    <span>₹<%= total.toPlainString() %></span>
</div>

<p class="notice">
    Demo mode only. No payment is processed and no money is transferred.
</p>

        </aside>

    </div>
</main>

<footer>
    © 2026 CityShop | Payment demonstration page
</footer>

<script>
function showDemoMessage() {
    const selected = document.querySelector(
        'input[name="paymentMethod"]:checked'
    );

    if (selected.value === "UPI") {
        alert("Demo only: UPI payment is not connected yet. No money was charged.");
    } else {
        alert("Cash on Delivery selected. No order or payment has been created by this demo page.");
    }
}
</script>

</body>
</html>