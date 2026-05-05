<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPath" value="${pageContext.request.servletPath}" />
<c:set var="cartCountValue" value="${not empty cartCount ? cartCount : (not empty sessionScope.cartCount ? sessionScope.cartCount : 0)}" />
<c:set var="homeActive" value="${currentPath eq '/public/home.jsp' ? 'bg-white/15 text-white ring-1 ring-white/15' : 'text-stone-200 hover:bg-white/10 hover:text-white'}" />
<c:set var="menuActive" value="${currentPath eq '/public/menu.jsp' ? 'bg-white/15 text-white ring-1 ring-white/15' : 'text-stone-200 hover:bg-white/10 hover:text-white'}" />
<c:set var="aboutActive" value="${currentPath eq '/public/about.jsp' ? 'bg-white/15 text-white ring-1 ring-white/15' : 'text-stone-200 hover:bg-white/10 hover:text-white'}" />
<c:set var="contactActive" value="${currentPath eq '/public/contact.jsp' ? 'bg-white/15 text-white ring-1 ring-white/15' : 'text-stone-200 hover:bg-white/10 hover:text-white'}" />

<script src="https://cdn.tailwindcss.com"></script>

<nav class="sticky top-0 z-50 border-b border-amber-100/10 bg-stone-950/95 shadow-2xl shadow-stone-950/20 backdrop-blur-xl">
    <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-3 sm:px-6 lg:px-8">
        <a href="${pageContext.request.contextPath}/public/home.jsp" class="flex min-w-0 items-center gap-3 no-underline">
            <span class="flex h-14 w-14 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-amber-50 shadow-lg shadow-amber-500/20 ring-1 ring-white/15">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" class="h-full w-full object-cover" />
            </span>
            <span class="min-w-0">
                <span class="block text-xs font-bold uppercase tracking-[0.28em] text-amber-300">Himalayan Yaks</span>
                <span class="block truncate text-lg font-black text-white">Taste of Himalayas</span>
            </span>
        </a>

        <button id="restaurantNavbarToggle" type="button" class="inline-flex h-11 w-11 items-center justify-center rounded-2xl border border-white/10 bg-white/5 text-stone-100 transition hover:bg-white/10 lg:hidden" aria-controls="restaurantNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 7h16M4 12h16M4 17h16" />
            </svg>
        </button>

        <div id="restaurantNavbar" class="hidden absolute left-4 right-4 top-[5.25rem] rounded-3xl border border-white/10 bg-stone-950/98 p-4 shadow-2xl shadow-stone-950/35 lg:static lg:flex lg:flex-1 lg:items-center lg:justify-between lg:gap-4 lg:rounded-none lg:border-0 lg:bg-transparent lg:p-0 lg:shadow-none">
            <div class="flex flex-col gap-2 lg:mx-auto lg:flex-row lg:items-center">
                <a class="rounded-full px-4 py-2 text-sm font-semibold no-underline transition ${homeActive}" href="${pageContext.request.contextPath}/public/home.jsp">Home</a>
                <a class="rounded-full px-4 py-2 text-sm font-semibold no-underline transition ${menuActive}" href="${pageContext.request.contextPath}/menu">Menu</a>
                <a class="rounded-full px-4 py-2 text-sm font-semibold no-underline transition ${aboutActive}" href="${pageContext.request.contextPath}/public/about.jsp">About</a>
                <a class="rounded-full px-4 py-2 text-sm font-semibold no-underline transition ${contactActive}" href="${pageContext.request.contextPath}/public/contact.jsp">Contact</a>
            </div>

            <div class="mt-4 flex flex-col gap-3 border-t border-white/10 pt-4 lg:mt-0 lg:flex-row lg:items-center lg:border-t-0 lg:pt-0">
                <c:choose>
                    <c:when test="${not empty sessionScope.user or not empty sessionScope.userRole or not empty sessionScope.guestCart}">
                        <c:choose>
                            <c:when test="${sessionScope.userRole eq 'ADMIN'}">
                                <a class="inline-flex items-center justify-center rounded-full border border-amber-200/25 px-4 py-2 text-sm font-bold text-amber-100 no-underline transition hover:bg-amber-100 hover:text-stone-950" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a class="inline-flex items-center justify-center rounded-full border border-amber-200/25 px-4 py-2 text-sm font-bold text-amber-100 no-underline transition hover:bg-amber-100 hover:text-stone-950" href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        <a class="relative inline-flex items-center justify-center rounded-full border border-white/15 px-4 py-2 text-sm font-bold text-stone-100 no-underline transition hover:bg-white/10" href="${pageContext.request.contextPath}/cart">
                            Cart
                            <span id="navCartCount" class="ml-2 inline-flex min-w-6 items-center justify-center rounded-full bg-red-500 px-2 py-0.5 text-xs font-black text-white">${cartCountValue}</span>
                        </a>
                        <a class="inline-flex items-center justify-center rounded-full bg-gradient-to-r from-amber-300 to-orange-500 px-5 py-2 text-sm font-black text-stone-950 no-underline shadow-lg shadow-orange-500/20 transition hover:brightness-105" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a class="inline-flex items-center justify-center rounded-full border border-amber-200/25 px-4 py-2 text-sm font-bold text-amber-100 no-underline transition hover:bg-amber-100 hover:text-stone-950" href="${pageContext.request.contextPath}/login">Login</a>
                        <a class="inline-flex items-center justify-center rounded-full bg-gradient-to-r from-amber-300 to-orange-500 px-5 py-2 text-sm font-black text-stone-950 no-underline shadow-lg shadow-orange-500/20 transition hover:brightness-105" href="${pageContext.request.contextPath}/register">Book a Table</a>
                    </c:otherwise>
                </c:choose>

                <div class="min-w-0 border-t border-white/10 pt-3 text-stone-100 lg:border-l lg:border-t-0 lg:pl-4 lg:pt-0">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user and not empty sessionScope.user.fullName}">
                            <p class="truncate text-sm font-bold text-white">${sessionScope.user.fullName}</p>
                        </c:when>
                        <c:when test="${not empty sessionScope.adminFullName}">
                            <p class="truncate text-sm font-bold text-white">${sessionScope.adminFullName}</p>
                        </c:when>
                        <c:when test="${not empty sessionScope.userFullName}">
                            <p class="truncate text-sm font-bold text-white">${sessionScope.userFullName}</p>
                        </c:when>
                        <c:otherwise>
                            <p class="truncate text-sm font-bold text-white">Guest</p>
                        </c:otherwise>
                    </c:choose>
                    <p class="mt-0.5 text-[0.68rem] font-bold uppercase tracking-[0.22em] text-stone-400">
                        <c:choose>
                            <c:when test="${sessionScope.userRole eq 'ADMIN'}">Administrator</c:when>
                            <c:when test="${not empty sessionScope.userRole}">Customer</c:when>
                            <c:otherwise>Visitor</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>
        </div>
    </div>
</nav>

<script>
(() => {
    const toggle = document.getElementById('restaurantNavbarToggle');
    const menu = document.getElementById('restaurantNavbar');
    if (!toggle || !menu) {
        return;
    }

    toggle.addEventListener('click', () => {
        const isHidden = menu.classList.toggle('hidden');
        toggle.setAttribute('aria-expanded', String(!isHidden));
    });
})();
</script>
