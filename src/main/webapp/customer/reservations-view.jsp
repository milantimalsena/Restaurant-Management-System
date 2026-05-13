<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Table Reservations | Smart Restaurant</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'ui-sans-serif', 'system-ui']
                    }
                }
            }
        }
    </script>
</head>
<body class="min-h-screen bg-slate-950 text-slate-100">
<div class="absolute inset-0 -z-10 overflow-hidden">
    <div class="h-full w-full bg-[radial-gradient(circle_at_top_left,rgba(245,158,11,0.18),transparent_34%),radial-gradient(circle_at_bottom_right,rgba(244,63,94,0.16),transparent_32%),linear-gradient(135deg,#020617_0%,#0f172a_55%,#111827_100%)]"></div>
</div>

<nav class="sticky top-0 z-40 border-b border-white/10 bg-slate-950/75 backdrop-blur-xl">
    <div class="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
        <a href="${pageContext.request.contextPath}/public/home.jsp" class="flex items-center gap-3">
            <span class="flex h-10 w-10 items-center justify-center overflow-hidden rounded-2xl bg-white shadow-lg">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Smart Restaurant logo" class="h-full w-full object-cover">
            </span>
            <span class="text-lg font-bold tracking-wide text-white">Smart Restaurant</span>
        </a>
        <div class="hidden items-center gap-7 text-sm font-medium text-slate-300 md:flex">
            <a href="${pageContext.request.contextPath}/menu" class="transition hover:text-amber-400">Menu</a>
            <a href="${pageContext.request.contextPath}/customer/reservations.jsp" class="text-amber-400">Book Table</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user or sessionScope.userRole eq 'CUSTOMER'}">
                    <a href="${pageContext.request.contextPath}/customer/reservations.jsp#history" class="transition hover:text-amber-400">My Reservations</a>
                    <a href="${pageContext.request.contextPath}/logout" class="rounded-full border border-white/15 px-4 py-2 transition hover:border-rose-400 hover:text-rose-300">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="transition hover:text-amber-400">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="rounded-full bg-amber-500 px-4 py-2 font-bold text-slate-950 shadow-lg shadow-amber-500/25 transition hover:scale-105 hover:bg-amber-400">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="flex items-center gap-3 md:hidden">
            <c:choose>
                <c:when test="${not empty sessionScope.user or sessionScope.userRole eq 'CUSTOMER'}">
                    <a href="${pageContext.request.contextPath}/logout" class="rounded-full border border-white/15 px-3 py-2 text-sm font-semibold text-slate-200">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="rounded-full bg-amber-500 px-3 py-2 text-sm font-bold text-slate-950">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 lg:py-12">
    <section class="grid gap-8 lg:grid-cols-[1.05fr_0.95fr] lg:items-start">
        <div class="rounded-2xl border border-white/15 bg-white/10 p-5 shadow-xl shadow-black/25 backdrop-blur-2xl sm:p-8">
            <div class="mb-7">
                <p class="text-sm font-semibold uppercase tracking-[0.2em] text-amber-300">Reserve your table</p>
                <h1 class="mt-3 text-3xl font-black text-white sm:text-4xl">Plan a seamless dining experience.</h1>
                <p class="mt-3 max-w-2xl text-sm leading-6 text-slate-300 sm:text-base">Choose your preferred date, time, guest count, and table. Our team will confirm your booking after review.</p>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="mb-5 rounded-2xl border border-emerald-400/40 bg-emerald-500/15 px-4 py-3 text-sm font-semibold text-emerald-100 shadow-lg">
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="mb-5 rounded-2xl border border-rose-400/40 bg-rose-500/15 px-4 py-3 text-sm font-semibold text-rose-100 shadow-lg">
                    ${errorMessage}
                </div>
            </c:if>
            <c:if test="${fullyBooked}">
                <div class="mb-5 rounded-2xl border border-amber-400/40 bg-amber-500/15 px-4 py-3 text-sm font-semibold text-amber-100 shadow-lg">
                    All tables are fully booked for the selected slot. Please choose another time.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/customer/reservations" method="post" class="grid gap-5 sm:grid-cols-2">
                <div>
                    <label for="fullName" class="mb-2 block text-sm font-semibold text-slate-200">Full Name</label>
                    <input id="fullName" name="fullName" type="text" value="${not empty reservation.fullName ? reservation.fullName : sessionScope.userFullName}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition placeholder:text-slate-500 focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20" placeholder="Your name">
                </div>
                <div>
                    <label for="phone" class="mb-2 block text-sm font-semibold text-slate-200">Phone Number</label>
                    <input id="phone" name="phone" type="tel" value="${reservation.phone}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition placeholder:text-slate-500 focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20" placeholder="98XXXXXXXX">
                </div>
                <div>
                    <label for="email" class="mb-2 block text-sm font-semibold text-slate-200">Email</label>
                    <input id="email" name="email" type="email" value="${not empty reservation.email ? reservation.email : sessionScope.userEmail}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition placeholder:text-slate-500 focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20" placeholder="you@example.com">
                </div>
                <div>
                    <label for="reservationDate" class="mb-2 block text-sm font-semibold text-slate-200">Reservation Date</label>
                    <input id="reservationDate" name="reservationDate" type="date" value="${reservation.reservationDate}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20">
                </div>
                <div>
                    <label for="reservationTime" class="mb-2 block text-sm font-semibold text-slate-200">Reservation Time</label>
                    <input id="reservationTime" name="reservationTime" type="time" value="${reservation.reservationTime}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20">
                </div>
                <div>
                    <label for="guests" class="mb-2 block text-sm font-semibold text-slate-200">Number of Guests</label>
                    <input id="guests" name="guests" type="number" min="1" max="40" value="${reservation.guests}" required class="w-full rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition placeholder:text-slate-500 focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20" placeholder="4">
                </div>
                <div class="sm:col-span-2">
                    <label for="tableId" class="mb-2 block text-sm font-semibold text-slate-200">Table Selection</label>
                    <select id="tableId" name="tableId" required class="w-full rounded-2xl border border-white/10 bg-slate-900 px-4 py-3 text-white outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20">
                        <option value="">Select an available table</option>
                        <c:forEach var="table" items="${availableTables}">
                            <option value="${table.id}" ${table.id == reservation.tableId ? 'selected="selected"' : ''}>
                                Table ${table.tableNumber} - ${table.capacity} guests - ${table.status}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="sm:col-span-2">
                    <label for="specialRequest" class="mb-2 block text-sm font-semibold text-slate-200">Special Request</label>
                    <textarea id="specialRequest" name="specialRequest" rows="4" class="w-full resize-none rounded-2xl border border-white/10 bg-white/10 px-4 py-3 text-white outline-none transition placeholder:text-slate-500 focus:border-amber-400 focus:ring-4 focus:ring-amber-500/20" placeholder="Birthday setup, window seat, allergies, accessibility needs...">${reservation.specialRequest}</textarea>
                </div>
                <div class="sm:col-span-2">
                    <button type="submit" class="w-full rounded-2xl bg-amber-500 px-6 py-4 text-base font-black text-slate-950 shadow-xl shadow-amber-500/25 transition hover:scale-[1.01] hover:bg-amber-400 focus:outline-none focus:ring-4 focus:ring-amber-500/30">
                        Confirm Reservation Request
                    </button>
                </div>
            </form>
        </div>

        <aside class="space-y-6">
            <div class="rounded-2xl border border-white/15 bg-white/10 p-5 shadow-xl shadow-black/25 backdrop-blur-2xl sm:p-6">
                <div class="mb-5 flex items-center justify-between gap-4">
                    <div>
                        <p class="text-sm font-semibold uppercase tracking-[0.18em] text-rose-300">Dining floor</p>
                        <h2 class="mt-2 text-2xl font-black text-white">Available Tables</h2>
                    </div>
                    <span class="rounded-full bg-amber-500/15 px-3 py-1 text-xs font-bold text-amber-200">Live floor</span>
                </div>
                <c:choose>
                    <c:when test="${empty availableTables}">
                        <div class="rounded-2xl border border-amber-400/30 bg-amber-500/10 p-5 text-sm font-semibold text-amber-100">
                            No table availability found for this slot.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-1 xl:grid-cols-2">
                            <c:forEach var="table" items="${availableTables}">
                                <div class="rounded-2xl border border-white/10 bg-slate-950/45 p-4 shadow-lg transition hover:scale-[1.02] hover:border-amber-400/60 hover:bg-slate-900/80">
                                    <div class="flex items-start justify-between gap-3">
                                        <div>
                                            <p class="text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">Table</p>
                                            <h3 class="mt-1 text-2xl font-black text-white">No. ${table.tableNumber}</h3>
                                        </div>
                                        <c:choose>
                                            <c:when test="${table.status == 'Available'}">
                                                <span class="rounded-full bg-emerald-500/15 px-3 py-1 text-xs font-bold text-emerald-200">Available</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="rounded-full bg-rose-500/15 px-3 py-1 text-xs font-bold text-rose-200">Reserved</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mt-5 rounded-2xl bg-white/5 p-3">
                                        <p class="text-sm text-slate-400">Capacity</p>
                                        <p class="mt-1 text-lg font-bold text-slate-100">${table.capacity} guests</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </aside>
    </section>

    <section id="history" class="mt-10 rounded-2xl border border-white/15 bg-white/10 p-5 shadow-xl shadow-black/25 backdrop-blur-2xl sm:p-8">
        <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
            <div>
                <p class="text-sm font-semibold uppercase tracking-[0.18em] text-amber-300">Your bookings</p>
                <h2 class="mt-2 text-2xl font-black text-white sm:text-3xl">Reservation History</h2>
            </div>
            <span class="rounded-full border border-white/15 px-4 py-2 text-sm font-semibold text-slate-300">Latest activity</span>
        </div>
        <c:choose>
            <c:when test="${empty reservationHistory}">
                <div class="rounded-2xl border border-white/10 bg-slate-950/45 p-6 text-center text-slate-300">
                    You have no reservation history yet.
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                    <c:forEach var="booking" items="${reservationHistory}">
                        <article class="rounded-2xl border border-white/10 bg-slate-950/45 p-5 shadow-lg transition hover:scale-[1.02] hover:border-amber-400/50">
                            <div class="flex items-start justify-between gap-3">
                                <div>
                                    <p class="text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">Booking ID</p>
                                    <h3 class="mt-1 text-xl font-black text-white">#${booking.bookingId}</h3>
                                </div>
                                <c:choose>
                                    <c:when test="${booking.status == 'Pending'}">
                                        <span class="rounded-full bg-amber-500/15 px-3 py-1 text-xs font-bold text-amber-200">Pending</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'Approved'}">
                                        <span class="rounded-full bg-emerald-500/15 px-3 py-1 text-xs font-bold text-emerald-200">Approved</span>
                                    </c:when>
                                    <c:when test="${booking.status == 'Rejected'}">
                                        <span class="rounded-full bg-rose-500/15 px-3 py-1 text-xs font-bold text-rose-200">Rejected</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="rounded-full bg-slate-500/20 px-3 py-1 text-xs font-bold text-slate-200">Completed</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <dl class="mt-5 space-y-3 text-sm">
                                <div class="flex justify-between gap-4">
                                    <dt class="text-slate-400">Date</dt>
                                    <dd class="font-semibold text-slate-100">${booking.reservationDate}</dd>
                                </div>
                                <div class="flex justify-between gap-4">
                                    <dt class="text-slate-400">Time</dt>
                                    <dd class="font-semibold text-slate-100">${booking.reservationTime}</dd>
                                </div>
                                <div class="flex justify-between gap-4">
                                    <dt class="text-slate-400">Guests</dt>
                                    <dd class="font-semibold text-slate-100">${booking.guests}</dd>
                                </div>
                            </dl>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<footer class="border-t border-white/10 bg-slate-950/75 py-6 text-center text-sm text-slate-400">
    <p>&copy; 2026 Smart Restaurant Management System. All rights reserved.</p>
</footer>
</body>
</html>
