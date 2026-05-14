<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Our Restaurant | Himalayan Yaks</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-white text-slate-900 antialiased">
<%@ include file="../includes/navbar.jsp" %>
<c:set var="menuAssets" value="${pageContext.request.contextPath}/assets/menu" />

<main class="overflow-hidden">
    <section class="relative isolate min-h-[78vh] bg-slate-950">
        <div class="absolute inset-0 -z-10">
            <img src="${menuAssets}/biryani.webp" alt="Biryani restaurant banner" class="h-full w-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-950/80 to-amber-950/75"></div>
            <div class="absolute inset-x-0 bottom-0 h-40 bg-gradient-to-t from-white to-transparent"></div>
        </div>

        <div class="mx-auto grid min-h-[78vh] max-w-7xl items-center gap-12 px-4 py-20 sm:px-6 lg:grid-cols-[1.05fr_0.95fr] lg:px-8">
            <div class="max-w-3xl">
                <span class="inline-flex rounded-full border border-amber-200/30 bg-white/10 px-4 py-2 text-xs font-black uppercase tracking-[0.28em] text-amber-200 shadow-xl backdrop-blur-md">
                    Smart Restaurant Experience
                </span>
                <h1 class="mt-7 text-4xl font-black leading-tight tracking-tight text-white sm:text-6xl lg:text-7xl">
                    About Our Restaurant
                </h1>
                <p class="mt-6 max-w-2xl text-lg leading-8 text-slate-200 sm:text-xl">
                    Himalayan Yaks brings warm hospitality, fresh local ingredients, and smart digital ordering together for a faster, cleaner, and more memorable dining experience.
                </p>
                <div class="mt-9 flex flex-col gap-4 sm:flex-row">
                    <a href="${pageContext.request.contextPath}/menu" class="inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-amber-300 to-orange-500 px-7 py-4 text-sm font-black uppercase tracking-wide text-slate-950 shadow-xl shadow-amber-500/25 transition hover:-translate-y-1 hover:brightness-105">
                        Explore Menu
                    </a>
                    <a href="${pageContext.request.contextPath}/customer/reservations.jsp" class="inline-flex items-center justify-center rounded-2xl border border-white/20 bg-white/10 px-7 py-4 text-sm font-black uppercase tracking-wide text-white shadow-xl backdrop-blur-md transition hover:-translate-y-1 hover:bg-white/20">
                        Reserve Table
                    </a>
                </div>
            </div>

            <div class="relative hidden lg:block">
                <div class="absolute -left-8 -top-8 h-40 w-40 rounded-full bg-amber-300/20 blur-3xl"></div>
                <div class="rounded-[2rem] border border-white/15 bg-white/10 p-5 shadow-2xl shadow-slate-950/50 backdrop-blur-xl">
                    <img src="${menuAssets}/chicken%20siz.jpeg" alt="Signature chicken sizzler" class="h-[30rem] w-full rounded-[1.5rem] bg-white object-cover shadow-xl">
                    <div class="-mt-16 ml-5 flex gap-3">
                        <img src="${menuAssets}/momo.webp" alt="Momo" class="h-24 w-24 rounded-2xl border-4 border-white bg-white object-cover shadow-xl">
                        <img src="${menuAssets}/choila.webp" alt="Choila" class="h-24 w-24 rounded-2xl border-4 border-white bg-white object-cover shadow-xl">
                        <img src="${menuAssets}/beverage/mojito.webp" alt="Mojito" class="h-24 w-24 rounded-2xl border-4 border-white bg-white object-cover shadow-xl">
                    </div>
                    <div class="mt-5 grid grid-cols-3 gap-3">
                        <div class="rounded-2xl bg-white/15 p-4 text-center backdrop-blur-md">
                            <p class="text-2xl font-black text-white">4.8</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wide text-amber-100">Rating</p>
                        </div>
                        <div class="rounded-2xl bg-white/15 p-4 text-center backdrop-blur-md">
                            <p class="text-2xl font-black text-white">30m</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wide text-amber-100">Delivery</p>
                        </div>
                        <div class="rounded-2xl bg-white/15 p-4 text-center backdrop-blur-md">
                            <p class="text-2xl font-black text-white">100%</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wide text-amber-100">Fresh</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-white py-20 sm:py-24">
        <div class="mx-auto grid max-w-7xl gap-12 px-4 sm:px-6 lg:grid-cols-[0.85fr_1.15fr] lg:px-8">
            <div>
                <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">Our Story</span>
                <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-5xl">Built around flavor, service, and smarter dining.</h2>
            </div>
            <div class="grid gap-5 text-base leading-8 text-slate-600 sm:text-lg">
                <p>
                    Himalayan Yaks started as a local restaurant with a simple promise: serve honest food with the warmth of Nepali hospitality. From traditional Thakali sets to fresh momo, every plate is prepared with care and served with consistency.
                </p>
                <p>
                    As our guests grew, we introduced a Smart Restaurant Management System to make ordering, reservations, payments, feedback, and kitchen coordination more efficient without losing the human touch.
                </p>
                <div class="grid gap-4 sm:grid-cols-2">
                    <div class="rounded-2xl border border-amber-100 bg-amber-50/70 p-6 shadow-xl shadow-amber-900/5">
                        <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-500 text-white shadow-lg shadow-amber-500/25">
                            <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M9 12.75 11.25 15 15 9.75M12 3l7 4v5c0 4.4-2.9 8.4-7 9.8-4.1-1.4-7-5.4-7-9.8V7l7-4Z" />
                            </svg>
                        </div>
                        <h3 class="mt-5 text-lg font-black text-slate-950">Mission</h3>
                        <p class="mt-3 text-sm leading-7 text-slate-600">Deliver fresh, hygienic, flavorful meals through fast service and reliable digital restaurant operations.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                        <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-slate-950 text-amber-300 shadow-lg shadow-slate-900/20">
                            <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 5.5A2.5 2.5 0 0 1 6.5 3h11A2.5 2.5 0 0 1 20 5.5v13a2.5 2.5 0 0 1-2.5 2.5h-11A2.5 2.5 0 0 1 4 18.5v-13Z" />
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M8 7h8M8 11h8M8 15h4" />
                            </svg>
                        </div>
                        <h3 class="mt-5 text-lg font-black text-slate-950">Vision</h3>
                        <p class="mt-3 text-sm leading-7 text-slate-600">Become a trusted modern dining destination where technology improves every guest experience.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-slate-50 py-20 sm:py-24">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div class="mx-auto max-w-3xl text-center">
                <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">Why Choose Us</span>
                <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-5xl">Everything guests expect from a premium restaurant.</h2>
            </div>

            <div class="mt-12 grid gap-6 sm:grid-cols-2 lg:grid-cols-4">
                <div class="group rounded-2xl border border-white bg-white/80 p-7 shadow-xl shadow-slate-900/6 backdrop-blur-xl transition hover:-translate-y-2 hover:shadow-2xl">
                    <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700 transition group-hover:bg-amber-500 group-hover:text-white">
                        <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 21C7.6 17.2 5.4 13.7 5.4 10.6A6.6 6.6 0 0 1 12 4a6.6 6.6 0 0 1 6.6 6.6c0 3.1-2.2 6.6-6.6 10.4Z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M9 10.5c2 0 3-1 3-3 0 2 1 3 3 3-2 0-3 1-3 3 0-2-1-3-3-3Z"/></svg>
                    </div>
                    <h3 class="mt-6 text-xl font-black text-slate-950">Fresh Ingredients</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-600">Daily-selected vegetables, spices, grains, and proteins prepared for clean, vibrant flavor.</p>
                </div>

                <div class="group rounded-2xl border border-white bg-white/80 p-7 shadow-xl shadow-slate-900/6 backdrop-blur-xl transition hover:-translate-y-2 hover:shadow-2xl">
                    <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700 transition group-hover:bg-amber-500 group-hover:text-white">
                        <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M3 8h11v8H3zM14 11h3l3 3v2h-6zM6.5 19a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3ZM17.5 19a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z"/></svg>
                    </div>
                    <h3 class="mt-6 text-xl font-black text-slate-950">Fast Delivery</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-600">Smart order tracking helps our team prepare, pack, and serve orders with less waiting.</p>
                </div>

                <div class="group rounded-2xl border border-white bg-white/80 p-7 shadow-xl shadow-slate-900/6 backdrop-blur-xl transition hover:-translate-y-2 hover:shadow-2xl">
                    <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700 transition group-hover:bg-amber-500 group-hover:text-white">
                        <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M7 10a5 5 0 0 1 10 0M5 10h14M6 10l1 10h10l1-10M9 14h6"/></svg>
                    </div>
                    <h3 class="mt-6 text-xl font-black text-slate-950">Professional Chefs</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-600">Experienced kitchen teams balance traditional recipes with modern plating and quality control.</p>
                </div>

                <div class="group rounded-2xl border border-white bg-white/80 p-7 shadow-xl shadow-slate-900/6 backdrop-blur-xl transition hover:-translate-y-2 hover:shadow-2xl">
                    <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700 transition group-hover:bg-amber-500 group-hover:text-white">
                        <svg class="h-7 w-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 3 5 6v5c0 4.5 2.9 8.5 7 10 4.1-1.5 7-5.5 7-10V6l-7-3Z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m9 12 2 2 4-5"/></svg>
                    </div>
                    <h3 class="mt-6 text-xl font-black text-slate-950">Hygienic Kitchen</h3>
                    <p class="mt-3 text-sm leading-7 text-slate-600">Structured kitchen workflows keep preparation areas clean, organized, and inspection-ready.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-slate-950 py-16 sm:py-20">
        <div class="mx-auto grid max-w-7xl gap-5 px-4 sm:grid-cols-2 sm:px-6 lg:grid-cols-4 lg:px-8">
            <div class="rounded-2xl border border-white/10 bg-white/10 p-7 text-center shadow-xl backdrop-blur-xl transition hover:-translate-y-1">
                <p class="text-4xl font-black text-amber-300 sm:text-5xl">12K+</p>
                <p class="mt-3 text-sm font-bold uppercase tracking-[0.18em] text-slate-300">Happy Customers</p>
            </div>
            <div class="rounded-2xl border border-white/10 bg-white/10 p-7 text-center shadow-xl backdrop-blur-xl transition hover:-translate-y-1">
                <p class="text-4xl font-black text-amber-300 sm:text-5xl">48K+</p>
                <p class="mt-3 text-sm font-bold uppercase tracking-[0.18em] text-slate-300">Orders Served</p>
            </div>
            <div class="rounded-2xl border border-white/10 bg-white/10 p-7 text-center shadow-xl backdrop-blur-xl transition hover:-translate-y-1">
                <p class="text-4xl font-black text-amber-300 sm:text-5xl">8+</p>
                <p class="mt-3 text-sm font-bold uppercase tracking-[0.18em] text-slate-300">Years Experience</p>
            </div>
            <div class="rounded-2xl border border-white/10 bg-white/10 p-7 text-center shadow-xl backdrop-blur-xl transition hover:-translate-y-1">
                <p class="text-4xl font-black text-amber-300 sm:text-5xl">80+</p>
                <p class="mt-3 text-sm font-bold uppercase tracking-[0.18em] text-slate-300">Food Items</p>
            </div>
        </div>
    </section>

    <section class="bg-white py-20 sm:py-24">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div class="grid gap-10 lg:grid-cols-[0.9fr_1.1fr] lg:items-center">
                <div>
                    <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">Our Team</span>
                    <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-5xl">Chefs who lead with craft and care.</h2>
                    <p class="mt-5 max-w-xl text-base leading-8 text-slate-600">Every service is coordinated by people who understand taste, speed, hygiene, and guest comfort.</p>
                </div>
                <div class="grid grid-cols-3 gap-4">
                    <img src="${menuAssets}/pizza.webp" alt="Pizza" class="h-32 w-full rounded-2xl bg-amber-50 object-cover shadow-xl sm:h-44">
                    <img src="${menuAssets}/burger.webp" alt="Burger" class="mt-8 h-32 w-full rounded-2xl bg-amber-50 object-cover shadow-xl sm:h-44">
                    <img src="${menuAssets}/beverage/lassi.webp" alt="Lassi" class="h-32 w-full rounded-2xl bg-amber-50 object-cover shadow-xl sm:h-44">
                </div>
            </div>

            <div class="mt-12 grid gap-6 md:grid-cols-3">
                <div class="group overflow-hidden rounded-2xl bg-white shadow-xl shadow-slate-900/8 ring-1 ring-slate-200 transition hover:-translate-y-2 hover:shadow-2xl">
                    <img src="${menuAssets}/biryani.webp" alt="Biryani prepared by the executive chef" class="h-72 w-full bg-amber-50 object-cover transition duration-500 group-hover:scale-105">
                    <div class="p-6">
                        <h3 class="text-xl font-black text-slate-950">Aarav Sharma</h3>
                        <p class="mt-2 text-sm font-bold uppercase tracking-[0.18em] text-amber-600">Executive Chef</p>
                    </div>
                </div>
                <div class="group overflow-hidden rounded-2xl bg-white shadow-xl shadow-slate-900/8 ring-1 ring-slate-200 transition hover:-translate-y-2 hover:shadow-2xl">
                    <img src="${menuAssets}/thakali.jpeg" alt="Thakali set prepared by the head chef" class="h-72 w-full bg-amber-50 object-cover transition duration-500 group-hover:scale-105">
                    <div class="p-6">
                        <h3 class="text-xl font-black text-slate-950">Nisha Gurung</h3>
                        <p class="mt-2 text-sm font-bold uppercase tracking-[0.18em] text-amber-600">Head Chef</p>
                    </div>
                </div>
                <div class="group overflow-hidden rounded-2xl bg-white shadow-xl shadow-slate-900/8 ring-1 ring-slate-200 transition hover:-translate-y-2 hover:shadow-2xl">
                    <img src="${menuAssets}/BlackForestPastry.webp" alt="Black forest pastry prepared by the pastry chef" class="h-72 w-full bg-amber-50 object-cover transition duration-500 group-hover:scale-105">
                    <div class="p-6">
                        <h3 class="text-xl font-black text-slate-950">Samir Rai</h3>
                        <p class="mt-2 text-sm font-bold uppercase tracking-[0.18em] text-amber-600">Pastry Chef</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-slate-50 py-20 sm:py-24">
        <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
            <div class="mx-auto max-w-3xl text-center">
                <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">Gallery Preview</span>
                <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-5xl">A quick look at our favorite flavors.</h2>
            </div>

            <div class="mt-12 grid grid-cols-2 gap-4 md:grid-cols-4">
                <img src="${menuAssets}/thakali.jpeg" alt="Traditional Thakali set" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
                <img src="${menuAssets}/choila.webp" alt="Choila plate" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
                <img src="${menuAssets}/momo.webp" alt="Momo" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
                <img src="${menuAssets}/pizza.webp" alt="Pizza" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
                <img src="${menuAssets}/keema%20noodles.webp" alt="Keema noodles" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56 md:col-span-2">
                <img src="${menuAssets}/sel.webp" alt="Sel roti" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
                <img src="${menuAssets}/yomari.webp" alt="Yomari dessert" class="h-44 w-full rounded-2xl bg-white object-cover shadow-xl transition hover:-translate-y-1 sm:h-56">
            </div>
        </div>
    </section>

    <section class="bg-white px-4 py-20 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-7xl overflow-hidden rounded-[2rem] bg-gradient-to-r from-slate-950 via-amber-950 to-slate-900 px-6 py-14 text-center shadow-2xl shadow-slate-900/20 sm:px-10">
            <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-300">Dining Made Easy</span>
            <h2 class="mx-auto mt-4 max-w-3xl text-3xl font-black tracking-tight text-white sm:text-5xl">Reserve Your Table Today</h2>
            <p class="mx-auto mt-5 max-w-2xl text-base leading-8 text-slate-200">Plan your next lunch, dinner, celebration, or family gathering with fast online reservation and warm restaurant service.</p>
            <a href="${pageContext.request.contextPath}/customer/reservations.jsp" class="mt-8 inline-flex items-center justify-center rounded-2xl bg-gradient-to-r from-amber-300 to-orange-500 px-8 py-4 text-sm font-black uppercase tracking-wide text-slate-950 shadow-xl shadow-amber-500/25 transition hover:-translate-y-1 hover:brightness-105">
                Book Now
            </a>
        </div>
    </section>
</main>

<%@ include file="../includes/footer.jsp" %>
</body>
</html>
