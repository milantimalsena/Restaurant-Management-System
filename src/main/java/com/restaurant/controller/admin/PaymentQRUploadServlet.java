package com.restaurant.controller.admin;

import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 8 * 1024 * 1024
)
public class PaymentQRUploadServlet extends HttpServlet {
    private static final String ESEWA = "esewa";
    private static final String KHALTI = "khalti";
    private static final String QR_PART_NAME = "qrImage";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String paymentType = request.getParameter("paymentType");
        String fileName = resolveQrFileName(paymentType);
        if (fileName == null) {
            response.sendRedirect(request.getContextPath() + "/admin/payment-settings.jsp?error=invalidType");
            return;
        }

        Part qrImage = request.getPart(QR_PART_NAME);
        if (qrImage == null || qrImage.getSize() == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/payment-settings.jsp?error=missingFile");
            return;
        }

        String contentType = qrImage.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendRedirect(request.getContextPath() + "/admin/payment-settings.jsp?error=invalidFile");
            return;
        }

        String uploadPath = getServletContext().getRealPath("/uploads/payments");
        if (uploadPath == null) {
            throw new ServletException("Unable to resolve payment QR upload directory.");
        }

        File uploadDirectory = new File(uploadPath);
        if (!uploadDirectory.exists() && !uploadDirectory.mkdirs()) {
            throw new IOException("Unable to create payment QR upload directory.");
        }

        qrImage.write(new File(uploadDirectory, fileName).getAbsolutePath());
        response.sendRedirect(request.getContextPath() + "/admin/payment-settings.jsp?success=" + paymentType);
    }

    private String resolveQrFileName(String paymentType) {
        if (ESEWA.equalsIgnoreCase(paymentType)) {
            return "esewa-qr.png";
        }
        if (KHALTI.equalsIgnoreCase(paymentType)) {
            return "khalti-qr.png";
        }
        return null;
    }
}
