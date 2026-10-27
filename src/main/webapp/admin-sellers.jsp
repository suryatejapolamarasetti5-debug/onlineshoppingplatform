
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("username") == null
            || !"ADMIN".equalsIgnoreCase(
                String.valueOf(session.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, Object>> sellers =
        (List<Map<String, Object>>) request.getAttribute("sellers");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manage Sellers | CityShop</title>
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
        max-width: 1100px;
        margin: 30px auto;
        padding: 0 16px;
    }
    .panel {
        background: white;
        padding: 22px;
        border-radius: 12px;
        box-shadow: 0 3px 12px #0000000d;
        overflow-x: auto;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        min-width: 650px;
    }
    th, td {
        padding: 13px;
        text-align: left;
        border-bottom: 1px solid #e5e8ef;
    }
    th {
        background: #eef1fa;
    }
    .back {
        display: inline-block;
        background: #263b80;
        padding: 10px 14px;
        border-radius: 6px;
        margin-bottom: 18px;
    }
</style>
</head>
<body>
<header>
    <h2>CityShop — Manage Sellers</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back"
       href="<%= request.getContextPath() %>/admin-dashboard">
       ← Back to Dashboard
    </a>

    <section class="panel">
        <h2>Registered Sellers</h2>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Shop Name</th>
                    <th>Owner</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>City ID</th>
                </tr>
            </thead>
            <tbody>
            <% if (sellers != null && !sellers.isEmpty()) {
                   for (Map<String, Object> seller : sellers) { %>
                <tr>
                    <td><%= seller.get("sellerId") %></td>
                    <td><%= seller.get("shopName") %></td>
                    <td><%= seller.get("ownerName") %></td>
                    <td><%= seller.get("email") %></td>
                    <td><%= seller.get("phone") == null
                            ? "Not provided" : seller.get("phone") %></td>
                    <td><%= seller.get("cityId") == null
                            ? "Not assigned" : seller.get("cityId") %></td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="6">No sellers registered yet.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
