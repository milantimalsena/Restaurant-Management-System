package com.restaurant.util;

import com.restaurant.model.Order;
import com.restaurant.model.OrderItem;

import java.math.BigDecimal;

public final class InvoiceUtil {
    private InvoiceUtil() {
    }

    public static String buildInvoiceHtml(Order order) {
        StringBuilder html = new StringBuilder();
        html.append("<html><head><title>Invoice ").append(order.getOrderNumber()).append("</title></head><body>")
                .append("<h2>Smart Restaurant Invoice</h2>")
                .append("<p><strong>Order Number:</strong> ").append(order.getOrderNumber()).append("</p>")
                .append("<p><strong>Order Type:</strong> ").append(order.getOrderType()).append("</p>")
                .append("<p><strong>Payment:</strong> ").append(order.getPaymentMethod()).append("</p>")
                .append("<table border='1' cellpadding='8' cellspacing='0' width='100%'>")
                .append("<tr><th>Item</th><th>Qty</th><th>Unit</th><th>Total</th></tr>");

        for (OrderItem item : order.getItems()) {
            html.append("<tr><td>").append(item.getItemName())
                    .append("</td><td>").append(item.getQuantity())
                    .append("</td><td>").append(item.getUnitPrice())
                    .append("</td><td>").append(item.getLineTotal())
                    .append("</td></tr>");
        }

        html.append("</table>")
                .append("<p><strong>Subtotal:</strong> ").append(safe(order.getSubtotal())).append("</p>")
                .append("<p><strong>Tax:</strong> ").append(safe(order.getTax())).append("</p>")
                .append("<p><strong>Delivery Fee:</strong> ").append(safe(order.getDeliveryFee())).append("</p>")
                .append("<p><strong>Discount:</strong> ").append(safe(order.getDiscount())).append("</p>")
                .append("<h3>Grand Total: ").append(safe(order.getGrandTotal())).append("</h3>")
                .append("</body></html>");
        return html.toString();
    }

    private static BigDecimal safe(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
