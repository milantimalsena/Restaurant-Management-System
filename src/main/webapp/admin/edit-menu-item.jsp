<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.restaurant.model.Category" %>
<%@ page import="com.restaurant.model.MenuItem" %>
<%
    MenuItem item = (MenuItem) request.getAttribute("item");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Edit Menu Item | Admin</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
</head>
<body class="bg-light">
<div class="container py-4 py-lg-5">
    <div class="card border-0 shadow-sm">
        <div class="card-body p-4 p-lg-5">
            <h3 class="fw-bold mb-3">Edit Menu Item</h3>

            <% if (item == null) { %>
            <div class="alert alert-warning">Item not found.</div>
            <a href="${pageContext.request.contextPath}/admin/manage-menu" class="btn btn-outline-secondary">Back</a>
            <% } else { %>
            <form method="post" action="${pageContext.request.contextPath}/admin/edit-menu-item" enctype="multipart/form-data" class="row g-3">
                <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                <input type="hidden" name="existingImagePath" value="<%= item.getImagePath() %>">

                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select class="form-select" name="categoryId" required>
                        <% if (categories != null) {
                            for (Category c : categories) { %>
                            <option value="<%= c.getCategoryId() %>" <%= c.getCategoryId().equals(item.getCategoryId()) ? "selected" : "" %>><%= c.getCategoryName() %></option>
                        <% }} %>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Item Name</label>
                    <input type="text" class="form-control" name="itemName" value="<%= item.getItemName() %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" min="0" class="form-control" name="price" value="<%= item.getPrice() %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Preparation Time (minutes)</label>
                    <input type="number" min="1" max="240" class="form-control" name="prepTimeMinutes" value="<%= item.getPrepTimeMinutes() %>" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="description" rows="3"><%= item.getDescription() != null ? item.getDescription() : "" %></textarea>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Replace Image</label>
                    <input type="file" class="form-control" name="image" accept=".jpg,.jpeg,.png,.webp" onchange="previewImage(this)">
                </div>
                <div class="col-md-6 d-flex align-items-end gap-3">
                    <img id="currentImage" src="${pageContext.request.contextPath}/<%= item.getImagePath() != null ? item.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="img-thumbnail" style="max-height:120px;" alt="Current image">
                    <img id="preview" src="" class="img-thumbnail d-none" style="max-height:120px;" alt="Preview">
                </div>
                <div class="col-md-3 form-check ms-1">
                    <input class="form-check-input" type="checkbox" name="isAvailable" id="isAvailable" <%= item.isAvailable() ? "checked" : "" %>>
                    <label class="form-check-label" for="isAvailable">Available</label>
                </div>
                <div class="col-md-3 form-check ms-1">
                    <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured" <%= item.isFeatured() ? "checked" : "" %>>
                    <label class="form-check-label" for="isFeatured">Featured</label>
                </div>
                <div class="col-12 d-flex gap-2">
                    <button class="btn btn-primary">Update Item</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-menu" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</div>

<script>
    function previewImage(input) {
        const file = input.files[0];
        const preview = document.getElementById('preview');
        if (!file) {
            preview.classList.add('d-none');
            preview.src = '';
            return;
        }
        const reader = new FileReader();
        reader.onload = function (e) {
            preview.src = e.target.result;
            preview.classList.remove('d-none');
        };
        reader.readAsDataURL(file);
    }
</script>
</body>
</html>
