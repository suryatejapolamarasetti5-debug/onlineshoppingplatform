
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-orders")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("username") == null
                || !"ADMIN".equalsIgnoreCase(
                    String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String sql = """
            SELECT o.order_id, o.order_date, o.total_amount,
                   o.order_status, c.full_name
            FROM orders o
            LEFT JOIN customer c ON o.customer_id = c.customer_id
            ORDER BY o.order_date DESC, o.order_id DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> orders = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> order = new LinkedHashMap<>();
                order.put("orderId", rs.getInt("order_id"));
                order.put("orderDate", rs.getTimestamp("order_date"));
                order.put("totalAmount", rs.getBigDecimal("total_amount"));
                order.put("orderStatus", rs.getString("order_status"));
                order.put("customerName", rs.getString("full_name"));
                orders.add(order);
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin-orders.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load orders.", e);
        }
    }
}
