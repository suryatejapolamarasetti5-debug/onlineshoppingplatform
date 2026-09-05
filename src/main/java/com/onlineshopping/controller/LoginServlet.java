package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.dao.LoginDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginDAO loginDAO = new LoginDAO();

        String role = loginDAO.validateLogin(username, password);
        if (role != null) {

            HttpSession session = request.getSession();

            session.setAttribute("username", username);
            session.setAttribute("role", role);

            if (role.equals("ADMIN")) {

                response.sendRedirect("admin-dashboard.jsp");

            } else if (role.equals("SELLER")) {

                response.sendRedirect("seller-dashboard.jsp");

            } else if (role.equals("CUSTOMER")) {

                response.sendRedirect("customer-dashboard.jsp");

            } else {

                response.sendRedirect("dashboard.jsp");
            }

        } else {

            response.sendRedirect("login.jsp?error=1");
        }
    }
}