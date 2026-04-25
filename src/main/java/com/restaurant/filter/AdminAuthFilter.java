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

@WebFilter(filterName = "AdminAuthFilter", urlPatterns = "/admin/*")
public class AdminAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        boolean isLoginPage = uri.endsWith("/admin/admin-login.jsp") || uri.endsWith("/admin/login");
        if (isLoginPage) {
            chain.doFilter(request, response);
            return;
        }

        if (!SessionUtil.hasRole(httpRequest, "ADMIN")) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/login?sessionExpired=true");
            return;
        }

        chain.doFilter(request, response);
    }
}
