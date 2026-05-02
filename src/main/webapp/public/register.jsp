<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Customer Registration | Himalayan Yaks</title>
    <link href="${pageContext.request.contextPath}/assets/css/app-ui.css" rel="stylesheet" />
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(120deg, #064e3b 0%, #0f766e 50%, #134e4a 100%);
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-card {
            max-width: 760px;
            margin: 40px auto;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.93);
            border-radius: 18px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.2);
            animation: fadeUp 0.5s ease;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .btn-register {
            background: #0f766e;
            border: none;
            transition: all 0.2s ease;
        }
        .btn-register:hover {
            transform: translateY(-1px);
            background: #0d9488;
        }
        .auth-logo {
            width: 78px;
            height: 78px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1rem;
            box-shadow: 0 14px 32px rgba(15, 23, 42, 0.18);
        }
    </style>
</head>
<body>
<div class="container py-4">
    <div class="register-card p-4 p-md-5">
        <img class="auth-logo" src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo">
        <h3 class="fw-bold mb-2">Create Customer Account</h3>
        <p class="text-muted mb-4">Join Himalayan Yaks for faster ordering and reservations.</p>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/register" class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName" class="form-control" value="${fullName}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="${email}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" placeholder="98XXXXXXXX" value="${phone}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <input type="password" id="password" name="password" class="form-control" minlength="8" required>
                    <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('password')">Show</button>
                </div>
            </div>
            <div class="col-12">
                <label class="form-label">Address</label>
                <textarea name="address" class="form-control" rows="3">${address}</textarea>
            </div>
            <div class="col-12 d-grid">
                <button type="submit" class="btn btn-register text-white py-2">Register Account</button>
            </div>
        </form>

        <p class="mt-4 mb-0 text-center">Already have an account?
            <a href="${pageContext.request.contextPath}/login" class="fw-semibold">Login</a>
        </p>
    </div>
</div>

<script>
    function togglePassword(id) {
        const input = document.getElementById(id);
        input.type = input.type === 'password' ? 'text' : 'password';
    }
</script>
</body>
</html>
