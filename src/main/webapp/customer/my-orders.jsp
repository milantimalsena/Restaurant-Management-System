<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>My Orders | Himalayan Yaks</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
    <style>
        body { background: linear-gradient(180deg, #f8fafc 0%, #eef2ff 100%); }
        .shell { max-width: 1320px; }
        .orders-card {
            border: 1px solid rgba(148, 163, 184, 0.16);
            border-radius: 1.5rem;
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.08);
            overflow: hidden;
        }
        .status-badge {
            border-radius: 999px;
            font-size: .78rem;
            font-weight: 700;
            letter-spacing: .04em;
            text-transform: uppercase;
            padding: .45rem .75rem;
        }
    </style>
</head>
<body>
<div class="container shell py-4 py-lg-5">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
        <div>
            <p class="text-uppercase text-primary fw-semibold small mb-2">Customer orders</p>
            <h1 class="display-6 fw-bold mb-1">My Orders</h1>
            <p class="text-secondary mb-0">Track order history, payment state, and invoices.</p>
        </div>
        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark rounded-pill px-4">Back to Menu</a>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger border-0 shadow-sm">${errorMessage}</div>
    </c:if>

    <div class="card orders-card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th class="ps-4">Order #</th>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Total</th>
                        <th class="pe-4 text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty orders}">
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td class="ps-4 fw-semibold">${order.orderNumber}</td>
                                    <td>${order.orderedAt}</td>
                                    <td>${order.orderType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderStatus eq 'PENDING'}"><span class="status-badge bg-warning-subtle text-warning-emphasis">${order.orderStatus}</span></c:when>
                                            <c:when test="${order.orderStatus eq 'PREPARING'}"><span class="status-badge bg-primary-subtle text-primary-emphasis">${order.orderStatus}</span></c:when>
                                            <c:when test="${order.orderStatus eq 'READY'}"><span class="status-badge bg-info-subtle text-info-emphasis">${order.orderStatus}</span></c:when>
                                            <c:when test="${order.orderStatus eq 'DELIVERED'}"><span class="status-badge bg-success-subtle text-success-emphasis">${order.orderStatus}</span></c:when>
                                            <c:otherwise><span class="status-badge bg-secondary-subtle text-secondary-emphasis">${order.orderStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.paymentStatus eq 'PAID'}"><span class="status-badge bg-success-subtle text-success-emphasis">${order.paymentStatus}</span></c:when>
                                            <c:when test="${order.paymentStatus eq 'UNPAID'}"><span class="status-badge bg-warning-subtle text-warning-emphasis">${order.paymentStatus}</span></c:when>
                                            <c:otherwise><span class="status-badge bg-secondary-subtle text-secondary-emphasis">${order.paymentStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-semibold">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="pe-4 text-end">
                                        <a href="${pageContext.request.contextPath}/invoice?orderId=${order.orderId}" class="btn btn-sm btn-outline-primary rounded-pill px-3">View Invoice</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="text-center py-5">
                                    <div class="py-4">
                                        <h3 class="h5 fw-bold">No orders placed yet</h3>
                                        <p class="text-secondary mb-4">Once you place an order, it will appear here with its invoice link.</p>
                                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary rounded-pill px-4">Browse Menu</a>
                                    </div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
