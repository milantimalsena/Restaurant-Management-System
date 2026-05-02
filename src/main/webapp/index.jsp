<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome | Smart Restaurant</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body class="container">

    <!-- INTEGRATION: Including your shared Navbar -->
    <jsp:include page="common/navbar.jsp" />

    <main class="main-content">
        <div class="card">
            <h1>Welcome to Smart Restaurant</h1>
            <p>Your journey to ethically sourced, delicious food starts here.</p>
            <br>
            <a href="login.jsp" style="padding: 10px 20px; background: #333; color: white; text-decoration: none; border-radius: 5px;">Get Started</a>
        </div>
    </main>

    <!-- INTEGRATION: Including your shared Footer -->
    <jsp:include page="common/footer.jsp" />

</body>
</html>