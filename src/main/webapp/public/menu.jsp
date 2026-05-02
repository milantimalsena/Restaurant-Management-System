<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty menuList}">
    <c:set var="menuList" value="${menuItems}" />
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Restaurant Menu | Smart Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-950 text-slate-100">
<jsp:include page="/includes/navbar.jsp" />

<main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 lg:py-10">
    <section class="relative overflow-hidden rounded-[2rem] border border-white/10 bg-gradient-to-br from-slate-900 via-slate-900 to-indigo-950 p-6 shadow-2xl shadow-slate-950/40 sm:p-8 lg:p-10">
        <div class="absolute inset-0 bg-[radial-gradient(circle_at_top_right,_rgba(99,102,241,0.22),_transparent_34%),radial-gradient(circle_at_bottom_left,_rgba(14,165,233,0.18),_transparent_28%)]"></div>
        <div class="relative grid gap-8 lg:grid-cols-[1.5fr_0.9fr] lg:items-end">
            <div class="max-w-3xl">
                <span class="inline-flex rounded-full border border-indigo-400/30 bg-indigo-400/10 px-3 py-1 text-xs font-semibold uppercase tracking-[0.28em] text-indigo-200">Dynamic Menu</span>
                <h1 class="mt-4 text-3xl font-black tracking-tight text-white sm:text-4xl lg:text-5xl">Discover the dishes your guests are craving.</h1>
                <p class="mt-4 max-w-2xl text-sm leading-7 text-slate-300 sm:text-base">Browse the live menu, filter by category, and add items to cart in one tap. Every card is rendered from request-scoped data with JSTL and EL only.</p>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/menu" class="rounded-3xl border border-white/10 bg-white/5 p-4 backdrop-blur">
                <label for="searchInput" class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-400">Search menu</label>
                <div class="mt-3 flex flex-col gap-3 sm:flex-row">
                    <input id="searchInput" type="search" name="q" value="${searchQuery}" placeholder="Search dishes, ingredients, or specials"
                           class="w-full rounded-2xl border border-white/10 bg-slate-900/80 px-4 py-3 text-sm text-white outline-none ring-0 transition placeholder:text-slate-500 focus:border-indigo-400/60 focus:bg-slate-900" />
                    <button type="submit" class="inline-flex items-center justify-center rounded-2xl bg-indigo-500 px-5 py-3 text-sm font-semibold text-white shadow-lg shadow-indigo-500/25 transition hover:bg-indigo-400">Search</button>
                </div>
            </form>
        </div>
    </section>

    <section class="mt-8">
        <div class="flex flex-wrap items-center justify-between gap-4">
            <div>
                <h2 class="text-lg font-bold text-white sm:text-xl">Category Filters</h2>
                <p class="mt-1 text-sm text-slate-400">Use JSTL conditionals to keep the active filter highlighted.</p>
            </div>
            <a href="${pageContext.request.contextPath}/menu" class="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm font-semibold text-slate-200 transition hover:bg-white/10">Clear filters</a>
        </div>

        <div class="mt-4 flex flex-wrap gap-3">
            <a href="${pageContext.request.contextPath}/menu"
               class="rounded-full px-4 py-2 text-sm font-semibold transition ${empty selectedCategoryId ? 'bg-white text-slate-950 shadow-lg shadow-white/10' : 'border border-white/10 bg-slate-900/70 text-slate-300 hover:bg-slate-800'}">
                All
            </a>
            <c:if test="${not empty categories}">
                <c:forEach var="category" items="${categories}">
                    <a href="${pageContext.request.contextPath}/menu?categoryId=${category.categoryId}&q=${searchQuery}"
                       class="rounded-full px-4 py-2 text-sm font-semibold transition ${selectedCategoryId eq category.categoryId ? 'bg-indigo-500 text-white shadow-lg shadow-indigo-500/25' : 'border border-white/10 bg-slate-900/70 text-slate-300 hover:bg-slate-800'}">
                        ${category.categoryName}
                    </a>
                </c:forEach>
            </c:if>
        </div>
    </section>

    <section class="mt-10">
        <div class="flex items-end justify-between gap-4">
            <div>
                <h2 class="text-2xl font-black tracking-tight text-white">Menu Items</h2>
                <p class="mt-1 text-sm text-slate-400">Rendered from <span class="font-semibold text-slate-200">menuList</span> with a fallback to existing request data.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty menuList}">
                <div class="mt-6 grid gap-6 sm:grid-cols-2 xl:grid-cols-3">
                    <c:forEach var="item" items="${menuList}">
                        <article class="group overflow-hidden rounded-[1.75rem] border border-white/10 bg-slate-900/80 shadow-xl shadow-slate-950/30 transition duration-300 hover:-translate-y-1 hover:border-indigo-400/30 hover:shadow-indigo-950/30">
                            <div class="relative h-56 overflow-hidden bg-slate-800">
                                <c:choose>
                                    <c:when test="${not empty item.imagePath}">
                                        <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="${item.itemName}" class="h-full w-full object-cover transition duration-500 group-hover:scale-105" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/banners/placeholder-food.jpg" alt="${item.itemName}" class="h-full w-full object-cover transition duration-500 group-hover:scale-105" />
                                    </c:otherwise>
                                </c:choose>
                                <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/20 to-transparent"></div>
                                <div class="absolute left-4 top-4 flex gap-2">
                                    <c:if test="${item.featured}">
                                        <span class="rounded-full bg-amber-400 px-3 py-1 text-xs font-bold uppercase tracking-[0.2em] text-slate-950">Featured</span>
                                    </c:if>
                                    <span class="rounded-full bg-slate-950/80 px-3 py-1 text-xs font-semibold text-slate-200 ring-1 ring-white/10">${item.categoryName}</span>
                                </div>
                            </div>

                            <div class="flex h-full flex-col gap-4 p-5">
                                <div>
                                    <h3 class="text-xl font-bold text-white">${item.itemName}</h3>
                                    <p class="mt-2 text-sm leading-6 text-slate-400">${empty item.description ? 'Freshly prepared and ready to impress your guests.' : item.description}</p>
                                </div>

                                <div class="flex items-center justify-between">
                                    <div>
                                        <span class="text-xs font-semibold uppercase tracking-[0.28em] text-slate-500">Price</span>
                                        <p class="mt-1 text-2xl font-black text-white">NPR ${item.price}</p>
                                    </div>
                                    <div class="rounded-2xl border border-white/10 bg-white/5 px-3 py-2 text-right">
                                        <p class="text-xs uppercase tracking-[0.22em] text-slate-500">Category</p>
                                        <p class="text-sm font-semibold text-slate-200">${item.categoryName}</p>
                                    </div>
                                </div>

                                <div class="mt-auto flex items-center gap-3">
                                    <span class="inline-flex items-center rounded-full px-3 py-1 text-xs font-semibold ${item.available ? 'bg-emerald-400/15 text-emerald-300 ring-1 ring-emerald-400/30' : 'bg-rose-400/15 text-rose-300 ring-1 ring-rose-400/30'}">
                                        ${item.available ? 'Available' : 'Unavailable'}
                                    </span>

                                    <form method="post" action="${pageContext.request.contextPath}/cart/add" class="ml-auto">
                                        <input type="hidden" name="itemId" value="${item.itemId}" />
                                        <input type="hidden" name="qty" value="1" />
                                        <input type="hidden" name="redirect" value="/menu" />
                                        <button type="submit" class="inline-flex items-center justify-center rounded-2xl bg-indigo-500 px-4 py-2 text-sm font-semibold text-white shadow-lg shadow-indigo-500/25 transition hover:bg-indigo-400 disabled:cursor-not-allowed disabled:bg-slate-700 disabled:text-slate-400" ${item.available ? '' : 'disabled'}>
                                            Add to cart
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="mt-6 rounded-[1.75rem] border border-dashed border-white/15 bg-white/5 px-6 py-16 text-center shadow-xl shadow-slate-950/20">
                    <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-indigo-500/15 text-2xl">🍽</div>
                    <h3 class="mt-5 text-2xl font-bold text-white">No menu items found</h3>
                    <p class="mx-auto mt-3 max-w-xl text-sm leading-7 text-slate-400">Try removing filters or search terms. When items are available, they render dynamically from the request-supplied list.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="mt-6 inline-flex items-center justify-center rounded-2xl bg-white px-5 py-3 text-sm font-semibold text-slate-950 transition hover:bg-slate-200">Reset view</a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>
</body>
</html>
