<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.util.SessionUtil" %>
<%@ page import="com.restaurant.dao.CartDAO" %>
<%
    Long userId = SessionUtil.getLoggedInUserId(request);
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    int count = 0;
    try {
        count = new CartDAO().getCartCount(userId);
    } catch (Exception ignored) {
    }

    if (count <= 0) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Checkout | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <h3 class="fw-bold">Checkout</h3>
            <p class="text-muted mb-0">Your cart is ready. Integrate order placement flow here.</p>
        </div>
    </div>
</div>
</body>
</html>
