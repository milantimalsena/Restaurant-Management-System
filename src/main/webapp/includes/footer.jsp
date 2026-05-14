<script src="https://cdn.tailwindcss.com"></script>

<footer class="mt-12 border-t border-slate-200 bg-gradient-to-b from-slate-50 to-white">
    <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div class="grid gap-10 md:grid-cols-2 lg:grid-cols-[1.4fr_0.8fr_1fr_1fr]">
            <div>
                <a href="${pageContext.request.contextPath}/public/home.jsp" class="inline-flex items-center gap-3 no-underline">
                    <span class="flex h-14 w-14 items-center justify-center overflow-hidden rounded-2xl bg-white shadow-xl ring-1 ring-slate-200">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" class="h-full w-full object-cover" />
                    </span>
                    <span>
                        <span class="block text-xs font-black uppercase tracking-[0.28em] text-amber-600">Himalayan Yaks</span>
                        <span class="block text-xl font-black text-slate-950">Taste of Himalayas</span>
                    </span>
                </a>
                <p class="mt-5 max-w-sm text-sm leading-7 text-slate-600">
                    Taste of Himalayas through fresh food, warm service, simple online ordering, and reliable reservations.
                </p>
            </div>

            <div>
                <h3 class="text-sm font-black uppercase tracking-[0.2em] text-slate-950">Quick Links</h3>
                <ul class="mt-5 grid gap-3 text-sm font-semibold">
                    <li><a class="text-slate-600 no-underline transition hover:text-amber-600" href="${pageContext.request.contextPath}/public/home.jsp">Home</a></li>
                    <li><a class="text-slate-600 no-underline transition hover:text-amber-600" href="${pageContext.request.contextPath}/menu">Menu</a></li>
                    <li><a class="text-slate-600 no-underline transition hover:text-amber-600" href="${pageContext.request.contextPath}/public/about.jsp">About</a></li>
                    <li><a class="text-slate-600 no-underline transition hover:text-amber-600" href="${pageContext.request.contextPath}/public/contact.jsp">Contact</a></li>
                </ul>
            </div>

            <div>
                <h3 class="text-sm font-black uppercase tracking-[0.2em] text-slate-950">Contact</h3>
                <div class="mt-5 grid gap-3 text-sm text-slate-600">
                    <div class="flex gap-3">
                        <span class="mt-0.5 text-amber-600">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 21s7-4.6 7-11a7 7 0 1 0-14 0c0 6.4 7 11 7 11Z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M12 10.5h.01"/></svg>
                        </span>
                        <span>Itahari, Nepal</span>
                    </div>
                    <div class="flex gap-3">
                        <span class="mt-0.5 text-amber-600">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M4 6h16v12H4z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="m4 7 8 6 8-6"/></svg>
                        </span>
                        <span>info@himalayanyaks.com</span>
                    </div>
                    <div class="flex gap-3">
                        <span class="mt-0.5 text-amber-600">
                            <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.8" d="M6.6 3.8 9 3l2 4-1.5 1.2a11 11 0 0 0 5.3 5.3L16 12l4 2-.8 2.4c-.4 1.1-1.5 1.8-2.7 1.6C10.8 17.2 6.8 13.2 6 7.5c-.2-1.2.5-2.3 1.6-2.7Z"/></svg>
                        </span>
                        <span>+977 9800000000</span>
                    </div>
                </div>
            </div>

            <div>
                <h3 class="text-sm font-black uppercase tracking-[0.2em] text-slate-950">Follow Us</h3>
                <div class="mt-5 flex gap-3">
                    <a href="#" aria-label="Facebook" class="flex h-11 w-11 items-center justify-center rounded-full border border-slate-200 bg-white text-sm font-black text-slate-700 no-underline shadow-sm transition hover:-translate-y-1 hover:bg-slate-950 hover:text-white">f</a>
                    <a href="#" aria-label="Instagram" class="flex h-11 w-11 items-center justify-center rounded-full border border-slate-200 bg-white text-sm font-black text-slate-700 no-underline shadow-sm transition hover:-translate-y-1 hover:bg-slate-950 hover:text-white">ig</a>
                    <a href="#" aria-label="Twitter" class="flex h-11 w-11 items-center justify-center rounded-full border border-slate-200 bg-white text-sm font-black text-slate-700 no-underline shadow-sm transition hover:-translate-y-1 hover:bg-slate-950 hover:text-white">x</a>
                    <a href="#" aria-label="YouTube" class="flex h-11 w-11 items-center justify-center rounded-full border border-slate-200 bg-white text-sm font-black text-slate-700 no-underline shadow-sm transition hover:-translate-y-1 hover:bg-slate-950 hover:text-white">yt</a>
                </div>
                <p class="mt-5 text-sm leading-7 text-slate-600">Secure payments, fast pickup, and customer-first ordering.</p>
            </div>
        </div>

        <div class="mt-10 border-t border-slate-200 pt-6 text-sm font-semibold text-slate-500">
            &copy; 2026 Himalayan Yaks. All rights reserved.
        </div>
    </div>
</footer>
