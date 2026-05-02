<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Order Success | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background:
                radial-gradient(circle at top, rgba(34, 197, 94, 0.12), transparent 32%),
                linear-gradient(180deg, #f8fafc, #eef2ff);
        }

        .shell { max-width: 980px; }

        .success-card {
            border: 1px solid rgba(148, 163, 184, 0.16);
            border-radius: 1.75rem;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.10);
            overflow: hidden;
        }

        .success-icon {
            width: 96px;
            height: 96px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(34, 197, 94, 0.18), rgba(16, 185, 129, 0.12));
            color: #16a34a;
            font-size: 3rem;
            box-shadow: inset 0 0 0 1px rgba(34, 197, 94, 0.18);
        }
    </style>
</head>
<body>
<div class="container py-5 shell">
    <c:choose>
        <c:when test="${empty order}">
            <div class="alert alert-warning border-0 shadow-sm">Order not found.</div>
        </c:when>
        <c:otherwise>
            <div class="card success-card">
                <div class="card-body p-4 p-lg-5 text-center">
                    <div class="success-icon mb-4">&#10003;</div>
                    <h1 class="display-6 fw-bold mb-2">Order placed successfully</h1>
                    <p class="text-secondary mb-0">Your kitchen ticket, payment record, and invoice are ready.</p>

                    <div class="row g-3 justify-content-center mt-4 text-start">
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">Order ID</div><div class="fs-5 fw-bold">${order.orderNumber}</div></div></div>
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">Payment</div><div class="fs-5 fw-bold">${order.paymentMethod}</div></div></div>
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">Amount</div><div class="fs-5 fw-bold">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></div></div></div>
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">Order Type</div><div class="fs-5 fw-bold">${order.orderType}</div></div></div>
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">Status</div><div class="fs-5 fw-bold">${order.orderStatus}</div></div></div>
                        <div class="col-md-4"><div class="border rounded-4 p-3 h-100 bg-white"><div class="text-uppercase text-secondary small fw-semibold">ETA</div><div class="fs-5 fw-bold">20-35 mins</div></div></div>
                    </div>

                    <div class="mt-4 d-flex flex-wrap gap-2 justify-content-center">
                        <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-dark btn-lg px-4 rounded-pill">View Orders</a>
                        <a href="${pageContext.request.contextPath}/invoice?orderId=${order.orderId}" class="btn btn-outline-primary btn-lg px-4 rounded-pill">Download Invoice</a>
                        <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-secondary btn-lg px-4 rounded-pill">Continue Shopping</a>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
