<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:if test="${empty menuList}">
    <c:set var="menuList" value="${menuItems}" />
</c:if>
<c:set var="pageTitle" value="Restaurant Menu | Himalayan Yaks" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle}</title>
    <jsp:include page="/includes/header.jsp" />
    <style>
        :root {
            --sr-dark: #0f172a;
            --sr-ink: #1e293b;
            --sr-muted: #64748b;
            --sr-brand: #1d4ed8;
            --sr-accent: #f97316;
            --sr-soft: #f8fafc;
        }

        body {
            font-family: 'Poppins', sans-serif;
            color: var(--sr-ink);
            background:
                radial-gradient(circle at top left, rgba(29, 78, 216, 0.08), transparent 28%),
                radial-gradient(circle at right center, rgba(249, 115, 22, 0.08), transparent 24%),
                linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
        }

        .section-label {
            letter-spacing: .22em;
            text-transform: uppercase;
            font-size: .78rem;
            font-weight: 700;
            color: var(--sr-brand);
        }

        .hero-shell {
            position: relative;
            overflow: hidden;
            border-radius: 2rem;
            background:
                linear-gradient(135deg, rgba(15, 23, 42, .76), rgba(15, 23, 42, .42)),
                url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1800&q=80') center/cover no-repeat;
            box-shadow: 0 30px 80px rgba(15, 23, 42, 0.22);
        }

        .hero-badge {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.14);
            color: #fff;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.82);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(148, 163, 184, 0.18);
            box-shadow: 0 18px 48px rgba(15, 23, 42, 0.08);
            border-radius: 1.5rem;
        }

        .filter-panel,
        .food-card {
            border: 1px solid rgba(148, 163, 184, 0.16);
            border-radius: 1.5rem;
            background: rgba(255, 255, 255, 0.94);
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.06);
        }

        .food-card {
            overflow: hidden;
            transition: transform .25s ease, box-shadow .25s ease;
        }

        .food-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 24px 50px rgba(15, 23, 42, 0.10);
        }

        .food-media {
            position: relative;
            height: 220px;
            overflow: hidden;
            background: #e2e8f0;
        }

        .food-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .45s ease;
        }

        .food-card:hover .food-media img {
            transform: scale(1.05);
        }

        .overlay-chip {
            position: absolute;
            top: 1rem;
            left: 1rem;
            padding: .45rem .85rem;
            border-radius: 999px;
            background: rgba(15, 23, 42, 0.72);
            color: #fff;
            font-size: .74rem;
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
        }

        .availability-chip {
            border-radius: 999px;
            font-size: .78rem;
            font-weight: 700;
            padding: .45rem .75rem;
        }

        .category-pill {
            border-radius: 999px;
            padding: .65rem 1rem;
            font-weight: 700;
            text-decoration: none;
            transition: transform .2s ease, box-shadow .2s ease, background .2s ease;
        }

        .category-pill:hover {
            transform: translateY(-1px);
        }

        .empty-state {
            border: 1px dashed rgba(148, 163, 184, 0.45);
            border-radius: 1.75rem;
            background: #fff;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.06);
        }
    </style>
</head>
<body>
<jsp:include page="/includes/navbar.jsp" />

<main class="container py-4 py-lg-5">
    <section class="hero-shell text-white p-4 p-md-5 mb-5">
        <div class="row align-items-center g-4 position-relative" style="z-index:1;">
                <div class="col-12 col-lg-7 py-2 py-lg-4">
                    <span class="hero-badge badge rounded-pill px-3 py-2 mb-4">Fresh dishes | smart checkout | live menu</span>
                    <h1 class="display-4 fw-bold lh-1 mb-3 text-white">Explore Our Restaurant Menu</h1>
                    <p class="lead text-white-75 mb-0" style="max-width: 42rem;">
                        Browse freshly prepared dishes, filter by category, and add your favorites to cart with the same smooth experience as the home page.
                    </p>
                </div>

            <div class="col-12 col-lg-5">
                <form method="get" action="${pageContext.request.contextPath}/menu" class="glass-card p-4">
                    <p class="section-label mb-2">Search Menu</p>
                    <label for="searchInput" class="form-label fw-semibold text-dark">Find dishes, ingredients, or specials</label>
                    <div class="input-group input-group-lg">
                        <input id="searchInput" type="search" name="q" value="${searchQuery}" class="form-control rounded-start-pill" placeholder="Search menu" />
                        <button type="submit" class="btn btn-warning rounded-end-pill px-4 fw-semibold">
                            Search
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <section class="filter-panel p-4 p-lg-5 mb-5">
        <c:if test="${not empty cartMessage}">
            <div class="alert alert-success">${cartMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
            <div>
                <p class="section-label mb-2">Category Filters</p>
                <h2 class="display-6 fw-bold mb-2">Choose your craving</h2>
                <p class="text-secondary mb-0">Filter the live menu without leaving the restaurant theme.</p>
            </div>
            <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark rounded-pill px-4">Clear Filters</a>
        </div>

        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/menu"
               class="category-pill ${empty selectedCategoryId ? 'bg-dark text-white shadow-sm' : 'bg-light text-dark border'}">
                All
            </a>
            <c:if test="${not empty categories}">
                <c:forEach var="category" items="${categories}">
                    <a href="${pageContext.request.contextPath}/menu?categoryId=${category.categoryId}&q=${searchQuery}"
                       class="category-pill ${selectedCategoryId eq category.categoryId ? 'bg-primary text-white shadow-sm' : 'bg-light text-dark border'}">
                        ${category.categoryName}
                    </a>
                </c:forEach>
            </c:if>
        </div>
    </section>

    <section class="mb-5">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
            <div>
                <p class="section-label mb-2">Menu Items</p>
                <h2 class="display-6 fw-bold mb-2">Freshly prepared favorites</h2>
                <p class="text-secondary mb-0">Food cards now match the home page layout, spacing, and visual treatment.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty menuList}">
                <div class="row g-4">
                    <c:forEach var="item" items="${menuList}">
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media">
                                    <c:choose>
                                        <c:when test="${not empty item.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="${item.itemName}"
                                                 onerror="if(!this.dataset.attempt){this.dataset.attempt='svg';this.src='${pageContext.request.contextPath}/${fn:replace(item.imagePath,'.jpg','.svg')}';}else if(this.dataset.attempt==='svg'){this.dataset.attempt='unsplash';this.src='https://source.unsplash.com/600x400/?${fn:replace(item.itemName,' ','+')}';}else{this.onerror=null;this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=1200&q=80';}" />
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://source.unsplash.com/600x400/?${fn:replace(item.itemName,' ','+')}" alt="${item.itemName}"
                                                 onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=1200&q=80';" />
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="overlay-chip">${item.categoryName}</span>
                                </div>

                                <div class="p-4 d-flex flex-column h-100">
                                    <div class="d-flex justify-content-between align-items-start gap-3 mb-2">
                                        <h3 class="h5 fw-bold mb-0">${item.itemName}</h3>
                                        <c:if test="${item.featured}">
                                            <span class="badge text-bg-warning rounded-pill">Featured</span>
                                        </c:if>
                                    </div>
                                    <p class="text-secondary mb-4">
                                        ${empty item.description ? 'Freshly prepared and ready for your next order.' : item.description}
                                    </p>

                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center gap-3 mb-3">
                                            <div>
                                                <div class="text-secondary small text-uppercase fw-semibold">Price</div>
                                                <div class="h4 fw-bold text-dark mb-0">
                                                    NPR <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2" />
                                                </div>
                                            </div>
                                            <span class="availability-chip ${item.available ? 'bg-success-subtle text-success-emphasis' : 'bg-danger-subtle text-danger-emphasis'}">
                                                ${item.available ? 'Available' : 'Unavailable'}
                                            </span>
                                        </div>

                                        <c:choose>
                                            <!-- Show Add-to-cart form if we have a logged-in customer in any of the common session attributes -->
                                            <c:when test="${not empty sessionScope.userId or sessionScope.userRole eq 'CUSTOMER' or not empty sessionScope.user}">
                                                <form method="post" action="${pageContext.request.contextPath}/cart/add"
                                                      class="add-cart-form d-flex gap-2 align-items-center"
                                                      data-available="${item.available}"
                                                      data-item-name="${fn:escapeXml(item.itemName)}">
                                                    <input type="hidden" name="itemId" value="${item.itemId}" />
                                                    <input type="hidden" name="redirect" value="/cart" />
                                                    <input type="number" name="qty" value="1" min="1" max="20" class="form-control form-control-sm" style="width:5.5rem;" />
                                                    <button type="submit" class="btn btn-primary rounded-pill px-3 py-2 fw-semibold flex-grow-1">
                                                        <i class="bi bi-cart-plus-fill me-1" aria-hidden="true"></i> Add to Cart
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.requestURI}"
                                                   class="btn btn-outline-primary rounded-pill px-4 py-2 w-100 fw-semibold">
                                                    Please login to add
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </article>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state px-4 py-5 text-center">
                    <div class="display-5 mb-3">Menu</div>
                    <h3 class="h4 fw-bold">No menu items found</h3>
                    <p class="text-secondary mx-auto mb-4" style="max-width: 38rem;">
                        Try clearing filters or searching for another dish. Available menu items will appear here.
                    </p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-dark rounded-pill px-4">Reset Menu</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="/includes/footer.jsp" />
<script>
    document.querySelectorAll('.add-cart-form').forEach(form => {
        form.addEventListener('submit', event => {
            if (form.dataset.available !== 'true') {
                event.preventDefault();
                const itemName = form.dataset.itemName || 'This item';
                alert(`${itemName} is currently unavailable or out of stock.`);
            }
        });
    });
</script>
</body>
</html>
