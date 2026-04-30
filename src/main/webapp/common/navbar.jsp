<nav style="display: flex; justify-content: space-between; align-items: center; background: #333; padding: 15px 30px; color: white;">
    <div style="font-weight: bold; font-size: 20px;">Smart Restaurant</div>
    <div style="display: flex; gap: 20px;">
        <a href="${pageContext.request.contextPath}/index.jsp" style="color: white; text-decoration: none;">Home</a>
        <a href="${pageContext.request.contextPath}/menu" style="color: white; text-decoration: none;">Menu</a>
        <a href="${pageContext.request.contextPath}/cart" style="color: white; text-decoration: none;">Cart</a>
        <a href="${pageContext.request.contextPath}/admin/manage-menu" style="color: white; text-decoration: none;">Admin</a>
        <a href="${pageContext.request.contextPath}/logout" style="color: red; text-decoration: none; font-weight: bold;">Logout</a>
    </div>
</nav>