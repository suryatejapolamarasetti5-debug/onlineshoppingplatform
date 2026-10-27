
package com.onlineshopping.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.onlineshopping.dao.RegisterDAO;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final RegisterDAO registerDAO = new RegisterDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        String context = request.getContextPath();

        if (username == null || password == null
                || confirmPassword == null) {
            response.sendRedirect(
                    context + "/register.jsp?error=1");
            return;
        }

        username = username.trim();

        if (username.isEmpty() || username.length() > 50
                || password.length() < 8
                || password.length() > 1024
                || !password.equals(confirmPassword)) {

            String error = !password.equals(confirmPassword)
                    ? "password" : "1";

            response.sendRedirect(
                    context + "/register.jsp?error=" + error);
            return;
        }

        boolean registered =
                registerDAO.registerCustomer(username, password);

        if (registered) {
            response.sendRedirect(
                    context + "/login.jsp?registered=1");
        } else {
            response.sendRedirect(
                    context + "/register.jsp?error=1");
        }
    }
}