
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin-categories")
public class AdminCategoriesServlet extends HttpServlet {
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
            SELECT category_id, category_name
            FROM category
            ORDER BY category_name
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> categories = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> category = new LinkedHashMap<>();
                category.put("categoryId", rs.getInt("category_id"));
                category.put("categoryName", rs.getString("category_name"));
                categories.add(category);
            }

            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin-categories.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load categories.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
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

        request.setCharacterEncoding("UTF-8");

        String categoryName = request.getParameter("categoryName");

        if (categoryName == null || categoryName.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()
                    + "/admin-categories?error=empty");
            return;
        }

        categoryName = categoryName.trim();

        if (categoryName.length() > 100) {
            response.sendRedirect(request.getContextPath()
                    + "/admin-categories?error=length");
            return;
        }

        String sql = "INSERT INTO category (category_name) VALUES (?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, categoryName);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath()
                    + "/admin-categories?success=added");

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect(request.getContextPath()
                        + "/admin-categories?error=duplicate");
            } else {
                throw new ServletException(
                    "Unable to add category.", e);
            }
        }
    }
}
