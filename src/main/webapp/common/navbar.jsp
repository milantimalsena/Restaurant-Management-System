<nav style="display: flex; justify-content: space-between; align-items: center; background: #333; padding: 15px 30px; color: white;">
    <div style="display: flex; align-items: center; gap: 10px; font-weight: bold; font-size: 20px;">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;">
        <span>Himalayan Yaks</span>
    </div>
    <div style="display: flex; gap: 20px;">
        <a href="${pageContext.request.contextPath}/index.jsp" style="color: white; text-decoration: none;">Home</a>
        <a href="${pageContext.request.contextPath}/menu" style="color: white; text-decoration: none;">Menu</a>
        <a href="${pageContext.request.contextPath}/cart" style="color: white; text-decoration: none;">Cart</a>
        <a href="${pageContext.request.contextPath}/admin/manage-menu" style="color: white; text-decoration: none;">Admin</a>
        <a href="${pageContext.request.contextPath}/logout" style="color: red; text-decoration: none; font-weight: bold;">Logout</a>
    </div>
</nav>
