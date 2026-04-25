<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Customer Dashboard | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="#">Smart Restaurant</a>
        <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>

<div class="container py-5">
    <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
            <h3 class="fw-bold">Welcome, <%= session.getAttribute("userFullName") %></h3>
            <p class="text-muted mb-0">You are logged in as Customer.</p>
        </div>
    </div>
</div>
</body>
</html>
