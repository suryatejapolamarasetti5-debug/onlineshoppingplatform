
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.onlineshopping.controller.CheckoutServlet.CartProduct" %>

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
    List<CartProduct> items =
        (List<CartProduct>) request.getAttribute("cartItems");

    BigDecimal total =
        (BigDecimal) request.getAttribute("cartTotal");

    Integer cityId =
        (Integer) request.getAttribute("customerCityId");

    if (total == null) total = BigDecimal.ZERO;

    boolean canCheckout = items != null && !items.isEmpty();

    if (items != null) {
        for (CartProduct item : items) {
            if (cityId == null
                    || item.getSellerCityId() != cityId
                    || item.getQuantity() < 1
                    || item.getQuantity() > item.getStock()) {
                canCheckout = false;
            }
        }
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | Online Shopping</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 25px 15px;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #243047;
        }

        .container {
            max-width: 850px;
            margin: 25px auto;
            background: white;
            padding: 28px;
            border-radius: 14px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        h1 { color: #243b70; margin-top: 0; }

        .message {
            padding: 13px;
            margin: 15px 0;
            border-radius: 7px;
        }

        .success { background: #dcfce7; color: #166534; }
        .error { background: #fee2e2; color: #991b1b; }

        .item {
            padding: 16px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .item-name { font-weight: bold; font-size: 17px; }
        .muted { color: #64748b; margin-top: 6px; }

        .total {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            font-size: 21px;
            font-weight: bold;
            margin: 24px 0;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 20px;
        }

        .btn {
            display: inline-block;
            padding: 12px 18px;
            border: none;
            border-radius: 7px;
            background: #2563eb;
            color: white;
            text-decoration: none;
            font-size: 15px;
            cursor: pointer;
        }
        
.proceed-payment-btn {
    display: inline-block;
    width: 100%;
    max-width: 320px;
    padding: 14px 22px;
    background: linear-gradient(135deg, #0f766e, #0d9488);
    color: #ffffff;
    font-size: 16px;
    font-weight: 600;
    text-align: center;
    text-decoration: none;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(15, 118, 110, 0.2);
    transition: all 0.25s ease;
}

.proceed-payment-btn:hover {
    background: linear-gradient(135deg, #115e59, #0f766e);
    box-shadow: 0 7px 18px rgba(15, 118, 110, 0.3);
    transform: translateY(-2px);
}

.proceed-payment-btn:active {
    transform: translateY(0);
    box-shadow: 0 2px 6px rgba(15, 118, 110, 0.2);
}

.proceed-payment-btn:focus-visible {
    outline: 3px solid #99f6e4;
    outline-offset: 3px;
}
        

        .secondary { background: #64748b; }
        .btn:disabled { background: #9ca3af; cursor: not-allowed; }

        @media (max-width: 600px) {
            .container { padding: 18px; }
            .total { font-size: 18px; }
        }
    </style>
</head>

<body>
<div class="container">

    <h1>Checkout</h1>
    <p>Review your products before confirming your order.</p>

    <% if ("1".equals(success)) { %>
        <div class="message success">
            Your order was placed successfully!
            Your cart has been cleared.
        </div>
        <div class="actions">
            <a class="btn"
               href="<%= request.getContextPath() %>/customer-marketplace">
                Continue Shopping
            </a>
            <a class="btn secondary"
               href="<%= request.getContextPath() %>/my-orders">
                My Orders
            </a>
        </div>

    <% } else { %>

        <% if ("empty".equals(error)) { %>
            <div class="message error">
                Your cart is empty. Add a product before checkout.
            </div>
        <% } else if ("stock".equals(error)) { %>
            <div class="message error">
                Checkout could not be completed. A product's stock or
                availability may have changed. Review your cart and try again.
            </div>
        <% } else if ("processing".equals(error)) { %>
            <div class="message error">
                We could not process your order. Please review your cart
                and try again.
            </div>
        <% } %>

        <% if (items == null || items.isEmpty()) { %>
            <p>Your cart is empty.</p>
            <div class="actions">
                <a class="btn"
                   href="<%= request.getContextPath() %>/customer-marketplace">
                    Browse Products
                </a>
                <a class="btn secondary"
                   href="<%= request.getContextPath() %>/cart">
                    Back to Cart
                </a>
            </div>

        <% } else { %>

            <% for (CartProduct item : items) { %>
                <div class="item">
                    <div class="item-name">
                        <%= escapeHtml(item.getName()) %>
                    </div>

                    <div class="muted">
                        Price: ₹<%= item.getPrice().toPlainString() %>
                        &nbsp; | &nbsp;
                        Quantity: <%= item.getQuantity() %>
                    </div>

                    <div class="muted">
                        Subtotal: ₹<%= item.getPrice()
                            .multiply(BigDecimal.valueOf(item.getQuantity()))
                            .toPlainString() %>
                    </div>

                    <% if (cityId != null
                            && item.getSellerCityId() != cityId) { %>
                        <div class="message error">
                            This product is not available in your city.
                            Remove it from your cart to continue.
                        </div>
                    <% } else if (item.getQuantity() > item.getStock()) { %>
                        <div class="message error">
                            Only <%= item.getStock() %> units are currently
                            available. Update the quantity in your cart.
                        </div>
                    <% } %>
                </div>
            <% } %>

            <div class="total">
                <span>Total Amount</span>
                <span>₹<%= total.toPlainString() %></span>
            </div>

            <form method="post"
                  action="<%= request.getContextPath() %>/checkout">
                <div class="actions">
                    <a class="btn secondary"
                       href="<%= request.getContextPath() %>/cart">
                        Back to Cart
                    </a>

                    <button class="btn" type="submit"
                            <%= canCheckout ? "" : "disabled" %>>
                        Confirm Order
                    </button>
                    
                </div>
            </form>


<a href="${pageContext.request.contextPath}/checkout?payment=demo"
   class="proceed-payment-btn">
    💳 Proceed to Demo Payment →
</a>


        <% } %>
    <% } %>

</div>
</body>
</html>
