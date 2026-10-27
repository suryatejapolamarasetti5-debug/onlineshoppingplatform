
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = String.valueOf(session.getAttribute("username"));
    String role = String.valueOf(session.getAttribute("role"));
    String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seller Dashboard | CityShop</title>

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

    /* Navigation bar */
    .navbar {
        background: #142b4a;
        color: white;
        padding: 0 5%;
        min-height: 72px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
        box-shadow: 0 3px 12px rgba(15, 23, 42, 0.15);
    }

    .brand {
        font-size: 25px;
        font-weight: 800;
        letter-spacing: 0.5px;
        white-space: nowrap;
    }

    .brand span {
        color: #38bdf8;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }

    .nav-links a {
        color: #e2e8f0;
        text-decoration: none;
        padding: 12px 14px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        transition: 0.2s;
    }

    .nav-links a:hover,
    .nav-links a.active {
        background: #294766;
        color: white;
    }

    .nav-links .nav-logout {
        background: #dc2626;
        color: white;
    }

    .nav-links .nav-logout:hover {
        background: #b91c1c;
    }

    /* Main content */
    .container {
        width: 90%;
        max-width: 1200px;
        margin: 35px auto;
    }

    .welcome {
        background: linear-gradient(120deg, #1d4ed8, #0e7490);
        color: white;
        padding: 35px;
        border-radius: 18px;
        margin-bottom: 30px;
        box-shadow: 0 8px 22px rgba(37, 99, 235, 0.15);
    }

    .welcome h1 {
        font-size: 30px;
        margin-bottom: 12px;
    }

    .welcome p {
        color: #e0f2fe;
        line-height: 1.7;
    }

    .role-badge {
        display: inline-block;
        margin-top: 16px;
        background: rgba(255, 255, 255, 0.18);
        border: 1px solid rgba(255, 255, 255, 0.35);
        padding: 7px 13px;
        border-radius: 30px;
        font-size: 12px;
        font-weight: bold;
        letter-spacing: 1px;
    }

    .section-heading {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }

    .section-heading h2 {
        font-size: 23px;
    }

    .section-heading p {
        color: #64748b;
        font-size: 14px;
        margin-top: 5px;
    }

    /* Dashboard cards */
    .cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(235px, 1fr));
        gap: 22px;
    }

    .card {
        background: white;
        border: 1px solid #e5eaf2;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 4px 12px rgba(15, 23, 42, 0.04);
        transition: transform 0.2s, box-shadow 0.2s;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(15, 23, 42, 0.09);
    }

    .card-icon {
        width: 52px;
        height: 52px;
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 13px;
        font-size: 25px;
        margin-bottom: 18px;
    }

    .blue { background: #dbeafe; }
    .green { background: #d1fae5; }
    .orange { background: #ffedd5; }
    .purple { background: #ede9fe; }
    .red { background: #fee2e2; }

    .card h3 {
        font-size: 19px;
        margin-bottom: 10px;
    }

    .card p {
        color: #64748b;
        font-size: 14px;
        line-height: 1.7;
        margin-bottom: 22px;
        flex-grow: 1;
    }

    /* Action buttons */
    .btn {
        display: inline-flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
        padding: 11px 17px;
        border-radius: 8px;
        background: #2563eb;
        color: white;
        text-decoration: none;
        font-size: 14px;
        font-weight: 700;
        transition: background 0.2s;
    }

    .btn:hover {
        background: #1d4ed8;
    }

    .btn-green { background: #059669; }
    .btn-green:hover { background: #047857; }

    .btn-orange { background: #ea580c; }
    .btn-orange:hover { background: #c2410c; }

    .btn-purple { background: #7c3aed; }
    .btn-purple:hover { background: #6d28d9; }

    .btn-red { background: #dc2626; }
    .btn-red:hover { background: #b91c1c; }

    .quick-actions {
        margin-top: 32px;
        background: white;
        padding: 25px;
        border-radius: 15px;
        border: 1px solid #e5eaf2;
    }

    .quick-actions h2 {
        font-size: 20px;
        margin-bottom: 18px;
    }

    .action-buttons {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
    }

    .footer {
        text-align: center;
        padding: 25px 15px;
        margin-top: 40px;
        color: #64748b;
        font-size: 13px;
        border-top: 1px solid #e2e8f0;
    }

    @media (max-width: 700px) {
        .navbar {
            padding: 18px 5%;
        }

        .nav-links {
            width: 100%;
            gap: 5px;
        }

        .nav-links a {
            padding: 10px;
            font-size: 13px;
        }

        .container {
            width: 92%;
            margin: 22px auto;
        }

        .welcome {
            padding: 25px 20px;
        }

        .welcome h1 {
            font-size: 25px;
        }

        .cards {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>

<body>

<!-- Top navigation -->
<nav class="navbar">
    <div class="brand">City<span>Shop</span></div>

    <div class="nav-links">
        <a class="active"
           href="<%= cp %>/seller-dashboard.jsp">Dashboard</a>

        <a href="<%= cp %>/seller-products">My Products</a>

        <a href="<%= cp %>/add-product.jsp">Add Product</a>

        <a href="<%= cp %>/seller-orders">Orders</a>

        <a class="nav-logout"
           href="<%= cp %>/logout">Logout</a>
    </div>
</nav>

<main class="container">

    <!-- Welcome section -->
    <section class="welcome">
        <h1>Welcome back, <%= username %>! 👋</h1>

        <p>
            Manage your CityShop business from one place.
            Add products, update stock and keep track of customer orders.
        </p>

        <span class="role-badge">
            <%= role %> ACCOUNT
        </span>
    </section>

    <!-- Dashboard cards -->
    <section>
        <div class="section-heading">
            <div>
                <h2>Your Shop at a Glance</h2>
                <p>Choose an action to manage your online store.</p>
            </div>
        </div>

        <div class="cards">

            <article class="card">
                <div class="card-icon blue">📦</div>
                <h3>My Products</h3>
                <p>
                    View your listed products and manage their
                    details, prices and available quantities.
                </p>
                <a class="btn"
                   href="<%= cp %>/seller-products">
                    View Products →
                </a>
            </article>

            <article class="card">
                <div class="card-icon green">➕</div>
                <h3>Add New Product</h3>
                <p>
                    Add a new item to your shop with its name,
                    category, description, price and stock.
                </p>
                <a class="btn btn-green"
                   href="<%= cp %>/add-product.jsp">
                    + Add Product
                </a>
            </article>

            <article class="card">
                <div class="card-icon orange">✏️</div>
                <h3>Update Products</h3>
                <p>
                    Keep product information and prices accurate.
                    Update stock when inventory changes.
                </p>
                <a class="btn btn-orange"
                   href="<%= cp %>/seller-products">
                    Manage Products →
                </a>
            </article>

            <article class="card">
                <div class="card-icon purple">🛍️</div>
                <h3>Customer Orders</h3>
                <p>
                    Open the order management page to review
                    customer purchases, if order management is enabled.
                </p>
                <a class="btn btn-purple"
                   href="<%= cp %>/seller-orders">
                    View Orders →
                </a>
            </article>

        </div>
    </section>

    <!-- Quick action buttons -->
    <section class="quick-actions">
        <h2>Quick Actions</h2>

        <div class="action-buttons">
            <a class="btn btn-green"
               href="<%= cp %>/add-product.jsp">
                + Add Product
            </a>

            <a class="btn"
               href="<%= cp %>/seller-products">
                📋 Manage Inventory
            </a>

            <a class="btn btn-purple"
               href="<%= cp %>/seller-orders">
                🛒 Orders
            </a>

            <a class="btn btn-red"
               href="<%= cp %>/logout">
                ↪ Logout
            </a>
        </div>
    </section>

</main>

<footer class="footer">
    &copy; 2026 CityShop. Seller Dashboard.
</footer>

</body>
</html>
