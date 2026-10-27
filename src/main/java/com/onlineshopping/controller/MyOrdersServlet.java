
package com.onlineshopping.controller;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String role = String.valueOf(session.getAttribute("role"));

        if (!"CUSTOMER".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                               "Only customers can view orders.");
            return;
        }

        String username = String.valueOf(session.getAttribute("username"));

        String customerSql =
            "SELECT c.customer_id FROM user_account u "
          + "JOIN customer c ON c.customer_id = u.user_id "
          + "WHERE u.username = ?";

        String ordersSql =
            "SELECT o.order_id, o.order_date, o.total_amount, "
          + "o.order_status, oi.product_id, oi.quantity, oi.price, "
          + "p.product_name "
          + "FROM `orders` o "
          + "JOIN order_item oi ON oi.order_id = o.order_id "
          + "JOIN product p ON p.product_id = oi.product_id "
          + "WHERE o.customer_id = ? "
          + "ORDER BY o.order_date DESC, o.order_id DESC, p.product_name";

        List<Map<String, Object>> orders = new ArrayList<>();
        Map<Integer, Map<String, Object>> orderMap = new LinkedHashMap<>();

        try (Connection con = DBConnection.getConnection()) {

            int customerId;

            try (PreparedStatement ps = con.prepareStatement(customerSql)) {
                ps.setString(1, username);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendRedirect(
                            request.getContextPath()
                            + "/customer-dashboard.jsp?error=customer");
                        return;
                    }
                    customerId = rs.getInt("customer_id");
                }
            }

            try (PreparedStatement ps = con.prepareStatement(ordersSql)) {
                ps.setInt(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int orderId = rs.getInt("order_id");

                        Map<String, Object> order = orderMap.get(orderId);

                        if (order == null) {
                            order = new LinkedHashMap<>();
                            order.put("orderId", orderId);
                            order.put("orderDate", rs.getTimestamp("order_date"));
                            order.put("totalAmount", rs.getBigDecimal("total_amount"));
                            order.put("orderStatus", rs.getString("order_status"));
                            order.put("items", new ArrayList<Map<String, Object>>());

                            orderMap.put(orderId, order);
                            orders.add(order);
                        }

                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> items =
                            (List<Map<String, Object>>) order.get("items");

                        Map<String, Object> item = new LinkedHashMap<>();
                        item.put("productId", rs.getInt("product_id"));
                        item.put("productName", rs.getString("product_name"));
                        item.put("quantity", rs.getInt("quantity"));
                        item.put("price", rs.getBigDecimal("price"));

                        items.add(item);
                    }
                }
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/my-orders.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Unable to load customer orders.", e);
        }
    }
}
