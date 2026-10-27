
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

@WebServlet("/admin-customers")
public class AdminCustomersServlet extends HttpServlet {
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
            SELECT customer_id, full_name, email, phone, city_id
            FROM customer
            ORDER BY customer_id
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            List<Map<String, Object>> customers = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> customer = new LinkedHashMap<>();
                customer.put("customerId", rs.getInt("customer_id"));
                customer.put("fullName", rs.getString("full_name"));
                customer.put("email", rs.getString("email"));
                customer.put("phone", rs.getString("phone"));
                customer.put("cityId", rs.getObject("city_id"));
                customers.add(customer);
            }

            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/admin-customers.jsp")
                   .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to load customers.", e);
        }
    }
}
