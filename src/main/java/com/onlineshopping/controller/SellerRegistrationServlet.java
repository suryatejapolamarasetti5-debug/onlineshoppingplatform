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

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String ownerName = request.getParameter("ownerName");
        String businessName = request.getParameter("businessName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String cityValue = request.getParameter("cityId");

        int cityId;

        try {
            cityId = Integer.parseInt(cityValue);
        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() + "/seller-register.jsp?error=1");
            return;
        }

        SellerRegistrationDAO dao = new SellerRegistrationDAO();

        boolean success = dao.registerSeller(
            username, password, ownerName,
            businessName, email, phone, cityId
        );

        if (success) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp?registered=1");
        } else {
            response.sendRedirect(
                request.getContextPath() + "/seller-register.jsp?error=1");
        }
    }
}