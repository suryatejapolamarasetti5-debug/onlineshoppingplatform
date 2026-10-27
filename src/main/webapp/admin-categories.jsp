
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

    List<Map<String, Object>> categories =
        (List<Map<String, Object>>) request.getAttribute("categories");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Manage Categories | CityShop</title>
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
        max-width: 950px;
        margin: 30px auto;
        padding: 0 16px;
    }
    .panel {
        background: white;
        padding: 22px;
        border-radius: 12px;
        box-shadow: 0 3px 12px #0000000d;
        margin-bottom: 22px;
    }
    input {
        width: 100%;
        box-sizing: border-box;
        padding: 12px;
        border: 1px solid #ccd2df;
        border-radius: 7px;
        margin: 8px 0 14px;
    }
    button {
        padding: 11px 18px;
        background: #263b80;
        color: white;
        border: none;
        border-radius: 7px;
        cursor: pointer;
    }
    table {
        width: 100%;
        border-collapse: collapse;
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
    .message {
        padding: 12px;
        border-radius: 7px;
        margin-bottom: 15px;
    }
    .success { background: #e4f7e9; color: #176b32; }
    .error { background: #ffebeb; color: #a12626; }
</style>
</head>
<body>
<header>
    <h2>CityShop — Manage Categories</h2>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</header>

<main>
    <a class="back"
       href="<%= request.getContextPath() %>/admin-dashboard">
       ← Back to Dashboard
    </a>

    <% if ("added".equals(success)) { %>
        <div class="message success">Category added successfully.</div>
    <% } %>

    <% if ("empty".equals(error)) { %>
        <div class="message error">Enter a category name.</div>
    <% } else if ("length".equals(error)) { %>
        <div class="message error">Category name must be at most 100 characters.</div>
    <% } else if ("duplicate".equals(error)) { %>
        <div class="message error">That category already exists.</div>
    <% } %>

    <section class="panel">
        <h2>Add New Category</h2>
        <form method="post"
              action="<%= request.getContextPath() %>/admin-categories">
            <label for="categoryName">Category name</label>
            <input type="text" id="categoryName" name="categoryName"
                   maxlength="100" required
                   placeholder="Example: Home Appliances">
            <button type="submit">Add Category</button>
        </form>
    </section>

    <section class="panel">
        <h2>Existing Categories</h2>
        <table>
            <thead>
                <tr>
                    <th>Category ID</th>
                    <th>Category Name</th>
                </tr>
            </thead>
            <tbody>
            <% if (categories != null && !categories.isEmpty()) {
                   for (Map<String, Object> category : categories) { %>
                <tr>
                    <td><%= category.get("categoryId") %></td>
                    <td><%= category.get("categoryName") %></td>
                </tr>
            <%     }
               } else { %>
                <tr>
                    <td colspan="2">No categories found.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
