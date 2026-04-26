<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.restaurant.model.MenuItem" %>
<%
    MenuItem item = (MenuItem) request.getAttribute("menuItemDetail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Item Details | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-4 py-md-5">
    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-dark btn-sm mb-3">Back to Menu</a>

    <% if (item == null) { %>
    <div class="alert alert-warning">Item not found.</div>
    <% } else { %>
    <div class="card border-0 shadow-sm">
        <div class="row g-0">
            <div class="col-md-5">
                <img src="${pageContext.request.contextPath}/<%= item.getImagePath() != null ? item.getImagePath() : "assets/images/banners/placeholder-food.jpg" %>" class="img-fluid h-100 object-fit-cover" alt="<%= item.getItemName() %>">
            </div>
            <div class="col-md-7">
                <div class="card-body p-4 p-lg-5">
                    <h3 class="fw-bold mb-2"><%= item.getItemName() %></h3>
                    <p class="text-muted mb-2">Category: <%= item.getCategoryName() %></p>
                    <p class="mb-4"><%= item.getDescription() != null ? item.getDescription() : "No description available." %></p>
                    <h4 class="text-success mb-3">NPR <%= item.getPrice() %></h4>
                    <p class="mb-3">Prep Time: <strong><%= item.getPrepTimeMinutes() %> mins</strong></p>
                    <span class="badge <%= item.isAvailable() ? "text-bg-success" : "text-bg-secondary" %> mb-4">
                        <%= item.isAvailable() ? "Available" : "Out of Stock" %>
                    </span>
                    <div>
                        <form method="post" action="${pageContext.request.contextPath}/cart/add" class="d-inline">
                            <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                            <input type="hidden" name="qty" value="1">
                            <input type="hidden" name="redirect" value="/menu?itemId=<%= item.getItemId() %>">
                            <button class="btn btn-warning" <%= !item.isAvailable() ? "disabled" : "" %>>Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>
</body>
</html>
