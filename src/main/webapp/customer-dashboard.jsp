
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String context = request.getContextPath();
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect(context + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Customer Dashboard | CityShop</title>

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

        /* Navigation */
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
            font-weight: bold;
            transition: 0.2s;
        }

        .nav-links a:hover {
            background: #334e91;
            transform: translateY(-2px);
        }

        .nav-links a.active {
            background: #2563eb;
        }

        .nav-links a.logout {
            background: #dc2626;
        }

        .nav-links a.logout:hover {
            background: #b91c1c;
        }

        /* Main Layout */
        .container {
            max-width: 1150px;
            margin: 35px auto;
            padding: 0 20px;
        }

        /* Welcome Banner */
        .welcome-banner {
            background: linear-gradient(120deg, #1e3a8a, #2563eb);
            color: white;
            padding: 35px;
            border-radius: 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 24px;
            box-shadow: 0 8px 22px rgba(37,99,235,0.18);
        }

        .welcome-banner h1 {
            margin: 0 0 12px;
            font-size: 30px;
        }

        .welcome-banner p {
            margin: 0;
            line-height: 1.7;
            color: #dbeafe;
        }

        .welcome-icon {
            font-size: 70px;
        }

        /* Buttons */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 13px 18px;
            border-radius: 9px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn-white {
            background: white;
            color: #1d4ed8;
        }

        .btn-white:hover {
            background: #eff6ff;
        }

        .btn-blue {
            background: #2563eb;
            color: white;
        }

        .btn-blue:hover {
            background: #1d4ed8;
        }

        .btn-green {
            background: #059669;
            color: white;
        }

        .btn-green:hover {
            background: #047857;
        }

        .btn-purple {
            background: #7c3aed;
            color: white;
        }

        .btn-purple:hover {
            background: #6d28d9;
        }

        /* Section Headings */
        .section-heading {
            margin: 35px 0 20px;
        }

        .section-heading h2 {
            color: #243b70;
            margin: 0 0 8px;
            font-size: 23px;
        }

        .section-heading p {
            color: #64748b;
            margin: 0;
        }

        /* Feature Cards */
        .cards {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            border: 1px solid #e5eaf2;
            box-shadow: 0 5px 18px rgba(0,0,0,0.04);
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.09);
        }

        .card-icon {
            width: 58px;
            height: 58px;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 14px;
            font-size: 29px;
            margin-bottom: 18px;
        }

        .icon-blue {
            background: #dbeafe;
        }

        .icon-green {
            background: #d1fae5;
        }

        .icon-purple {
            background: #ede9fe;
        }

        .card h3 {
            margin: 0 0 10px;
            color: #243b70;
            font-size: 19px;
        }

        .card p {
            margin: 0 0 22px;
            color: #64748b;
            font-size: 14px;
            line-height: 1.7;
            flex-grow: 1;
        }

        /* Quick Links */
        .quick-panel {
            margin-top: 30px;
            padding: 25px;
            background: white;
            border: 1px solid #e5eaf2;
            border-radius: 15px;
        }

        .quick-panel h2 {
            margin-top: 0;
            color: #243b70;
        }

        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        /* Footer */
        .footer {
            margin-top: 45px;
            padding: 22px 15px;
            text-align: center;
            background: #172554;
            color: #cbd5e1;
            font-size: 13px;
        }

        /* Responsive Layout */
        @media (max-width: 850px) {
            .cards {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 600px) {
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
                margin: 22px auto;
                padding: 0 14px;
            }

            .welcome-banner {
                padding: 25px;
            }

            .welcome-banner h1 {
                font-size: 25px;
            }

            .welcome-icon {
                font-size: 48px;
            }

            .cards {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 22px;
            }

            .quick-actions {
                flex-direction: column;
            }

            .quick-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="brand">🛍️ CityShop</div>

    <div class="nav-links">
        <a class="active" href="<%= context %>/customer-dashboard.jsp">
            🏠 Dashboard
        </a>

        <a href="<%= context %>/customer-marketplace">
            🛒 Marketplace
        </a>

        <a href="<%= context %>/cart">
            🛍️ View Cart
        </a>

        <a href="<%= context %>/my-orders">
            📦 My Orders
        </a>

        <a class="logout" href="<%= context %>/logout">
            🚪 Logout
        </a>
    </div>
</nav>

<main class="container">

    <!-- Welcome Banner -->
    <section class="welcome-banner">
        <div>
            <h1>
                Welcome,
                <%= java.net.URLEncoder.encode(username,
                    java.nio.charset.StandardCharsets.UTF_8)
                    .replace("+", " ") %>! 👋
            </h1>

            <p>
                Welcome to CityShop — your local shopping destination.<br>
                Discover products from sellers in your city and shop with ease.
            </p>

            <br>

            <a class="btn btn-white"
               href="<%= context %>/customer-marketplace">
                🛒 Explore Marketplace →
            </a>
        </div>

        <div class="welcome-icon">🛍️</div>
    </section>

    <!-- Dashboard Features -->
    <section>
        <div class="section-heading">
            <h2>Your Shopping Dashboard</h2>
            <p>Choose an option to continue shopping or manage your purchases.</p>
        </div>

        <div class="cards">

            <article class="card">
                <div class="card-icon icon-blue">🛒</div>
                <h3>Browse Marketplace</h3>
                <p>
                    Discover products available from sellers in your city.
                    Search products and view their details before buying.
                </p>

                <a class="btn btn-blue"
                   href="<%= context %>/customer-marketplace">
                    Browse Products →
                </a>
            </article>

            <article class="card">
                <div class="card-icon icon-green">🛍️</div>
                <h3>Shopping Cart</h3>
                <p>
                    Review selected products, change quantities,
                    remove items, and check your total before checkout.
                </p>

                <a class="btn btn-green"
                   href="<%= context %>/cart">
                    Open My Cart →
                </a>
            </article>

            <article class="card">
                <div class="card-icon icon-purple">📦</div>
                <h3>My Orders</h3>
                <p>
                    View your previous orders, purchased products,
                    order dates, totals, and order statuses.
                </p>

                <a class="btn btn-purple"
                   href="<%= context %>/my-orders">
                    View Order History →
                </a>
            </article>

        </div>
    </section>

    <!-- Quick Actions -->
    <section class="quick-panel">
        <h2>Quick Actions</h2>

        <div class="quick-actions">
            <a class="btn btn-blue"
               href="<%= context %>/customer-marketplace">
                🔎 Find Products
            </a>

            <a class="btn btn-green"
               href="<%= context %>/cart">
                🛒 Review Cart
            </a>

            <a class="btn btn-purple"
               href="<%= context %>/my-orders">
                📋 Track My Orders
            </a>
        </div>
    </section>

</main>

<footer class="footer">
    © 2026 CityShop | Local Shopping Made Simple
</footer>

</body>
</html>
