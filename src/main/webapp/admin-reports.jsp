
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("username") == null
            || !"ADMIN".equalsIgnoreCase(
                String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Object totalSales = request.getAttribute("totalSales");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Admin Reports | CityShop</title>
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
        max-width: 1050px;
        margin: 30px auto;
        padding: 0 16px;
    }
    .back {
        display: inline-block;
        background: #263b80;
        padding: 10px 14px;
        border-radius: 6px;
        margin-bottom: 20px;
    }
    .grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
        gap: 18px;
    }
    .card {
        background: white;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 3px 12px #0000000d;
        border-left: 5px solid #526bd1;
    }
    .card p {
        margin: 0 0 12px;
        color: #64708a;
    }
    .card h2 {
        margin: 0;
        font-size: 28px;
    }
    .note {
        color: #64708a;
        font-size: 14px;
        margin-top: 22px;
    }
</style>
</head>
<body>
<header>
    <h2>CityShop — Admin Reports</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back" href="<%= request.getContextPath() %>/admin-dashboard">
        ← Back to Dashboard
    </a>

    <h2>Platform Overview</h2>
    <p>Current totals from the CityShop database.</p>

    <section class="grid">
        <div class="card">
            <p>Total Users</p>
            <h2><%= request.getAttribute("totalUsers") %></h2>
        </div>
        <div class="card">
            <p>Registered Sellers</p>
            <h2><%= request.getAttribute("totalSellers") %></h2>
        </div>
        <div class="card">
            <p>Registered Customers</p>
            <h2><%= request.getAttribute("totalCustomers") %></h2>
        </div>
        <div class="card">
            <p>Total Products</p>
            <h2><%= request.getAttribute("totalProducts") %></h2>
        </div>
        <div class="card">
            <p>Total Categories</p>
            <h2><%= request.getAttribute("totalCategories") %></h2>
        </div>
        <div class="card">
            <p>Total Orders</p>
            <h2><%= request.getAttribute("totalOrders") %></h2>
        </div>
        <div class="card">
            <p>Total Order Amount</p>
            <h2>₹<%= totalSales == null ? "0.00" : totalSales %></h2>
        </div>
    </section>

    <p class="note">
        Note: Total Order Amount is the sum of total_amount for all
        orders, regardless of order status. It is not necessarily
        the same as completed revenue.
    </p>
</main>
</body>
</html>
