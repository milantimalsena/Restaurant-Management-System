package com.restaurant.util;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Set;
import java.util.UUID;

public final class FileUploadUtil {
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");

    private FileUploadUtil() {
    }

    public static String saveMenuImage(Part imagePart, String uploadDirAbsolutePath) throws IOException, ServletException {
        if (imagePart == null || imagePart.getSize() == 0) {
            return null;
        }

        if (imagePart.getSize() > MAX_FILE_SIZE) {
            throw new ServletException("Image size must be 5MB or less.");
        }

        String submittedFileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String extension = getExtension(submittedFileName);
        if (extension == null || !ALLOWED_EXTENSIONS.contains(extension.toLowerCase())) {
            throw new ServletException("Only jpg, jpeg, png, and webp files are allowed.");
        }

        String mimeType = imagePart.getContentType();
        if (mimeType == null || !mimeType.startsWith("image/")) {
            throw new ServletException("Invalid file type.");
        }

        String uniqueName = System.currentTimeMillis() + "-" + UUID.randomUUID() + "." + extension.toLowerCase();
        File uploadDir = new File(uploadDirAbsolutePath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            throw new IOException("Unable to create upload directory.");
        }

        String destination = uploadDirAbsolutePath + File.separator + uniqueName;
        imagePart.write(destination);
        return "uploads/menu/" + uniqueName;
    }

    private static String getExtension(String fileName) {
        int index = fileName.lastIndexOf('.');
        if (index < 0 || index == fileName.length() - 1) {
            return null;
        }
        return fileName.substring(index + 1);
    }
}
