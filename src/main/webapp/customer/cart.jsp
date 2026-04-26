<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.restaurant.model.Cart" %>
<%
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal tax = (BigDecimal) request.getAttribute("tax");
    BigDecimal grandTotal = (BigDecimal) request.getAttribute("grandTotal");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (tax == null) tax = BigDecimal.ZERO;
    if (grandTotal == null) grandTotal = BigDecimal.ZERO;
    if (cartCount == null) cartCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Your Cart | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(180deg, #f8fafc, #eef2f7); }
        .cart-card { border: none; border-radius: 16px; box-shadow: 0 10px 24px rgba(15,23,42,.08); }
        .thumb { width: 72px; height: 72px; object-fit: cover; border-radius: 12px; }
        .summary-sticky { position: sticky; top: 18px; }
        .qty-form { display: inline-flex; gap: .35rem; align-items: center; }
        .qty-input { width: 64px; text-align: center; }
        .cart-empty {
            background: #fff;
            border-radius: 16px;
            border: 1px dashed #cbd5e1;
            padding: 3rem 1.5rem;
            text-align: center;
        }
        @media (max-width: 767.98px) {
            .desktop-table { display: none; }
        }
        @media (min-width: 768px) {
            .mobile-cards { display: none; }
        }
    </style>
</head>
<body>
<div class="container py-4 py-lg-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold mb-0">Your Cart</h2>
        <span class="badge text-bg-dark">Items: <%= cartCount %></span>
    </div>

    <% if (request.getAttribute("cartMessage") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("cartMessage") %></div>
    <% } %>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
    <div class="cart-empty">
        <h4 class="fw-semibold">Your cart is empty</h4>
        <p class="text-muted">Add delicious menu items and come back here to checkout.</p>
        <a class="btn btn-dark" href="${pageContext.request.contextPath}/menu">Browse Menu</a>
    </div>
    <% } else { %>
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card cart-card desktop-table">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>Item</th>
                                <th>Price</th>
                                <th>Quantity</th>
                                <th>Total</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Cart cart : cartItems) { %>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${pageContext.request.contextPath}/<%= cart.getImagePath() != null ? cart.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="thumb" alt="<%= cart.getItemName() %>">
                                        <div>
                                            <div class="fw-semibold"><%= cart.getItemName() %></div>
                                            <small class="text-muted"><%= cart.getCategoryName() %></small>
                                        </div>
                                    </div>
                                </td>
                                <td>NPR <span class="money" data-price="<%= cart.getUnitPrice() %>"><%= cart.getUnitPrice() %></span></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/update" class="qty-form">
                                        <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                                        <button class="btn btn-outline-secondary btn-sm" name="action" value="decrease">-</button>
                                        <input type="number" name="qty" value="<%= cart.getQuantity() %>" min="1" max="20" class="form-control form-control-sm qty-input">
                                        <button class="btn btn-outline-primary btn-sm" name="action" value="manual">Update</button>
                                        <button class="btn btn-outline-secondary btn-sm" name="action" value="increase">+</button>
                                    </form>
                                </td>
                                <td>NPR <span class="money" data-price="<%= cart.getLineTotal() %>"><%= cart.getLineTotal() %></span></td>
                                <td>
                                    <form method="post" action="${pageContext.request.contextPath}/cart/remove" onsubmit="return confirmRemove();">
                                        <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                                        <button class="btn btn-sm btn-outline-danger">Remove</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="mobile-cards d-grid gap-3">
                <% for (Cart cart : cartItems) { %>
                <div class="card cart-card">
                    <div class="card-body">
                        <div class="d-flex gap-3 mb-3">
                            <img src="${pageContext.request.contextPath}/<%= cart.getImagePath() != null ? cart.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="thumb" alt="<%= cart.getItemName() %>">
                            <div>
                                <div class="fw-semibold"><%= cart.getItemName() %></div>
                                <small class="text-muted"><%= cart.getCategoryName() %></small>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between mb-2"><span>Unit Price</span><strong>NPR <span class="money" data-price="<%= cart.getUnitPrice() %>"><%= cart.getUnitPrice() %></span></strong></div>
                        <div class="d-flex justify-content-between mb-2"><span>Line Total</span><strong>NPR <span class="money" data-price="<%= cart.getLineTotal() %>"><%= cart.getLineTotal() %></span></strong></div>
                        <form method="post" action="${pageContext.request.contextPath}/cart/update" class="qty-form mb-2">
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                            <button class="btn btn-outline-secondary btn-sm" name="action" value="decrease">-</button>
                            <input type="number" name="qty" value="<%= cart.getQuantity() %>" min="1" max="20" class="form-control form-control-sm qty-input">
                            <button class="btn btn-outline-primary btn-sm" name="action" value="manual">Update</button>
                            <button class="btn btn-outline-secondary btn-sm" name="action" value="increase">+</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/cart/remove" onsubmit="return confirmRemove();">
                            <input type="hidden" name="cartId" value="<%= cart.getCartId() %>">
                            <button class="btn btn-sm btn-outline-danger">Remove</button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>

            <div class="mt-3 d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark">Continue Shopping</a>
                <form method="post" action="${pageContext.request.contextPath}/cart/clear" onsubmit="return confirmClear();" class="d-inline">
                    <button class="btn btn-outline-danger">Clear Cart</button>
                </form>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card cart-card summary-sticky">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">Order Summary</h5>
                    <div class="d-flex justify-content-between mb-2"><span>Subtotal</span><strong>NPR <span class="money" data-price="<%= subtotal %>"><%= subtotal %></span></strong></div>
                    <div class="d-flex justify-content-between mb-3"><span>Tax (13%)</span><strong>NPR <span class="money" data-price="<%= tax %>"><%= tax %></span></strong></div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4"><span class="fw-semibold">Estimated Total</span><strong class="fs-5">NPR <span class="money" data-price="<%= grandTotal %>"><%= grandTotal %></span></strong></div>

                    <a href="${pageContext.request.contextPath}/customer/checkout.jsp" class="btn btn-warning w-100">Proceed to Checkout</a>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>

<script>
    function confirmRemove() {
        return confirm('Remove this item from cart?');
    }

    function confirmClear() {
        return confirm('Clear all items from cart?');
    }

    document.querySelectorAll('.money').forEach(el => {
        const value = Number(el.dataset.price || el.textContent || 0);
        el.textContent = new Intl.NumberFormat('en-NP', {minimumFractionDigits: 2, maximumFractionDigits: 2}).format(value);
    });

    document.querySelectorAll('input[name="qty"]').forEach(input => {
        input.addEventListener('change', () => {
            let value = Number(input.value);
            if (Number.isNaN(value) || value < 1) value = 1;
            if (value > 20) value = 20;
            input.value = value;
        });
    });
</script>
</body>
</html>
