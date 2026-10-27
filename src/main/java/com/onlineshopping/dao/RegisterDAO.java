
package com.onlineshopping.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.onlineshopping.util.DBConnection;
import com.onlineshopping.util.PasswordUtil;

public class RegisterDAO {

    public boolean registerCustomer(String username, String password) {

        String sql =
            "INSERT INTO user_account "
          + "(username, password_hash, role_id) "
          + "VALUES (?, ?, 1)";

        String passwordHash = PasswordUtil.hashPassword(password);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, passwordHash);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            // SQLState 23000 commonly indicates a duplicate username
            // or another integrity constraint violation.
            if ("23000".equals(e.getSQLState())) {
                return false;
            }

            e.printStackTrace();
            return false;
        }
    }
}