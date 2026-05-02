<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Checkout | Himalayan Yaks</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
    <style>
        :root { --brand: #4f46e5; }
        body {
            background:
                radial-gradient(circle at top left, rgba(79, 70, 229, 0.14), transparent 32%),
                linear-gradient(180deg, #f8fafc 0%, #eef2ff 100%);
        }
        .shell { max-width: 1320px; }
        .card-glass {
            border: 1px solid rgba(148, 163, 184, 0.18);
            border-radius: 1.5rem;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(14px);
            box-shadow: 0 18px 44px rgba(15, 23, 42, 0.08);
        }
        .payment-card {
            cursor: pointer;
            border: 1px solid #dbe4f0;
            border-radius: 1rem;
            background: #fff;
            transition: all .2s ease;
        }
        .payment-card.active {
            border-color: var(--brand);
            box-shadow: 0 10px 24px rgba(79, 70, 229, 0.16);
            transform: translateY(-1px);
            background: linear-gradient(180deg, #fff, #eef2ff);
        }
        .summary-sticky { top: 1rem; }
        .summary-row + .summary-row { border-top: 1px dashed #e2e8f0; }
        .section-label { letter-spacing: .18em; text-transform: uppercase; font-size: .75rem; font-weight: 700; color: #6366f1; }
    </style>
</head>
<body>
<div class="container shell py-4 py-lg-5">
    <div class="d-flex flex-column flex-md-row align-items-md-end justify-content-between gap-3 mb-4">
        <div>
            <div class="section-label mb-2">Secure Checkout</div>
            <h1 class="display-6 fw-bold mb-2 text-dark">Complete your order</h1>
            <p class="text-secondary mb-0">Review your cart, choose an order type, and place the order securely.</p>
        </div>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary rounded-pill px-4">Back to Cart</a>
    </div>

    <c:if test="${not empty checkoutError}"><div class="alert alert-danger border-0 shadow-sm">${checkoutError}</div></c:if>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger border-0 shadow-sm">${errorMessage}</div></c:if>

    <form method="post" action="${pageContext.request.contextPath}/place-order" id="checkoutForm" novalidate>
        <div class="row g-4">
            <div class="col-lg-7 col-xl-8">
                <div class="card-glass p-4 p-lg-5 mb-4">
                    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
                        <div>
                            <h2 class="h4 fw-bold mb-1">Order Details</h2>
                            <p class="text-secondary mb-0">Choose delivery behavior, pickup details, and notes.</p>
                        </div>
                        <span class="badge rounded-pill text-bg-primary-subtle text-primary-emphasis px-3 py-2">Step 1</span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="orderType" class="form-label fw-semibold">Order Type</label>
                            <select class="form-select form-select-lg" name="orderType" id="orderType" required>
                                <option value="DINE_IN">Dine In</option>
                                <option value="DELIVERY">Delivery</option>
                                <option value="TAKEAWAY">Takeaway</option>
                            </select>
                        </div>
                        <div class="col-md-6 d-none" id="deliveryAddressGroup">
                            <label for="deliveryAddress" class="form-label fw-semibold">Delivery Address</label>
                            <input type="text" class="form-control form-control-lg" name="deliveryAddress" id="deliveryAddress" placeholder="Enter delivery address" />
                        </div>
                        <div class="col-md-6 d-none" id="phoneGroup">
                            <label for="phone" class="form-label fw-semibold">Phone Number</label>
                            <input type="text" class="form-control form-control-lg" name="phone" id="phone" placeholder="98XXXXXXXX" inputmode="tel" />
                        </div>
                        <div class="col-md-6 d-none" id="tableGroup">
                            <label for="tableNumber" class="form-label fw-semibold">Table Number</label>
                            <input type="text" class="form-control form-control-lg" name="tableNumber" id="tableNumber" placeholder="Optional table number" />
                        </div>
                        <div class="col-md-6 d-none" id="pickupGroup">
                            <label for="pickupNote" class="form-label fw-semibold">Pickup Note</label>
                            <input type="text" class="form-control form-control-lg" name="pickupNote" id="pickupNote" placeholder="Optional pickup note" />
                        </div>
                        <div class="col-12">
                            <label for="notes" class="form-label fw-semibold">Additional Notes</label>
                            <textarea class="form-control" rows="4" name="notes" id="notes" placeholder="Special instructions or delivery notes"></textarea>
                        </div>
                    </div>
                </div>

                <div class="card-glass p-4 p-lg-5 mb-4">
                    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
                        <div>
                            <h2 class="h4 fw-bold mb-1">Payment Method</h2>
                            <p class="text-secondary mb-0">Cash stays unpaid. Card and e-wallet methods are marked as paid.</p>
                        </div>
                        <span class="badge rounded-pill text-bg-success-subtle text-success-emphasis px-3 py-2">Step 2</span>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6 col-xl-3">
                            <label class="payment-card active w-100 p-3 h-100" for="payCash">
                                <input class="form-check-input me-2 payment-radio" type="radio" name="paymentMethod" id="payCash" value="CASH" checked />
                                <div class="mt-3"><div class="fw-bold">Cash</div><small class="text-secondary">Unpaid until collected</small></div>
                            </label>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <label class="payment-card w-100 p-3 h-100" for="payCard">
                                <input class="form-check-input me-2 payment-radio" type="radio" name="paymentMethod" id="payCard" value="CARD" />
                                <div class="mt-3"><div class="fw-bold">Card</div><small class="text-secondary">Marked as paid</small></div>
                            </label>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <label class="payment-card w-100 p-3 h-100" for="payEsewa">
                                <input class="form-check-input me-2 payment-radio" type="radio" name="paymentMethod" id="payEsewa" value="ESEWA" />
                                <div class="mt-3"><div class="fw-bold">eSewa</div><small class="text-secondary">Wallet simulation</small></div>
                            </label>
                        </div>
                        <div class="col-md-6 col-xl-3">
                            <label class="payment-card w-100 p-3 h-100" for="payKhalti">
                                <input class="form-check-input me-2 payment-radio" type="radio" name="paymentMethod" id="payKhalti" value="KHALTI" />
                                <div class="mt-3"><div class="fw-bold">Khalti</div><small class="text-secondary">Wallet simulation</small></div>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="card-glass p-4 p-lg-5">
                    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
                        <div>
                            <h2 class="h4 fw-bold mb-1">Cart Items</h2>
                            <p class="text-secondary mb-0">Your cart is read from the current session and rechecked on the server.</p>
                        </div>
                        <span class="badge rounded-pill text-bg-dark px-3 py-2">${fn:length(cartItems)} items</span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty cartItems}">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light"><tr><th>Item</th><th class="text-center">Qty</th><th class="text-end">Unit</th><th class="text-end">Total</th></tr></thead>
                                    <tbody>
                                    <c:forEach var="cart" items="${cartItems}">
                                        <tr>
                                            <td><div class="fw-semibold">${cart.itemName}</div><small class="text-secondary">${cart.categoryName}</small></td>
                                            <td class="text-center">${cart.quantity}</td>
                                            <td class="text-end">NPR <fmt:formatNumber value="${cart.unitPrice}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="text-end fw-semibold">NPR <fmt:formatNumber value="${cart.lineTotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise><div class="alert alert-warning mb-0">Your cart is empty. Add items before checking out.</div></c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="col-lg-5 col-xl-4">
                <div class="card-glass p-4 p-lg-4 sticky-lg-top summary-sticky">
                    <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                        <div>
                            <h2 class="h4 fw-bold mb-1">Order Summary</h2>
                            <p class="text-secondary mb-0">Preview totals update live before submission.</p>
                        </div>
                    </div>

                    <div class="rounded-4 p-3 mb-3 bg-white border">
                        <div class="d-flex justify-content-between summary-row py-2"><span>Subtotal</span><strong id="subtotalValue" data-value="${subtotal}">NPR <fmt:formatNumber value="${subtotal}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                        <div class="d-flex justify-content-between summary-row py-2"><span>Tax (10%)</span><strong id="taxValue" data-value="${tax}">NPR <fmt:formatNumber value="${tax}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                        <div class="d-flex justify-content-between summary-row py-2"><span>Delivery Fee</span><strong id="deliveryValue" data-value="${deliveryFeeDefault}">NPR 0.00</strong></div>
                        <div class="d-flex justify-content-between summary-row py-2 mb-3"><span>Discount</span><strong id="discountValue" data-value="0">NPR 0.00</strong></div>
                        <label for="promoCode" class="form-label fw-semibold">Promo Code</label>
                        <input type="text" name="promoCode" id="promoCode" class="form-control form-control-lg mb-3" placeholder="Use SAVE10" />
                        <div class="d-flex justify-content-between align-items-center border-top pt-3"><span class="fw-semibold">Grand Total</span><strong class="fs-4" id="grandValue" data-value="${grandTotalPreview}">NPR <fmt:formatNumber value="${grandTotalPreview}" minFractionDigits="2" maxFractionDigits="2" /></strong></div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill" id="placeBtn" ${empty cartItems ? 'disabled' : ''}>
                            <span class="spinner-border spinner-border-sm d-none me-2" id="placeSpinner" role="status" aria-hidden="true"></span>
                            <span id="placeBtnText">Place Order</span>
                        </button>
                        <div class="form-text text-center">The order will be recalculated on the server before it is saved.</div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
(() => {
    const orderType = document.getElementById('orderType');
    const deliveryAddressGroup = document.getElementById('deliveryAddressGroup');
    const phoneGroup = document.getElementById('phoneGroup');
    const tableGroup = document.getElementById('tableGroup');
    const pickupGroup = document.getElementById('pickupGroup');
    const deliveryAddress = document.getElementById('deliveryAddress');
    const phone = document.getElementById('phone');
    const tableNumber = document.getElementById('tableNumber');
    const pickupNote = document.getElementById('pickupNote');
    const subtotalEl = document.getElementById('subtotalValue');
    const taxEl = document.getElementById('taxValue');
    const deliveryEl = document.getElementById('deliveryValue');
    const discountEl = document.getElementById('discountValue');
    const grandEl = document.getElementById('grandValue');
    const promoCodeEl = document.getElementById('promoCode');
    const placeBtn = document.getElementById('placeBtn');
    const placeSpinner = document.getElementById('placeSpinner');
    const placeBtnText = document.getElementById('placeBtnText');
    const form = document.getElementById('checkoutForm');
    const deliveryFeeBase = Number(deliveryEl.dataset.value || 0);

    function currency(value) {
        return 'NPR ' + new Intl.NumberFormat('en-NP', { minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(value);
    }
    function subtotal() { return Number(subtotalEl.dataset.value || 0); }
    function tax() { return Number(taxEl.dataset.value || 0); }
    function discountAmount() {
        const code = (promoCodeEl.value || '').trim().toUpperCase();
        if (code === 'SAVE10') {
            return Math.min(subtotal() * 0.10, 200);
        }
        return 0;
    }
    function toggleFields() {
        const type = orderType.value;
        const delivery = type === 'DELIVERY';
        const dineIn = type === 'DINE_IN';
        const takeaway = type === 'TAKEAWAY';
        deliveryAddressGroup.classList.toggle('d-none', !delivery);
        phoneGroup.classList.toggle('d-none', !delivery);
        tableGroup.classList.toggle('d-none', !dineIn);
        pickupGroup.classList.toggle('d-none', !takeaway);
        deliveryAddress.required = delivery;
        phone.required = delivery;
        recalculate();
    }
    function recalculate() {
        const deliveryFee = orderType.value === 'DELIVERY' ? deliveryFeeBase : 0;
        const discount = discountAmount();
        const grand = subtotal() + tax() + deliveryFee - discount;
        deliveryEl.dataset.value = deliveryFee;
        deliveryEl.textContent = currency(deliveryFee);
        discountEl.dataset.value = discount;
        discountEl.textContent = currency(discount);
        grandEl.dataset.value = grand;
        grandEl.textContent = currency(grand);
    }

    document.querySelectorAll('.payment-card').forEach(card => {
        const radio = card.querySelector('.payment-radio');
        if (!radio) return;
        card.addEventListener('click', () => {
            document.querySelectorAll('.payment-card').forEach(item => item.classList.remove('active'));
            card.classList.add('active');
            radio.checked = true;
        });
        radio.addEventListener('change', () => {
            document.querySelectorAll('.payment-card').forEach(item => item.classList.remove('active'));
            card.classList.add('active');
        });
    });

    orderType.addEventListener('change', toggleFields);
    promoCodeEl.addEventListener('input', recalculate);
    form.addEventListener('submit', (event) => {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
            form.classList.add('was-validated');
            return;
        }
        placeBtn.disabled = true;
        placeSpinner.classList.remove('d-none');
        placeBtnText.textContent = 'Placing Order...';
    });

    toggleFields();
    recalculate();
})();
</script>
</body>
</html>
