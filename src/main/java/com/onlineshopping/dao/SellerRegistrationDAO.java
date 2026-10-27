package com.onlineshopping.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.onlineshopping.util.DBConnection;

public class SellerRegistrationDAO {

    public boolean registerSeller(
            String username,
            String password,
            String ownerName,
            String businessName,
            String email,
            String phone,
            int cityId) {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Check for an existing username.
            String checkSql =
                "SELECT user_id FROM user_account WHERE username = ?";

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setString(1, username);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // Check for an existing seller email.
            String emailSql =
                "SELECT seller_id FROM seller WHERE email = ?";

            try (PreparedStatement ps = con.prepareStatement(emailSql)) {
                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // Create the seller's login account.
            String userSql =
                "INSERT INTO user_account "
                + "(username, password_hash, role_id) "
                + "SELECT ?, ?, role_id FROM role "
                + "WHERE role_name = 'SELLER'";

            int userId;

            try (PreparedStatement ps = con.prepareStatement(
                    userSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, username);
                ps.setString(2, password);

                int rows = ps.executeUpdate();

                if (rows != 1) {
                    con.rollback();
                    return false;
                }

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) {
                        con.rollback();
                        return false;
                    }

                    userId = keys.getInt(1);
                }
            }

            // Create the seller profile.
            // seller_id is linked to the newly created user_id.
            String sellerSql =
                "INSERT INTO seller "
                + "(seller_id, shop_name, owner_name, email, phone, city_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sellerSql)) {
                ps.setInt(1, userId);
                ps.setString(2, businessName);
                ps.setString(3, ownerName);
                ps.setString(4, email);

                if (phone == null || phone.trim().isEmpty()) {
                    ps.setNull(5, java.sql.Types.VARCHAR);
                } else {
                    ps.setString(5, phone.trim());
                }

                ps.setInt(6, cityId);

                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (Exception rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (Exception closeError) {
                    closeError.printStackTrace();
                }
            }
        }
    }
}