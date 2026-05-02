<footer class="site-footer mt-5">
	<div class="container py-5">
		<div class="row g-4 align-items-start">
			<div class="col-lg-4">
				<a href="${pageContext.request.contextPath}/public/home.jsp" class="d-inline-flex align-items-center gap-3 text-decoration-none mb-3">
					<span class="footer-logo">
						<img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Himalayan Yaks logo" />
					</span>
					<div>
						<div class="text-uppercase text-secondary small fw-semibold letter-spacing">Himalayan Yaks</div>
						<div class="h5 fw-bold mb-0 text-dark">Restaurant & Ordering</div>
					</div>
				</a>
				<p class="text-secondary mb-0">A modern restaurant platform for ordering, reservations, and smarter customer service.</p>
			</div>

			<div class="col-6 col-lg-2">
				<h3 class="h6 fw-bold text-dark mb-3">Quick Links</h3>
				<ul class="list-unstyled d-grid gap-2 mb-0">
					<li><a class="text-secondary text-decoration-none" href="${pageContext.request.contextPath}/public/home.jsp">Home</a></li>
					<li><a class="text-secondary text-decoration-none" href="${pageContext.request.contextPath}/menu">Menu</a></li>
					<li><a class="text-secondary text-decoration-none" href="${pageContext.request.contextPath}/public/about.jsp">About</a></li>
					<li><a class="text-secondary text-decoration-none" href="${pageContext.request.contextPath}/public/contact.jsp">Contact</a></li>
				</ul>
			</div>

			<div class="col-6 col-lg-3">
				<h3 class="h6 fw-bold text-dark mb-3">Contact</h3>
				<div class="d-grid gap-2 text-secondary">
					<div><i class="bi bi-geo-alt me-2 text-primary"></i> Itahari, Nepal</div>
					<div><i class="bi bi-envelope me-2 text-primary"></i> info@himalayanyaks.com</div>
					<div><i class="bi bi-telephone me-2 text-primary"></i> +977 9800000000</div>
				</div>
			</div>

			<div class="col-lg-3">
				<h3 class="h6 fw-bold text-dark mb-3">Follow Us</h3>
				<div class="d-flex gap-2 mb-3">
					<a href="#" class="social-link"><i class="bi bi-facebook"></i></a>
					<a href="#" class="social-link"><i class="bi bi-instagram"></i></a>
					<a href="#" class="social-link"><i class="bi bi-twitter-x"></i></a>
					<a href="#" class="social-link"><i class="bi bi-youtube"></i></a>
				</div>
				<p class="text-secondary small mb-0">Secure payments, fast pickup, and customer-first ordering.</p>
			</div>
		</div>

		<div class="border-top mt-4 pt-4 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 text-secondary small">
			<span>&copy; ${pageContext.request.contextPath != null ? 'Himalayan Yaks' : 'Himalayan Yaks'} 2026. All rights reserved.</span>
			<span>Built with JSP, Servlets, JDBC, MySQL, and custom CSS.</span>
		</div>
	</div>
</footer>

<style>
	.site-footer {
		background: linear-gradient(180deg, rgba(248, 250, 252, 0.85), #ffffff);
		border-top: 1px solid rgba(148, 163, 184, 0.16);
	}
	.social-link {
		width: 42px;
		height: 42px;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		border-radius: 999px;
		background: #f8fafc;
		color: #0f172a;
		border: 1px solid #e2e8f0;
		transition: transform .2s ease, background .2s ease, color .2s ease, box-shadow .2s ease;
	}
	.social-link:hover {
		background: #0f172a;
		color: #fff;
		transform: translateY(-1px);
		box-shadow: 0 12px 24px rgba(15, 23, 42, 0.12);
	}
	.footer-logo {
		width: 48px;
		height: 48px;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		border-radius: 1rem;
		overflow: hidden;
		background: #fff;
		box-shadow: 0 10px 24px rgba(15, 23, 42, 0.10);
	}
	.footer-logo img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
</style>
