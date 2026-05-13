<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Payment QR Settings | Himalayan Yaks</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-950 text-slate-100">
<c:set var="adminName" value="${not empty sessionScope.adminFullName ? sessionScope.adminFullName : 'Administrator'}" />
<c:set var="qrVersion" value="<%= String.valueOf(System.currentTimeMillis()) %>" />

<div class="min-h-screen bg-[radial-gradient(circle_at_top,_rgba(79,70,229,0.18),_transparent_30%),linear-gradient(180deg,#020617_0%,#0f172a_45%,#020617_100%)]">
    <div class="flex min-h-screen">
        <aside id="adminSidebar" class="fixed inset-y-0 left-0 z-40 w-72 -translate-x-full border-r border-white/10 bg-slate-950/95 px-5 py-6 backdrop-blur-xl transition-transform duration-300 lg:translate-x-0">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <span class="flex h-12 w-12 items-center justify-center overflow-hidden rounded-2xl bg-white shadow-lg shadow-indigo-500/20">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" class="h-full w-full object-cover" />
                    </span>
                    <div>
                        <p class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-500">Admin Console</p>
                        <h1 class="text-lg font-bold text-white">Himalayan Yaks</h1>
                    </div>
                </div>
                <button id="sidebarClose" type="button" class="rounded-xl border border-white/10 bg-white/5 p-2 text-slate-200 lg:hidden" aria-label="Close sidebar">
                    <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="mt-8 rounded-3xl border border-white/10 bg-white/5 p-4">
                <p class="text-xs uppercase tracking-[0.28em] text-slate-500">Signed in as</p>
                <p class="mt-2 text-lg font-bold text-white">${adminName}</p>
                <p class="mt-1 truncate text-sm text-slate-400">${sessionScope.adminEmail}</p>
            </div>

            <nav class="mt-8 space-y-2 text-sm font-medium">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/manage-menu" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Manage Menu</a>
                <a href="${pageContext.request.contextPath}/admin/categories" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Categories</a>
                <a href="${pageContext.request.contextPath}/admin/manage-orders" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Manage Orders</a>
                <a href="${pageContext.request.contextPath}/admin/payment-confirmation" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Payment Confirmation</a>
                <a href="${pageContext.request.contextPath}/admin/manage-reservations" class="flex items-center justify-between rounded-2xl px-4 py-3 text-slate-300 transition hover:bg-white/5 hover:text-white">Reservations</a>
                <a href="${pageContext.request.contextPath}/admin/payment-settings.jsp" class="flex items-center justify-between rounded-2xl bg-indigo-500/15 px-4 py-3 text-indigo-200 ring-1 ring-indigo-400/25 transition hover:bg-indigo-500/20">
                    <span>Payment Settings</span>
                    <span class="text-xs uppercase tracking-[0.24em]">Active</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="flex items-center justify-between rounded-2xl px-4 py-3 text-rose-300 transition hover:bg-rose-500/10 hover:text-rose-200">Logout</a>
            </nav>
        </aside>

        <div class="flex min-h-screen flex-1 flex-col lg:pl-72">
            <header class="sticky top-0 z-30 border-b border-white/10 bg-slate-950/85 backdrop-blur-xl">
                <div class="flex items-center gap-4 px-4 py-4 sm:px-6 lg:px-8">
                    <button id="sidebarOpen" type="button" class="inline-flex items-center justify-center rounded-2xl border border-white/10 bg-white/5 p-2 text-slate-200 transition hover:bg-white/10 lg:hidden" aria-label="Open sidebar">
                        <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.75" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>

                    <div class="min-w-0 flex-1">
                        <p class="text-xs font-semibold uppercase tracking-[0.3em] text-slate-500">Payment settings</p>
                        <h2 class="truncate text-2xl font-black tracking-tight text-white">Restaurant wallet QR images</h2>
                    </div>

                    <div class="hidden items-center gap-3 rounded-2xl border border-white/10 bg-white/5 px-4 py-2 shadow-lg shadow-slate-950/20 sm:flex">
                        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-500 to-cyan-400 font-bold text-white">AD</div>
                        <div>
                            <p class="text-sm font-semibold text-white">${adminName}</p>
                            <p class="text-xs text-slate-400">Administrator</p>
                        </div>
                    </div>
                </div>
            </header>

            <main class="flex-1 px-4 py-6 sm:px-6 lg:px-8 lg:py-8">
                <div class="mb-6 rounded-3xl border border-cyan-400/20 bg-cyan-400/10 p-5 text-cyan-100">
                    <p class="text-sm leading-6">
                        Uploads are saved with fixed filenames in <span class="font-semibold text-white">/uploads/payments/</span>.
                        Replacing an image updates the QR shown on customer checkout for that wallet.
                    </p>
                </div>

                <section class="grid gap-6 xl:grid-cols-2">
                    <article class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex flex-col gap-5 sm:flex-row sm:items-start sm:justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-emerald-300">eSewa</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Upload eSewa QR</h3>
                                <p class="mt-2 text-sm text-slate-400">Saved as esewa-qr.png and displayed when customers select eSewa.</p>
                            </div>
                            <span class="rounded-full border border-emerald-400/25 bg-emerald-400/10 px-3 py-1 text-xs font-semibold text-emerald-200">esewa-qr.png</span>
                        </div>

                        <div class="mt-6 rounded-3xl border border-white/10 bg-slate-950/60 p-4">
                            <div class="flex min-h-72 items-center justify-center rounded-2xl border border-dashed border-white/10 bg-white/[0.03] p-4">
                                <img
                                    src="${pageContext.request.contextPath}/uploads/payments/esewa-qr.png?v=${qrVersion}"
                                    alt="Current eSewa QR"
                                    class="max-h-64 w-auto rounded-2xl bg-white p-3 shadow-lg shadow-slate-950/30"
                                    onerror="this.classList.add('hidden'); this.nextElementSibling.classList.remove('hidden');"
                                />
                                <div class="hidden text-center">
                                    <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl border border-white/10 bg-white/5 text-2xl font-bold text-slate-400">QR</div>
                                    <p class="mt-3 text-sm font-semibold text-slate-300">No eSewa QR uploaded yet</p>
                                    <p class="mt-1 text-xs text-slate-500">Upload a PNG image to create the checkout preview.</p>
                                </div>
                            </div>
                        </div>

                        <form class="mt-6 space-y-4" method="post" action="${pageContext.request.contextPath}/admin/upload-payment-qr" enctype="multipart/form-data">
                            <input type="hidden" name="paymentType" value="esewa" />
                            <div>
                                <label for="esewaQr" class="block text-sm font-semibold text-slate-200">Choose eSewa QR image</label>
                                <input id="esewaQr" name="qrImage" type="file" accept="image/png,image/jpeg,image/jpg,image/webp" required class="mt-2 block w-full rounded-2xl border border-white/10 bg-slate-950/70 px-4 py-3 text-sm text-slate-200 file:mr-4 file:rounded-xl file:border-0 file:bg-emerald-500 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-white hover:file:bg-emerald-400 focus:border-emerald-400/70 focus:outline-none" />
                            </div>
                            <button type="submit" class="inline-flex w-full items-center justify-center rounded-2xl bg-emerald-500 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-emerald-950/30 transition hover:bg-emerald-400 sm:w-auto">
                                Upload / Replace eSewa QR
                            </button>
                        </form>
                    </article>

                    <article class="rounded-[1.75rem] border border-white/10 bg-slate-900/80 p-6 shadow-xl shadow-slate-950/30">
                        <div class="flex flex-col gap-5 sm:flex-row sm:items-start sm:justify-between">
                            <div>
                                <p class="text-xs font-semibold uppercase tracking-[0.28em] text-violet-300">Khalti</p>
                                <h3 class="mt-2 text-xl font-bold text-white">Upload Khalti QR</h3>
                                <p class="mt-2 text-sm text-slate-400">Saved as khalti-qr.png and displayed when customers select Khalti.</p>
                            </div>
                            <span class="rounded-full border border-violet-400/25 bg-violet-400/10 px-3 py-1 text-xs font-semibold text-violet-200">khalti-qr.png</span>
                        </div>

                        <div class="mt-6 rounded-3xl border border-white/10 bg-slate-950/60 p-4">
                            <div class="flex min-h-72 items-center justify-center rounded-2xl border border-dashed border-white/10 bg-white/[0.03] p-4">
                                <img
                                    src="${pageContext.request.contextPath}/uploads/payments/khalti-qr.png?v=${qrVersion}"
                                    alt="Current Khalti QR"
                                    class="max-h-64 w-auto rounded-2xl bg-white p-3 shadow-lg shadow-slate-950/30"
                                    onerror="this.classList.add('hidden'); this.nextElementSibling.classList.remove('hidden');"
                                />
                                <div class="hidden text-center">
                                    <div class="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl border border-white/10 bg-white/5 text-2xl font-bold text-slate-400">QR</div>
                                    <p class="mt-3 text-sm font-semibold text-slate-300">No Khalti QR uploaded yet</p>
                                    <p class="mt-1 text-xs text-slate-500">Upload a PNG image to create the checkout preview.</p>
                                </div>
                            </div>
                        </div>

                        <form class="mt-6 space-y-4" method="post" action="${pageContext.request.contextPath}/admin/upload-payment-qr" enctype="multipart/form-data">
                            <input type="hidden" name="paymentType" value="khalti" />
                            <div>
                                <label for="khaltiQr" class="block text-sm font-semibold text-slate-200">Choose Khalti QR image</label>
                                <input id="khaltiQr" name="qrImage" type="file" accept="image/png,image/jpeg,image/jpg,image/webp" required class="mt-2 block w-full rounded-2xl border border-white/10 bg-slate-950/70 px-4 py-3 text-sm text-slate-200 file:mr-4 file:rounded-xl file:border-0 file:bg-violet-500 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-white hover:file:bg-violet-400 focus:border-violet-400/70 focus:outline-none" />
                            </div>
                            <button type="submit" class="inline-flex w-full items-center justify-center rounded-2xl bg-violet-500 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-violet-950/30 transition hover:bg-violet-400 sm:w-auto">
                                Upload / Replace Khalti QR
                            </button>
                        </form>
                    </article>
                </section>
            </main>
        </div>
    </div>
</div>

<script>
(() => {
    const sidebar = document.getElementById('adminSidebar');
    const openBtn = document.getElementById('sidebarOpen');
    const closeBtn = document.getElementById('sidebarClose');

    openBtn?.addEventListener('click', () => sidebar?.classList.remove('-translate-x-full'));
    closeBtn?.addEventListener('click', () => sidebar?.classList.add('-translate-x-full'));
})();
</script>
</body>
</html>
