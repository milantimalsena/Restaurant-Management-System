<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Category" %>
<%@ page import="com.restaurant.model.MenuItem" %>
<%
    List<MenuItem> items = (List<MenuItem>) request.getAttribute("items");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String searchQuery = (String) request.getAttribute("searchQuery");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Menu | Admin</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
    <style>
        .sidebar {
            min-height: 100vh;
            background: #111827;
            color: #fff;
        }
        .table img {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-body-tertiary">
<div class="container-fluid">
    <div class="row">
        <aside class="col-lg-2 p-3 sidebar">
            <h5 class="fw-bold">Admin Panel</h5>
            <hr class="border-light">
            <a class="d-block text-decoration-none text-light mb-2" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a>
            <a class="d-block text-decoration-none text-warning mb-2" href="${pageContext.request.contextPath}/admin/manage-menu">Manage Menu</a>
            <a class="d-block text-decoration-none text-light mb-2" href="${pageContext.request.contextPath}/admin/categories">Categories</a>
            <a class="btn btn-outline-light btn-sm mt-3" href="${pageContext.request.contextPath}/logout">Logout</a>
        </aside>

        <main class="col-lg-10 p-4 p-lg-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold mb-0">Menu Management</h3>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/add-menu-item">Add New Item</a>
            </div>

            <form method="get" action="${pageContext.request.contextPath}/admin/manage-menu" class="row g-2 mb-3">
                <div class="col-md-5">
                    <input type="search" name="q" id="tableSearch" class="form-control" value="<%= searchQuery != null ? searchQuery : "" %>" placeholder="Search menu items...">
                </div>
                <div class="col-md-4">
                    <select name="categoryId" class="form-select">
                        <option value="">All Categories</option>
                        <% if (categories != null) {
                            for (Category c : categories) { %>
                            <option value="<%= c.getCategoryId() %>" <%= String.valueOf(c.getCategoryId()).equals(selectedCategoryId) ? "selected" : "" %>><%= c.getCategoryName() %></option>
                        <% }} %>
                    </select>
                </div>
                <div class="col-md-3 d-grid">
                    <button type="submit" class="btn btn-dark">Apply Filter</button>
                </div>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/admin/manage-menu" class="mb-3">
                <input type="hidden" name="action" value="bulkAvailability">
                <div class="d-flex flex-wrap gap-2">
                    <select name="availability" class="form-select w-auto">
                        <option value="available">Set Available</option>
                        <option value="unavailable">Set Out of Stock</option>
                    </select>
                    <button type="submit" class="btn btn-outline-primary">Apply Bulk Action</button>
                </div>

                <div class="table-responsive mt-3">
                    <table class="table table-hover align-middle bg-white" id="menuTable">
                        <thead class="table-dark">
                        <tr>
                            <th><input type="checkbox" id="checkAll"></th>
                            <th>Image</th>
                            <th>Item</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Featured</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (items != null) {
                            for (MenuItem item : items) { %>
                        <tr>
                            <td><input type="checkbox" name="selectedItemIds" value="<%= item.getItemId() %>"></td>
                            <td><img src="${pageContext.request.contextPath}/<%= item.getImagePath() != null ? item.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" alt="image"></td>
                            <td><%= item.getItemName() %></td>
                            <td><%= item.getCategoryName() %></td>
                            <td>NPR <span class="money" data-price="<%= item.getPrice() %>"><%= item.getPrice() %></span></td>
                            <td>
                                <span class="badge <%= item.isAvailable() ? "text-bg-success" : "text-bg-secondary" %>">
                                    <%= item.isAvailable() ? "Available" : "Out of Stock" %>
                                </span>
                            </td>
                            <td><span class="badge <%= item.isFeatured() ? "text-bg-warning" : "text-bg-light" %>"><%= item.isFeatured() ? "Yes" : "No" %></span></td>
                            <td>
                                <a class="btn btn-sm btn-outline-dark" href="${pageContext.request.contextPath}/admin/edit-menu-item?id=<%= item.getItemId() %>">Edit</a>
                                <form method="post" action="${pageContext.request.contextPath}/admin/delete-menu-item" class="d-inline" onsubmit="return confirmDelete();">
                                    <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                    <button class="btn btn-sm btn-outline-danger">Delete</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/toggle-availability" class="d-inline">
                                    <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                    <input type="hidden" name="isAvailable" value="<%= item.isAvailable() ? "0" : "1" %>">
                                    <button class="btn btn-sm btn-outline-primary"><%= item.isAvailable() ? "Mark Out" : "Mark In" %></button>
                                </form>
                            </td>
                        </tr>
                        <% }} %>
                        </tbody>
                    </table>
                </div>
            </form>
        </main>
    </div>
</div>

<script>
    function confirmDelete() {
        return confirm('Are you sure you want to delete this menu item?');
    }

    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('input[name="selectedItemIds"]').forEach(cb => cb.checked = this.checked);
    });

    document.querySelectorAll('.money').forEach(el => {
        const value = Number(el.dataset.price || el.textContent || 0);
        el.textContent = new Intl.NumberFormat('en-NP', {minimumFractionDigits: 2, maximumFractionDigits: 2}).format(value);
    });

    const tableSearch = document.getElementById('tableSearch');
    const rows = document.querySelectorAll('#menuTable tbody tr');
    tableSearch?.addEventListener('input', () => {
        const q = tableSearch.value.toLowerCase();
        rows.forEach(row => {
            row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
        });
    });
</script>
</body>
</html>
