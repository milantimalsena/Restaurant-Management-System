<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="adminName" value="${not empty sessionScope.adminFullName ? sessionScope.adminFullName : 'Administrator'}" />
<c:set var="currentPath" value="${pageContext.request.servletPath}" />

<c:set var="adminLinkBase" value="flex items-center justify-between rounded-2xl px-4 py-3 text-sm font-semibold transition hover:bg-white/5 hover:text-white" />
<c:set var="adminLinkActive" value="bg-amber-500 px-4 py-3 text-slate-950 shadow-xl shadow-amber-500/20 hover:bg-amber-400 hover:text-slate-950" />
<c:set var="adminLinkIdle" value="text-slate-300" />

<aside id="adminSidebar" class="fixed inset-y-0 left-0 z-40 flex w-72 -translate-x-full flex-col overflow-hidden border-r border-white/10 bg-slate-950/95 backdrop-blur-xl transition-transform duration-300 lg:translate-x-0">
    <div class="shrink-0 px-5 pt-6">
    <div class="flex items-center justify-between">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex min-w-0 items-center gap-3 no-underline">
            <span class="flex h-12 w-12 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-white shadow-lg shadow-amber-500/20">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" class="h-full w-full object-cover" />
            </span>
            <span class="min-w-0">
                <span class="block text-xs font-semibold uppercase tracking-[0.3em] text-slate-500">Admin Console</span>
                <span class="block truncate text-lg font-bold text-white">Himalayan Yaks</span>
            </span>
        </a>
        <button id="sidebarClose" type="button" class="rounded-xl border border-white/10 bg-white/5 p-2 text-slate-200 lg:hidden" aria-label="Close sidebar">
            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M6 18L18 6M6 6l12 12" />
            </svg>
        </button>
    </div>
    </div>

    <div class="mx-5 mt-8 shrink-0 rounded-3xl border border-white/10 bg-white/5 p-4">
        <p class="text-xs uppercase tracking-[0.28em] text-slate-500">Signed in as</p>
        <p class="mt-2 truncate text-lg font-bold text-white">${adminName}</p>
        <p class="mt-1 truncate text-sm text-slate-400">${sessionScope.adminEmail}</p>
    </div>

    <nav class="mt-8 flex-1 space-y-2 overflow-y-auto px-5 pb-6 pr-3">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="${adminLinkBase} ${(currentPath eq '/admin/dashboard' or currentPath eq '/admin/dashboard.jsp') ? adminLinkActive : adminLinkIdle}">
            <span>Dashboard</span>
            <span class="text-xs uppercase tracking-[0.2em]">Live</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-menu" class="${adminLinkBase} ${(currentPath eq '/admin/manage-menu.jsp' or currentPath eq '/admin/add-menu-item.jsp' or currentPath eq '/admin/edit-menu-item.jsp') ? adminLinkActive : adminLinkIdle}">
            <span>Manage Menu</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories" class="${adminLinkBase} ${currentPath eq '/admin/manage-categories.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Categories</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-customers.jsp" class="${adminLinkBase} ${currentPath eq '/admin/manage-customers.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Customers</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-orders" class="${adminLinkBase} ${currentPath eq '/admin/manage-orders.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Manage Orders</span>
            <span class="rounded-full bg-cyan-400/10 px-2 py-0.5 text-xs text-cyan-300">Status</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/payment-confirmation" class="${adminLinkBase} ${currentPath eq '/admin/payment-confirmation.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Payment Confirmation</span>
            <span class="rounded-full bg-amber-400/10 px-2 py-0.5 text-xs text-amber-300">Verify</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-reservations" class="${adminLinkBase} ${currentPath eq '/admin/manage-reservations.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Reservations</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-reservations#tables" class="${adminLinkBase} ${adminLinkIdle}">
            <span>Manage Tables</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/payment-settings.jsp" class="${adminLinkBase} ${currentPath eq '/admin/payment-settings.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Payment Settings</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports.jsp" class="${adminLinkBase} ${currentPath eq '/admin/reports.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Reports</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/feedbacks.jsp" class="${adminLinkBase} ${currentPath eq '/admin/feedbacks.jsp' ? adminLinkActive : adminLinkIdle}">
            <span>Feedbacks</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-between rounded-2xl px-4 py-3 text-sm font-semibold text-rose-300 transition hover:bg-rose-500/10 hover:text-rose-200">
            <span>Logout</span>
        </a>
    </nav>
</aside>
