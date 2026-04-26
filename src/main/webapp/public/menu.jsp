<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Category" %>
<%@ page import="com.restaurant.model.MenuItem" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<MenuItem> menuItems = (List<MenuItem>) request.getAttribute("menuItems");
    List<MenuItem> featuredItems = (List<MenuItem>) request.getAttribute("featuredItems");
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String searchQuery = (String) request.getAttribute("searchQuery");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Restaurant Menu | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --gold: #f59e0b;
            --deep-green: #0f766e;
            --ink: #0b1320;
        }
        body {
            background: linear-gradient(180deg, #f8fafc 0%, #e2e8f0 100%);
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }
        .hero {
            background: linear-gradient(120deg, #0f172a 0%, #1e293b 45%, #334155 100%);
            color: #fff;
            border-radius: 18px;
            padding: 48px 32px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.3);
        }
        .food-card {
            border: none;
            border-radius: 16px;
            overflow: hidden;
            transition: transform .22s ease, box-shadow .22s ease;
            box-shadow: 0 10px 22px rgba(2, 6, 23, 0.1);
        }
        .food-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 18px 36px rgba(2, 6, 23, 0.2);
        }
        .food-image {
            height: 190px;
            object-fit: cover;
            background: #dbeafe;
        }
        .price-tag {
            color: var(--deep-green);
            font-weight: 700;
            font-size: 1.05rem;
        }
        .badge-featured {
            background-color: var(--gold);
            color: #111827;
        }
        .search-box {
            border-radius: 999px;
        }
    </style>
</head>
<body>
<div class="container py-4 py-md-5">
    <div class="d-flex justify-content-end mb-3">
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-dark position-relative">
            Cart
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill text-bg-danger">
                <%= request.getAttribute("cartCount") != null ? request.getAttribute("cartCount") : 0 %>
            </span>
        </a>
    </div>

    <section class="hero mb-4">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <h1 class="display-6 fw-bold mb-2">Premium Dining Starts with Great Food</h1>
                <p class="mb-0 text-white-50">Discover fresh favorites, signature Nepali flavors, and chef specials.</p>
            </div>
            <div class="col-lg-4">
                <form method="get" action="${pageContext.request.contextPath}/menu" class="d-flex gap-2">
                    <input id="searchInput" type="search" class="form-control search-box" name="q" value="<%= searchQuery != null ? searchQuery : "" %>" placeholder="Search dishes...">
                    <button type="submit" class="btn btn-warning fw-semibold px-4">Search</button>
                </form>
            </div>
        </div>
    </section>

    <div class="d-flex flex-wrap gap-2 mb-4" id="categoryTabs">
        <a class="btn <%= selectedCategoryId == null || selectedCategoryId.isBlank() ? "btn-dark" : "btn-outline-dark" %>" href="${pageContext.request.contextPath}/menu">All</a>
        <% if (categories != null) {
            for (Category category : categories) { %>
                <a class="btn <%= String.valueOf(category.getCategoryId()).equals(selectedCategoryId) ? "btn-dark" : "btn-outline-dark" %>"
                   href="${pageContext.request.contextPath}/menu?categoryId=<%= category.getCategoryId() %>"><%= category.getCategoryName() %></a>
        <%  }
        } %>
    </div>

    <% if (featuredItems != null && !featuredItems.isEmpty()) { %>
    <h4 class="fw-bold mb-3">Featured Picks</h4>
    <div class="row g-3 mb-4">
        <% for (MenuItem item : featuredItems) { %>
        <div class="col-12 col-sm-6 col-lg-3">
            <div class="card food-card h-100">
                <img src="${pageContext.request.contextPath}/<%= item.getImagePath() != null ? item.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="food-image w-100" alt="<%= item.getItemName() %>">
                <div class="card-body">
                    <span class="badge badge-featured mb-2">Popular</span>
                    <h6 class="mb-1"><%= item.getItemName() %></h6>
                    <div class="price-tag">NPR <span class="money" data-price="<%= item.getPrice() %>"><%= item.getPrice() %></span></div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <h4 class="fw-bold mb-3">Menu Items</h4>
    <div class="row g-4" id="menuGrid">
        <% if (menuItems != null && !menuItems.isEmpty()) {
            for (MenuItem item : menuItems) { %>
            <div class="col-12 col-sm-6 col-lg-4 menu-item-card">
                <div class="card food-card h-100">
                    <img src="${pageContext.request.contextPath}/<%= item.getImagePath() != null ? item.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="food-image w-100" alt="<%= item.getItemName() %>">
                    <div class="card-body d-flex flex-column">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title mb-0"><%= item.getItemName() %></h5>
                            <% if (item.isFeatured()) { %><span class="badge badge-featured">Featured</span><% } %>
                        </div>
                        <p class="text-muted small mb-2"><%= item.getDescription() != null ? item.getDescription() : "No description available." %></p>
                        <div class="mb-2">
                            <span class="price-tag">NPR <span class="money" data-price="<%= item.getPrice() %>"><%= item.getPrice() %></span></span>
                        </div>
                        <div class="mb-3">
                            <span class="badge <%= item.isAvailable() ? "text-bg-success" : "text-bg-secondary" %>">
                                <%= item.isAvailable() ? "Available" : "Out of Stock" %>
                            </span>
                        </div>
                        <div class="mt-auto d-flex gap-2">
                            <a class="btn btn-outline-dark btn-sm" href="${pageContext.request.contextPath}/menu?itemId=<%= item.getItemId() %>">Details</a>
                            <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-inline">
                                <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                <input type="hidden" name="qty" value="1">
                                <input type="hidden" name="redirect" value="/menu">
                                <button class="btn btn-warning btn-sm" <%= !item.isAvailable() ? "disabled" : "" %>>Quick Add to Cart</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        <%  }
        } else { %>
        <div class="col-12">
            <div class="alert alert-info">No menu items found.</div>
        </div>
        <% } %>
    </div>
</div>

<script>
    const moneyEls = document.querySelectorAll('.money');
    moneyEls.forEach(el => {
        const value = Number(el.dataset.price || el.textContent || 0);
        el.textContent = new Intl.NumberFormat('en-NP', {minimumFractionDigits: 2, maximumFractionDigits: 2}).format(value);
    });

    const searchInput = document.getElementById('searchInput');
    const cards = document.querySelectorAll('.menu-item-card');
    if (searchInput) {
        searchInput.addEventListener('input', () => {
            const token = searchInput.value.trim().toLowerCase();
            cards.forEach(card => {
                const text = card.textContent.toLowerCase();
                card.style.display = text.includes(token) ? '' : 'none';
            });
        });
    }
</script>
</body>
</html>
