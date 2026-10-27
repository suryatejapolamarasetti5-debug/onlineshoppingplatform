
package com.onlineshopping.filter;

import java.io.IOException;

import com.onlineshopping.util.TokenUtil;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AutoLoginFilter implements Filter {

    public static final String REMEMBER_ME_COOKIE = "rememberMe";

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        // User is already logged in
        if (session != null &&
            session.getAttribute("username") != null) {

            chain.doFilter(request, response);
            return;
        }

        // Check for Remember Me cookie
        Cookie[] cookies = httpRequest.getCookies();

        if (cookies != null) {

            for (Cookie cookie : cookies) {

                if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {

                    String token = cookie.getValue();

                    String[] userData = TokenUtil.verify(token);

                    if (userData != null) {

                        String username = userData[0];
                        String role = userData[1];

                        HttpSession newSession =
                                httpRequest.getSession(true);

                        newSession.setAttribute(
                                "username", username);

                        newSession.setAttribute(
                                "role", role);
                    }

                    break;
                }
            }
        }

        chain.doFilter(httpRequest, httpResponse);
    }
}

