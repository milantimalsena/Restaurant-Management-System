package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.model.Cart;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.List;

public class ViewCartServlet extends HttpServlet {
    private static final BigDecimal TAX_RATE = new BigDecimal("0.13");
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long userId = SessionUtil.getLoggedInUserId(request);

        try {
            if (userId != null) {
                // logged-in customer: load persistent cart
                List<Cart> carts = cartDAO.getCartByUser(userId);
                BigDecimal subtotal = cartDAO.getSubtotal(userId);
                BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
                BigDecimal grandTotal = subtotal.add(tax);
                int cartCount = cartDAO.getCartCount(userId);

                request.setAttribute("cartItems", carts);
                request.setAttribute("subtotal", subtotal);
                request.setAttribute("tax", tax);
                request.setAttribute("grandTotal", grandTotal);
                request.setAttribute("cartCount", cartCount);

                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("cartMessage") != null) {
                    request.setAttribute("cartMessage", session.getAttribute("cartMessage"));
                    session.removeAttribute("cartMessage");
                }
            } else {
                // guest: read session-based cart
                HttpSession session = request.getSession(false);
                java.util.Map<Long, Integer> guestCart = null;
                if (session != null) {
                    @SuppressWarnings("unchecked")
                    java.util.Map<Long, Integer> tmp = (java.util.Map<Long, Integer>) session.getAttribute("guestCart");
                    guestCart = tmp;
                }

                java.util.List<Cart> carts = new java.util.ArrayList<>();
                java.math.BigDecimal subtotal = java.math.BigDecimal.ZERO;
                int cartCount = 0;
                if (guestCart != null && !guestCart.isEmpty()) {
                    com.restaurant.dao.MenuItemDAO menuItemDAO = new com.restaurant.dao.MenuItemDAO();
                    for (var entry : guestCart.entrySet()) {
                        Long itemId = entry.getKey();
                        Integer qty = entry.getValue();
                        com.restaurant.model.MenuItem mi = menuItemDAO.getById(itemId);
                        if (mi == null) continue;
                        Cart cart = new Cart();
                        cart.setItemId(itemId);
                        cart.setItemName(mi.getItemName());
                        cart.setImagePath(mi.getImagePath());
                        cart.setCategoryName(mi.getCategoryName());
                        cart.setQuantity(qty);
                        cart.setUnitPrice(mi.getPrice());
                        java.math.BigDecimal lineTotal = mi.getPrice().multiply(new java.math.BigDecimal(qty));
                        cart.setLineTotal(lineTotal);
                        carts.add(cart);

                        subtotal = subtotal.add(lineTotal);
                        cartCount += qty;
                    }
                }

                java.math.BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
                java.math.BigDecimal grandTotal = subtotal.add(tax);

                request.setAttribute("cartItems", carts);
                request.setAttribute("subtotal", subtotal);
                request.setAttribute("tax", tax);
                request.setAttribute("grandTotal", grandTotal);
                request.setAttribute("cartCount", cartCount);

                if (session != null && session.getAttribute("cartMessage") != null) {
                    request.setAttribute("cartMessage", session.getAttribute("cartMessage"));
                    session.removeAttribute("cartMessage");
                }
            }

            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to load cart right now.");
            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
        }
    }
}
