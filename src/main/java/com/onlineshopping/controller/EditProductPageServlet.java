
package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.dao.Product;
import com.onlineshopping.dao.ProductDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/edit-product-page")
public class EditProductPageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check login
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

            // Get seller's products
            java.util.List<Product> products =
                    productDAO.getProductsBySeller(sellerId);

            Product selectedProduct = null;

            // Find requested product
            for (Product product : products) {

                if (product.getProductId() == productId) {

                    selectedProduct = product;
                    break;
                }
            }

            // Product not found or belongs to another seller
            if (selectedProduct == null) {

                response.sendRedirect(
                        "seller-products?error=notfound");

                return;
            }

            // Send product to JSP
            request.setAttribute(
                    "product",
                    selectedProduct);

            request.getRequestDispatcher(
                    "edit-product.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "seller-products?error=invalid");
        }
    }

    // Get seller ID using username
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
