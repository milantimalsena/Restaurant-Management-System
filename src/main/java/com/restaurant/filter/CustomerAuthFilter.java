package com.restaurant.filter;

import com.restaurant.util.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter(filterName = "CustomerAuthFilter", urlPatterns = "/customer/*")
public class CustomerAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (!SessionUtil.hasRole(httpRequest, "CUSTOMER")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?sessionExpired=true");
            return;
        }

        chain.doFilter(request, response);
    }
}
