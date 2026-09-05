package com.onlineshopping.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.onlineshopping.util.DBConnection;

public class LoginDAO {

    public String validateLogin(String username, String password) {

        String role = null;

        String sql = "SELECT r.role_name "
                   + "FROM user_account u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "WHERE u.username = ? "
                   + "AND u.password_hash = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                role = rs.getString("role_name");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return role;
    }
}