
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null
            || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CityShop | Admin Dashboard</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3f6fb;
            color: #1e293b;
        }

        .navbar {
            background: #111827;
            color: white;
            padding: 16px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.12);
        }

        .brand {
            font-size: 25px;
            font-weight: 800;
            letter-spacing: 0.5px;
        }

        .brand span {
            color: #60a5fa;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }

        .admin-label {
            color: #cbd5e1;
            font-size: 14px;
        }

        .logout {
            text-decoration: none;
            color: white;
            background: #dc2626;
            padding: 10px 17px;
            border-radius: 8px;
            font-weight: 600;
            transition: 0.2s;
        }

        .logout:hover {
            background: #b91c1c;
        }

        .container {
            max-width: 1250px;
            margin: 35px auto;
            padding: 0 22px;
        }

        .welcome {
            background: linear-gradient(120deg, #1d4ed8, #4f46e5);
            color: white;
            padding: 32px;
            border-radius: 16px;
            margin-bottom: 30px;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.16);
        }

        .welcome h1 {
            font-size: 30px;
            margin-bottom: 10px;
        }

        .welcome p {
            color: #e0e7ff;
            line-height: 1.7;
        }

        .section-title {
            font-size: 23px;
            margin-bottom: 18px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
        }

        .admin-card {
            display: block;
            background: white;
            color: #1e293b;
            text-decoration: none;
            padding: 25px;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.04);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(15, 23, 42, 0.10);
            border-color: #93c5fd;
        }

        .card-icon {
            width: 52px;
            height: 52px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 13px;
            font-size: 26px;
            margin-bottom: 18px;
        }

        .blue   { background: #dbeafe; }
        .green  { background: #dcfce7; }
        .purple { background: #ede9fe; }
        .orange { background: #ffedd5; }
        .pink   { background: #fce7f3; }
        .teal   { background: #ccfbf1; }

        .admin-card h3 {
            font-size: 19px;
            margin-bottom: 9px;
        }

        .admin-card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
            min-height: 45px;
        }

        .card-link {
            display: inline-block;
            margin-top: 18px;
            color: #2563eb;
            font-weight: 700;
            font-size: 14px;
        }

        .footer {
            text-align: center;
            color: #64748b;
            padding: 28px 15px;
            margin-top: 30px;
            font-size: 13px;
        }

        @media (max-width: 900px) {
            .dashboard-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 560px) {
            .navbar {
                align-items: flex-start;
            }

            .nav-right {
                width: 100%;
                justify-content: space-between;
            }

            .container {
                margin-top: 22px;
                padding: 0 14px;
            }

            .welcome {
                padding: 24px;
            }

            .welcome h1 {
                font-size: 24px;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

    <nav class="navbar">
        <div class="brand">City<span>Shop</span></div>

        <div class="nav-right">
            <span class="admin-label">
                Administrator: <strong><%= username %></strong>
            </span>

            <a class="logout" href="<%= cp %>/logout">Logout</a>
        </div>
    </nav>

    <main class="container">

        <section class="welcome">
            <h1>Welcome back, <%= username %>! 👋</h1>
            <p>
                You are logged in as <strong>ADMIN</strong>.
                Manage your marketplace, monitor orders, and oversee
                customers, sellers, products, and categories from one place.
            </p>
        </section>

        <h2 class="section-title">Administration Centre</h2>

        <div class="dashboard-grid">

            <a class="admin-card" href="<%= cp %>/admin-sellers">
                <div class="card-icon blue">🏪</div>
                <h3>Manage Sellers</h3>
                <p>View registered sellers and review their shop information.</p>
                <span class="card-link">Manage Sellers →</span>
            </a>

            <a class="admin-card" href="<%= cp %>/admin-customers">
                <div class="card-icon green">👥</div>
                <h3>Manage Customers</h3>
                <p>View customer accounts and their registration details.</p>
                <span class="card-link">View Customers →</span>
            </a>

            <a class="admin-card" href="<%= cp %>/admin-products">
                <div class="card-icon purple">📦</div>
                <h3>Manage Products</h3>
                <p>Review marketplace products, prices, sellers, and stock.</p>
                <span class="card-link">View Products →</span>
            </a>

            <a class="admin-card" href="<%= cp %>/admin-categories">
                <div class="card-icon orange">🏷️</div>
                <h3>Manage Categories</h3>
                <p>View product categories and manage category information.</p>
                <span class="card-link">View Categories →</span>
            </a>

            <a class="admin-card" href="<%= cp %>/admin-orders">
                <div class="card-icon pink">🛒</div>
                <h3>Manage Orders</h3>
                <p>Inspect customer orders, order items, amounts, and status.</p>
                <span class="card-link">View Orders →</span>
            </a>

            <a class="admin-card" href="<%= cp %>/admin-reports">
                <div class="card-icon teal">📊</div>
                <h3>Reports & Analytics</h3>
                <p>Review sales summaries, order statistics, and marketplace activity.</p>
                <span class="card-link">View Reports →</span>
            </a>

        </div>
    </main>

    <footer class="footer">
        © 2026 CityShop Admin Panel | Marketplace Management System
    </footer>

</body>
</html>
