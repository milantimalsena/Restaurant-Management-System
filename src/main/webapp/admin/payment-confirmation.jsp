<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900">
<div class="flex min-h-screen">
    <%@ include file="../includes/adminSidebar.jsp" %>

    <main class="min-w-0 flex-1 px-4 py-6 sm:px-6 lg:ml-72 lg:px-8">
        <button id="sidebarOpen" type="button" class="mb-4 inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-black text-slate-700 shadow-sm transition hover:border-amber-300 hover:text-amber-700 lg:hidden">
            Admin Menu
        </button>
        <header class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.2em] text-amber-600">Payment Verification</p>
                <h1 class="mt-2 text-3xl font-black text-slate-950">Payment Confirmation</h1>
                <p class="mt-1 text-sm font-medium text-slate-500">Approve or reject orders waiting for payment verification.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/manage-orders" class="rounded-2xl bg-slate-900 px-4 py-3 text-sm font-black text-white shadow-lg transition hover:bg-amber-600">Manage Orders</a>
        </header>

        <c:if test="${not empty successMessage}">
            <div class="mb-4 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-700">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="mb-4 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-700">${errorMessage}</div>
        </c:if>

        <section class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-200/70">
            <div class="border-b border-slate-200 px-5 py-5">
                <h2 class="text-xl font-black text-slate-950">Pending Verification</h2>
                <p class="mt-1 text-sm font-semibold text-slate-500">Only orders with payment status Pending Verification are shown here.</p>
            </div>

            <c:choose>
                <c:when test="${empty pendingPaymentOrders}">
                    <div class="px-5 py-16 text-center">
                        <div class="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-emerald-100 text-xl font-black text-emerald-700">OK</div>
                        <p class="mt-4 text-lg font-black text-slate-900">No pending payments.</p>
                        <p class="mt-2 text-sm font-medium text-slate-500">New checkout orders waiting for verification will appear here.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                            <thead class="bg-slate-50 text-xs font-black uppercase tracking-wide text-slate-500">
                            <tr>
                                <th class="whitespace-nowrap px-5 py-4">Order ID</th>
                                <th class="whitespace-nowrap px-5 py-4">Customer</th>
                                <th class="whitespace-nowrap px-5 py-4">Order Type</th>
                                <th class="whitespace-nowrap px-5 py-4">Grand Total</th>
                                <th class="whitespace-nowrap px-5 py-4">Payment Status</th>
                                <th class="whitespace-nowrap px-5 py-4">Ordered Date</th>
                                <th class="whitespace-nowrap px-5 py-4 text-right">Actions</th>
                            </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 bg-white">
                            <c:forEach var="order" items="${pendingPaymentOrders}">
                                <tr class="transition hover:bg-amber-50/70">
                                    <td class="whitespace-nowrap px-5 py-4 font-black text-slate-950">#${order.orderId}</td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">
                                        <c:out value="${empty order.customerName ? 'Customer #' : order.customerName}" /><c:if test="${empty order.customerName}">${order.userId}</c:if>
                                    </td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${order.orderType}</td>
                                    <td class="whitespace-nowrap px-5 py-4 font-black text-slate-950">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="whitespace-nowrap px-5 py-4">
                                        <span class="rounded-full bg-yellow-100 px-3 py-1 text-xs font-black text-yellow-700">${order.paymentStatus}</span>
                                    </td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-600">${order.orderedAt}</td>
                                    <td class="whitespace-nowrap px-5 py-4">
                                        <div class="flex justify-end gap-2">
                                            <form action="${pageContext.request.contextPath}/admin/payment-confirmation" method="post">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <input type="hidden" name="action" value="confirm">
                                                <button type="submit" class="rounded-xl bg-emerald-500 px-4 py-2 text-xs font-black text-white transition hover:bg-emerald-600">Confirm Payment</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/payment-confirmation" method="post">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <input type="hidden" name="action" value="reject">
                                                <button type="submit" class="rounded-xl bg-red-500 px-4 py-2 text-xs font-black text-white transition hover:bg-red-600">Reject Payment</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>
<script>
(() => {
    const sidebar = document.getElementById('adminSidebar');
    const openBtn = document.getElementById('sidebarOpen');
    const closeBtn = document.getElementById('sidebarClose');

    openBtn?.addEventListener('click', () => sidebar?.classList.remove('-translate-x-full'));
    closeBtn?.addEventListener('click', () => sidebar?.classList.add('-translate-x-full'));
})();
</script>
</body>
</html>
