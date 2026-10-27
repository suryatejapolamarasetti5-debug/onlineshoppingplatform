
package com.onlineshopping.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.onlineshopping.dao.Product;
import com.onlineshopping.dao.ProductDAO;
import com.onlineshopping.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/customer-marketplace")
public class CustomerMarketplaceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check whether customer is logged in
        if (session == null ||
            session.getAttribute("username") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String username =
                (String) session.getAttribute("username");

        // Find customer's city
        int cityId =
                getCustomerCityId(username);

        if (cityId == -1) {

            response.sendRedirect(
                    "customer-dashboard.jsp?error=customer");

            return;
        }

        // Get products from customer's city
        ProductDAO productDAO = new ProductDAO();

        String search = request.getParameter("search");

        List<Product> products;

        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProductsByCustomerCity(
                    cityId, search);
        } else {
            products = productDAO.getProductsByCustomerCity(cityId);
        }

        request.setAttribute("products", products);

        request.getRequestDispatcher(
                "customer-marketplace.jsp"
        ).forward(request, response);
    }

    // Get customer's city ID using username
    private int getCustomerCityId(String username) {

    	String sql = "SELECT cst.city_id "
    	           + "FROM user_account u "
    	           + "JOIN customer cst "
    	           + "ON u.user_id = cst.customer_id "
    	           + "WHERE u.username = ?";
        try (
            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql)
        ) {

            ps.setString(1, username);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("city_id");
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return -1;
    }
}