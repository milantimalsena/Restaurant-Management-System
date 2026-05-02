package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Cart;
import com.restaurant.model.Order;
import com.restaurant.model.OrderItem;
import com.restaurant.util.OrderNumberUtil;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlaceOrderServlet extends HttpServlet {
    private static final BigDecimal TAX_RATE = new BigDecimal("0.10");
    private static final BigDecimal DELIVERY_FEE = new BigDecimal("100.00");
    private final OrderDAO orderDAO = new OrderDAO();

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

        String orderType = ValidationUtil.sanitize(request.getParameter("orderType"));
        String paymentMethod = ValidationUtil.sanitize(request.getParameter("paymentMethod"));
        String deliveryAddress = ValidationUtil.sanitize(request.getParameter("deliveryAddress"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));
        String notes = ValidationUtil.sanitize(request.getParameter("notes"));
        String tableNumber = ValidationUtil.sanitize(request.getParameter("tableNumber"));
        String pickupNote = ValidationUtil.sanitize(request.getParameter("pickupNote"));
        String promoCode = ValidationUtil.sanitize(request.getParameter("promoCode"));

        if (!ValidationUtil.isOrderTypeValid(orderType) || !ValidationUtil.isPaymentMethodValid(paymentMethod)) {
            request.getSession().setAttribute("checkoutError", "Please choose a valid order type and payment method.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if ("DELIVERY".equalsIgnoreCase(orderType)) {
            if (!ValidationUtil.isRequiredValid(deliveryAddress) || !ValidationUtil.isPhoneValid(phone)) {
                request.getSession().setAttribute("checkoutError", "Delivery requires valid address and phone.");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
        } else {
            deliveryAddress = null;
            phone = null;
        }

        StringBuilder finalNotes = new StringBuilder();
        if (ValidationUtil.isRequiredValid(notes)) {
            finalNotes.append(notes);
        }
        if ("DINE_IN".equalsIgnoreCase(orderType) && ValidationUtil.isRequiredValid(tableNumber)) {
            finalNotes.append(finalNotes.isEmpty() ? "" : " | ").append("Table: ").append(tableNumber);
        }
        if ("TAKEAWAY".equalsIgnoreCase(orderType) && ValidationUtil.isRequiredValid(pickupNote)) {
            finalNotes.append(finalNotes.isEmpty() ? "" : " | ").append("Pickup Note: ").append(pickupNote);
        }

        try {
            List<Cart> cartItems = orderDAO.getCartItems(userId);
            if (cartItems.isEmpty()) {
                request.getSession().setAttribute("checkoutError", "Your cart is empty. Add items before checking out.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            BigDecimal subtotal = orderDAO.getCartSubtotal(userId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal deliveryFee = "DELIVERY".equalsIgnoreCase(orderType) ? DELIVERY_FEE : BigDecimal.ZERO;
            BigDecimal discount = calculateDiscount(subtotal, promoCode);
            BigDecimal grandTotal = subtotal.add(tax).add(deliveryFee).subtract(discount).setScale(2, RoundingMode.HALF_UP);
            String normalizedPaymentMethod = paymentMethod.toUpperCase();
            String paymentStatus = "CASH".equals(normalizedPaymentMethod) ? "UNPAID" : "PAID";

            Order order = new Order();
            order.setOrderNumber(OrderNumberUtil.generateOrderNumber());
            order.setUserId(userId);
            order.setOrderType(orderType.toUpperCase());
            order.setOrderStatus("PENDING");
            order.setPaymentStatus(paymentStatus);
            order.setSubtotal(subtotal);
            order.setTax(tax);
            order.setDeliveryFee(deliveryFee);
            order.setDiscount(discount);
            order.setGrandTotal(grandTotal);
            order.setDeliveryAddress("DELIVERY".equalsIgnoreCase(orderType) ? deliveryAddress : null);
            order.setPhoneSnapshot("DELIVERY".equalsIgnoreCase(orderType) ? phone : null);
            order.setNotes(finalNotes.toString());
            order.setPaymentMethod(normalizedPaymentMethod);

            List<OrderItem> orderItems = new ArrayList<>();
            for (Cart cart : cartItems) {
                OrderItem item = new OrderItem();
                item.setItemId(cart.getItemId());
                item.setQuantity(cart.getQuantity());
                item.setUnitPrice(cart.getUnitPrice());
                item.setLineTotal(cart.getLineTotal());
                orderItems.add(item);
            }
            order.setItems(orderItems);

            long orderId = orderDAO.createOrder(order);
            response.sendRedirect(request.getContextPath() + "/order-success?orderId=" + orderId);
        } catch (SQLException ex) {
            request.getSession().setAttribute("checkoutError", "Order placement failed. Please try again.");
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }

    private BigDecimal calculateDiscount(BigDecimal subtotal, String promoCode) {
        if (!ValidationUtil.isRequiredValid(promoCode)) {
            return BigDecimal.ZERO;
        }

        if ("SAVE10".equalsIgnoreCase(promoCode.trim())) {
            BigDecimal discount = subtotal.multiply(new BigDecimal("0.10"));
            BigDecimal cap = new BigDecimal("200.00");
            if (discount.compareTo(cap) > 0) {
                return cap;
            }
            return discount.setScale(2, RoundingMode.HALF_UP);
        }
        return BigDecimal.ZERO;
    }
}
