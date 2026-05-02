<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.restaurant.model.Cart" %>
<%
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    BigDecimal subtotal = (BigDecimal) request.getAttribute("subtotal");
    BigDecimal tax = (BigDecimal) request.getAttribute("tax");
    BigDecimal deliveryFeeDefault = (BigDecimal) request.getAttribute("deliveryFeeDefault");
    if (subtotal == null) subtotal = BigDecimal.ZERO;
    if (tax == null) tax = BigDecimal.ZERO;
    if (deliveryFeeDefault == null) deliveryFeeDefault = BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Checkout | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(180deg, #f8fafc, #eef2f7); }
        .panel { border: none; border-radius: 16px; box-shadow: 0 10px 28px rgba(2,6,23,.08); }
        .payment-card { border: 2px solid #e5e7eb; border-radius: 12px; padding: 12px; cursor: pointer; transition: all .2s ease; }
        .payment-card.active { border-color: #0f766e; background: #ecfeff; }
    </style>
</head>
<body class="bg-light">
<div class="container py-4 py-lg-5">
    <h2 class="fw-bold mb-4">Checkout</h2>

    <% if (request.getAttribute("checkoutError") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("checkoutError") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/place-order" id="checkoutForm">
        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card panel mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3">Order Details</h5>

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Order Type</label>
                                <select class="form-select" name="orderType" id="orderType" required>
                                    <option value="DINE_IN">Dine In</option>
                                    <option value="DELIVERY">Delivery</option>
                                    <option value="TAKEAWAY">Takeaway</option>
                                </select>
                            </div>
                            <div class="col-md-4" id="deliveryAddressGroup" style="display:none;">
                                <label class="form-label">Delivery Address</label>
                                <input type="text" class="form-control" name="deliveryAddress" id="deliveryAddress">
                            </div>
                            <div class="col-md-4" id="phoneGroup" style="display:none;">
                                <label class="form-label">Phone</label>
                                <input type="text" class="form-control" name="phone" id="phone" placeholder="98XXXXXXXX">
                            </div>
                            <div class="col-md-4" id="tableGroup" style="display:none;">
                                <label class="form-label">Table Number (optional)</label>
                                <input type="text" class="form-control" name="tableNumber">
                            </div>
                            <div class="col-md-4" id="pickupGroup" style="display:none;">
                                <label class="form-label">Pickup Time (optional)</label>
                                <input type="time" class="form-control" name="pickupTime">
                            </div>
                            <div class="col-12">
                                <label class="form-label">Notes</label>
                                <textarea class="form-control" rows="3" name="notes"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card panel mb-4">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3">Payment Method</h5>
                        <div class="row g-2" id="paymentCards">
                            <div class="col-sm-6 col-lg-3">
                                <label class="payment-card active w-100">
                                    <input class="form-check-input me-2" type="radio" name="paymentMethod" value="CASH" checked>
                                    Cash
                                </label>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <label class="payment-card w-100">
                                    <input class="form-check-input me-2" type="radio" name="paymentMethod" value="CARD">
                                    Card
                                </label>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <label class="payment-card w-100">
                                    <input class="form-check-input me-2" type="radio" name="paymentMethod" value="ESEWA">
                                    eSewa
                                </label>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <label class="payment-card w-100">
                                    <input class="form-check-input me-2" type="radio" name="paymentMethod" value="KHALTI">
                                    Khalti
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card panel">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3">Cart Items</h5>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Qty</th>
                                    <th>Unit</th>
                                    <th>Total</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% if (cartItems != null) {
                                    for (Cart cart : cartItems) { %>
                                <tr>
                                    <td><%= cart.getItemName() %></td>
                                    <td><%= cart.getQuantity() %></td>
                                    <td>NPR <%= cart.getUnitPrice() %></td>
                                    <td>NPR <%= cart.getLineTotal() %></td>
                                </tr>
                                <% }} %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card panel">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-3">Price Summary</h5>
                        <div class="mb-2 d-flex justify-content-between"><span>Subtotal</span><strong id="subtotalValue" data-value="<%= subtotal %>">NPR <%= subtotal %></strong></div>
                        <div class="mb-2 d-flex justify-content-between"><span>Tax (13%)</span><strong id="taxValue" data-value="<%= tax %>">NPR <%= tax %></strong></div>
                        <div class="mb-2 d-flex justify-content-between"><span>Delivery Fee</span><strong id="deliveryValue" data-value="0">NPR 0.00</strong></div>
                        <div class="mb-2 d-flex justify-content-between"><span>Discount</span><strong id="discountValue" data-value="0">NPR 0.00</strong></div>
                        <div class="mb-3">
                            <label class="form-label">Promo Code</label>
                            <input type="text" name="promoCode" id="promoCode" class="form-control" placeholder="Use SAVE10">
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between"><span class="fw-semibold">Grand Total</span><strong id="grandValue">NPR 0.00</strong></div>

                        <button type="submit" class="btn btn-warning w-100 mt-4" id="placeBtn">
                            <span class="spinner-border spinner-border-sm d-none" id="placeSpinner"></span>
                            <span id="placeBtnText">Place Order</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    const orderType = document.getElementById('orderType');
    const deliveryAddressGroup = document.getElementById('deliveryAddressGroup');
    const phoneGroup = document.getElementById('phoneGroup');
    const tableGroup = document.getElementById('tableGroup');
    const pickupGroup = document.getElementById('pickupGroup');
    const deliveryAddress = document.getElementById('deliveryAddress');
    const phone = document.getElementById('phone');

    const subtotalEl = document.getElementById('subtotalValue');
    const taxEl = document.getElementById('taxValue');
    const deliveryEl = document.getElementById('deliveryValue');
    const discountEl = document.getElementById('discountValue');
    const grandEl = document.getElementById('grandValue');
    const promoCodeEl = document.getElementById('promoCode');

    function toNumber(el) {
        return Number(el.dataset.value || 0);
    }

    function formatNpr(value) {
        return 'NPR ' + new Intl.NumberFormat('en-NP', {minimumFractionDigits: 2, maximumFractionDigits: 2}).format(value);
    }

    function handleOrderTypeUI() {
        const type = orderType.value;
        deliveryAddressGroup.style.display = type === 'DELIVERY' ? '' : 'none';
        phoneGroup.style.display = type === 'DELIVERY' ? '' : 'none';
        tableGroup.style.display = type === 'DINE_IN' ? '' : 'none';
        pickupGroup.style.display = type === 'TAKEAWAY' ? '' : 'none';

        deliveryAddress.required = type === 'DELIVERY';
        phone.required = type === 'DELIVERY';

        recalcTotals();
    }

    function getDiscount(subtotal) {
        const code = (promoCodeEl.value || '').trim().toUpperCase();
        if (code === 'SAVE10') {
            return Math.min(subtotal * 0.10, 200);
        }
        return 0;
    }

    function recalcTotals() {
        const subtotal = toNumber(subtotalEl);
        const tax = toNumber(taxEl);
        const deliveryFee = orderType.value === 'DELIVERY' ? <%= deliveryFeeDefault %> : 0;
        const discount = getDiscount(subtotal);
        const grand = subtotal + tax + deliveryFee - discount;

        deliveryEl.dataset.value = deliveryFee;
        deliveryEl.textContent = formatNpr(deliveryFee);
        discountEl.dataset.value = discount;
        discountEl.textContent = formatNpr(discount);
        grandEl.textContent = formatNpr(grand);
    }

    document.querySelectorAll('.payment-card').forEach(card => {
        card.addEventListener('click', () => {
            document.querySelectorAll('.payment-card').forEach(c => c.classList.remove('active'));
            card.classList.add('active');
        });
    });

    orderType.addEventListener('change', handleOrderTypeUI);
    promoCodeEl.addEventListener('input', recalcTotals);
    handleOrderTypeUI();

    const form = document.getElementById('checkoutForm');
    const placeBtn = document.getElementById('placeBtn');
    const placeSpinner = document.getElementById('placeSpinner');
    const placeBtnText = document.getElementById('placeBtnText');

    form.addEventListener('submit', () => {
        placeBtn.disabled = true;
        placeSpinner.classList.remove('d-none');
        placeBtnText.textContent = 'Placing Order...';
    });
</script>
</body>
</html>
