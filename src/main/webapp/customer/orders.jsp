<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | Smart Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-50 text-slate-900">
<main class="mx-auto max-w-6xl px-4 py-8 sm:px-6 lg:px-8">
    <header class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.2em] text-amber-600">Live Order Tracking</p>
            <h1 class="mt-2 text-3xl font-black text-slate-950">My Orders</h1>
            <p class="mt-1 text-sm font-medium text-slate-500">Refresh this page to load the latest payment and kitchen status from the restaurant.</p>
        </div>
        <div class="flex gap-2">
            <a href="${pageContext.request.contextPath}/customer/orders" class="rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-black text-slate-700 shadow-sm transition hover:border-amber-300 hover:text-amber-700">Refresh</a>
            <a href="${pageContext.request.contextPath}/menu" class="rounded-2xl bg-slate-900 px-4 py-3 text-sm font-black text-white shadow-lg transition hover:bg-amber-600">Back to Menu</a>
        </div>
    </header>

    <c:if test="${not empty errorMessage}">
        <div class="mb-4 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-bold text-red-700">${errorMessage}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <section class="rounded-2xl border border-dashed border-slate-300 bg-white px-5 py-16 text-center shadow-sm">
                <p class="text-lg font-black text-slate-900">No orders placed yet.</p>
                <p class="mt-2 text-sm font-medium text-slate-500">After checkout, your payment and order tracking details will appear here.</p>
                <a href="${pageContext.request.contextPath}/menu" class="mt-5 inline-flex rounded-2xl bg-amber-500 px-5 py-3 text-sm font-black text-slate-950 transition hover:bg-amber-400">Browse Menu</a>
            </section>
        </c:when>
        <c:otherwise>
            <section class="grid gap-4">
                <c:forEach var="order" items="${orders}">
                    <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-lg shadow-slate-200/70">
                        <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                            <div>
                                <div class="flex flex-wrap items-center gap-2">
                                    <h2 class="text-xl font-black text-slate-950">Order #${order.orderId}</h2>
                                    <span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-black text-slate-600">${order.orderType}</span>
                                </div>
                                <p class="mt-2 text-sm font-semibold text-slate-500">Ordered at ${order.orderedAt}</p>
                            </div>
                            <div class="text-left lg:text-right">
                                <p class="text-xs font-bold uppercase tracking-wide text-slate-400">Grand Total</p>
                                <p class="mt-1 text-2xl font-black text-slate-950">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></p>
                            </div>
                        </div>

                        <div class="mt-5 grid gap-4 md:grid-cols-2">
                            <div class="rounded-2xl bg-slate-50 p-4">
                                <p class="text-xs font-black uppercase tracking-wide text-slate-500">Payment Status</p>
                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${order.paymentStatus eq 'Pending Verification'}">
                                            <span class="inline-flex rounded-full bg-yellow-100 px-3 py-1 text-sm font-black text-yellow-700">Pending Verification</span>
                                        </c:when>
                                        <c:when test="${order.paymentStatus eq 'Paid'}">
                                            <span class="inline-flex rounded-full bg-green-100 px-3 py-1 text-sm font-black text-green-700">Paid</span>
                                        </c:when>
                                        <c:when test="${order.paymentStatus eq 'Rejected'}">
                                            <span class="inline-flex rounded-full bg-red-100 px-3 py-1 text-sm font-black text-red-700">Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex rounded-full bg-slate-100 px-3 py-1 text-sm font-black text-slate-700">${order.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="rounded-2xl bg-slate-50 p-4">
                                <p class="text-xs font-black uppercase tracking-wide text-slate-500">Order Status</p>
                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${order.orderStatus eq 'Pending'}">
                                            <span class="inline-flex rounded-full bg-gray-100 px-3 py-1 text-sm font-black text-gray-700">Pending</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'Preparing'}">
                                            <span class="inline-flex rounded-full bg-orange-100 px-3 py-1 text-sm font-black text-orange-700">Preparing</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'Ready'}">
                                            <span class="inline-flex rounded-full bg-blue-100 px-3 py-1 text-sm font-black text-blue-700">Ready</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'Delivered'}">
                                            <span class="inline-flex rounded-full bg-green-100 px-3 py-1 text-sm font-black text-green-700">Delivered</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus eq 'Cancelled'}">
                                            <span class="inline-flex rounded-full bg-red-100 px-3 py-1 text-sm font-black text-red-700">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex rounded-full bg-slate-100 px-3 py-1 text-sm font-black text-slate-700">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div class="mt-5 flex flex-wrap items-center justify-between gap-3 border-t border-slate-100 pt-4">
                            <p class="text-sm font-semibold text-slate-500">Latest database status is loaded on every page refresh.</p>
                            <a href="${pageContext.request.contextPath}/invoice?orderId=${order.orderId}" class="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-black text-slate-700 transition hover:border-amber-300 hover:text-amber-700">View Invoice</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
