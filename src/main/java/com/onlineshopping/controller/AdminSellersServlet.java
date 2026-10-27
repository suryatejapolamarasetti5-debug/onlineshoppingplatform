
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

@WebServlet("/admin-sellers")
public class AdminSellersServlet extends HttpServlet {
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
            SELECT seller_id, shop_name, owner_name, email, phone, city_id
            FROM seller
            ORDER BY seller_id
            """;

try (Connection con = DBConnection.getConnection();
     PreparedStatement ps = con.prepareStatement(sql);
     ResultSet rs = ps.executeQuery()) {

    java.util.List<java.util.Map<String, Object>> sellers =
        new java.util.ArrayList<>();

    while (rs.next()) {
        java.util.Map<String, Object> seller =
            new java.util.LinkedHashMap<>();

        seller.put("sellerId", rs.getInt("seller_id"));
        seller.put("shopName", rs.getString("shop_name"));
        seller.put("ownerName", rs.getString("owner_name"));
        seller.put("email", rs.getString("email"));
        seller.put("phone", rs.getString("phone"));
        seller.put("cityId", rs.getObject("city_id"));

        sellers.add(seller);
    }

    request.setAttribute("sellers", sellers);
    request.getRequestDispatcher("/admin-sellers.jsp")
           .forward(request, response);

} catch (SQLException e) {
    throw new ServletException("Unable to load sellers.", e);
}

    }
}
