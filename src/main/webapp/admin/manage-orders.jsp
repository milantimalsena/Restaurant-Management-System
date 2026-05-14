<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders | Admin</title>
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
                <p class="text-xs font-bold uppercase tracking-[0.2em] text-amber-600">Order Processing</p>
                <h1 class="mt-2 text-3xl font-black text-slate-950">Manage Orders</h1>
                <p class="mt-1 text-sm font-medium text-slate-500">Update kitchen and delivery status after payment is verified.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/payment-confirmation" class="rounded-2xl bg-slate-900 px-4 py-3 text-sm font-black text-white shadow-lg transition hover:bg-amber-600">Verify Payments</a>
        </header>

        <c:if test="${not empty successMessage}">
            <div class="mb-4 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-700">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="mb-4 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-700">${errorMessage}</div>
        </c:if>

        <section class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-200/70">
            <div class="flex flex-col gap-4 border-b border-slate-200 px-5 py-5 lg:flex-row lg:items-center lg:justify-between">
                <div>
                    <h2 class="text-xl font-black text-slate-950">All Orders</h2>
                    <p class="mt-1 text-sm font-semibold text-slate-500">Search runs in your browser and filters visible rows.</p>
                </div>
                <input id="orderSearch" type="search" placeholder="Search order, customer, status..." class="w-full rounded-2xl border border-slate-200 px-4 py-3 text-sm font-semibold outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-100 lg:max-w-sm">
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="px-5 py-16 text-center">
                        <p class="text-lg font-black text-slate-900">No orders found.</p>
                        <p class="mt-2 text-sm font-medium text-slate-500">New customer checkout orders will appear here.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                            <thead class="bg-slate-50 text-xs font-black uppercase tracking-wide text-slate-500">
                            <tr>
                                <th class="whitespace-nowrap px-5 py-4">Order</th>
                                <th class="whitespace-nowrap px-5 py-4">Customer</th>
                                <th class="whitespace-nowrap px-5 py-4">Type</th>
                                <th class="whitespace-nowrap px-5 py-4">Order Status</th>
                                <th class="whitespace-nowrap px-5 py-4">Payment</th>
                                <th class="whitespace-nowrap px-5 py-4">Total</th>
                                <th class="whitespace-nowrap px-5 py-4">Ordered At</th>
                                <th class="whitespace-nowrap px-5 py-4 text-right">Update</th>
                            </tr>
                            </thead>
                            <tbody id="ordersBody" class="divide-y divide-slate-100 bg-white">
                            <c:forEach var="order" items="${orders}">
                                <tr class="order-row transition hover:bg-amber-50/70">
                                    <td class="whitespace-nowrap px-5 py-4 font-black text-slate-950">#${order.orderId}</td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">
                                        <c:out value="${empty order.customerName ? 'Customer #' : order.customerName}" /><c:if test="${empty order.customerName}">${order.userId}</c:if>
                                    </td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${order.orderType}</td>
                                    <td class="whitespace-nowrap px-5 py-4">
                                        <c:choose>
                                            <c:when test="${order.orderStatus eq 'Pending'}"><span class="rounded-full bg-gray-100 px-3 py-1 text-xs font-black text-gray-700">Pending</span></c:when>
                                            <c:when test="${order.orderStatus eq 'Preparing'}"><span class="rounded-full bg-orange-100 px-3 py-1 text-xs font-black text-orange-700">Preparing</span></c:when>
                                            <c:when test="${order.orderStatus eq 'Ready'}"><span class="rounded-full bg-blue-100 px-3 py-1 text-xs font-black text-blue-700">Ready</span></c:when>
                                            <c:when test="${order.orderStatus eq 'Delivered'}"><span class="rounded-full bg-green-100 px-3 py-1 text-xs font-black text-green-700">Delivered</span></c:when>
                                            <c:when test="${order.orderStatus eq 'Cancelled'}"><span class="rounded-full bg-red-100 px-3 py-1 text-xs font-black text-red-700">Cancelled</span></c:when>
                                            <c:otherwise><span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-black text-slate-700">${order.orderStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="whitespace-nowrap px-5 py-4">
                                        <c:choose>
                                            <c:when test="${order.paymentStatus eq 'Pending Verification'}"><span class="rounded-full bg-yellow-100 px-3 py-1 text-xs font-black text-yellow-700">Pending Verification</span></c:when>
                                            <c:when test="${order.paymentStatus eq 'Paid'}"><span class="rounded-full bg-green-100 px-3 py-1 text-xs font-black text-green-700">Paid</span></c:when>
                                            <c:when test="${order.paymentStatus eq 'Rejected'}"><span class="rounded-full bg-red-100 px-3 py-1 text-xs font-black text-red-700">Rejected</span></c:when>
                                            <c:otherwise><span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-black text-slate-700">${order.paymentStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="whitespace-nowrap px-5 py-4 font-black text-slate-950">NPR <fmt:formatNumber value="${order.grandTotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-600">${order.orderedAt}</td>
                                    <td class="whitespace-nowrap px-5 py-4">
                                        <form action="${pageContext.request.contextPath}/admin/manage-orders" method="post" class="flex justify-end gap-2">
                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                            <select name="orderStatus" class="rounded-xl border border-slate-200 bg-white px-3 py-2 text-xs font-bold text-slate-700 outline-none focus:border-amber-400">
                                                <option value="Pending" ${order.orderStatus eq 'Pending' ? 'selected' : ''}>Pending</option>
                                                <option value="Preparing" ${order.orderStatus eq 'Preparing' ? 'selected' : ''}>Preparing</option>
                                                <option value="Ready" ${order.orderStatus eq 'Ready' ? 'selected' : ''}>Ready</option>
                                                <option value="Delivered" ${order.orderStatus eq 'Delivered' ? 'selected' : ''}>Delivered</option>
                                                <option value="Cancelled" ${order.orderStatus eq 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                            <button type="submit" class="rounded-xl bg-slate-900 px-4 py-2 text-xs font-black text-white transition hover:bg-amber-600">Save</button>
                                        </form>
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
const searchInput = document.getElementById('orderSearch');
if (searchInput) {
    searchInput.addEventListener('input', () => {
        const query = searchInput.value.toLowerCase();
        document.querySelectorAll('.order-row').forEach((row) => {
            row.classList.toggle('hidden', !row.textContent.toLowerCase().includes(query));
        });
    });
}

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
