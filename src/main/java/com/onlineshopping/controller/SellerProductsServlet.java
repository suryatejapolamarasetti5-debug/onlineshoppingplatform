package com.onlineshopping.controller;

import java.io.IOException;
import java.util.List;

import com.onlineshopping.dao.Product;
import com.onlineshopping.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/seller-products")
public class SellerProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("username") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get logged-in username
        String username =
                (String) session.getAttribute("username");

        // Find seller ID
        int sellerId = getSellerId(username);

        if (sellerId == -1) {

            response.sendRedirect(
                    "seller-dashboard.jsp?error=seller"
            );

            return;
        }

        // Get products belonging to this seller
        ProductDAO productDAO = new ProductDAO();

        List<Product> products =
                productDAO.getProductsBySeller(sellerId);

        // Send products to JSP
        request.setAttribute("products", products);

        request.getRequestDispatcher(
                "seller-products.jsp"
        ).forward(request, response);
    }


    private int getSellerId(String username) {

        String sql =
                "SELECT u.user_id "
              + "FROM user_account u "
              + "JOIN seller s "
              + "ON u.user_id = s.seller_id "
              + "WHERE u.username = ?";

        try (
            java.sql.Connection con =
                    com.onlineshopping.util.DBConnection
                    .getConnection();

            java.sql.PreparedStatement ps =
                    con.prepareStatement(sql)
        ) {

            ps.setString(1, username);

            java.sql.ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                return rs.getInt("user_id");

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return -1;
    }
}