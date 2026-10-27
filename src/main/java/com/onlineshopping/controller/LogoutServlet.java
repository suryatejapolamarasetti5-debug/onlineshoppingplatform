package com.onlineshopping.controller;

import java.io.IOException;

import com.onlineshopping.filter.AutoLoginFilter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }

        Cookie rememberMe =
                new Cookie(AutoLoginFilter.REMEMBER_ME_COOKIE, "");

        rememberMe.setHttpOnly(true);
        rememberMe.setPath(request.getContextPath() + "/");
        rememberMe.setMaxAge(0);

        response.addCookie(rememberMe);

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
