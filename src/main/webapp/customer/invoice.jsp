<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Invoice | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: linear-gradient(180deg, #f8fafc 0%, #eef2ff 100%); }
        .shell { max-width: 1120px; }
        .invoice-card {
            border: 1px solid rgba(148, 163, 184, 0.16);
            border-radius: 1.75rem;
            box-shadow: 0 22px 56px rgba(15, 23, 42, 0.10);
            overflow: hidden;
        }
        .invoice-header {
            background: linear-gradient(135deg, rgba(79, 70, 229, 0.12), rgba(56, 189, 248, 0.08));
            border-bottom: 1px solid rgba(148, 163, 184, 0.14);
        }
        .summary-box {
            border-radius: 1rem;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>
<div class="container shell py-4 py-lg-5">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
        <div>
            <p class="text-uppercase text-primary fw-semibold small mb-2">Order receipt</p>
            <h1 class="display-6 fw-bold mb-1">Invoice</h1>
            <p class="text-secondary mb-0">Printable order record with full item breakdown.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-outline-secondary rounded-pill px-4">Back to Orders</a>
            <button class="btn btn-primary rounded-pill px-4" onclick="window.print()" type="button">Print</button>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty order}">
            <div class="alert alert-warning border-0 shadow-sm">Invoice data unavailable.</div>
        </c:when>
        <c:otherwise>
            <div class="card invoice-card">
                <div class="invoice-header p-4 p-lg-5">
                    <div class="d-flex flex-column flex-md-row justify-content-between gap-4">
                        <div>
                            <h2 class="h3 fw-bold mb-2">Smart Restaurant Invoice</h2>
                            <p class="text-secondary mb-1">Order #${order.orderNumber}</p>
                            <p class="text-secondary mb-0">${order.orderType} · ${order.paymentMethod} · ${order.orderStatus}</p>
                        </div>
                        <div class="text-md-end">
                            <div class="summary-box px-4 py-3 d-inline-block">
                                <div class="text-uppercase text-secondary small fw-semibold">Grand Total</div>
                                <div class="fs-3 fw-bold text-dark">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card-body p-4 p-lg-5">
                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="summary-box p-4 h-100">
                                <div class="text-uppercase text-secondary small fw-semibold mb-2">Billing Info</div>
                                <p class="mb-1 fw-semibold">Order ID: ${order.orderId}</p>
                                <p class="mb-1">Placed At: ${order.orderedAt}</p>
                                <p class="mb-1">Phone: <c:choose><c:when test="${not empty order.phoneSnapshot}">${order.phoneSnapshot}</c:when><c:otherwise>-</c:otherwise></c:choose></p>
                                <p class="mb-0">Address: <c:choose><c:when test="${not empty order.deliveryAddress}">${order.deliveryAddress}</c:when><c:otherwise>-</c:otherwise></c:choose></p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="summary-box p-4 h-100">
                                <div class="text-uppercase text-secondary small fw-semibold mb-2">Order Notes</div>
                                <p class="mb-0">${empty order.notes ? 'No extra notes provided.' : order.notes}</p>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive mb-4">
                        <table class="table align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Item</th>
                                <th class="text-center">Qty</th>
                                <th class="text-end">Unit Price</th>
                                <th class="text-end">Line Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${order.items}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold">${item.itemName}</div>
                                        <small class="text-secondary">Item ID ${item.itemId}</small>
                                    </td>
                                    <td class="text-center">${item.quantity}</td>
                                    <td class="text-end">NPR <fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="text-end fw-semibold">NPR <fmt:formatNumber value="${item.lineTotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="row justify-content-end">
                        <div class="col-lg-5">
                            <div class="summary-box p-4">
                                <div class="d-flex justify-content-between mb-2"><span>Subtotal</span><strong>NPR <fmt:formatNumber value="${order.subtotal}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                                <div class="d-flex justify-content-between mb-2"><span>Tax</span><strong>NPR <fmt:formatNumber value="${order.tax}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                                <div class="d-flex justify-content-between mb-2"><span>Delivery Fee</span><strong>NPR <fmt:formatNumber value="${order.deliveryFee}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                                <div class="d-flex justify-content-between mb-3"><span>Discount</span><strong>NPR <fmt:formatNumber value="${order.discount}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                                <hr />
                                <div class="d-flex justify-content-between fs-5 fw-bold"><span>Grand Total</span><span>NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></span></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
