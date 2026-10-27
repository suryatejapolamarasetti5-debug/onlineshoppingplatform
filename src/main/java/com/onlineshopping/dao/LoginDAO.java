
package com.onlineshopping.dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.onlineshopping.util.DBConnection;
import com.onlineshopping.util.PasswordUtil;

public class LoginDAO {

    public String validateLogin(String username, String password) {

        String sql =
            "SELECT u.user_id, u.password_hash, r.role_name "
          + "FROM user_account u "
          + "JOIN role r ON u.role_id = r.role_id "
          + "WHERE u.username = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                int userId = rs.getInt("user_id");
                String storedPassword = rs.getString("password_hash");
                String role = rs.getString("role_name");

                boolean valid;

                if (PasswordUtil.isHashed(storedPassword)) {
                    valid = PasswordUtil.verifyPassword(
                            password, storedPassword);
                } else {
                    // Temporary compatibility for existing accounts.
                    valid = MessageDigest.isEqual(
                        password.getBytes(StandardCharsets.UTF_8),
                        storedPassword.getBytes(StandardCharsets.UTF_8)
                    );

                    // Upgrade the legacy password after successful login.
                    if (valid) {
                        String newHash =
                                PasswordUtil.hashPassword(password);

                        String updateSql =
                            "UPDATE user_account SET password_hash = ? "
                          + "WHERE user_id = ? AND password_hash = ?";

                        try (PreparedStatement update =
                                con.prepareStatement(updateSql)) {

                            update.setString(1, newHash);
                            update.setInt(2, userId);
                            update.setString(3, storedPassword);
                            update.executeUpdate();
                        }
                    }
                }

                return valid ? role : null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}