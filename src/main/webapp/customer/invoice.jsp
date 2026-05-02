<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
    String invoiceHtml = (String) request.getAttribute("invoiceHtml");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Invoice | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4 py-lg-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold mb-0">Invoice</h3>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary btn-sm">Back to Orders</a>
            <button class="btn btn-outline-primary btn-sm" onclick="window.print()">Print</button>
        </div>
    </div>

    <% if (order == null) { %>
    <div class="alert alert-warning">Invoice data unavailable.</div>
    <% } else { %>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-4" id="invoiceArea">
            <%= invoiceHtml %>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>
