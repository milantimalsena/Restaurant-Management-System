<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.io.PrintWriter,java.io.StringWriter" %>
<%
    Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
    if (statusCode == null) {
        statusCode = 500;
    }
    String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
    String message = (String) request.getAttribute("jakarta.servlet.error.message");
    String debugMessage = (String) request.getAttribute("debugMessage");
    Throwable rootCause = exception != null ? exception : (Throwable) request.getAttribute("jakarta.servlet.error.exception");
    StringWriter stackTraceWriter = new StringWriter();
    if (rootCause != null) {
        rootCause.printStackTrace(new PrintWriter(stackTraceWriter));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Debug Error | Smart Restaurant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: #0f172a; color: #e2e8f0; min-height: 100vh; }
        .error-shell { max-width: 1100px; }
        .error-card { background: rgba(15, 23, 42, 0.92); border: 1px solid rgba(148, 163, 184, 0.18); border-radius: 1.5rem; box-shadow: 0 24px 60px rgba(0,0,0,.35); }
        .stack { white-space: pre-wrap; font-family: Consolas, "Courier New", monospace; font-size: .85rem; max-height: 380px; overflow: auto; }
    </style>
</head>
<body>
<div class="container py-5 error-shell">
    <div class="error-card p-4 p-lg-5">
        <div class="d-flex align-items-center justify-content-between gap-3 mb-4">
            <div>
                <div class="text-uppercase text-info-emphasis small fw-semibold">Server Debug</div>
                <h1 class="display-6 fw-bold mb-0">Something went wrong</h1>
            </div>
            <span class="badge text-bg-danger rounded-pill px-3 py-2">HTTP <%= statusCode %></span>
        </div>

        <p class="lead text-secondary mb-4">The application encountered an error. The real exception details are shown below for debugging.</p>

        <div class="row g-3 mb-4">
            <div class="col-md-6"><div class="p-3 rounded-4 bg-dark border border-secondary-subtle"><div class="text-secondary small text-uppercase">Request URI</div><div class="fw-semibold"><c:out value="<%= requestUri %>" /></div></div></div>
            <div class="col-md-6"><div class="p-3 rounded-4 bg-dark border border-secondary-subtle"><div class="text-secondary small text-uppercase">Message</div><div class="fw-semibold"><c:out value="<%= message != null ? message : debugMessage %>" /></div></div></div>
        </div>

        <div class="p-3 rounded-4 bg-black border border-secondary-subtle">
            <div class="text-secondary small text-uppercase mb-2">Stack Trace</div>
            <div class="stack"><%= rootCause != null ? stackTraceWriter.toString() : "No exception object available." %></div>
        </div>

        <div class="mt-4 d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/public/home.jsp" class="btn btn-light rounded-pill px-4">Go Home</a>
            <a href="javascript:history.back()" class="btn btn-outline-light rounded-pill px-4">Go Back</a>
        </div>
    </div>
</div>
</body>
</html>