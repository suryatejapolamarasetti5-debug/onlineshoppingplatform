
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

    List<Map<String, Object>> customers =
        (List<Map<String, Object>>) request.getAttribute("customers");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manage Customers | CityShop</title>
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
    <h2>CityShop — Manage Customers</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back"
       href="<%= request.getContextPath() %>/admin-dashboard">
       ← Back to Dashboard
    </a>

    <section class="panel">
        <h2>Registered Customers</h2>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>City ID</th>
                </tr>
            </thead>
            <tbody>
            <% if (customers != null && !customers.isEmpty()) {
                   for (Map<String, Object> customer : customers) { %>
                <tr>
                    <td><%= customer.get("customerId") %></td>
                    <td><%= customer.get("fullName") %></td>
                    <td><%= customer.get("email") %></td>
                    <td><%= customer.get("phone") == null
                            ? "Not provided" : customer.get("phone") %></td>
                    <td><%= customer.get("cityId") == null
                            ? "Not assigned" : customer.get("cityId") %></td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="5">No customers registered yet.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
