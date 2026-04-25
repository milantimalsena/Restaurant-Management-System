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
    <title>Add Menu Item | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4 py-lg-5">
    <div class="card border-0 shadow-sm">
        <div class="card-body p-4 p-lg-5">
            <h3 class="fw-bold mb-3">Add New Menu Item</h3>

            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/admin/add-menu-item" enctype="multipart/form-data" class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <select class="form-select" name="categoryId" required>
                        <option value="">Select category</option>
                        <% if (categories != null) {
                            for (Category c : categories) { %>
                            <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                        <% }} %>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Item Name</label>
                    <input type="text" class="form-control" name="itemName" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" min="0" class="form-control" name="price" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Preparation Time (minutes)</label>
                    <input type="number" min="1" max="240" class="form-control" name="prepTimeMinutes" required>
                </div>
                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea class="form-control" name="description" rows="3"></textarea>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Image (jpg, jpeg, png, webp; max 5MB)</label>
                    <input type="file" class="form-control" name="image" accept=".jpg,.jpeg,.png,.webp" onchange="previewImage(this)" required>
                </div>
                <div class="col-md-6 d-flex align-items-end">
                    <img id="preview" src="" class="img-thumbnail d-none" style="max-height:120px;" alt="Preview">
                </div>
                <div class="col-md-3 form-check ms-1">
                    <input class="form-check-input" type="checkbox" name="isAvailable" id="isAvailable" checked>
                    <label class="form-check-label" for="isAvailable">Available</label>
                </div>
                <div class="col-md-3 form-check ms-1">
                    <input class="form-check-input" type="checkbox" name="isFeatured" id="isFeatured">
                    <label class="form-check-label" for="isFeatured">Featured</label>
                </div>
                <div class="col-12 d-flex gap-2">
                    <button class="btn btn-primary">Save Item</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-menu" class="btn btn-outline-secondary">Cancel</a>
                </div>
            </form>
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
