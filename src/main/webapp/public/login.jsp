<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Customer Login | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bg-start: #1f2937;
            --bg-end: #0f172a;
            --accent: #f59e0b;
            --accent-dark: #d97706;
        }
        body {
            min-height: 100vh;
            background: radial-gradient(circle at top left, #374151 0%, var(--bg-start) 40%, var(--bg-end) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }
        .glass-card {
            width: 100%;
            max-width: 430px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.35);
            color: #f8fafc;
        }
        .btn-animated {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            border: none;
        }
        .btn-animated:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(245, 158, 11, 0.35);
        }
        .form-control {
            background-color: rgba(255, 255, 255, 0.9);
            border: none;
        }
        .text-link {
            color: #fde68a;
        }
    </style>
</head>
<body>
<div class="glass-card p-4 p-md-5">
    <h3 class="fw-bold mb-2">Welcome Back</h3>
    <p class="mb-4">Login to your customer account</p>

    <% if (request.getParameter("sessionExpired") != null) { %>
    <div class="alert alert-warning">Session expired. Please login again.</div>
    <% } %>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="<%= request.getAttribute("rememberedEmail") != null ? request.getAttribute("rememberedEmail") : "" %>" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <div class="input-group">
                <input type="password" id="password" name="password" class="form-control" minlength="8" required>
                <button class="btn btn-light" type="button" onclick="togglePassword('password')">Show</button>
            </div>
        </div>
        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" name="rememberMe" id="rememberMe">
            <label class="form-check-label" for="rememberMe">Remember session</label>
        </div>
        <button type="submit" class="btn btn-animated text-white w-100 py-2">Login</button>
    </form>

    <p class="mt-4 mb-0 text-center">New customer?
        <a class="text-link fw-semibold" href="${pageContext.request.contextPath}/register">Create account</a>
    </p>
</div>

<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
