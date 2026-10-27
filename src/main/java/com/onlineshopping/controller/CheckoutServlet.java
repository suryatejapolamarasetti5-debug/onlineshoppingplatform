
package com.onlineshopping.controller;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    public static class CartProduct {
        int productId;
        int quantity;
        int stock;
        int sellerCityId;
        String name;
        BigDecimal price;

        CartProduct(int productId, int quantity, int stock,
                    int sellerCityId, String name, BigDecimal price) {
            this.productId = productId;
            this.quantity = quantity;
            this.stock = stock;
            this.sellerCityId = sellerCityId;
            this.name = name;
            this.price = price;
        }
        public int getProductId() { return productId; }
        public int getQuantity() { return quantity; }
        public int getStock() { return stock; }
        public int getSellerCityId() { return sellerCityId; }
        public String getName() { return name; }
        public BigDecimal getPrice() { return price; }
    }

    private int[] getCustomerInfo(String username) throws Exception {
        String sql = "SELECT c.customer_id, c.city_id "
                   + "FROM user_account u "
                   + "JOIN customer c ON c.customer_id = u.user_id "
                   + "WHERE u.username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new int[] {
                        rs.getInt("customer_id"),
                        rs.getInt("city_id")
                    };
                }
            }
        }

        return null;
    }

    private String getCustomerUsername(HttpServletRequest request,
                                       HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("username") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return null;
        }

        String role = String.valueOf(session.getAttribute("role"));

        if (!"CUSTOMER".equalsIgnoreCase(role)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Only customers can checkout.");
            return null;
        }

        return String.valueOf(session.getAttribute("username"));
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String username = getCustomerUsername(request, response);
        if (username == null) return;

        try {
            int[] info = getCustomerInfo(username);

            if (info == null) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/customer-dashboard.jsp?error=customer");
                return;
            }

            int customerId = info[0];
            int cityId = info[1];

            List<CartProduct> items = new ArrayList<>();
            BigDecimal total = BigDecimal.ZERO;

            String sql = "SELECT ci.product_id, ci.quantity, "
                       + "p.product_name, p.price, "
                       + "p.stock_quantity, s.city_id "
                       + "FROM cart_item ci "
                       + "JOIN product p ON p.product_id = ci.product_id "
                       + "JOIN seller s ON s.seller_id = p.seller_id "
                       + "WHERE ci.customer_id = ? "
                       + "ORDER BY ci.cart_item_id";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, customerId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        CartProduct item = new CartProduct(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("stock_quantity"),
                            rs.getInt("city_id"),
                            rs.getString("product_name"),
                            rs.getBigDecimal("price")
                        );

                        items.add(item);

                        if (item.sellerCityId == cityId) {
                            total = total.add(
                                item.price.multiply(
                                    BigDecimal.valueOf(item.quantity)));
                        }
                    }
                }
            }


request.setAttribute("cartItems", items);
request.setAttribute("cartTotal", total);
request.setAttribute("customerCityId", cityId);

// Open the demo payment page only when requested.
// This does not create an order or change product stock.
if ("demo".equals(request.getParameter("payment"))) {
    request.getRequestDispatcher("/payment.jsp")
           .forward(request, response);
} else {
    request.getRequestDispatcher("/checkout.jsp")
           .forward(request, response);
}

        } catch (Exception e) {
            throw new ServletException("Unable to load checkout.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = getCustomerUsername(request, response);
        if (username == null) return;

        String redirect = request.getContextPath() + "/checkout";

        try {
            int[] info = getCustomerInfo(username);

            if (info == null) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/customer-dashboard.jsp?error=customer");
                return;
            }

            int customerId = info[0];
            int cityId = info[1];

            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                try {
                    List<CartProduct> items = new ArrayList<>();

                    String cartSql =
                        "SELECT ci.product_id, ci.quantity, "
                      + "p.product_name, p.price, p.stock_quantity, "
                      + "s.city_id "
                      + "FROM cart_item ci "
                      + "JOIN product p ON p.product_id = ci.product_id "
                      + "JOIN seller s ON s.seller_id = p.seller_id "
                      + "WHERE ci.customer_id = ? "
                      + "FOR UPDATE";

                    try (PreparedStatement ps =
                             con.prepareStatement(cartSql)) {
                        ps.setInt(1, customerId);

                        try (ResultSet rs = ps.executeQuery()) {
                            while (rs.next()) {
                                items.add(new CartProduct(
                                    rs.getInt("product_id"),
                                    rs.getInt("quantity"),
                                    rs.getInt("stock_quantity"),
                                    rs.getInt("city_id"),
                                    rs.getString("product_name"),
                                    rs.getBigDecimal("price")
                                ));
                            }
                        }
                    }

                    if (items.isEmpty()) {
                        con.rollback();
                        response.sendRedirect(
                            redirect + "?error=empty");
                        return;
                    }

                    BigDecimal total = BigDecimal.ZERO;

                    for (CartProduct item : items) {
                        if (item.sellerCityId != cityId) {
                            throw new IllegalStateException(
                                "A cart item is outside your city.");
                        }

                        if (item.quantity < 1
                                || item.quantity > item.stock) {
                            throw new IllegalStateException(
                                "Insufficient stock for "
                                + item.name);
                        }

                        total = total.add(
                            item.price.multiply(
                                BigDecimal.valueOf(item.quantity)));
                    }

                    int orderId;

                    String orderSql =
                        "INSERT INTO `orders` "
                      + "(customer_id, total_amount, order_status) "
                      + "VALUES (?, ?, 'PLACED')";

                    try (PreparedStatement ps = con.prepareStatement(
                            orderSql, Statement.RETURN_GENERATED_KEYS)) {

                        ps.setInt(1, customerId);
                        ps.setBigDecimal(2, total);
                        ps.executeUpdate();

                        try (ResultSet keys = ps.getGeneratedKeys()) {
                            if (!keys.next()) {
                                throw new IllegalStateException(
                                    "Order ID was not generated.");
                            }
                            orderId = keys.getInt(1);
                        }
                    }

                    String itemSql =
                        "INSERT INTO order_item "
                      + "(order_id, product_id, quantity, price) "
                      + "VALUES (?, ?, ?, ?)";

                    String stockSql =
                        "UPDATE product "
                      + "SET stock_quantity = stock_quantity - ? "
                      + "WHERE product_id = ? AND stock_quantity >= ?";

                    try (PreparedStatement itemPs =
                             con.prepareStatement(itemSql);
                         PreparedStatement stockPs =
                             con.prepareStatement(stockSql)) {

                        for (CartProduct item : items) {
                            stockPs.setInt(1, item.quantity);
                            stockPs.setInt(2, item.productId);
                            stockPs.setInt(3, item.quantity);

                            if (stockPs.executeUpdate() != 1) {
                                throw new IllegalStateException(
                                    "Stock changed. Please try again.");
                            }

                            itemPs.setInt(1, orderId);
                            itemPs.setInt(2, item.productId);
                            itemPs.setInt(3, item.quantity);
                            itemPs.setBigDecimal(4, item.price);
                            itemPs.executeUpdate();
                        }
                    }

                    String deleteSql =
                        "DELETE FROM cart_item WHERE customer_id = ?";

                    try (PreparedStatement ps =
                             con.prepareStatement(deleteSql)) {
                        ps.setInt(1, customerId);
                        ps.executeUpdate();
                    }

                    con.commit();
                    response.sendRedirect(redirect + "?success=1");
                    return;

                } catch (Exception e) {
                    con.rollback();
                    throw e;
                } finally {
                    con.setAutoCommit(true);
                }
            }

        } catch (IllegalStateException e) {
            response.sendRedirect(redirect + "?error=stock");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(redirect + "?error=processing");
        }
    }
}
