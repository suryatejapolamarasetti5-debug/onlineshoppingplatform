package com.onlineshopping.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.onlineshopping.util.DBConnection;

public class SellerRegistrationDAO {

    public boolean registerSeller(
            String username,
            String password,
            String businessName,
            String phone,
            String address,
            int cityId) {

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);

            // Check whether username already exists
            String checkSql =
                    "SELECT user_id FROM user_account WHERE username = ?";

            try (PreparedStatement checkPs =
                    con.prepareStatement(checkSql)) {

                checkPs.setString(1, username);

                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    return false;
                }
            }

            // Insert user account
            String userSql =
                    "INSERT INTO user_account "
                    + "(username, password_hash, role_id) "
                    + "SELECT ?, ?, role_id "
                    + "FROM role "
                    + "WHERE role_name = 'SELLER'";

            int userId;

            try (PreparedStatement userPs =
                    con.prepareStatement(
                            userSql,
                            java.sql.Statement.RETURN_GENERATED_KEYS)) {

                userPs.setString(1, username);
                userPs.setString(2, password);

                userPs.executeUpdate();

                ResultSet keys = userPs.getGeneratedKeys();

                if (!keys.next()) {
                    con.rollback();
                    return false;
                }

                userId = keys.getInt(1);
            }

            // Insert seller profile
            String sellerSql =
                    "INSERT INTO seller "
                    + "(user_id, business_name, phone, address, city_id) "
                    + "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement sellerPs =
                    con.prepareStatement(sellerSql)) {

                sellerPs.setInt(1, userId);
                sellerPs.setString(2, businessName);
                sellerPs.setString(3, phone);
                sellerPs.setString(4, address);
                sellerPs.setInt(5, cityId);

                sellerPs.executeUpdate();
            }

            con.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception rollbackError) {
                rollbackError.printStackTrace();
            }

            return false;

        } finally {

            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception closeError) {
                closeError.printStackTrace();
            }
        }
    }
}