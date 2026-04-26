<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.util.SessionUtil" %>
<%@ page import="com.restaurant.dao.CartDAO" %>
<%
    int navCartCount = 0;
    Long navUserId = SessionUtil.getLoggedInUserId(request);
    if (navUserId != null) {
        try {
            navCartCount = new CartDAO().getCartCount(navUserId);
        } catch (Exception ignored) {
            navCartCount = 0;
        }
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/menu">Smart Restaurant</a>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/menu">Menu</a>
            <a class="btn btn-outline-warning btn-sm position-relative" href="${pageContext.request.contextPath}/cart">
                Cart
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill text-bg-danger"><%= navCartCount %></span>
            </a>
        </div>
    </div>
</nav>
