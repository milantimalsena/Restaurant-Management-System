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
            border-radius: 1.5rem;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: 0.25s;
        }

        .food-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 45px rgba(0,0,0,0.08);
        }

        .food-media {
            height: 200px;
            overflow: hidden;
        }

        .food-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .availability-chip {
            font-size: 0.75rem;
            padding: 0.4rem 0.7rem;
            border-radius: 999px;
            font-weight: 600;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border: none;
        }
    </style>
</head>

<body>

<jsp:include page="/includes/navbar.jsp" />

<main class="container py-5">

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
        <div class="row g-4">

            <c:forEach var="item" items="${menuItems}">
                <div class="col-md-6 col-lg-4">

                    <div class="food-card h-100">

                        <div class="food-media">
                            <img src="https://source.unsplash.com/600x400/?${fn:replace(item.itemName,' ','+')}"
                                 alt="${item.itemName}" />
                        </div>

                        <div class="p-4 d-flex flex-column">

                            <h5 class="fw-bold">${item.itemName}</h5>
                            <p class="text-secondary small">
                                    ${empty item.description ? 'Delicious and freshly prepared.' : item.description}
                            </p>

                            <div class="mt-auto">

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="fw-bold">
                                        NPR <fmt:formatNumber value="${item.price}" minFractionDigits="2" />
                                    </span>

                                    <span class="availability-chip
                                        ${item.available ? 'bg-success-subtle text-success' : 'bg-danger-subtle text-danger'}">
                                            ${item.available ? 'Available' : 'Out'}
                                    </span>
                                </div>

                                <!-- SIMPLE LOGIN CHECK -->
                                <c:choose>
                                    <!-- Consider common session attributes: userId, userRole or a user object -->
                                    <c:when test="${not empty sessionScope.userId or sessionScope.userRole eq 'CUSTOMER' or not empty sessionScope.user}">
                                        <form method="post" action="${pageContext.request.contextPath}/cart/add"
                                              class="d-flex gap-2">

                                            <input type="hidden" name="itemId" value="${item.itemId}" />

                                            <input type="number" name="qty" value="1" min="1"
                                                   class="form-control" style="width:70px;" />

                                            <button class="btn btn-primary w-100"
                                                ${!item.available ? "disabled" : ""}>
                                                Add
                                            </button>
                                        </form>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="btn btn-outline-primary w-100">
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