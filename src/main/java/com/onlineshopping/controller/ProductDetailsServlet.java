
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/product-details")
public class ProductDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        String idValue = request.getParameter("id");
        int productId;

        try {
            productId = Integer.parseInt(idValue);
            if (productId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid product ID.");
            return;
        }

        String sql =
                "SELECT p.product_id, p.product_name, "
              + "p.description, p.price, p.stock_quantity, "
              + "c.category_name, s.shop_name "
              + "FROM product p "
              + "JOIN category c ON p.category_id = c.category_id "
              + "JOIN seller s ON p.seller_id = s.seller_id "
              + "JOIN customer cust ON cust.city_id = s.city_id "
              + "JOIN user_account u ON u.user_id = cust.customer_id "
              + "WHERE u.username = ? "
              + "AND p.product_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, (String) session.getAttribute("username"));
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("productId",
                            rs.getInt("product_id"));
                    request.setAttribute("productName",
                            rs.getString("product_name"));
                    request.setAttribute("description",
                            rs.getString("description"));
                    request.setAttribute("price",
                            rs.getBigDecimal("price"));
                    request.setAttribute("stock",
                            rs.getInt("stock_quantity"));
                    request.setAttribute("category",
                            rs.getString("category_name"));
                    request.setAttribute("shopName",
                            rs.getString("shop_name"));

                    request.getRequestDispatcher(
                            "/product-details.jsp")
                            .forward(request, response);
                } else {
                    response.sendError(
                            HttpServletResponse.SC_NOT_FOUND,
                            "Product not found in your city.");
                }
            }

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load product details.", e);
        }
    }
}
