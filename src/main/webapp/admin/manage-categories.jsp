<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Category" %>
<%
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Manage Categories | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-body-tertiary">
<div class="container py-4 py-lg-5">
    <div class="row g-4">
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-3">Add Category</h4>
                    <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                        <div class="mb-3">
                            <label class="form-label">Category Name</label>
                            <input type="text" name="categoryName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" name="isActive" id="isActive" checked>
                            <label class="form-check-label" for="isActive">Active</label>
                        </div>
                        <button class="btn btn-primary">Save Category</button>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h4 class="fw-bold mb-3">Categories</h4>
                    <div class="table-responsive">
                        <table class="table table-striped align-middle">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (categories != null) {
                                for (Category c : categories) { %>
                            <tr>
                                <td><%= c.getCategoryId() %></td>
                                <td><%= c.getCategoryName() %></td>
                                <td><%= c.getDescription() %></td>
                                <td><span class="badge <%= c.isActive() ? "text-bg-success" : "text-bg-secondary" %>"><%= c.isActive() ? "Active" : "Inactive" %></span></td>
                            </tr>
                            <% }} %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
