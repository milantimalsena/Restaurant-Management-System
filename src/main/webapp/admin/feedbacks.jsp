<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedbacks | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 text-slate-900">
<div class="flex min-h-screen">
    <%@ include file="../includes/adminSidebar.jsp" %>

    <main class="min-w-0 flex-1 px-4 py-6 sm:px-6 lg:ml-72 lg:px-8">
        <button id="sidebarOpen" type="button" class="mb-4 inline-flex items-center justify-center rounded-2xl border border-slate-200 bg-white px-4 py-3 text-sm font-black text-slate-700 shadow-sm transition hover:border-amber-300 hover:text-amber-700 lg:hidden">
            Admin Menu
        </button>

        <header class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
            <div>
                <p class="text-xs font-black uppercase tracking-[0.22em] text-amber-600">Customer Voice</p>
                <h1 class="mt-2 text-3xl font-black text-slate-950">Feedbacks</h1>
                <p class="mt-2 max-w-2xl text-sm font-medium leading-7 text-slate-500">Review guest comments, ratings, service notes, and follow-up priorities.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="rounded-2xl bg-slate-950 px-5 py-3 text-sm font-black text-white shadow-lg transition hover:bg-amber-600">Dashboard</a>
        </header>

        <section class="grid gap-5 md:grid-cols-3">
            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Average Rating</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">4.8</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Current customer satisfaction snapshot.</p>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">New Feedback</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">0</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Unread comments awaiting review.</p>
            </article>

            <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
                <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">Resolved</p>
                <h2 class="mt-4 text-4xl font-black text-slate-950">0</h2>
                <p class="mt-3 text-sm leading-6 text-slate-500">Feedback items marked as handled.</p>
            </article>
        </section>

        <section class="mt-6 rounded-3xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-900/5">
            <div class="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-amber-600">Latest Feedback</p>
                    <h2 class="mt-2 text-xl font-black text-slate-950">Guest comments</h2>
                </div>
                <span class="rounded-full bg-slate-100 px-4 py-2 text-xs font-black text-slate-600">No database connected</span>
            </div>

            <div class="mt-6 grid gap-4">
                <article class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                    <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                        <div>
                            <h3 class="text-base font-black text-slate-950">Sample customer feedback</h3>
                            <p class="mt-2 text-sm leading-7 text-slate-600">Feedback records will appear here after the feedback module stores customer messages in the database.</p>
                        </div>
                        <div class="flex text-amber-500">
                            <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
                        </div>
                    </div>
                </article>

                <article class="rounded-2xl border border-dashed border-slate-300 bg-white p-8 text-center">
                    <h3 class="text-lg font-black text-slate-950">No feedback records yet</h3>
                    <p class="mx-auto mt-3 max-w-xl text-sm leading-7 text-slate-500">Once customers submit feedback, connect this page to the feedback DAO and render live records here.</p>
                    <a href="${pageContext.request.contextPath}/customer/feedback.jsp" class="mt-5 inline-flex rounded-2xl bg-amber-500 px-5 py-3 text-sm font-black text-slate-950 no-underline shadow-lg transition hover:bg-amber-400">Open Customer Feedback Page</a>
                </article>
            </div>
        </section>
    </main>
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
