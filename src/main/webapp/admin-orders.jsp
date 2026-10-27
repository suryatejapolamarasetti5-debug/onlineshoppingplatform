
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

    List<Map<String, Object>> orders =
        (List<Map<String, Object>>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>View Orders | CityShop</title>
<style>
    body { margin: 0; font-family: Arial, sans-serif;
           background: #f4f6fb; color: #263247; }
    header { background: #263b80; color: white; padding: 20px 5%;
             display: flex; justify-content: space-between;
             align-items: center; flex-wrap: wrap; gap: 12px; }
    header a, .back { color: white; text-decoration: none; }
    main { max-width: 1150px; margin: 30px auto; padding: 0 16px; }
    .panel { background: white; padding: 22px; border-radius: 12px;
             box-shadow: 0 3px 12px #0000000d; overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; min-width: 700px; }
    th, td { padding: 13px; text-align: left;
             border-bottom: 1px solid #e5e8ef; }
    th { background: #eef1fa; }
    .back { display: inline-block; background: #263b80;
            padding: 10px 14px; border-radius: 6px; margin-bottom: 18px; }
</style>
</head>
<body>
<header>
    <h2>CityShop — View Orders</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back" href="<%= request.getContextPath() %>/admin-dashboard">
        ← Back to Dashboard
    </a>

    <section class="panel">
        <h2>All Customer Orders</h2>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <% if (orders != null && !orders.isEmpty()) {
                   for (Map<String, Object> order : orders) { %>
                <tr>
                    <td><%= order.get("orderId") %></td>
                    <td><%= order.get("customerName") == null
                            ? "Customer unavailable" : order.get("customerName") %></td>
                    <td><%= order.get("orderDate") == null
                            ? "—" : order.get("orderDate") %></td>
                    <td>₹<%= order.get("totalAmount") == null
                            ? "0.00" : order.get("totalAmount") %></td>
                    <td><%= order.get("orderStatus") == null
                            ? "Unknown" : order.get("orderStatus") %></td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="5">No orders found.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
