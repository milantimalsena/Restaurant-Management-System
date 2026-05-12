<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<c:set var="pageTitle" value="Restaurant Menu | Himalayan Yaks" />

<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle}</title>
    <jsp:include page="/includes/header.jsp" />

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f8fafc;
            color: #1e293b;
        }

        .hero-clean {
            background: #fff;
            border-radius: 1.5rem;
            padding: 3rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        .filter-panel {
            background: #fff;
            border-radius: 1.5rem;
            padding: 2rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        .category-pill {
            padding: 0.5rem 1rem;
            border-radius: 999px;
            font-weight: 600;
            text-decoration: none;
        }

        .food-card {
            background: #fff;
            border-radius: 0.25rem; /* sharper, modern, premium look */
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(0,0,0,0.05); /* very subtle border */
            box-shadow: 0 4px 10px rgba(0,0,0,0.03); /* soft realistic shadow */
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .food-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1); /* slick lift effect */
        }

        .food-media {
            height: 260px; /* taller image container for vertical impact */
            position: relative;
            overflow: hidden;
        }

        .food-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }

        .food-card:hover .food-media img {
            transform: scale(1.05); /* subtle zoom */
        }

        .item-desc {
            display: none; /* hidden by default, toggled later */
            margin-bottom: 1.5rem;
            color: #6b7280;
            font-size: .92rem;
            font-style: italic;
        }

        .toggle-desc {
            font-size: 0.85rem;
            color: #6b7280;
            text-decoration: underline;
            text-underline-offset: 4px;
            background: none;
            border: none;
            padding: 0;
            cursor: pointer;
            margin-bottom: 1rem;
        }

        .toggle-desc:hover {
            color: #1e293b;
        }

        .availability-chip {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255,255,255,0.95);
            font-size: 0.7rem;
            padding: 0.35rem 0.6rem;
            border-radius: 4px;
            font-weight: 700;
            text-transform: uppercase;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border: none;
        }
    </style>
</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<main class="container py-5" style="max-width: 1400px;">

    <!-- HERO -->
    <section class="hero-clean mb-5">
        <h1 class="fw-bold mb-2">Explore Our Menu</h1>
        <p class="text-secondary mb-0">Fresh dishes, ready to order.</p>
    </section>

    <!-- FILTER + SEARCH -->
    <section class="filter-panel mb-5">

        <!-- SEARCH -->
        <form method="get" action="${pageContext.request.contextPath}/menu" class="mb-4">
            <div class="input-group">
                <input type="search" name="q" value="${searchQuery}"
                       class="form-control rounded-start-pill"
                       placeholder="Search dishes..." />

                <button class="btn btn-primary rounded-end-pill px-4">
                    Search
                </button>
            </div>
        </form>

        <!-- CATEGORY -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold">Categories</h5>
            <a href="${pageContext.request.contextPath}/menu"
               class="btn btn-sm btn-outline-dark rounded-pill">
                Clear
            </a>
        </div>

        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/menu"
               class="category-pill ${empty selectedCategoryId ? 'bg-dark text-white' : 'bg-light border'}">
                All
            </a>

            <c:forEach var="category" items="${categories}">
                <a href="${pageContext.request.contextPath}/menu?categoryId=${category.categoryId}&q=${searchQuery}"
                   class="category-pill ${selectedCategoryId eq category.categoryId ? 'bg-primary text-white' : 'bg-light border'}">
                        ${category.categoryName}
                </a>
            </c:forEach>
        </div>

    </section>

    <!-- MENU ITEMS -->
    <section>
        <div class="row g-4 g-lg-5 justify-content-center">

            <c:forEach var="item" items="${menuItems}">
                <div class="col-12 col-md-6 col-lg-4">

                    <div class="food-card h-100">

                        <div class="food-media">
                            <c:choose>
                                <c:when test="${not empty item.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${item.imagePath}"
                                         alt="${item.itemName}"
                                         onerror="this.onerror=null;this.src='https://source.unsplash.com/600x400/?${fn:replace(item.itemName,' ','+')}';" />
                                </c:when>
                                <c:otherwise>
                                    <img src="https://source.unsplash.com/600x400/?${fn:replace(item.itemName,' ','+')}"
                                         alt="${item.itemName}" />
                                </c:otherwise>
                            </c:choose>
                            <span class="availability-chip ${item.available ? 'text-success' : 'text-danger'}">
                                ${item.available ? 'Available' : 'Out'}
                            </span>
                        </div>

                        <div class="p-4 d-flex flex-column flex-grow-1 text-center align-items-center">

                            <h5 class="fw-bold mb-2 text-uppercase" style="letter-spacing: 1px;">${item.itemName}</h5>
                            <button type="button" class="toggle-desc" aria-expanded="false" title="Show details">more</button>

                            <p class="item-desc">
                                ${empty item.description ? 'Delicious and freshly prepared.' : item.description}
                            </p>

                            <div class="mt-auto w-100">

                                <div class="fw-bold fs-5 mb-3" style="color: #1e293b;">
                                    NPR <fmt:formatNumber value="${item.price}" minFractionDigits="2" />
                                </div>

                                <!-- SIMPLE LOGIN CHECK -->
                                <c:choose>
                                    <%-- Consider common session attributes: userId, userRole or a user object --%>
                                    <c:when test="${not empty sessionScope.userId or sessionScope.userRole eq 'CUSTOMER' or not empty sessionScope.user}">
                                        <form action="${pageContext.request.contextPath}/add-to-cart" method="post">
                                            <input type="hidden" name="itemId" value="${item.itemId}" />
                                            <button type="submit" class="btn btn-primary flex-grow-1" style="max-width: 140px;" ${!item.available ? "disabled" : ""}>
                                                Add to Cart
                                            </button>
                                        </form>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="btn btn-outline-primary px-4">
                                            Login to Order
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>

                    </div>

                </div>
            </c:forEach>

        </div>
    </section>

</main>

<jsp:include page="/includes/footer.jsp" />

</body>
</html>

<script>
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.toggle-desc').forEach(btn => {
        btn.addEventListener('click', function () {
            const card = btn.closest('.food-card');
            if (!card) return;
            const desc = card.querySelector('.item-desc');
            if (!desc) return;
            const isVisible = window.getComputedStyle(desc).display !== 'none';
            desc.style.display = isVisible ? 'none' : 'block';
            btn.textContent = isVisible ? 'more' : 'less';
            btn.setAttribute('aria-expanded', String(!isVisible));
        });
    });
});
</script>
