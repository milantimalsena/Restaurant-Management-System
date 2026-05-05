<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<c:set var="pageTitle" value="Himalayan Yaks | Taste of Himalayas" />
<c:set var="pageDescription" value="Taste of Himalayas with fresh food, online ordering, reservations, secure payments, and live service updates." />
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

        html { scroll-behavior: smooth; }

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
                linear-gradient(135deg, rgba(15, 23, 42, .74), rgba(15, 23, 42, .40)),
                url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1800&q=80') center/cover no-repeat;
            box-shadow: 0 30px 80px rgba(15, 23, 42, 0.22);
        }

        .hero-shell::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,.06), rgba(255,255,255,0));
            pointer-events: none;
        }

        .hero-badge {
            backdrop-filter: blur(10px);
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.14);
            color: #fff;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.78);
            backdrop-filter: blur(14px);
            border: 1px solid rgba(148, 163, 184, 0.18);
            box-shadow: 0 18px 48px rgba(15, 23, 42, 0.08);
            border-radius: 1.5rem;
        }

        .feature-tile,
        .stat-tile {
            border-radius: 1.5rem;
            border: 1px solid rgba(148, 163, 184, 0.16);
            transition: transform .25s ease, box-shadow .25s ease, border-color .25s ease;
            background: rgba(255, 255, 255, 0.92);
        }

        .feature-tile:hover,
        .stat-tile:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.10);
            border-color: rgba(29, 78, 216, 0.22);
        }

        .feature-icon {
            width: 3.25rem;
            height: 3.25rem;
            border-radius: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, rgba(29, 78, 216, 0.12), rgba(249, 115, 22, 0.12));
            color: var(--sr-brand);
            font-size: 1.4rem;
        }

        .food-card {
            overflow: hidden;
            border: 1px solid rgba(148, 163, 184, 0.16);
            border-radius: 1.6rem;
            background: #fff;
            transition: transform .25s ease, box-shadow .25s ease;
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.06);
        }

        .food-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 24px 50px rgba(15, 23, 42, 0.10);
        }

        .food-media {
            position: relative;
            height: 220px;
            overflow: hidden;
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

        .section-soft {
            position: relative;
            overflow: hidden;
            border-radius: 2rem;
            background: linear-gradient(180deg, #ffffff, #f8fafc);
            border: 1px solid rgba(148, 163, 184, 0.16);
        }

        .about-visual {
            min-height: 340px;
            border-radius: 1.75rem;
            background:
                linear-gradient(135deg, rgba(15, 23, 42, .20), rgba(15, 23, 42, .28)),
                url('https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=1200&q=80') center/cover no-repeat;
            box-shadow: inset 0 0 0 1px rgba(255,255,255,.08);
        }

        .footer-note {
            color: var(--sr-muted);
        }
    </style>
</head>
<body>
    <jsp:include page="/includes/navbar.jsp" />

    <main class="container py-4 py-lg-5">
        <!-- Hero Section -->
        <section class="hero-shell text-white p-4 p-md-5 p-lg-6 mb-5">
                <div class="row align-items-center g-4 position-relative" style="z-index:1;">
                                <div class="col-12 col-lg-7 py-2 py-lg-4">
                            <span class="hero-badge badge rounded-pill px-3 py-2 mb-4">Fresh dishes • smart checkout • live menu</span>
                            <h1 class="display-4 fw-bold lh-1 mb-3 text-white">Taste of Himalayas</h1>
                            <p class="lead text-white-75 mb-4" style="max-width: 42rem;">A modern restaurant experience for customers and staff, built to handle online ordering, reservations, invoice generation, and live order management from one clean platform.</p>
                            <div class="d-flex flex-wrap gap-3">
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-light btn-lg rounded-pill px-4 fw-semibold">Explore Menu</a>
                                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-light btn-lg rounded-pill px-4 fw-semibold">Order Now</a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-warning btn-lg rounded-pill px-4 fw-semibold">Register</a>
                            </div>
                            <div class="d-flex flex-wrap gap-3 mt-4 text-white-75 small">
                                <span class="hero-badge badge rounded-pill px-3 py-2">Fresh ingredients</span>
                                <span class="hero-badge badge rounded-pill px-3 py-2">Fast checkout</span>
                                <span class="hero-badge badge rounded-pill px-3 py-2">Mobile first</span>
                            </div>
                        </div>

                <div class="col-12 col-lg-5">
                    <div class="glass-card p-4 p-lg-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <p class="section-label mb-1">Live Overview</p>

                            </div>
                            <span class="badge text-bg-success-subtle text-success-emphasis rounded-pill px-3 py-2">Open Now</span>
                        </div>
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="stat-tile p-3">
                                    <div class="text-secondary small">Orders in queue</div>
                                    <div class="display-6 fw-bold mb-0 text-dark">24</div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="stat-tile p-3">
                                    <div class="text-secondary small">Avg. rating</div>
                                    <div class="display-6 fw-bold mb-0 text-dark">4.8</div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="stat-tile p-3">
                                    <div class="text-secondary small mb-2">Popular today</div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-semibold text-dark">Spicy Grill Platter</div>
                                            <small class="text-secondary">Chef's special with fries and dip</small>
                                        </div>
                                        <div class="fw-bold text-primary">NPR 1,250</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Featured Section -->
        <section class="mb-5">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
                <div>
                    <p class="section-label mb-2">Featured Dishes</p>
                    <h2 class="display-6 fw-bold mb-2">Chef-picked favorites</h2>
                    <p class="text-secondary mb-0">Featured items are ready for direct JDBC-backed rendering later through a request attribute like <code>featuredItems</code>.</p>
                </div>
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark rounded-pill px-4">View Full Menu</a>
            </div>

            <c:choose>
                <c:when test="${not empty featuredItems}">
                    <div class="row g-4">
                        <c:forEach var="item" items="${featuredItems}">
                            <div class="col-sm-6 col-xl-4">
                                <article class="food-card h-100">
                                    <div class="food-media">
                                        <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="${item.itemName}" />
                                        <span class="overlay-chip">${item.categoryName}</span>
                                    </div>
                                    <div class="p-4 d-flex flex-column h-100">
                                        <div class="d-flex justify-content-between align-items-start gap-3 mb-2">
                                            <h3 class="h5 fw-bold mb-0">${item.itemName}</h3>
                                            <span class="badge text-bg-primary-subtle text-primary-emphasis rounded-pill">Featured</span>
                                        </div>
                                        <p class="text-secondary mb-4">${item.description}</p>
                                        <div class="mt-auto d-flex justify-content-between align-items-center gap-3">
                                            <div>
                                                <div class="text-secondary small text-uppercase fw-semibold">Price</div>
                                                <div class="h4 fw-bold text-dark mb-0">NPR <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2" /></div>
                                            </div>
                                            <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                                <input type="hidden" name="itemId" value="${item.itemId}" />
                                                <input type="hidden" name="qty" value="1" />
                                                <input type="hidden" name="redirect" value="/public/home.jsp" />
                                                <button type="submit" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button>
                                            </form>
                                        </div>
                                    </div>
                                </article>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=1200&q=80" alt="Wood-fired Margherita Pizza" /><span class="overlay-chip">Pizza</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Wood-fired Margherita Pizza</h3>
                                    <p class="text-secondary mb-4">Fresh basil, house sauce, and mozzarella baked to perfection.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 890</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=1200&q=80" alt="Grilled Chicken Bowl" /><span class="overlay-chip">Healthy</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Grilled Chicken Bowl</h3>
                                    <p class="text-secondary mb-4">Lean protein, seasonal vegetables, and herbed rice.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 760</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1200&q=80" alt="Classic Burger Stack" /><span class="overlay-chip">Bestseller</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Classic Burger Stack</h3>
                                    <p class="text-secondary mb-4">Juicy patty, melted cheese, crisp vegetables, and sauce.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 640</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=1200&q=80" alt="Royal Pasta" /><span class="overlay-chip">Pasta</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Royal Pasta</h3>
                                    <p class="text-secondary mb-4">Creamy sauce, roasted veggies, and parmesan finish.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 720</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&w=1200&q=80" alt="Signature Breakfast Plate" /><span class="overlay-chip">Breakfast</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Signature Breakfast Plate</h3>
                                    <p class="text-secondary mb-4">Eggs, toast, potatoes, and a fresh fruit side.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 510</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                        <div class="col-sm-6 col-xl-4">
                            <article class="food-card h-100">
                                <div class="food-media"><img src="https://images.unsplash.com/photo-1490633874781-1c63cc424610?auto=format&fit=crop&w=1200&q=80" alt="Dessert Delight" /><span class="overlay-chip">Dessert</span></div>
                                <div class="p-4 d-flex flex-column h-100">
                                    <h3 class="h5 fw-bold">Dessert Delight</h3>
                                    <p class="text-secondary mb-4">A smooth finish with rich chocolate and berries.</p>
                                    <div class="mt-auto d-flex justify-content-between align-items-center gap-3"><div><div class="text-secondary small text-uppercase fw-semibold">Price</div><div class="h4 fw-bold text-dark mb-0">NPR 380</div></div><button type="button" class="btn btn-dark rounded-pill px-3 py-2">Add to Cart</button></div>
                                </div>
                            </article>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Features Section -->
        <section class="section-soft p-4 p-lg-5 mb-5">
            <div class="row align-items-end g-4 mb-4">
                <div class="col-lg-7">
                    <p class="section-label mb-2">Why Himalayan Yaks</p>
                    <h2 class="display-6 fw-bold mb-2">Built for digital dining operations</h2>
                    <p class="text-secondary mb-0">Every feature is designed to streamline the customer journey while leaving room for clean servlet and JDBC integration later.</p>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                                <div class="feature-icon mb-3"><i class="fa-solid fa-bag-shopping"></i></div>
                        <h3 class="h5 fw-bold">Online Ordering</h3>
                        <p class="text-secondary mb-0">Guests can browse the menu, add items, and move through checkout with minimal friction.</p>
                    </div>
                </div>
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                        <div class="feature-icon mb-3"><i class="fa-solid fa-calendar-check"></i></div>
                        <h3 class="h5 fw-bold">Table Reservation</h3>
                        <p class="text-secondary mb-0">Reservation-ready flows make it easy to schedule visits for dine-in customers and events.</p>
                    </div>
                </div>
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                        <div class="feature-icon mb-3"><i class="fa-solid fa-truck"></i></div>
                        <h3 class="h5 fw-bold">Fast Delivery</h3>
                        <p class="text-secondary mb-0">Support for delivery orders, address capture, and clear checkout notes for courier handoff.</p>
                    </div>
                </div>
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                        <div class="feature-icon mb-3"><i class="fa-solid fa-shield-halved"></i></div>
                        <h3 class="h5 fw-bold">Secure Payments</h3>
                        <p class="text-secondary mb-0">Designed for card and e-wallet simulation flows like eSewa and Khalti while keeping server-side validation strict.</p>
                    </div>
                </div>
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                        <div class="feature-icon mb-3"><i class="fa-solid fa-chart-line"></i></div>
                        <h3 class="h5 fw-bold">Live Order Tracking</h3>
                        <p class="text-secondary mb-0">Status badges and tracking-ready data structures support real-time order updates later.</p>
                    </div>
                </div>
                <div class="col-md-6 col-xl-4">
                    <div class="feature-tile p-4 h-100">
                        <div class="feature-icon mb-3"><i class="fa-solid fa-receipt"></i></div>
                        <h3 class="h5 fw-bold">Invoice & History</h3>
                        <p class="text-secondary mb-0">Order history and printable invoices make the platform useful for both customers and admins.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <section class="mb-5">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-end gap-3 mb-4">
                <div>
                    <p class="section-label mb-2">By the numbers</p>
                    <h2 class="display-6 fw-bold mb-2">A growing community of food lovers</h2>
                    <p class="text-secondary mb-0">Key stats can be rendered through request attributes like <code>totalOrders</code>, <code>avgRating</code>, and <code>totalCustomers</code> for dynamic updates.</p>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-tile p-4 h-100">
                        <div class="text-secondary small">Total Orders</div>
                        <div class="display-6 fw-bold text-dark mb-0">12,483</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-tile p-4 h-100">
                        <div class="text-secondary small">Average Rating</div>
                        <div class="display-6 fw-bold text-dark mb-0">4.7 / 5.0</div>
                    </div>
                </div>
                <div class="col-sm-6 col-xl-4">
                    <div class="stat-tile p-4 h-100">
                        <div class="text-secondary small">Total Customers</div>
                        <div class="display-6 fw-bold text-dark mb-0">3,256</div>
                    </div>
                </div>
            </div>

        <!-- About Section -->
        <section class="section-soft p-4 p-lg-5 mb-5">
            <div class="row align-items-center g-4">
                <div class="col-lg-6">
                    <div class="about-visual"></div>
                </div>
                <div class="col-lg-6">
                    <p class="section-label mb-2">Our Story</p>
                    <h2 class="display-6 fw-bold mb-2">Inspired by the Himalayas, built for the world</h2>
                    <p class="text-secondary mb-0">Himalayan Yaks was born from a desire to create a restaurant experience that captures the warmth and richness of Himalayan culture while embracing the possibilities of modern technology. Our platform is designed to make dining seamless and enjoyable for everyone, whether you're ordering from home or visiting us in person.</p>
                </div>
            </div>
    </main>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>
