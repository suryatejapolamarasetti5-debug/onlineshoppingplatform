
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

@WebServlet("/admin-products")
public class AdminProductsServlet extends HttpServlet {
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
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String sql = """
            SELECT p.product_id, p.product_name, p.description,
                   p.price, p.stock_quantity,
                   s.shop_name, c.category_name
            FROM product p
            LEFT JOIN seller s ON p.seller_id = s.seller_id
            LEFT JOIN category c ON p.category_id = c.category_id
            ORDER BY p.product_id DESC
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> products = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> product = new LinkedHashMap<>();
                product.put("productId", rs.getInt("product_id"));
                product.put("productName", rs.getString("product_name"));
                product.put("description", rs.getString("description"));
                product.put("price", rs.getBigDecimal("price"));
                product.put("stock", rs.getInt("stock_quantity"));
                product.put("shopName", rs.getString("shop_name"));
                product.put("categoryName", rs.getString("category_name"));
                products.add(product);
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("/admin-products.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load products.", e);
        }
    }
}
