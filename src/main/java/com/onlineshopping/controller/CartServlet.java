
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Integer getCustomerId(String username)
            throws SQLException {

        String sql = "SELECT c.customer_id FROM customer c "
                   + "JOIN user_account u ON u.user_id = c.customer_id "
                   + "WHERE u.username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("customer_id");
                }
            }
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("username") == null
                || !"CUSTOMER".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String username = (String) session.getAttribute("username");

        try {
            Integer customerId = getCustomerId(username);

            if (customerId == null) {
                response.sendError(403, "Customer profile not found.");
                return;
            }

            if ("add".equals(action)) {
                addToCart(request, response, customerId);
                return;
            }

            String sql =
                    "SELECT ci.cart_item_id, ci.product_id, "
                  + "ci.quantity, p.product_name, p.price, "
                  + "p.stock_quantity "
                  + "FROM cart_item ci "
                  + "JOIN product p ON p.product_id = ci.product_id "
                  + "JOIN seller s ON s.seller_id = p.seller_id "
                  + "JOIN customer c ON c.customer_id = ci.customer_id "
                  + "WHERE ci.customer_id = ? AND s.city_id = c.city_id "
                  + "ORDER BY ci.cart_item_id DESC";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    java.util.List<java.util.Map<String, Object>> items =
                            new java.util.ArrayList<>();

                    double total = 0;

                    while (rs.next()) {
                        java.util.Map<String, Object> item =
                                new java.util.HashMap<>();

                        int quantity = rs.getInt("quantity");
                        double price = rs.getDouble("price");

                        item.put("cartItemId",
                                rs.getInt("cart_item_id"));
                        item.put("productId",
                                rs.getInt("product_id"));
                        item.put("productName",
                                rs.getString("product_name"));
                        item.put("price", price);
                        item.put("quantity", quantity);
                        item.put("stock",
                                rs.getInt("stock_quantity"));
                        item.put("subtotal", price * quantity);

                        total += price * quantity;
                        items.add(item);
                    }

                    request.setAttribute("cartItems", items);
                    request.setAttribute("cartTotal", total);
                }
            }

            request.getRequestDispatcher("/cart.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load cart.", e);
        }
    }

    private void addToCart(HttpServletRequest request,
                           HttpServletResponse response,
                           int customerId)
            throws IOException, SQLException {

        int productId;

        try {
            productId = Integer.parseInt(
                    request.getParameter("productId"));
            if (productId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid product ID.");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            try {
                String checkSql =
                        "SELECT p.stock_quantity "
                      + "FROM product p "
                      + "JOIN seller s ON s.seller_id = p.seller_id "
                      + "JOIN customer c ON c.city_id = s.city_id "
                      + "WHERE p.product_id = ? "
                      + "AND c.customer_id = ? "
                      + "FOR UPDATE";

                int stock;

                try (PreparedStatement ps =
                        con.prepareStatement(checkSql)) {
                    ps.setInt(1, productId);
                    ps.setInt(2, customerId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            response.sendError(404,
                                    "Product is not available in your city.");
                            return;
                        }
                        stock = rs.getInt("stock_quantity");
                    }
                }

                if (stock <= 0) {
                    con.rollback();
                    response.sendError(409, "Product is out of stock.");
                    return;
                }

                String existingSql =
                        "SELECT quantity FROM cart_item "
                      + "WHERE customer_id = ? AND product_id = ? "
                      + "FOR UPDATE";

                Integer existingQuantity = null;

                try (PreparedStatement ps =
                        con.prepareStatement(existingSql)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, productId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            existingQuantity = rs.getInt("quantity");
                        }
                    }
                }

                if (existingQuantity != null) {
                    if (existingQuantity >= stock) {
                        con.rollback();
                        response.sendRedirect(
                                request.getContextPath() + "/cart?error=stock");
                        return;
                    }

                    String updateSql =
                            "UPDATE cart_item SET quantity = quantity + 1 "
                          + "WHERE customer_id = ? AND product_id = ?";

                    try (PreparedStatement ps =
                            con.prepareStatement(updateSql)) {
                        ps.setInt(1, customerId);
                        ps.setInt(2, productId);
                        ps.executeUpdate();
                    }

                } else {
                    String insertSql =
                            "INSERT INTO cart_item "
                          + "(customer_id, product_id, quantity) "
                          + "VALUES (?, ?, 1)";

                    try (PreparedStatement ps =
                            con.prepareStatement(insertSql)) {
                        ps.setInt(1, customerId);
                        ps.setInt(2, productId);
                        ps.executeUpdate();
                    }
                }

                con.commit();

            } catch (SQLException e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("username") == null
                || !"CUSTOMER".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String username = (String) session.getAttribute("username");

        try {
            Integer customerId = getCustomerId(username);

            if (customerId == null) {
                response.sendError(403, "Customer profile not found.");
                return;
            }

            int cartItemId = Integer.parseInt(
                    request.getParameter("cartItemId"));

            if ("remove".equals(action)) {
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(
                         "DELETE FROM cart_item "
                       + "WHERE cart_item_id = ? AND customer_id = ?")) {
                    ps.setInt(1, cartItemId);
                    ps.setInt(2, customerId);
                    ps.executeUpdate();
                }

            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(
                        request.getParameter("quantity"));

                if (quantity < 1) {
                    response.sendError(400, "Quantity must be at least 1.");
                    return;
                }

                String sql =
                        "UPDATE cart_item ci "
                      + "JOIN product p ON p.product_id = ci.product_id "
                      + "JOIN seller s ON s.seller_id = p.seller_id "
                      + "JOIN customer c ON c.customer_id = ci.customer_id "
                      + "SET ci.quantity = ? "
                      + "WHERE ci.cart_item_id = ? "
                      + "AND ci.customer_id = ? "
                      + "AND s.city_id = c.city_id "
                      + "AND ? <= p.stock_quantity";

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, quantity);
                    ps.setInt(2, cartItemId);
                    ps.setInt(3, customerId);
                    ps.setInt(4, quantity);

                    if (ps.executeUpdate() == 0) {
                        response.sendRedirect(
                                request.getContextPath() + "/cart?error=stock");
                        return;
                    }
                }

            } else {
                response.sendError(400, "Invalid cart action.");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/cart");

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid cart value.");
        } catch (SQLException e) {
            throw new ServletException("Unable to update cart.", e);
        }
    }
}
