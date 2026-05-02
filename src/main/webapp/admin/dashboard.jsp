<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Dashboard | Himalayan Yaks</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-slate-950 text-slate-100">
<c:set var="adminName" value="${not empty sessionScope.adminFullName ? sessionScope.adminFullName : 'Administrator'}" />
<c:set var="totalOrdersValue" value="${empty totalOrders ? 0 : totalOrders}" />
<c:set var="revenueValue" value="${empty revenue ? 0 : revenue}" />
<c:set var="customerValue" value="${empty customers ? 0 : customers}" />
<c:set var="reservationValue" value="${empty reservations ? 0 : reservations}" />

<div class="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(79,70,229,0.18),_transparent_30%),linear-gradient(180deg,#020617_0%,#0f172a_40%,#020617_100%)]">
    <div class="flex min-h-screen">
        <aside id="adminSidebar" class="fixed inset-y-0 left-0 z-40 w-72 -translate-x-full border-r border-white/10 bg-slate-950/95 px-5 py-6 backdrop-blur-xl transition-transform duration-300 lg:translate-x-0">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <span class="flex h-12 w-12 items-center justify-center overflow-hidden rounded-2xl bg-white shadow-lg shadow-indigo-500/20">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" class="h-full w-full object-cover" />
                    </span>
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-500">Admin Console</p>
                        <h1 class="text-lg font-bold text-white">Himalayan Yaks</h1>
                    </div>
                </div>
                <button id="sidebarClose" type="button" class="rounded-xl border border-white/10 bg-white/5 p-2 text-slate-200 lg:hidden" aria-label="Close sidebar">
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M6 18L18 6M6 6l12 12" /></svg>
                </button>
            </div>

            <div class="mt-8 rounded-3xl border border-white/10 bg-white/5 p-4">
                <p class="text-xs uppercase tracking-[0.28em] text-slate-500">Signed in as</p>
                <p class="mt-2 text-lg font-bold text-white">${adminName}</p>
                <p class="mt-1 truncate text-sm text-slate-400">${sessionScope.adminEmail}</p>
            </div>

            <nav class="mt-8 space-y-2 text-sm font-medium">
                <a href="#overview" class="flex items-center justify-between rounded-2xl bg-indigo-500/15 px-4 py-3 text-indigo-200 ring-1 ring-indigo-400/25 transition hover:bg-indigo-500/20">
                    <span>Overview</span>
                    <span class="text-xs uppercase tracking-[0.24em]">Live</span>
                </a>
                <a href="#orders" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Recent Orders</a>
                <a href="#selling" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Top Selling Items</a>
                <a href="${pageContext.request.contextPath}/admin/manage-menu" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Manage Menu</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Categories</a>
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-between rounded-2xl px-4 py-3 text-rose-300 transition hover:bg-rose-500/10 hover:text-rose-200">Logout</a>
            </nav>
        </aside>

        <div class="flex min-h-screen flex-1 flex-col lg:pl-72">
            <header class="sticky top-0 z-30 border-b border-white/10 bg-slate-950/85 backdrop-blur-xl">
                <div class="flex items-center gap-4 px-4 py-4 sm:px-6 lg:px-8">
                    <button id="sidebarOpen" type="button" class="inline-flex items-center justify-center rounded-2xl border border-white/10 bg-white/5 p-2 text-slate-200 transition hover:bg-white/10 lg:hidden" aria-label="Open sidebar">
                        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M4 6h16M4 12h16M4 18h16" /></svg>
                    </button>

                    <div class="min-w-0 flex-1">
                        <p class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-500">Admin dashboard</p>
                        <h2 class="truncate text-2xl font-black tracking-tight text-white">Operational control at a glance</h2>
                    </div>

                    <div class="hidden flex-1 max-w-md lg:block">
                        <label class="relative block">
                            <span class="sr-only">Search</span>
                            <span class="pointer-events-none absolute inset-y-0 left-4 flex items-center text-slate-500">
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M21 21l-4.35-4.35m1.85-5.15a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z" /></svg>
                            </span>
                            <input type="search" placeholder="Search orders, customers, reservations..." class="w-full rounded-2xl border border-white/10 bg-white/5 py-3 pl-12 pr-4 text-sm text-white outline-none transition placeholder:text-slate-500 focus:border-indigo-400/60 focus:bg-white/10" />
                        </label>
                    </div>

                    <div class="flex items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-4 py-2 shadow-lg shadow-slate-950/20">
                        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-cyan-400 font-bold text-white">AD</div>
                        <div class="hidden sm:block">
                            <p class="text-sm font-semibold text-white">${adminName}</p>
                            <p class="text-xs text-slate-400">Administrator</p>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-1 px-4 py-6 sm:px-6 lg:px-8 lg:py-8">
                <section id="overview" class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
                    <article class="group rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-5 shadow-xl shadow-slate-950/30 transition hover:-translate-y-1 hover:border-indigo-400/30 hover:shadow-indigo-950/30">
                        <div class="flex items-start justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Total Orders</p>
                                <p class="mt-3 text-3xl font-black text-white">${totalOrdersValue}</p>
                            </div>
                            <span class="rounded-2xl bg-indigo-500/15 p-3 text-indigo-300 ring-1 ring-indigo-400/20">Ã¢â€”â€ </span>
                        </div>
                        <p class="mt-4 text-sm text-slate-400">All completed, pending, and in-progress orders.</p>
                    </article>

                    <article class="group rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-5 shadow-xl shadow-slate-950/30 transition hover:-translate-y-1 hover:border-emerald-400/30 hover:shadow-emerald-950/30">
                        <div class="flex items-start justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Revenue</p>
                                <p class="mt-3 text-3xl font-black text-white">NPR ${revenueValue}</p>
                            </div>
                            <span class="rounded-2xl bg-emerald-500/15 p-3 text-emerald-300 ring-1 ring-emerald-400/20">$</span>
                        </div>
                        <p class="mt-4 text-sm text-slate-400">Gross revenue from live and historical orders.</p>
                    </article>

                    <article class="group rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-5 shadow-xl shadow-slate-950/30 transition hover:-translate-y-1 hover:border-cyan-400/30 hover:shadow-cyan-950/30">
                        <div class="flex items-start justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Customers</p>
                                <p class="mt-3 text-3xl font-black text-white">${customerValue}</p>
                            </div>
                            <span class="rounded-2xl bg-cyan-500/15 p-3 text-cyan-300 ring-1 ring-cyan-400/20">Ã¢ËœÂº</span>
                        </div>
                        <p class="mt-4 text-sm text-slate-400">Registered and active customer accounts.</p>
                    </article>

                    <article class="group rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-5 shadow-xl shadow-slate-950/30 transition hover:-translate-y-1 hover:border-amber-400/30 hover:shadow-amber-950/30">
                        <div class="flex items-start justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Reservations</p>
                                <p class="mt-3 text-3xl font-black text-white">${reservationValue}</p>
                            </div>
                            <span class="rounded-2xl bg-amber-500/15 p-3 text-amber-300 ring-1 ring-amber-400/20">Ã¢â€“Â£</span>
                        </div>
                        <p class="mt-4 text-sm text-slate-400">Booked and upcoming dining reservations.</p>
                    </article>
                </section>

                <section class="mt-6 grid gap-6 xl:grid-cols-[1.45fr_0.95fr]">
                    <article class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex items-center justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Revenue Chart</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Weekly performance</h3>
                            </div>
                            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-semibold text-slate-300">Chart.js</span>
                        </div>
                        <div class="mt-6 h-80 rounded-[1.5rem] border border-white/10 bg-slate-950/60 p-4">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </article>

                    <article class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex items-center justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Orders Trend</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Order velocity</h3>
                            </div>
                            <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-semibold text-slate-300">Live summary</span>
                        </div>
                        <div class="mt-6 h-80 rounded-[1.5rem] border border-white/10 bg-slate-950/60 p-4">
                            <canvas id="ordersChart"></canvas>
                        </div>
                    </article>
                </section>

                <section class="mt-6 grid gap-6 xl:grid-cols-[1.3fr_0.9fr]">
                    <article id="orders" class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex items-center justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Recent Orders</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Latest activity</h3>
                            </div>
                        </div>

                        <div class="mt-6 overflow-hidden rounded-[1.5rem] border border-white/10">
                            <c:choose>
                                <c:when test="${not empty recentOrders}">
                                    <div class="overflow-x-auto">
                                        <table class="min-w-full divide-y divide-white/10 text-left text-sm">
                                            <thead class="bg-white/5 text-xs uppercase tracking-[0.28em] text-slate-400">
                                                <tr>
                                                    <th class="px-4 py-3 font-semibold">Order</th>
                                                    <th class="px-4 py-3 font-semibold">Status</th>
                                                    <th class="px-4 py-3 font-semibold">Payment</th>
                                                    <th class="px-4 py-3 font-semibold">Total</th>
                                                    <th class="px-4 py-3 font-semibold">Placed</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-white/10 bg-slate-950/40 text-slate-200">
                                                <c:forEach var="order" items="${recentOrders}">
                                                    <tr class="transition hover:bg-white/5">
                                                        <td class="px-4 py-4">
                                                            <p class="font-semibold text-white">${order.orderNumber}</p>
                                                            <p class="text-xs text-slate-400">Order ID ${order.orderId}</p>
                                                        </td>
                                                        <td class="px-4 py-4">
                                                            <span class="inline-flex rounded-full px-3 py-1 text-xs font-semibold ${order.orderStatus eq 'DELIVERED' ? 'bg-emerald-400/15 text-emerald-300 ring-1 ring-emerald-400/30' : order.orderStatus eq 'PENDING' ? 'bg-amber-400/15 text-amber-300 ring-1 ring-amber-400/30' : 'bg-cyan-400/15 text-cyan-300 ring-1 ring-cyan-400/30'}">${order.orderStatus}</span>
                                                        </td>
                                                        <td class="px-4 py-4 text-slate-300">${order.paymentStatus}</td>
                                                        <td class="px-4 py-4 font-semibold text-white">NPR ${order.grandTotal}</td>
                                                        <td class="px-4 py-4 text-slate-400">${order.orderedAt}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="space-y-3 p-6">
                                        <div class="h-4 w-2/3 animate-pulse rounded-full bg-white/10"></div>
                                        <div class="h-4 w-1/2 animate-pulse rounded-full bg-white/10"></div>
                                        <div class="h-4 w-5/6 animate-pulse rounded-full bg-white/10"></div>
                                        <p class="pt-4 text-sm text-slate-400">No recent orders yet. This section will populate once the backend sends <span class="font-semibold text-slate-200">recentOrders</span>.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>

                    <article id="selling" class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex items-center justify-between gap-4">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Top Selling Items</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Best performers</h3>
                            </div>
                        </div>

                        <div class="mt-6 space-y-3">
                            <c:choose>
                                <c:when test="${not empty topSellingItems}">
                                    <c:forEach var="item" items="${topSellingItems}">
                                        <div class="flex items-center justify-between gap-4 rounded-[1.25rem] border border-white/10 bg-slate-950/50 px-4 py-4 transition hover:border-indigo-400/30 hover:bg-white/5">
                                            <div class="min-w-0">
                                                <p class="truncate font-semibold text-white">${item.itemName}</p>
                                                <p class="text-xs text-slate-400">${item.categoryName}</p>
                                            </div>
                                            <div class="text-right">
                                                <p class="text-sm font-semibold text-white">Qty: ${item.quantity}</p>
                                                <p class="text-xs text-slate-400">Revenue: ${item.lineTotal}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="rounded-[1.25rem] border border-dashed border-white/15 bg-white/5 p-6 text-center">
                                        <p class="text-sm font-semibold text-white">No top-selling data yet</p>
                                        <p class="mt-2 text-sm text-slate-400">Add a backend list called <span class="font-semibold text-slate-200">topSellingItems</span> to populate this widget.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </section>
            </main>
        </div>
    </div>
</div>

<script>
(() => {
    const sidebar = document.getElementById('adminSidebar');
    const openButton = document.getElementById('sidebarOpen');
    const closeButton = document.getElementById('sidebarClose');

    const toggleSidebar = (open) => {
        if (!sidebar) return;
        sidebar.classList.toggle('-translate-x-full', !open);
        sidebar.classList.toggle('translate-x-0', open);
    };

    if (openButton) {
        openButton.addEventListener('click', () => toggleSidebar(true));
    }
    if (closeButton) {
        closeButton.addEventListener('click', () => toggleSidebar(false));
    }
})();

const revenueLabels = [
<c:choose>
    <c:when test="${not empty revenueLabels}">
        <c:forEach var="label" items="${revenueLabels}" varStatus="status">'${label}'<c:if test="${!status.last}">,</c:if></c:forEach>
    </c:when>
    <c:otherwise>'Mon','Tue','Wed','Thu','Fri','Sat','Sun'</c:otherwise>
</c:choose>
];

const revenueValues = [
<c:choose>
    <c:when test="${not empty revenueValues}">
        <c:forEach var="value" items="${revenueValues}" varStatus="status">${value}<c:if test="${!status.last}">,</c:if></c:forEach>
    </c:when>
    <c:otherwise>22000,28000,21000,34000,36000,39000,45000</c:otherwise>
</c:choose>
];

const ordersLabels = [
<c:choose>
    <c:when test="${not empty ordersTrendLabels}">
        <c:forEach var="label" items="${ordersTrendLabels}" varStatus="status">'${label}'<c:if test="${!status.last}">,</c:if></c:forEach>
    </c:when>
    <c:otherwise>'Mon','Tue','Wed','Thu','Fri','Sat','Sun'</c:otherwise>
</c:choose>
];

const ordersValues = [
<c:choose>
    <c:when test="${not empty ordersTrendValues}">
        <c:forEach var="value" items="${ordersTrendValues}" varStatus="status">${value}<c:if test="${!status.last}">,</c:if></c:forEach>
    </c:when>
    <c:otherwise>24,31,28,36,40,43,48</c:otherwise>
</c:choose>
];

const commonGridColor = 'rgba(148, 163, 184, 0.12)';
const commonTextColor = '#cbd5e1';

if (document.getElementById('revenueChart')) {
    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: revenueLabels,
            datasets: [{
                label: 'Revenue',
                data: revenueValues,
                borderColor: '#818cf8',
                backgroundColor: 'rgba(129, 140, 248, 0.16)',
                fill: true,
                tension: 0.38,
                pointRadius: 4,
                pointHoverRadius: 6,
                pointBackgroundColor: '#f8fafc'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: commonTextColor }
                }
            },
            scales: {
                x: {
                    grid: { color: commonGridColor },
                    ticks: { color: commonTextColor }
                },
                y: {
                    grid: { color: commonGridColor },
                    ticks: { color: commonTextColor }
                }
            }
        }
    });
}

if (document.getElementById('ordersChart')) {
    new Chart(document.getElementById('ordersChart'), {
        type: 'bar',
        data: {
            labels: ordersLabels,
            datasets: [{
                label: 'Orders',
                data: ordersValues,
                borderRadius: 14,
                backgroundColor: ['#38bdf8', '#818cf8', '#22c55e', '#f59e0b', '#ec4899', '#14b8a6', '#60a5fa']
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: { color: commonTextColor }
                }
            },
            scales: {
                x: {
                    grid: { color: commonGridColor },
                    ticks: { color: commonTextColor }
                },
                y: {
                    grid: { color: commonGridColor },
                    ticks: { color: commonTextColor }
                }
            }
        }
    });
}
</script>
</body>
</html>
