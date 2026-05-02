<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Admin Login | Himalayan Yaks</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #111827 0%, #1f2937 45%, #374151 100%);
            display: grid;
            place-items: center;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-admin {
            width: 100%;
            max-width: 420px;
            border: none;
            border-radius: 16px;
            box-shadow: 0 18px 36px rgba(0, 0, 0, 0.3);
        }
        .auth-logo {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1rem;
            box-shadow: 0 14px 30px rgba(0, 0, 0, 0.22);
        }
    </style>
</head>
<body>
<div class="card card-admin p-4">
    <img class="auth-logo" src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo">
    <h4 class="fw-bold mb-1">Admin Portal</h4>
    <p class="text-muted mb-4">Sign in to manage restaurant operations.</p>

    <% if (request.getParameter("sessionExpired") != null) { %>
    <div class="alert alert-warning">Session expired. Please login again.</div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/admin/login">
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <div class="input-group">
                <input type="password" id="adminPassword" name="password" class="form-control" minlength="8" required>
                <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('adminPassword')">Show</button>
            </div>
        </div>
        <button type="submit" class="btn btn-dark w-100">Secure Login</button>
    </form>
</div>

<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
