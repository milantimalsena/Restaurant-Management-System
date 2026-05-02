<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPath" value="${pageContext.request.servletPath}" />
<c:set var="cartCountValue" value="${empty cartCount ? 0 : cartCount}" />
<c:set var="homeActive" value="${currentPath eq '/public/home.jsp' ? 'active' : ''}" />
<c:set var="menuActive" value="${currentPath eq '/public/menu.jsp' ? 'active' : ''}" />
<c:set var="aboutActive" value="${currentPath eq '/public/about.jsp' ? 'active' : ''}" />
<c:set var="contactActive" value="${currentPath eq '/public/contact.jsp' ? 'active' : ''}" />

<style>
    .restaurant-navbar {
        position: sticky;
        top: 0;
        z-index: 1030;
        background: rgba(20, 14, 10, 0.94);
        border-bottom: 1px solid rgba(255, 255, 255, 0.10);
        box-shadow: 0 18px 45px rgba(20, 14, 10, 0.18);
        backdrop-filter: blur(14px);
    }

    .restaurant-navbar .navbar-brand {
        color: #fff;
        text-decoration: none;
    }

    .brand-mark {
        width: 46px;
        height: 46px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #f97316, #facc15);
        color: #1f1308;
        font-weight: 800;
        box-shadow: 0 12px 30px rgba(249, 115, 22, 0.28);
    }

    .brand-eyebrow {
        display: block;
        color: #fbbf24;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 0.18em;
        text-transform: uppercase;
        line-height: 1;
    }

    .brand-title {
        display: block;
        color: #fff8ed;
        font-size: 1.15rem;
        font-weight: 800;
        line-height: 1.2;
    }

    .restaurant-navbar .nav-link {
        color: rgba(255, 248, 237, 0.78);
        border-radius: 999px;
        padding: 0.65rem 1rem;
        font-weight: 600;
        transition: background-color .2s ease, color .2s ease;
    }

    .restaurant-navbar .nav-link:hover,
    .restaurant-navbar .nav-link.active {
        color: #fff;
        background: rgba(255, 255, 255, 0.10);
    }

    .navbar-user-card {
        color: #fff8ed;
        border-left: 1px solid rgba(255, 255, 255, 0.12);
        padding-left: 1rem;
        line-height: 1.1;
    }

    .navbar-user-card small {
        color: rgba(255, 248, 237, 0.58);
        font-size: 0.72rem;
        letter-spacing: 0.14em;
        text-transform: uppercase;
    }

    .nav-action-outline,
    .nav-action-solid {
        border-radius: 999px;
        padding: 0.65rem 1.05rem;
        font-weight: 700;
        text-decoration: none;
        white-space: nowrap;
    }

    .nav-action-outline {
        color: #fff8ed;
        border: 1px solid rgba(255, 248, 237, 0.26);
        background: rgba(255, 255, 255, 0.04);
    }

    .nav-action-outline:hover {
        color: #1f1308;
        background: #fff8ed;
    }

    .nav-action-solid {
        color: #1f1308;
        border: 1px solid #fbbf24;
        background: linear-gradient(135deg, #fbbf24, #f97316);
        box-shadow: 0 12px 28px rgba(249, 115, 22, 0.24);
    }

    .nav-action-solid:hover {
        color: #1f1308;
        filter: brightness(1.04);
    }

    .cart-pill {
        position: relative;
    }

    .cart-pill .badge {
        position: absolute;
        top: -0.45rem;
        right: -0.45rem;
        background: #ef4444;
    }

    .restaurant-navbar .navbar-toggler {
        border-color: rgba(255, 248, 237, 0.24);
        color: #fff8ed;
        box-shadow: none;
    }

    .restaurant-navbar .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255,248,237,0.92%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }

    @media (max-width: 991.98px) {
        .restaurant-navbar .navbar-collapse {
            margin-top: 1rem;
            padding: 1rem;
            border-radius: 1.25rem;
            background: rgba(35, 24, 17, 0.98);
            border: 1px solid rgba(255, 255, 255, 0.10);
        }

        .navbar-user-card {
            border-left: 0;
            border-top: 1px solid rgba(255, 255, 255, 0.12);
            padding-left: 0;
            padding-top: 1rem;
        }
    }
</style>

<nav class="navbar navbar-expand-lg restaurant-navbar">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-3" href="${pageContext.request.contextPath}/public/home.jsp">
            <span class="brand-mark">SR</span>
            <span>
                <span class="brand-eyebrow">Smart Restaurant</span>
                <span class="brand-title">Fine Dining & Ordering</span>
            </span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#restaurantNavbar" aria-controls="restaurantNavbar" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="restaurantNavbar">
            <ul class="navbar-nav mx-lg-auto my-3 my-lg-0 gap-lg-1">
                <li class="nav-item"><a class="nav-link ${homeActive}" href="${pageContext.request.contextPath}/public/home.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link ${menuActive}" href="${pageContext.request.contextPath}/menu">Menu</a></li>
                <li class="nav-item"><a class="nav-link ${aboutActive}" href="${pageContext.request.contextPath}/public/about.jsp">About</a></li>
                <li class="nav-item"><a class="nav-link ${contactActive}" href="${pageContext.request.contextPath}/public/contact.jsp">Contact</a></li>
            </ul>

            <div class="d-flex flex-column flex-lg-row align-items-lg-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.user or not empty sessionScope.userRole}">
                        <c:choose>
                            <c:when test="${sessionScope.userRole eq 'ADMIN'}">
                                <a class="nav-action-outline" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a class="nav-action-outline" href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        <a class="nav-action-outline cart-pill" href="${pageContext.request.contextPath}/cart">
                            <i class="bi bi-bag me-1"></i> Cart
                            <span class="badge rounded-pill">${cartCountValue}</span>
                        </a>
                        <a class="nav-action-solid" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a class="nav-action-outline" href="${pageContext.request.contextPath}/login">Login</a>
                        <a class="nav-action-solid" href="${pageContext.request.contextPath}/register">Book a Table</a>
                    </c:otherwise>
                </c:choose>

                <div class="navbar-user-card">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user and not empty sessionScope.user.fullName}">
                            <strong>${sessionScope.user.fullName}</strong>
                        </c:when>
                        <c:when test="${not empty sessionScope.adminFullName}">
                            <strong>${sessionScope.adminFullName}</strong>
                        </c:when>
                        <c:when test="${not empty sessionScope.userFullName}">
                            <strong>${sessionScope.userFullName}</strong>
                        </c:when>
                        <c:otherwise>
                            <strong>Guest</strong>
                        </c:otherwise>
                    </c:choose>
                    <small class="d-block">
                        <c:choose>
                            <c:when test="${sessionScope.userRole eq 'ADMIN'}">Administrator</c:when>
                            <c:when test="${not empty sessionScope.userRole}">Customer</c:when>
                            <c:otherwise>Visitor</c:otherwise>
                        </c:choose>
                    </small>
                </div>
            </div>
        </div>
    </div>
</nav>
