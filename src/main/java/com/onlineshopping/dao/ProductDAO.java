package com.onlineshopping.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.onlineshopping.util.DBConnection;

public class ProductDAO {

    // Add a new product
    public boolean addProduct(int sellerId,
                              int categoryId,
                              String productName,
                              String description,
                              double price,
                              int stockQuantity) {

        String sql = "INSERT INTO product "
                   + "(seller_id, category_id, product_name, "
                   + "description, price, stock_quantity) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sellerId);
            ps.setInt(2, categoryId);
            ps.setString(3, productName);
            ps.setString(4, description);
            ps.setDouble(5, price);
            ps.setInt(6, stockQuantity);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // Get all products belonging to a particular seller
    public List<Product> getProductsBySeller(int sellerId) {

        List<Product> products = new ArrayList<>();

        String sql = "SELECT p.product_id, "
                   + "p.product_name, "
                   + "p.description, "
                   + "p.price, "
                   + "p.stock_quantity, "
                   + "c.category_name "
                   + "FROM product p "
                   + "JOIN category c "
                   + "ON p.category_id = c.category_id "
                   + "WHERE p.seller_id = ? "
                   + "ORDER BY p.product_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sellerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product product = new Product();

                product.setProductId(
                        rs.getInt("product_id"));

                product.setProductName(
                        rs.getString("product_name"));

                product.setDescription(
                        rs.getString("description"));

                product.setPrice(
                        rs.getDouble("price"));

                product.setStockQuantity(
                        rs.getInt("stock_quantity"));

                product.setCategoryName(
                        rs.getString("category_name"));

                products.add(product);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return products;
        
    }
 // Update an existing product
    public boolean updateProduct(int productId,
                                 int sellerId,
                                 int categoryId,
                                 String productName,
                                 String description,
                                 double price,
                                 int stockQuantity) {

        String sql = "UPDATE product "
                   + "SET category_id = ?, "
                   + "product_name = ?, "
                   + "description = ?, "
                   + "price = ?, "
                   + "stock_quantity = ? "
                   + "WHERE product_id = ? "
                   + "AND seller_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setString(2, productName);
            ps.setString(3, description);
            ps.setDouble(4, price);
            ps.setInt(5, stockQuantity);
            ps.setInt(6, productId);
            ps.setInt(7, sellerId);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
 // Delete a product belonging to a particular seller
    public boolean deleteProduct(int productId, int sellerId) {

        String sql = "DELETE FROM product "
                   + "WHERE product_id = ? "
                   + "AND seller_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, sellerId);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
 // Get products available from sellers in the customer's city
 public List<Product> getProductsByCustomerCity(int cityId) {

     List<Product> products = new ArrayList<>();

     String sql =
             "SELECT p.product_id, "
           + "p.product_name, "
           + "p.description, "
           + "p.price, "
           + "p.stock_quantity, "
           + "c.category_name, "
           + "s.shop_name "
           + "FROM product p "
           + "JOIN category c "
           + "ON p.category_id = c.category_id "
           + "JOIN seller s "
           + "ON p.seller_id = s.seller_id "
           + "WHERE s.city_id = ? "
           + "AND p.stock_quantity > 0 "
           + "ORDER BY p.product_id DESC";

     try (Connection con = DBConnection.getConnection();
          PreparedStatement ps = con.prepareStatement(sql)) {

         ps.setInt(1, cityId);

         ResultSet rs = ps.executeQuery();

         while (rs.next()) {

             Product product = new Product();

             product.setProductId(
                     rs.getInt("product_id"));

             product.setProductName(
                     rs.getString("product_name"));

             product.setDescription(
                     rs.getString("description"));

             product.setPrice(
                     rs.getDouble("price"));

             product.setStockQuantity(
                     rs.getInt("stock_quantity"));

             product.setCategoryName(
                     rs.getString("category_name"));

             products.add(product);
         }

     } catch (Exception e) {

         e.printStackTrace();
     }

     return products;
 }

 // Search products available in the customer's city
 public List<Product> searchProductsByCustomerCity(
         int cityId, String search) {

     List<Product> products = new ArrayList<>();

     String sql =
             "SELECT p.product_id, "
           + "p.product_name, "
           + "p.description, "
           + "p.price, "
           + "p.stock_quantity, "
           + "c.category_name "
           + "FROM product p "
           + "JOIN category c "
           + "ON p.category_id = c.category_id "
           + "JOIN seller s "
           + "ON p.seller_id = s.seller_id "
           + "WHERE s.city_id = ? "
           + "AND p.stock_quantity > 0 "
           + "AND p.product_name LIKE ? "
           + "ORDER BY p.product_id DESC";

     try (Connection con = DBConnection.getConnection();
          PreparedStatement ps = con.prepareStatement(sql)) {

         ps.setInt(1, cityId);
         ps.setString(2, "%" + search.trim() + "%");

         try (ResultSet rs = ps.executeQuery()) {
             while (rs.next()) {
                 Product product = new Product();

                 product.setProductId(
                         rs.getInt("product_id"));
                 product.setProductName(
                         rs.getString("product_name"));
                 product.setDescription(
                         rs.getString("description"));
                 product.setPrice(
                         rs.getDouble("price"));
                 product.setStockQuantity(
                         rs.getInt("stock_quantity"));
                 product.setCategoryName(
                         rs.getString("category_name"));

                 products.add(product);
             }
         }

     } catch (Exception e) {
         e.printStackTrace();
     }

     return products;
 }

}