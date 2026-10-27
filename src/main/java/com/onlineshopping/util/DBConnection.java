package com.onlineshopping.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/online_shopping";

    private static final String USER = "root";

    private static final String PASSWORD = "Mysql@jayanth7";

    public static Connection getConnection() throws SQLException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "MySQL JDBC Driver NOT found by Tomcat!", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}