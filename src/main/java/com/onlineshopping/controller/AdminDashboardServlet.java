
package com.onlineshopping.controller;

import java.io.IOException;
import java.math.BigDecimal;
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

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Protect the admin dashboard
        if (session == null
                || session.getAttribute("username") == null
                || !"ADMIN".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String sql =
            "SELECT " +
            "(SELECT COUNT(*) FROM user_account) AS totalUsers, " +
            "(SELECT COUNT(*) FROM seller) AS totalSellers, " +
            "(SELECT COUNT(*) FROM customer) AS totalCustomers, " +
            "(SELECT COUNT(*) FROM product) AS totalProducts, " +
            "(SELECT COUNT(*) FROM category) AS totalCategories, " +
            "(SELECT COUNT(*) FROM orders) AS totalOrders, " +
            "(SELECT COALESCE(SUM(total_amount), 0) FROM orders) AS totalSales";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                request.setAttribute(
                        "totalUsers", rs.getInt("totalUsers"));
                request.setAttribute(
                        "totalSellers", rs.getInt("totalSellers"));
                request.setAttribute(
                        "totalCustomers", rs.getInt("totalCustomers"));
                request.setAttribute(
                        "totalProducts", rs.getInt("totalProducts"));
                request.setAttribute(
                        "totalCategories", rs.getInt("totalCategories"));
                request.setAttribute(
                        "totalOrders", rs.getInt("totalOrders"));

                BigDecimal totalSales =
                        rs.getBigDecimal("totalSales");

                request.setAttribute("totalSales", totalSales);
            }

            request.getRequestDispatcher("/admin-dashboard.jsp")
            .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load admin dashboard statistics.", e);
        }
    }
}
