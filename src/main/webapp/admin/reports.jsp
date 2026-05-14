<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | Admin</title>
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
                <p class="text-xs font-black uppercase tracking-[0.22em] text-amber-600">Business Insights</p>
                <h1 class="mt-2 text-3xl font-black text-slate-950">Reports</h1>
                <p class="mt-2 max-w-2xl text-sm font-medium leading-7 text-slate-500">Track restaurant performance, order activity, revenue, reservations, and customer growth from one place.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="rounded-2xl bg-slate-950 px-5 py-3 text-sm font-black text-white shadow-lg transition hover:bg-amber-600">Dashboard</a>
        </header>

        <section class="grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Orders</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">${empty totalOrders ? 0 : totalOrders}</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Total customer orders recorded in the system.</p>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Revenue</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">NPR ${empty revenue ? 0 : revenue}</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Confirmed payment revenue summary.</p>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Reservations</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">${empty reservations ? 0 : reservations}</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Booked dining reservations and table requests.</p>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Customers</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">${empty customers ? 0 : customers}</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Registered customer accounts.</p>
            </article>
        </section>

        <section class="mt-6 grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <div class="flex items-center justify-between gap-4">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-amber-600">Weekly Overview</p>
                        <h2 class="mt-2 text-xl font-black text-slate-950">Operational Summary</h2>
                    </div>
                    <span class="rounded-full bg-amber-100 px-4 py-2 text-xs font-black text-amber-700">Live Ready</span>
                </div>

                <div class="mt-8 grid gap-4">
                    <div class="rounded-2xl bg-slate-50 p-5">
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-bold text-slate-600">Order completion</span>
                            <span class="text-sm font-black text-slate-950">78%</span>
                        </div>
                        <div class="mt-3 h-3 overflow-hidden rounded-full bg-slate-200">
                            <div class="h-full w-[78%] rounded-full bg-amber-500"></div>
                        </div>
                    </div>

                    <div class="rounded-2xl bg-slate-50 p-5">
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-bold text-slate-600">Payment verification</span>
                            <span class="text-sm font-black text-slate-950">64%</span>
                        </div>
                        <div class="mt-3 h-3 overflow-hidden rounded-full bg-slate-200">
                            <div class="h-full w-[64%] rounded-full bg-slate-950"></div>
                        </div>
                    </div>

                    <div class="rounded-2xl bg-slate-50 p-5">
                        <div class="flex items-center justify-between">
                            <span class="text-sm font-bold text-slate-600">Reservation approval</span>
                            <span class="text-sm font-black text-slate-950">86%</span>
                        </div>
                        <div class="mt-3 h-3 overflow-hidden rounded-full bg-slate-200">
                            <div class="h-full w-[86%] rounded-full bg-emerald-500"></div>
                        </div>
                    </div>
                </div>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-slate-950 p-6 text-white shadow-xl shadow-slate-900/10">
                <p class="text-xs font-black uppercase tracking-[0.22em] text-amber-300">Admin Note</p>
                <h2 class="mt-4 text-2xl font-black">Reports module is ready for live data.</h2>
                <p class="mt-4 text-sm leading-7 text-slate-300">Connect this page to dashboard DAO summaries, order trend queries, and revenue reports when finalizing analytics.</p>
                <div class="mt-6 grid gap-3">
                    <a href="${pageContext.request.contextPath}/admin/manage-orders" class="rounded-2xl bg-white/10 px-4 py-3 text-sm font-black text-white no-underline transition hover:bg-white/20">View Orders</a>
                    <a href="${pageContext.request.contextPath}/admin/manage-reservations" class="rounded-2xl bg-white/10 px-4 py-3 text-sm font-black text-white no-underline transition hover:bg-white/20">View Reservations</a>
                </div>
            </article>
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
