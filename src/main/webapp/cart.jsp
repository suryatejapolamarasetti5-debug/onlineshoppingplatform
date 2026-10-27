
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f4f6f8; color: #1f2937; }
        header { background: #1f2937; color: white; padding: 20px 35px; }
        .container { width: 92%; max-width: 950px; margin: 30px auto; }
        .item { background: white; padding: 20px; margin-bottom: 15px; border-radius: 9px; box-shadow: 0 2px 8px #0001; }
        .row { display: flex; justify-content: space-between; align-items: center; gap: 15px; flex-wrap: wrap; }
        input { padding: 8px; width: 65px; }
        button, .btn { border: 0; padding: 10px 15px; background: #2563eb; color: white; border-radius: 5px; text-decoration: none; cursor: pointer; }
        .remove { background: #dc2626; }
        .total { background: white; padding: 22px; border-radius: 9px; font-size: 22px; font-weight: bold; }
        .empty { background: white; padding: 35px; text-align: center; border-radius: 9px; }
        .links { margin-top: 20px; display: flex; gap: 10px; flex-wrap: wrap; }
    </style>
</head>
<body>
<header><h1>My Shopping Cart</h1></header>

<div class="container">
    <%
        List<Map<String, Object>> items =
            (List<Map<String, Object>>) request.getAttribute("cartItems");
        double total = request.getAttribute("cartTotal") == null
            ? 0 : (Double) request.getAttribute("cartTotal");
    %>

    <% if (items != null && !items.isEmpty()) { %>

        <% for (Map<String, Object> item : items) { %>
            <div class="item">
                <h3><%= item.get("productName") %></h3>
                <p>Price: ₹<%= item.get("price") %></p>
                <p>Subtotal: ₹<%= item.get("subtotal") %></p>
                <p>Available stock: <%= item.get("stock") %></p>

                <div class="row">
                    <form method="post"
                          action="${pageContext.request.contextPath}/cart">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="cartItemId"
                               value="<%= item.get("cartItemId") %>">
                        <label>Quantity:
                            <input type="number" name="quantity"
                                   min="1" max="<%= item.get("stock") %>"
                                   value="<%= item.get("quantity") %>" required>
                        </label>
                        <button type="submit">Update</button>
                    </form>

                    <form method="post"
                          action="${pageContext.request.contextPath}/cart">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="cartItemId"
                               value="<%= item.get("cartItemId") %>">
                        <button class="remove" type="submit">Remove</button>
                    </form>
                </div>
            </div>
        <% } %>

        <div class="total">Cart Total: ₹<%= String.format("%.2f", total) %></div>

        <div class="links">
            <a class="btn"
               href="${pageContext.request.contextPath}/checkout">
                Proceed to Checkout
            </a>
            <a class="btn"
               href="${pageContext.request.contextPath}/customer-marketplace">
                Continue Shopping
            </a>
        </div>

    <% } else { %>
        <div class="empty">
            <h2>Your cart is empty</h2>
            <p>Add products from your city's marketplace to get started.</p>
            <a class="btn"
               href="${pageContext.request.contextPath}/customer-marketplace">
                Browse Marketplace
            </a>
        </div>
    <% } %>
</div>
</body>
</html>
