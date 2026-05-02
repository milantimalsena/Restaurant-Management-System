<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Order" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>My Orders | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4 py-lg-5">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold mb-0">My Orders</h3>
        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark btn-sm">Back to Menu</a>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table mb-0 align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Order #</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Amount</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (orders != null && !orders.isEmpty()) {
                        for (Order o : orders) { %>
                    <tr>
                        <td><%= o.getOrderNumber() %></td>
                        <td><%= o.getOrderedAt() != null ? o.getOrderedAt() : "-" %></td>
                        <td><%= o.getOrderType() %></td>
                        <td><span class="badge text-bg-secondary"><%= o.getOrderStatus() %></span></td>
                        <td><span class="badge <%= "PAID".equalsIgnoreCase(o.getPaymentStatus()) ? "text-bg-success" : "text-bg-warning" %>"><%= o.getPaymentStatus() %></span></td>
                        <td>NPR <%= o.getGrandTotal() %></td>
                        <td><a href="${pageContext.request.contextPath}/invoice?orderId=<%= o.getOrderId() %>" class="btn btn-sm btn-outline-primary">View Invoice</a></td>
                    </tr>
                    <% }} else { %>
                    <tr>
                        <td colspan="7" class="text-center py-4">No orders placed yet.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
