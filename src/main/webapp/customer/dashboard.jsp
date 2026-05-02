<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Customer Dashboard | Himalayan Yaks" />
<!DOCTYPE html>
<html lang="en">
<head>
    <title>${pageTitle}</title>
    <jsp:include page="/includes/header.jsp" />
    <style>
        body {
            min-height: 100vh;
            background:
                linear-gradient(135deg, rgba(249, 115, 22, 0.08), transparent 30%),
                linear-gradient(180deg, #fffaf4 0%, #f8fafc 100%);
            color: #1f2937;
            font-family: 'Poppins', sans-serif;
        }

        .dashboard-hero {
            border-radius: 1.75rem;
            background:
                linear-gradient(135deg, rgba(20, 14, 10, 0.88), rgba(20, 14, 10, 0.58)),
                url('https://images.unsplash.com/photo-1551218808-94e220e084d2?auto=format&fit=crop&w=1600&q=80') center/cover no-repeat;
            box-shadow: 0 24px 60px rgba(20, 14, 10, 0.18);
            overflow: hidden;
        }

        .dashboard-card {
            border: 1px solid rgba(148, 163, 184, 0.18);
            border-radius: 1.25rem;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
            transition: transform .2s ease, box-shadow .2s ease;
        }

        .dashboard-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 24px 52px rgba(15, 23, 42, 0.12);
        }

        .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 1rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fff4df;
            color: #c2410c;
            font-size: 1.3rem;
        }

        .status-pill {
            border-radius: 999px;
            background: rgba(34, 197, 94, 0.12);
            color: #166534;
            font-weight: 700;
            padding: .5rem .9rem;
        }
    </style>
</head>
<body>
<jsp:include page="/includes/navbar.jsp" />

<main class="container py-4 py-lg-5">
    <section class="dashboard-hero text-white p-4 p-lg-5 mb-4">
        <div class="row align-items-center g-4">
            <div class="col-lg-8">
                <span class="badge rounded-pill text-bg-warning text-dark px-3 py-2 mb-3">Customer Account</span>
                <h1 class="display-6 fw-bold mb-3">
                    Welcome back, ${empty sessionScope.userFullName ? 'Customer' : sessionScope.userFullName}
                </h1>
                <p class="lead mb-0" style="max-width: 48rem;">
                    Continue ordering, review your order history, manage your cart, and move through checkout from one place.
                </p>
            </div>
            <div class="col-lg-4">
                <div class="bg-white bg-opacity-10 border border-white border-opacity-10 rounded-4 p-4">
                    <div class="text-white-50 small text-uppercase fw-semibold mb-2">Signed in as</div>
                    <div class="h5 fw-bold mb-1">${empty sessionScope.userEmail ? 'Customer account' : sessionScope.userEmail}</div>
                    <span class="status-pill d-inline-flex mt-3">Active</span>
                </div>
            </div>
        </div>
    </section>

    <div class="row g-4 mb-4">
        <div class="col-md-6 col-xl-3">
            <a href="${pageContext.request.contextPath}/menu" class="card dashboard-card h-100 text-decoration-none text-dark">
                <div class="card-body p-4">
                    <div class="action-icon mb-3"><i class="bi bi-journal-richtext"></i></div>
                    <h2 class="h5 fw-bold">Browse Menu</h2>
                    <p class="text-secondary mb-0">Explore dishes and add fresh items to your cart.</p>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-xl-3">
            <a href="${pageContext.request.contextPath}/cart" class="card dashboard-card h-100 text-decoration-none text-dark">
                <div class="card-body p-4">
                    <div class="action-icon mb-3"><i class="bi bi-bag-check"></i></div>
                    <h2 class="h5 fw-bold">View Cart</h2>
                    <p class="text-secondary mb-0">Update quantities and continue to checkout.</p>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-xl-3">
            <a href="${pageContext.request.contextPath}/my-orders" class="card dashboard-card h-100 text-decoration-none text-dark">
                <div class="card-body p-4">
                    <div class="action-icon mb-3"><i class="bi bi-receipt-cutoff"></i></div>
                    <h2 class="h5 fw-bold">My Orders</h2>
                    <p class="text-secondary mb-0">Track order status and open invoices.</p>
                </div>
            </a>
        </div>
        <div class="col-md-6 col-xl-3">
            <a href="${pageContext.request.contextPath}/checkout" class="card dashboard-card h-100 text-decoration-none text-dark">
                <div class="card-body p-4">
                    <div class="action-icon mb-3"><i class="bi bi-credit-card"></i></div>
                    <h2 class="h5 fw-bold">Checkout</h2>
                    <p class="text-secondary mb-0">Review delivery, payment, and order details.</p>
                </div>
            </a>
        </div>
    </div>

    <section class="card dashboard-card border-0">
        <div class="card-body p-4 p-lg-5">
            <div class="row align-items-center g-4">
                <div class="col-lg-7">
                    <p class="text-uppercase text-warning fw-bold small mb-2">Next step</p>
                    <h2 class="h3 fw-bold mb-3">Ready to order something fresh?</h2>
                    <p class="text-secondary mb-0">
                        Start from the menu, add items to your cart, and your order history will appear under My Orders after checkout.
                    </p>
                </div>
                <div class="col-lg-5 text-lg-end">
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-warning btn-lg rounded-pill px-4 fw-semibold me-lg-2 mb-2 mb-lg-0">
                        Order Now
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-dark btn-lg rounded-pill px-4 fw-semibold">
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="/includes/footer.jsp" />
</body>
</html>
