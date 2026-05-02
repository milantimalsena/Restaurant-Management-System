<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPath" value="${pageContext.request.servletPath}" />
<c:set var="navbarVariant" value="${empty navbarVariant ? 'tailwind' : navbarVariant}" />
<c:set var="cartCountValue" value="${empty cartCount ? 0 : cartCount}" />

<c:choose>
    <c:when test="${navbarVariant eq 'bootstrap'}">
        <c:set var="homeActive" value="${currentPath eq '/public/home.jsp' ? 'active fw-semibold text-primary' : ''}" />
        <c:set var="menuActive" value="${currentPath eq '/public/menu.jsp' ? 'active fw-semibold text-primary' : ''}" />
        <c:set var="aboutActive" value="${currentPath eq '/public/about.jsp' ? 'active fw-semibold text-primary' : ''}" />
        <c:set var="contactActive" value="${currentPath eq '/public/contact.jsp' ? 'active fw-semibold text-primary' : ''}" />
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top shadow-sm">
            <div class="container py-2">
                <a class="navbar-brand d-flex align-items-center gap-3" href="${pageContext.request.contextPath}/public/home.jsp">
                    <span class="d-inline-flex align-items-center justify-content-center rounded-4 bg-dark text-white fw-bold" style="width: 46px; height: 46px;">SR</span>
                    <span>
                        <span class="d-block text-uppercase small text-secondary fw-semibold" style="letter-spacing:.24em;">Smart Restaurant</span>
                        <span class="d-block fw-bold text-dark">Management System</span>
                    </span>
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#publicNavbar" aria-controls="publicNavbar" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="publicNavbar">
                    <ul class="navbar-nav mx-lg-auto mb-2 mb-lg-0 gap-lg-1">
                        <li class="nav-item"><a class="nav-link ${homeActive}" href="${pageContext.request.contextPath}/public/home.jsp">Home</a></li>
                        <li class="nav-item"><a class="nav-link ${menuActive}" href="${pageContext.request.contextPath}/menu">Menu</a></li>
                        <li class="nav-item"><a class="nav-link ${aboutActive}" href="${pageContext.request.contextPath}/public/about.jsp">About</a></li>
                        <li class="nav-item"><a class="nav-link ${contactActive}" href="${pageContext.request.contextPath}/public/contact.jsp">Contact</a></li>
                    </ul>

                    <div class="d-flex flex-column flex-lg-row gap-2 ms-lg-auto align-items-lg-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user or not empty sessionScope.userRole}">
                                <c:choose>
                                    <c:when test="${sessionScope.userRole eq 'ADMIN'}">
                                        <a class="btn btn-outline-primary rounded-pill px-4" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn btn-outline-primary rounded-pill px-4" href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a>
                                    </c:otherwise>
                                </c:choose>
                                <a class="btn btn-outline-dark rounded-pill px-4 position-relative" href="${pageContext.request.contextPath}/cart">
                                    Cart
                                    <span class="badge text-bg-dark position-absolute top-0 start-100 translate-middle">${cartCountValue}</span>
                                </a>
                                <a class="btn btn-dark rounded-pill px-4" href="${pageContext.request.contextPath}/logout">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn btn-outline-dark rounded-pill px-4" href="${pageContext.request.contextPath}/login">Login</a>
                                <a class="btn btn-dark rounded-pill px-4" href="${pageContext.request.contextPath}/register">Register</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${currentPath eq '/public/menu.jsp'}">
                <c:set var="menuLinkClass" value="rounded-full bg-white/10 px-4 py-2 text-sm font-semibold text-white ring-1 ring-white/10 transition hover:bg-white/15" />
            </c:when>
            <c:otherwise>
                <c:set var="menuLinkClass" value="rounded-full px-4 py-2 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${currentPath eq '/customer/dashboard.jsp' or currentPath eq '/admin/dashboard.jsp'}">
                <c:set var="dashboardLinkClass" value="rounded-full bg-white/10 px-4 py-2 text-sm font-semibold text-white ring-1 ring-white/10 transition hover:bg-white/15" />
            </c:when>
            <c:otherwise>
                <c:set var="dashboardLinkClass" value="rounded-full px-4 py-2 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${currentPath eq '/cart'}">
                <c:set var="cartLinkClass" value="rounded-full bg-amber-400/15 px-4 py-2 text-sm font-semibold text-amber-300 ring-1 ring-amber-400/30 transition hover:bg-amber-400/20" />
            </c:when>
            <c:otherwise>
                <c:set var="cartLinkClass" value="rounded-full px-4 py-2 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${currentPath eq '/login'}">
                <c:set var="loginLinkClass" value="rounded-full bg-white/10 px-4 py-2 text-sm font-semibold text-white ring-1 ring-white/10 transition hover:bg-white/15" />
            </c:when>
            <c:otherwise>
                <c:set var="loginLinkClass" value="rounded-full px-4 py-2 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${currentPath eq '/register'}">
                <c:set var="registerLinkClass" value="rounded-full bg-emerald-400/15 px-4 py-2 text-sm font-semibold text-emerald-300 ring-1 ring-emerald-400/30 transition hover:bg-emerald-400/20" />
            </c:when>
            <c:otherwise>
                <c:set var="registerLinkClass" value="rounded-full px-4 py-2 text-sm font-medium text-slate-300 transition hover:bg-white/10 hover:text-white" />
            </c:otherwise>
        </c:choose>
        <nav class="sticky top-0 z-50 border-b border-white/10 bg-slate-950/90 backdrop-blur-xl">
            <div class="mx-auto flex max-w-7xl items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
                <a href="${pageContext.request.contextPath}/menu" class="flex items-center gap-3">
                    <span class="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-indigo-500 to-sky-400 text-lg font-black text-white shadow-lg shadow-indigo-500/20">SR</span>
                    <span>
                        <span class="block text-sm font-semibold uppercase tracking-[0.3em] text-slate-400">Smart Restaurant</span>
                        <span class="block text-lg font-bold text-white">Management System</span>
                    </span>
                </a>

                <button id="navToggle" type="button" class="inline-flex items-center justify-center rounded-xl border border-white/10 bg-white/5 p-2 text-slate-200 transition hover:bg-white/10 md:hidden" aria-controls="navMenu" aria-expanded="false">
                    <span class="sr-only">Toggle navigation</span>
                    <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M4 6h16M4 12h16M4 18h16" />
                    </svg>
                </button>

                <div id="navMenu" class="hidden w-full items-center gap-3 rounded-3xl border border-white/10 bg-slate-900/95 p-4 shadow-2xl shadow-slate-950/40 md:flex md:w-auto md:border-0 md:bg-transparent md:p-0 md:shadow-none">
                    <div class="flex flex-col gap-2 md:flex-row md:items-center md:gap-2">
                        <a href="${pageContext.request.contextPath}/menu" class="${menuLinkClass}">Menu</a>
                        <c:choose>
                            <c:when test="${not empty sessionScope.user or not empty sessionScope.userRole}">
                                <c:choose>
                                    <c:when test="${sessionScope.userRole eq 'ADMIN'}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="${dashboardLinkClass}">Dashboard</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="${dashboardLinkClass}">Dashboard</a>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/cart" class="${cartLinkClass} flex items-center gap-2">
                                    <span>Cart</span>
                                    <span class="inline-flex min-w-7 items-center justify-center rounded-full bg-amber-400 px-2 py-0.5 text-xs font-bold text-slate-950">${cartCountValue}</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/logout" class="rounded-full bg-rose-500/15 px-4 py-2 text-sm font-semibold text-rose-300 ring-1 ring-rose-500/30 transition hover:bg-rose-500/25">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="${loginLinkClass}">Login</a>
                                <a href="${pageContext.request.contextPath}/register" class="${registerLinkClass}">Register</a>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="ml-0 flex items-center gap-3 border-t border-white/10 pt-3 md:ml-4 md:border-t-0 md:pt-0">
                        <div class="hidden md:block h-10 w-px bg-white/10"></div>
                        <div class="min-w-0">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user and not empty sessionScope.user.fullName}">
                                    <p class="truncate text-sm font-semibold text-white">${sessionScope.user.fullName}</p>
                                </c:when>
                                <c:when test="${not empty sessionScope.adminFullName}">
                                    <p class="truncate text-sm font-semibold text-white">${sessionScope.adminFullName}</p>
                                </c:when>
                                <c:when test="${not empty sessionScope.userFullName}">
                                    <p class="truncate text-sm font-semibold text-white">${sessionScope.userFullName}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="truncate text-sm font-semibold text-white">Guest</p>
                                </c:otherwise>
                            </c:choose>
                            <p class="text-xs uppercase tracking-[0.25em] text-slate-400">
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
            const toggle = document.getElementById('navToggle');
            const menu = document.getElementById('navMenu');
            if (!toggle || !menu) {
                return;
            }

            toggle.addEventListener('click', () => {
                const isHidden = menu.classList.contains('hidden');
                menu.classList.toggle('hidden');
                menu.classList.toggle('flex');
                toggle.setAttribute('aria-expanded', String(isHidden));
            });
        })();
        </script>
    </c:otherwise>
</c:choose>
