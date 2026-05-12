package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Cart;
import com.restaurant.model.Order;
import com.restaurant.model.OrderItem;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/process-checkout")
public class CheckoutServlet extends HttpServlet {
    private static final BigDecimal TAX_RATE = new BigDecimal("0.10");
    private static final BigDecimal DELIVERY_FEE = new BigDecimal("100.00");
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: CheckoutServlet#doGet");
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Cart> cartItems = orderDAO.getCartItems(userId);
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (request.getSession(false) != null && request.getSession(false).getAttribute("checkoutError") != null) {
                request.setAttribute("checkoutError", request.getSession(false).getAttribute("checkoutError"));
                request.getSession(false).removeAttribute("checkoutError");
            }

            BigDecimal subtotal = orderDAO.getCartSubtotal(userId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal grandTotal = subtotal.add(tax).setScale(2, RoundingMode.HALF_UP);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("deliveryFeeDefault", DELIVERY_FEE);
            request.setAttribute("grandTotalPreview", grandTotal);
            request.setAttribute("taxRate", TAX_RATE);
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("jakarta.servlet.error.status_code", 500);
            request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
            request.setAttribute("jakarta.servlet.error.message", ex.getMessage());
            request.setAttribute("jakarta.servlet.error.exception", ex);
            request.setAttribute("debugMessage", "Checkout failed: " + ex.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderType = normalizeOrderType(ValidationUtil.sanitize(request.getParameter("orderType")));
        String paymentMethod = normalizePaymentMethod(ValidationUtil.sanitize(request.getParameter("paymentMethod")));
        String deliveryAddress = ValidationUtil.sanitize(request.getParameter("deliveryAddress"));
        String specialInstructions = ValidationUtil.sanitize(request.getParameter("specialInstructions"));
        if (!ValidationUtil.isRequiredValid(specialInstructions)) {
            specialInstructions = ValidationUtil.sanitize(request.getParameter("notes"));
        }

        if (!ValidationUtil.isOrderTypeValid(orderType) || !ValidationUtil.isPaymentMethodValid(paymentMethod)) {
            redirectToCheckoutWithError(request, response, "Please choose a valid order type and payment method.");
            return;
        }

        try {
            List<Cart> cartItems = orderDAO.getCartItems(userId);
            if (cartItems.isEmpty()) {
                redirectToCheckoutWithError(request, response, "Your cart is empty. Add items before checking out.");
                return;
            }

            BigDecimal totalAmount = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart cart : cartItems) {
                BigDecimal subtotal = cart.getUnitPrice().multiply(BigDecimal.valueOf(cart.getQuantity())).setScale(2, RoundingMode.HALF_UP);
                totalAmount = totalAmount.add(subtotal);

                OrderItem orderItem = new OrderItem();
                orderItem.setItemId(cart.getItemId());
                orderItem.setQuantity(cart.getQuantity());
                orderItem.setUnitPrice(cart.getUnitPrice());
                orderItem.setLineTotal(subtotal);
                orderItems.add(orderItem);
            }
            totalAmount = totalAmount.setScale(2, RoundingMode.HALF_UP);

            Order order = new Order();
            order.setUserId(userId);
            order.setOrderType(orderType);
            order.setOrderStatus("PENDING");
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus("UNPAID");
            order.setSubtotal(totalAmount);
            order.setTax(BigDecimal.ZERO);
            order.setDeliveryFee(BigDecimal.ZERO);
            order.setDiscount(BigDecimal.ZERO);
            order.setGrandTotal(totalAmount);
            order.setDeliveryAddress("DELIVERY".equals(orderType) ? deliveryAddress : null);
            order.setNotes(specialInstructions);
            order.setItems(orderItems);

            orderDAO.processCheckout(order);
            response.sendRedirect(request.getContextPath() + "/customer/orders.jsp?success=order_placed");
        } catch (SQLException ex) {
            ex.printStackTrace();
            redirectToCheckoutWithError(request, response, "Unable to place your order right now. Please try again.");
        }
    }

    private void redirectToCheckoutWithError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        request.getSession().setAttribute("checkoutError", message);
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    private String normalizeOrderType(String orderType) {
        if (orderType == null) {
            return null;
        }

        return switch (orderType.trim().toUpperCase().replace("-", "_").replace(" ", "_")) {
            case "DINE_IN", "DINEIN" -> "DINE_IN";
            case "DELIVERY" -> "DELIVERY";
            case "TAKEAWAY", "TAKE_AWAY" -> "TAKEAWAY";
            default -> orderType.trim().toUpperCase();
        };
    }

    private String normalizePaymentMethod(String paymentMethod) {
        if (paymentMethod == null) {
            return null;
        }

        return switch (paymentMethod.trim().toUpperCase()) {
            case "CASH" -> "CASH";
            case "CARD" -> "CARD";
            case "ESEWA" -> "ESEWA";
            case "KHALTI" -> "KHALTI";
            default -> paymentMethod.trim().toUpperCase();
        };
    }
}
