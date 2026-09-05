package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.dao.SellerRegistrationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/seller-register")
public class SellerRegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username =
                request.getParameter("username");

        String password =
                request.getParameter("password");

        String businessName =
                request.getParameter("businessName");

        String phone =
                request.getParameter("phone");

        String address =
                request.getParameter("address");

        int cityId =
                Integer.parseInt(request.getParameter("cityId"));

        SellerRegistrationDAO dao =
                new SellerRegistrationDAO();

        boolean success =
                dao.registerSeller(
                        username,
                        password,
                        businessName,
                        phone,
                        address,
                        cityId);

        if (success) {

            response.sendRedirect(
                    "login.jsp?registered=1");

        } else {

            response.sendRedirect(
                    "seller-register.jsp?error=1");
        }
    }
}