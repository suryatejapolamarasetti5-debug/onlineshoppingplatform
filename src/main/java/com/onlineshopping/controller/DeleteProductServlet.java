
package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/delete-product")
public class DeleteProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check whether seller is logged in
        if (session == null ||
            session.getAttribute("username") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        try {

            // Get product ID from URL
            int productId =
                    Integer.parseInt(
                            request.getParameter("id"));

            String username =
                    (String) session.getAttribute("username");

            // Find seller ID
            int sellerId =
                    getSellerId(username);

            if (sellerId == -1) {

                response.sendRedirect(
                        "seller-dashboard.jsp?error=seller");

                return;
            }

            ProductDAO productDAO =
                    new ProductDAO();

            // Delete product
            boolean success =
                    productDAO.deleteProduct(
                            productId,
                            sellerId
                    );

            if (success) {

                response.sendRedirect(
                        "seller-products?deleted=1");

            } else {

                response.sendRedirect(
                        "seller-products?error=delete");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "seller-products?error=invalid");
        }
    }

    // Get seller ID using logged-in username
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