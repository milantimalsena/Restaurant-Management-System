<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Checkout Details | Himalayan Yaks</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900">
<main class="mx-auto flex min-h-screen w-full max-w-5xl items-center px-4 py-8">
    <section class="w-full rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-200/70 md:p-8">
        <div class="mb-8 flex flex-col gap-4 border-b border-slate-200 pb-6 md:flex-row md:items-end md:justify-between">
            <div>
                <p class="text-sm font-bold uppercase tracking-[0.22em] text-amber-600">Step 1 of 3</p>
                <h1 class="mt-2 text-3xl font-black tracking-tight text-slate-950">Checkout Details</h1>
                <p class="mt-2 text-sm text-slate-500">Choose how you want to receive your order.</p>
            </div>
            <a href="${pageContext.request.contextPath}/cart" class="inline-flex items-center justify-center rounded-2xl border border-slate-300 px-5 py-3 text-sm font-bold text-slate-700 transition hover:border-amber-400 hover:text-amber-700">
                Back to Cart
            </a>
        </div>

        <c:if test="${not empty sessionScope.checkoutError}">
            <div class="mb-6 rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                ${sessionScope.checkoutError}
            </div>
            <c:remove var="checkoutError" scope="session" />
        </c:if>

        <form action="${pageContext.request.contextPath}/checkout-step1" method="post" class="space-y-8" id="checkoutStep1Form">
            <div>
                <label class="mb-3 block text-sm font-bold uppercase tracking-[0.18em] text-slate-500">Order Type</label>
                <div class="grid grid-cols-1 gap-4 md:grid-cols-3">
                    <label class="relative block cursor-pointer">
                        <input type="radio" name="orderType" value="DINE_IN" class="peer sr-only order-type-radio" checked />
                        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition peer-checked:border-amber-500 peer-checked:ring-4 peer-checked:ring-amber-100">
                            <div class="flex items-center justify-between gap-3">
                                <h2 class="font-bold text-slate-950">Dine-in</h2>
                                <span class="order-dot h-5 w-5 rounded-full border border-slate-400"></span>
                            </div>
                            <p class="mt-2 text-sm text-slate-500">Eat at the restaurant.</p>
                        </div>
                    </label>

                    <label class="relative block cursor-pointer">
                        <input type="radio" name="orderType" value="DELIVERY" class="peer sr-only order-type-radio" />
                        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition peer-checked:border-amber-500 peer-checked:ring-4 peer-checked:ring-amber-100">
                            <div class="flex items-center justify-between gap-3">
                                <h2 class="font-bold text-slate-950">Delivery</h2>
                                <span class="order-dot h-5 w-5 rounded-full border border-slate-400"></span>
                            </div>
                            <p class="mt-2 text-sm text-slate-500">Send the order to your address.</p>
                        </div>
                    </label>

                    <label class="relative block cursor-pointer">
                        <input type="radio" name="orderType" value="TAKEAWAY" class="peer sr-only order-type-radio" />
                        <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition peer-checked:border-amber-500 peer-checked:ring-4 peer-checked:ring-amber-100">
                            <div class="flex items-center justify-between gap-3">
                                <h2 class="font-bold text-slate-950">Takeaway</h2>
                                <span class="order-dot h-5 w-5 rounded-full border border-slate-400"></span>
                            </div>
                            <p class="mt-2 text-sm text-slate-500">Pick up from the restaurant.</p>
                        </div>
                    </label>
                </div>
            </div>

            <div id="deliveryFields" class="hidden rounded-3xl border border-amber-200 bg-amber-50 p-5">
                <h2 class="text-lg font-black text-slate-950">Delivery Information</h2>
                <div class="mt-5 grid grid-cols-1 gap-5 md:grid-cols-2">
                    <div class="md:col-span-2">
                        <label for="deliveryAddress" class="block text-sm font-bold text-slate-700">Delivery Address</label>
                        <input type="text" name="deliveryAddress" id="deliveryAddress" class="mt-2 w-full rounded-2xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-amber-500 focus:ring-4 focus:ring-amber-100" placeholder="Enter delivery address" />
                    </div>

                    <div>
                        <label for="phoneNumber" class="block text-sm font-bold text-slate-700">Phone Number</label>
                        <input type="text" name="phoneNumber" id="phoneNumber" class="mt-2 w-full rounded-2xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-amber-500 focus:ring-4 focus:ring-amber-100" placeholder="98XXXXXXXX" inputmode="tel" />
                    </div>

                    <div>
                        <label for="notes" class="block text-sm font-bold text-slate-700">Delivery Note</label>
                        <input type="text" name="notes" id="notes" class="mt-2 w-full rounded-2xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-amber-500 focus:ring-4 focus:ring-amber-100" placeholder="Optional delivery note" />
                    </div>
                </div>
            </div>

            <div id="generalNotesBox">
                <label for="generalNotes" class="block text-sm font-bold text-slate-700">Notes</label>
                <textarea name="notes" id="generalNotes" rows="4" class="mt-2 w-full rounded-2xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-amber-500 focus:ring-4 focus:ring-amber-100" placeholder="Special instructions"></textarea>
            </div>

            <div class="flex flex-col-reverse gap-3 border-t border-slate-200 pt-6 sm:flex-row sm:items-center sm:justify-end">
                <a href="${pageContext.request.contextPath}/cart" class="inline-flex items-center justify-center rounded-2xl border border-slate-300 px-6 py-3 text-sm font-bold text-slate-700 transition hover:border-slate-400">
                    Cancel
                </a>
                <button type="submit" class="inline-flex items-center justify-center rounded-2xl bg-amber-500 px-6 py-3 text-sm font-black text-white shadow-lg shadow-amber-200 transition hover:bg-amber-600">
                    Continue to Payment
                </button>
            </div>
        </form>
    </section>
</main>

<script>
(() => {
    const radios = document.querySelectorAll('.order-type-radio');
    const deliveryFields = document.getElementById('deliveryFields');
    const deliveryAddress = document.getElementById('deliveryAddress');
    const phoneNumber = document.getElementById('phoneNumber');
    const generalNotesBox = document.getElementById('generalNotesBox');
    const generalNotes = document.getElementById('generalNotes');

    function updateOrderType() {
        const selected = document.querySelector('.order-type-radio:checked')?.value;
        const isDelivery = selected === 'DELIVERY';

        radios.forEach((radio) => {
            const dot = radio.closest('label')?.querySelector('.order-dot');
            if (!dot) return;

            dot.classList.toggle('border-amber-500', radio.checked);
            dot.classList.toggle('bg-amber-500', radio.checked);
            dot.classList.toggle('ring-4', radio.checked);
            dot.classList.toggle('ring-amber-100', radio.checked);
            dot.classList.toggle('border-slate-400', !radio.checked);
        });

        deliveryFields.classList.toggle('hidden', !isDelivery);
        generalNotesBox.classList.toggle('hidden', isDelivery);
        deliveryAddress.required = isDelivery;
        phoneNumber.required = isDelivery;
        generalNotes.disabled = isDelivery;
    }

    radios.forEach((radio) => radio.addEventListener('change', updateOrderType));
    updateOrderType();
})();
</script>
</body>
</html>
