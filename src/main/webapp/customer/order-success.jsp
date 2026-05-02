<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Order Success | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <% if (order == null) { %>
    <div class="alert alert-warning">Order not found.</div>
    <% } else { %>
    <div class="card border-0 shadow-sm text-center">
        <div class="card-body p-5">
            <div class="display-4 text-success mb-2">✓</div>
            <h2 class="fw-bold mb-2">Thank you! Your order is placed.</h2>
            <p class="text-muted">Order Number: <strong><%= order.getOrderNumber() %></strong></p>

            <div class="row g-3 justify-content-center mt-2">
                <div class="col-md-3"><div class="border rounded p-3">Payment<br><strong><%= order.getPaymentMethod() %></strong></div></div>
                <div class="col-md-3"><div class="border rounded p-3">Amount<br><strong>NPR <%= order.getGrandTotal() %></strong></div></div>
                <div class="col-md-3"><div class="border rounded p-3">ETA<br><strong>20-35 mins</strong></div></div>
            </div>

            <div class="mt-4 d-flex flex-wrap gap-2 justify-content-center">
                <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-dark">View Orders</a>
                <a href="${pageContext.request.contextPath}/invoice?orderId=<%= order.getOrderId() %>" class="btn btn-outline-primary">Download Invoice</a>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-secondary">Continue Shopping</a>
            </div>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>
