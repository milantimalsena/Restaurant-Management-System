<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Himalayan Yaks | Smart Restaurant Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>
</head>
<body class="bg-white text-slate-900 antialiased">
<%@ include file="../includes/navbar.jsp" %>

<main class="overflow-hidden">
    <section class="relative isolate min-h-[72vh] bg-slate-950">
        <div class="absolute inset-0 -z-10">
            <img src="${pageContext.request.contextPath}/assets/menu/thakali.jpeg" alt="Himalayan restaurant dining table" class="h-full w-full object-cover">
            <div class="absolute inset-0 bg-gradient-to-r from-slate-950 via-slate-950/80 to-amber-950/70"></div>
            <div class="absolute inset-x-0 bottom-0 h-36 bg-gradient-to-t from-white to-transparent"></div>
        </div>

        <div class="mx-auto flex min-h-[72vh] max-w-7xl items-center px-4 py-20 sm:px-6 lg:px-8">
            <div class="max-w-3xl">
                <span class="inline-flex rounded-full border border-amber-200/30 bg-white/10 px-4 py-2 text-xs font-black uppercase tracking-[0.28em] text-amber-200 shadow-xl backdrop-blur-md">
                    Get In Touch
                </span>
                <h1 class="mt-7 text-4xl font-black leading-tight tracking-tight text-white sm:text-6xl lg:text-7xl">
                    Contact Himalayan Yaks
                </h1>
                <p class="mt-6 max-w-2xl text-lg leading-8 text-slate-200 sm:text-xl">
                    We would love to hear from you.
                </p>
                <a href="${pageContext.request.contextPath}/customer/reservations.jsp" class="mt-9 inline-flex items-center justify-center gap-3 rounded-2xl bg-gradient-to-r from-amber-300 to-orange-500 px-7 py-4 text-sm font-black uppercase tracking-wide text-slate-950 shadow-xl shadow-amber-500/25 transition hover:-translate-y-1 hover:brightness-105">
                    <i class="fa-solid fa-calendar-check"></i>
                    Reserve a Table
                </a>
            </div>
        </div>
    </section>

    <section class="relative z-10 -mt-16 px-4 sm:px-6 lg:px-8">
        <div class="mx-auto grid max-w-7xl gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <div class="rounded-2xl border border-white bg-white/80 p-6 shadow-xl backdrop-blur transition hover:-translate-y-1 hover:shadow-2xl">
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700">
                    <i class="fa-solid fa-location-dot text-2xl"></i>
                </div>
                <h2 class="mt-5 text-lg font-black text-slate-950">Address</h2>
                <p class="mt-2 text-sm leading-7 text-slate-600">Itahari, Sunsari, Nepal</p>
            </div>

            <div class="rounded-2xl border border-white bg-white/80 p-6 shadow-xl backdrop-blur transition hover:-translate-y-1 hover:shadow-2xl">
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700">
                    <i class="fa-solid fa-phone text-2xl"></i>
                </div>
                <h2 class="mt-5 text-lg font-black text-slate-950">Phone</h2>
                <p class="mt-2 text-sm leading-7 text-slate-600">+977 9800000000</p>
            </div>

            <div class="rounded-2xl border border-white bg-white/80 p-6 shadow-xl backdrop-blur transition hover:-translate-y-1 hover:shadow-2xl">
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700">
                    <i class="fa-solid fa-envelope text-2xl"></i>
                </div>
                <h2 class="mt-5 text-lg font-black text-slate-950">Email</h2>
                <p class="mt-2 break-words text-sm leading-7 text-slate-600">info@himalayanyaks.com</p>
            </div>

            <div class="rounded-2xl border border-white bg-white/80 p-6 shadow-xl backdrop-blur transition hover:-translate-y-1 hover:shadow-2xl">
                <div class="flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-100 text-amber-700">
                    <i class="fa-solid fa-clock text-2xl"></i>
                </div>
                <h2 class="mt-5 text-lg font-black text-slate-950">Opening Hours</h2>
                <p class="mt-2 text-sm leading-7 text-slate-600">Sun - Fri: 10:00 AM - 10:00 PM</p>
            </div>
        </div>
    </section>

    <section class="bg-white py-20 sm:py-24">
        <div class="mx-auto grid max-w-7xl gap-10 px-4 sm:px-6 lg:grid-cols-[1.05fr_0.95fr] lg:px-8">
            <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/8 sm:p-8">
                <div>
                    <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">Send Message</span>
                    <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-4xl">Tell us how we can help.</h2>
                    <p class="mt-4 text-sm leading-7 text-slate-600">For reservations, catering, feedback, or support, send a message and our team will respond soon.</p>
                </div>

                <c:if test="${not empty sessionScope.contactSuccess}">
                    <div class="mt-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-700">
                        ${sessionScope.contactSuccess}
                    </div>
                    <c:remove var="contactSuccess" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.contactError}">
                    <div class="mt-6 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-700">
                        ${sessionScope.contactError}
                    </div>
                    <c:remove var="contactError" scope="session" />
                </c:if>

                <form action="${pageContext.request.contextPath}/contact-message" method="POST" class="mt-8 grid gap-5">
                    <div>
                        <label for="fullName" class="text-sm font-black text-slate-800">Full Name</label>
                        <input id="fullName" name="fullName" type="text" required placeholder="Enter your full name" class="mt-2 w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-amber-400 focus:ring-4 focus:ring-amber-100">
                        <p class="mt-2 min-h-5 text-xs font-semibold text-rose-600"></p>
                    </div>

                    <div>
                        <label for="email" class="text-sm font-black text-slate-800">Email</label>
                        <input id="email" name="email" type="email" required placeholder="you@example.com" class="mt-2 w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-amber-400 focus:ring-4 focus:ring-amber-100">
                        <p class="mt-2 min-h-5 text-xs font-semibold text-rose-600"></p>
                    </div>

                    <div>
                        <label for="subject" class="text-sm font-black text-slate-800">Subject</label>
                        <input id="subject" name="subject" type="text" required placeholder="Reservation, delivery, payment, or feedback" class="mt-2 w-full rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-amber-400 focus:ring-4 focus:ring-amber-100">
                        <p class="mt-2 min-h-5 text-xs font-semibold text-rose-600"></p>
                    </div>

                    <div>
                        <label for="message" class="text-sm font-black text-slate-800">Message</label>
                        <textarea id="message" name="message" rows="6" required placeholder="Write your message..." class="mt-2 w-full resize-none rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-800 outline-none transition placeholder:text-slate-400 focus:border-amber-400 focus:ring-4 focus:ring-amber-100"></textarea>
                        <p class="mt-2 min-h-5 text-xs font-semibold text-rose-600"></p>
                    </div>

                    <div class="flex flex-col gap-3 sm:flex-row">
                        <button type="submit" class="inline-flex items-center justify-center gap-3 rounded-2xl bg-slate-950 px-6 py-4 text-sm font-black uppercase tracking-wide text-white shadow-xl shadow-slate-900/20 transition hover:-translate-y-1 hover:bg-amber-600">
                            <i class="fa-solid fa-paper-plane"></i>
                            Send Message
                        </button>
                        <button type="reset" class="inline-flex items-center justify-center gap-3 rounded-2xl border border-slate-200 bg-white px-6 py-4 text-sm font-black uppercase tracking-wide text-slate-700 shadow-sm transition hover:-translate-y-1 hover:border-amber-300 hover:text-amber-700">
                            <i class="fa-solid fa-rotate-left"></i>
                            Reset
                        </button>
                    </div>
                </form>
            </div>

            <div class="grid gap-6">
                <div class="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-xl shadow-slate-900/8">
                    <iframe title="Himalayan Yaks map" src="https://www.google.com/maps?q=Itahari,Nepal&output=embed" class="h-80 w-full border-0" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                    <div class="p-6">
                        <h2 class="text-xl font-black text-slate-950">Visit Our Restaurant</h2>
                        <p class="mt-3 text-sm leading-7 text-slate-600">Find us in Itahari for dine-in service, pickup orders, table reservations, and authentic Himalayan flavors.</p>
                    </div>
                </div>

                <div class="rounded-3xl bg-gradient-to-br from-slate-950 to-amber-950 p-6 text-white shadow-xl shadow-slate-900/20">
                    <span class="text-xs font-black uppercase tracking-[0.26em] text-amber-300">Social</span>
                    <h2 class="mt-3 text-2xl font-black">Follow Himalayan Yaks</h2>
                    <div class="mt-6 flex flex-wrap gap-3">
                        <a href="#" aria-label="Facebook" class="flex h-12 w-12 items-center justify-center rounded-full border border-white/15 bg-white/10 text-white transition hover:scale-110 hover:bg-blue-600"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#" aria-label="Instagram" class="flex h-12 w-12 items-center justify-center rounded-full border border-white/15 bg-white/10 text-white transition hover:scale-110 hover:bg-pink-600"><i class="fa-brands fa-instagram"></i></a>
                        <a href="#" aria-label="TikTok" class="flex h-12 w-12 items-center justify-center rounded-full border border-white/15 bg-white/10 text-white transition hover:scale-110 hover:bg-slate-800"><i class="fa-brands fa-tiktok"></i></a>
                        <a href="#" aria-label="YouTube" class="flex h-12 w-12 items-center justify-center rounded-full border border-white/15 bg-white/10 text-white transition hover:scale-110 hover:bg-red-600"><i class="fa-brands fa-youtube"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-slate-50 py-20 sm:py-24">
        <div class="mx-auto max-w-4xl px-4 sm:px-6 lg:px-8">
            <div class="text-center">
                <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-600">FAQ</span>
                <h2 class="mt-4 text-3xl font-black tracking-tight text-slate-950 sm:text-5xl">Common Questions</h2>
            </div>

            <div class="mt-12 grid gap-4">
                <div class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-900/5">
                    <button type="button" class="faq-toggle flex w-full items-center justify-between gap-4 px-6 py-5 text-left text-base font-black text-slate-950">
                        <span>How do I reserve a table?</span>
                        <i class="fa-solid fa-chevron-down text-amber-600 transition"></i>
                    </button>
                    <div class="faq-panel hidden px-6 pb-5 text-sm leading-7 text-slate-600">Use the Reserve a Table button, choose your preferred date and time, and submit the reservation request.</div>
                </div>

                <div class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-900/5">
                    <button type="button" class="faq-toggle flex w-full items-center justify-between gap-4 px-6 py-5 text-left text-base font-black text-slate-950">
                        <span>Do you offer home delivery?</span>
                        <i class="fa-solid fa-chevron-down text-amber-600 transition"></i>
                    </button>
                    <div class="faq-panel hidden px-6 pb-5 text-sm leading-7 text-slate-600">Yes, delivery is available for supported areas. Delivery details are collected during checkout.</div>
                </div>

                <div class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-900/5">
                    <button type="button" class="faq-toggle flex w-full items-center justify-between gap-4 px-6 py-5 text-left text-base font-black text-slate-950">
                        <span>Which payment methods are supported?</span>
                        <i class="fa-solid fa-chevron-down text-amber-600 transition"></i>
                    </button>
                    <div class="faq-panel hidden px-6 pb-5 text-sm leading-7 text-slate-600">The system supports cash and digital payment flows such as eSewa and Khalti based on the configured checkout options.</div>
                </div>

                <div class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-900/5">
                    <button type="button" class="faq-toggle flex w-full items-center justify-between gap-4 px-6 py-5 text-left text-base font-black text-slate-950">
                        <span>Can I cancel my reservation?</span>
                        <i class="fa-solid fa-chevron-down text-amber-600 transition"></i>
                    </button>
                    <div class="faq-panel hidden px-6 pb-5 text-sm leading-7 text-slate-600">Yes, reservations can be cancelled before the scheduled time. Contact the restaurant if you need urgent assistance.</div>
                </div>
            </div>
        </div>
    </section>

    <section class="bg-white px-4 py-20 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-7xl overflow-hidden rounded-3xl bg-gradient-to-r from-slate-950 via-amber-950 to-slate-900 px-6 py-14 text-center shadow-xl shadow-slate-900/20 sm:px-10">
            <span class="text-sm font-black uppercase tracking-[0.28em] text-amber-300">Fresh Food Awaits</span>
            <h2 class="mx-auto mt-4 max-w-3xl text-3xl font-black tracking-tight text-white sm:text-5xl">Ready to enjoy authentic Himalayan flavors?</h2>
            <div class="mt-8 flex flex-col justify-center gap-4 sm:flex-row">
                <a href="${pageContext.request.contextPath}/menu" class="inline-flex items-center justify-center gap-3 rounded-2xl bg-gradient-to-r from-amber-300 to-orange-500 px-8 py-4 text-sm font-black uppercase tracking-wide text-slate-950 shadow-xl shadow-amber-500/25 transition hover:-translate-y-1 hover:brightness-105">
                    <i class="fa-solid fa-utensils"></i>
                    Order Now
                </a>
                <a href="${pageContext.request.contextPath}/customer/reservations.jsp" class="inline-flex items-center justify-center gap-3 rounded-2xl border border-white/20 bg-white/10 px-8 py-4 text-sm font-black uppercase tracking-wide text-white shadow-xl backdrop-blur transition hover:-translate-y-1 hover:bg-white/20">
                    <i class="fa-solid fa-calendar-check"></i>
                    Book Table
                </a>
            </div>
        </div>
    </section>
</main>

<script>
document.querySelectorAll('.faq-toggle').forEach((button) => {
    button.addEventListener('click', () => {
        const panel = button.nextElementSibling;
        const icon = button.querySelector('i');
        panel.classList.toggle('hidden');
        icon.classList.toggle('rotate-180');
    });
});
</script>

<%@ include file="../includes/footer.jsp" %>
</body>
</html>
