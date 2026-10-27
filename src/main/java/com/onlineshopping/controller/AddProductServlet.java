package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-product")
public class AddProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get the logged-in user's session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("username") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        String productName =
                request.getParameter("productName");

        String description =
                request.getParameter("description");

        int categoryId =
                Integer.parseInt(
                        request.getParameter("categoryId"));

        double price =
                Double.parseDouble(
                        request.getParameter("price"));

        int stockQuantity =
                Integer.parseInt(
                        request.getParameter("stockQuantity"));

        // Get username from session
        String username =
                (String) session.getAttribute("username");

        ProductDAO productDAO = new ProductDAO();

        /*
         * For now, we will obtain the seller_id
         * using the username.
         */
        int sellerId =
                getSellerId(username);

        if (sellerId == -1) {

            response.sendRedirect(
                    "add-product.jsp?error=seller"
            );

            return;
        }

        boolean success =
                productDAO.addProduct(
                        sellerId,
                        categoryId,
                        productName,
                        description,
                        price,
                        stockQuantity
                );

        if (success) {

            response.sendRedirect(
                    "seller-products?success=1"
            );

        } else {

            response.sendRedirect(
                    "add-product.jsp?error=1"
            );
        }
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