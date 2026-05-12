<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Reservations | Admin</title>
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
<body class="min-h-screen bg-slate-100 text-slate-900">
<div class="flex min-h-screen">
    <aside class="hidden w-72 shrink-0 border-r border-slate-200 bg-slate-900 text-white lg:flex lg:flex-col">
        <div class="border-b border-white/10 px-6 py-6">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="flex items-center gap-3">
                <span class="flex h-11 w-11 items-center justify-center rounded-2xl bg-amber-500 text-lg font-black text-slate-950 shadow-lg shadow-amber-500/25">SR</span>
                <span>
                    <span class="block text-lg font-black">Smart Restaurant</span>
                    <span class="block text-xs font-semibold uppercase tracking-[0.18em] text-slate-400">Admin Panel</span>
                </span>
            </a>
        </div>
        <nav class="flex-1 space-y-2 px-4 py-6 text-sm font-semibold text-slate-300">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="flex items-center justify-between rounded-2xl px-4 py-3 transition hover:bg-white/10 hover:text-white">
                <span>Dashboard</span>
                <span class="h-2 w-2 rounded-full bg-slate-600"></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage-menu.jsp" class="flex items-center justify-between rounded-2xl px-4 py-3 transition hover:bg-white/10 hover:text-white">
                <span>Menu Items</span>
                <span class="h-2 w-2 rounded-full bg-slate-600"></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage-reservations" class="flex items-center justify-between rounded-2xl bg-amber-500 px-4 py-3 text-slate-950 shadow-xl shadow-amber-500/25">
                <span>Reservations</span>
                <span class="h-2 w-2 rounded-full bg-slate-950"></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manage-orders.jsp" class="flex items-center justify-between rounded-2xl px-4 py-3 transition hover:bg-white/10 hover:text-white">
                <span>Orders</span>
                <span class="h-2 w-2 rounded-full bg-slate-600"></span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports.jsp" class="flex items-center justify-between rounded-2xl px-4 py-3 transition hover:bg-white/10 hover:text-white">
                <span>Reports</span>
                <span class="h-2 w-2 rounded-full bg-slate-600"></span>
            </a>
        </nav>
        <div class="border-t border-white/10 p-4">
            <a href="${pageContext.request.contextPath}/logout" class="block rounded-2xl border border-white/10 px-4 py-3 text-center text-sm font-bold text-slate-200 transition hover:border-rose-400 hover:text-rose-300">Logout</a>
        </div>
    </aside>

    <div class="min-w-0 flex-1">
        <header class="sticky top-0 z-30 border-b border-slate-200 bg-white/85 backdrop-blur-xl">
            <div class="flex items-center justify-between gap-4 px-4 py-4 sm:px-6 lg:px-8">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-amber-600">Reservation Management</p>
                    <h1 class="mt-1 text-2xl font-black text-slate-950 sm:text-3xl">Manage Reservations</h1>
                </div>
                <div class="flex items-center gap-3">
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-sm font-bold text-slate-700 shadow-sm transition hover:scale-105 hover:border-amber-300 hover:text-amber-700 lg:hidden">Admin</a>
                    <a href="${pageContext.request.contextPath}/logout" class="rounded-2xl bg-slate-900 px-4 py-2 text-sm font-bold text-white shadow-lg transition hover:scale-105 hover:bg-rose-500">Logout</a>
                </div>
            </div>
        </header>

        <main class="px-4 py-6 sm:px-6 lg:px-8">
            <c:if test="${not empty successMessage}">
                <div class="mb-6 rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-700 shadow-sm">
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="mb-6 rounded-2xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-700 shadow-sm">
                    ${errorMessage}
                </div>
            </c:if>

            <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
                <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-200/70 transition hover:scale-[1.01] hover:shadow-2xl">
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <p class="text-sm font-bold text-slate-500">Total Reservations</p>
                            <h2 class="mt-3 text-4xl font-black text-slate-950">${totalReservations}</h2>
                        </div>
                        <span class="rounded-2xl bg-amber-500/15 px-3 py-2 text-sm font-black text-amber-700">All</span>
                    </div>
                    <p class="mt-5 text-sm text-slate-500">All customer booking requests in the system.</p>
                </article>
                <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-200/70 transition hover:scale-[1.01] hover:shadow-2xl">
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <p class="text-sm font-bold text-slate-500">Pending Bookings</p>
                            <h2 class="mt-3 text-4xl font-black text-slate-950">${pendingBookings}</h2>
                        </div>
                        <span class="rounded-2xl bg-rose-500/15 px-3 py-2 text-sm font-black text-rose-700">Queue</span>
                    </div>
                    <p class="mt-5 text-sm text-slate-500">Requests waiting for admin approval.</p>
                </article>
                <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-xl shadow-slate-200/70 transition hover:scale-[1.01] hover:shadow-2xl sm:col-span-2 xl:col-span-1">
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <p class="text-sm font-bold text-slate-500">Approved Today</p>
                            <h2 class="mt-3 text-4xl font-black text-slate-950">${approvedToday}</h2>
                        </div>
                        <span class="rounded-2xl bg-emerald-500/15 px-3 py-2 text-sm font-black text-emerald-700">Today</span>
                    </div>
                    <p class="mt-5 text-sm text-slate-500">Confirmed reservations scheduled or approved today.</p>
                </article>
            </section>

            <section class="mt-6 grid gap-6 xl:grid-cols-[0.85fr_1.15fr]">
                <div class="rounded-2xl border border-slate-200 bg-white p-5 shadow-xl shadow-slate-200/70">
                    <div class="mb-5">
                        <p class="text-sm font-bold uppercase tracking-[0.18em] text-amber-600">Dining floor</p>
                        <h2 class="mt-1 text-xl font-black text-slate-950">Manage Tables</h2>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/manage-reservations" method="post" class="grid gap-3 sm:grid-cols-[1fr_120px_auto]">
                        <input type="hidden" name="action" value="addTable">
                        <input type="text" name="tableNumber" required placeholder="Table No. e.g. T01" class="rounded-2xl border border-slate-200 px-4 py-3 text-sm font-semibold outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-100">
                        <input type="number" name="capacity" min="1" max="30" required placeholder="Seats" class="rounded-2xl border border-slate-200 px-4 py-3 text-sm font-semibold outline-none transition focus:border-amber-400 focus:ring-4 focus:ring-amber-100">
                        <button type="submit" class="rounded-2xl bg-amber-500 px-5 py-3 text-sm font-black text-slate-950 shadow-lg shadow-amber-200 transition hover:scale-105 hover:bg-amber-400">Add Table</button>
                    </form>

                    <div class="mt-5 space-y-3">
                        <c:choose>
                            <c:when test="${empty tableList}">
                                <div class="rounded-2xl border border-dashed border-slate-300 p-5 text-center text-sm font-semibold text-slate-500">
                                    No restaurant tables added yet.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="table" items="${tableList}">
                                    <div class="flex flex-col gap-3 rounded-2xl border border-slate-200 bg-slate-50 p-4 sm:flex-row sm:items-center sm:justify-between">
                                        <div>
                                            <p class="font-black text-slate-950">Table ${table.tableNumber}</p>
                                            <p class="text-sm font-semibold text-slate-500">${table.capacity} seats • ${table.active ? 'Active' : 'Inactive'}</p>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/admin/manage-reservations" method="post">
                                            <input type="hidden" name="action" value="toggleTable">
                                            <input type="hidden" name="tableId" value="${table.tableId}">
                                            <input type="hidden" name="active" value="${!table.active}">
                                            <button type="submit" class="rounded-2xl border border-slate-200 bg-white px-4 py-2 text-xs font-black text-slate-700 shadow-sm transition hover:scale-105 hover:border-amber-300">
                                                ${table.active ? 'Deactivate' : 'Activate'}
                                            </button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="rounded-2xl border border-slate-200 bg-white shadow-xl shadow-slate-200/70">
                <div class="flex flex-col gap-3 border-b border-slate-200 px-5 py-5 sm:flex-row sm:items-center sm:justify-between">
                    <div>
                        <p class="text-sm font-bold uppercase tracking-[0.18em] text-amber-600">Booking list</p>
                        <h2 class="mt-1 text-xl font-black text-slate-950">Reservation Table</h2>
                    </div>
                    <span class="rounded-full bg-slate-100 px-4 py-2 text-sm font-bold text-slate-600">Live records</span>
                </div>

                <c:choose>
                    <c:when test="${empty reservationList}">
                        <div class="px-5 py-14 text-center">
                            <p class="text-lg font-black text-slate-900">No reservations found.</p>
                            <p class="mt-2 text-sm text-slate-500">New booking requests will appear here.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                                <thead class="bg-slate-50 text-xs font-black uppercase tracking-wide text-slate-500">
                                <tr>
                                    <th class="whitespace-nowrap px-5 py-4">Customer Name</th>
                                    <th class="whitespace-nowrap px-5 py-4">Phone</th>
                                    <th class="whitespace-nowrap px-5 py-4">Table No</th>
                                    <th class="whitespace-nowrap px-5 py-4">Guests</th>
                                    <th class="whitespace-nowrap px-5 py-4">Date</th>
                                    <th class="whitespace-nowrap px-5 py-4">Time</th>
                                    <th class="whitespace-nowrap px-5 py-4">Status</th>
                                    <th class="whitespace-nowrap px-5 py-4 text-right">Actions</th>
                                </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 bg-white">
                                <c:forEach var="reservation" items="${reservationList}">
                                    <tr class="transition hover:bg-amber-50/70">
                                        <td class="whitespace-nowrap px-5 py-4">
                                            <div class="font-black text-slate-950">${reservation.customerName}</div>
                                            <div class="text-xs font-medium text-slate-500">ID #${reservation.bookingId}</div>
                                        </td>
                                        <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${reservation.phone}</td>
                                        <td class="whitespace-nowrap px-5 py-4 font-bold text-slate-900">${reservation.tableNumber}</td>
                                        <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${reservation.guests}</td>
                                        <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${reservation.reservationDate}</td>
                                        <td class="whitespace-nowrap px-5 py-4 font-semibold text-slate-700">${reservation.reservationTime}</td>
                                        <td class="whitespace-nowrap px-5 py-4">
                                            <c:choose>
                                                <c:when test="${reservation.status == 'Pending'}">
                                                    <span class="rounded-full bg-amber-100 px-3 py-1 text-xs font-black text-amber-700">Pending</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'Approved'}">
                                                    <span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-black text-emerald-700">Approved</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'Rejected'}">
                                                    <span class="rounded-full bg-rose-100 px-3 py-1 text-xs font-black text-rose-700">Rejected</span>
                                                </c:when>
                                                <c:when test="${reservation.status == 'Cancelled'}">
                                                    <span class="rounded-full bg-slate-200 px-3 py-1 text-xs font-black text-slate-700">Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="rounded-full bg-slate-900 px-3 py-1 text-xs font-black text-white">${reservation.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="whitespace-nowrap px-5 py-4">
                                            <div class="flex justify-end gap-2">
                                                <form action="${pageContext.request.contextPath}/admin/manage-reservations" method="post">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="status" value="APPROVED">
                                                    <input type="hidden" name="bookingId" value="${reservation.bookingId}">
                                                    <button type="submit" class="rounded-2xl bg-emerald-500 px-3 py-2 text-xs font-black text-white shadow-sm transition hover:scale-105 hover:bg-emerald-600">Approve</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/manage-reservations" method="post">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="status" value="REJECTED">
                                                    <input type="hidden" name="bookingId" value="${reservation.bookingId}">
                                                    <button type="submit" class="rounded-2xl bg-rose-500 px-3 py-2 text-xs font-black text-white shadow-sm transition hover:scale-105 hover:bg-rose-600">Reject</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/manage-reservations" method="post">
                                                    <input type="hidden" name="action" value="updateStatus">
                                                    <input type="hidden" name="status" value="CANCELLED">
                                                    <input type="hidden" name="bookingId" value="${reservation.bookingId}">
                                                    <button type="submit" class="rounded-2xl border border-slate-200 bg-white px-3 py-2 text-xs font-black text-slate-700 shadow-sm transition hover:scale-105 hover:border-slate-400 hover:bg-slate-50">Cancel</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </section>
        </main>
    </div>
</div>
</body>
</html>
