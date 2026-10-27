
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/seller-orders")
public class SellerOrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String cp = request.getContextPath();

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(cp + "/login.jsp");
            return;
        }

        String username = String.valueOf(
                session.getAttribute("username"));

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            // Find the seller profile belonging to this login.
            String sellerSql =
                "SELECT s.seller_id " +
                "FROM seller s " +
                "JOIN user_account u ON u.user_id = s.seller_id " +
                "JOIN role r ON r.role_id = u.role_id " +
                "WHERE u.username = ? AND r.role_name = 'SELLER'";

            int sellerId;

            try (PreparedStatement ps =
                    con.prepareStatement(sellerSql)) {

                ps.setString(1, username);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "Seller account not found.");
                        return;
                    }

                    sellerId = rs.getInt("seller_id");
                }
            }

            // Retrieve only orders containing this seller's products.
            String orderSql =
                "SELECT o.order_id, o.order_date, o.order_status, " +
                "o.total_amount, " +
                "COUNT(DISTINCT oi.product_id) AS product_count, " +
                "SUM(oi.quantity) AS total_quantity, " +
                "SUM(oi.quantity * oi.price) AS seller_subtotal, " +
                "GROUP_CONCAT(" +
                "CONCAT(p.product_name, ' (Qty: ', oi.quantity, ')') " +
                "ORDER BY p.product_name SEPARATOR ', ' " +
                ") AS product_summary " +
                "FROM orders o " +
                "JOIN order_item oi ON oi.order_id = o.order_id " +
                "JOIN product p ON p.product_id = oi.product_id " +
                "WHERE p.seller_id = ? " +
                "GROUP BY o.order_id, o.order_date, " +
                "o.order_status, o.total_amount " +
                "ORDER BY o.order_date DESC, o.order_id DESC";

            List<Map<String, Object>> orders = new ArrayList<>();

            try (PreparedStatement ps =
                    con.prepareStatement(orderSql)) {

                ps.setInt(1, sellerId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> order = new HashMap<>();

                        order.put("orderId", rs.getInt("order_id"));
                        order.put("orderDate", rs.getTimestamp("order_date"));
                        order.put("status", rs.getString("order_status"));
                        order.put("totalAmount", rs.getBigDecimal("total_amount"));
                        order.put("productCount", rs.getInt("product_count"));
                        order.put("quantity", rs.getInt("total_quantity"));
                        order.put("sellerSubtotal",
                                  rs.getBigDecimal("seller_subtotal"));
                        order.put("products", rs.getString("product_summary"));

                        orders.add(order);
                    }
                }
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/seller-orders.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load seller orders.", e);
        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (Exception e) {
                    getServletContext().log(
                        "Unable to close database connection.", e);
                }
            }
        }
    }
}
