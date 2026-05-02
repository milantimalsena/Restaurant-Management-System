package com.restaurant.util;

import com.restaurant.model.Order;
import com.restaurant.model.OrderItem;

import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;

public final class InvoiceUtil {
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a");

    private InvoiceUtil() {
    }

    public static String buildInvoiceHtml(Order order) {
        StringBuilder html = new StringBuilder();
    html.append("<html><head><title>Invoice ").append(order.getOrderNumber()).append("</title>")
        .append("<style>")
        .append("body{font-family:Arial,sans-serif;color:#0f172a;padding:24px;background:#f8fafc;}")
        .append(".card{max-width:900px;margin:0 auto;background:#fff;border:1px solid #e2e8f0;border-radius:18px;padding:24px;box-shadow:0 16px 40px rgba(15,23,42,.08);}")
        .append("table{width:100%;border-collapse:collapse;margin-top:16px;}")
        .append("th,td{padding:12px;border-bottom:1px solid #e2e8f0;text-align:left;}")
        .append("th{background:#f8fafc;font-size:12px;text-transform:uppercase;letter-spacing:.08em;color:#475569;}")
        .append(".meta{display:flex;gap:16px;flex-wrap:wrap;margin:16px 0;}")
        .append(".pill{display:inline-block;background:#e0e7ff;color:#3730a3;padding:6px 10px;border-radius:999px;font-size:12px;font-weight:700;}")
        .append(".summary{margin-top:16px;display:grid;grid-template-columns:1fr auto;gap:8px 24px;max-width:360px;margin-left:auto;}")
        .append(".total{font-size:20px;font-weight:800;color:#0f172a;}")
        .append("</style></head><body><div class='card'>")
        .append("<h2 style='margin:0;'>Smart Restaurant Invoice</h2>")
        .append("<p style='margin:6px 0 0;color:#64748b;'>Order receipt and payment record</p>")
        .append("<div class='meta'>")
        .append("<span class='pill'>").append(order.getOrderNumber()).append("</span>")
        .append("<span class='pill'>").append(order.getOrderType()).append("</span>")
        .append("<span class='pill'>").append(order.getPaymentMethod()).append("</span>")
        .append("</div>")
        .append("<p><strong>Placed:</strong> ").append(order.getOrderedAt() == null ? "-" : DATE_TIME.format(order.getOrderedAt())).append("</p>")
        .append("<p><strong>Status:</strong> ").append(order.getOrderStatus()).append(" | <strong>Payment:</strong> ").append(order.getPaymentStatus()).append("</p>")
        .append("<table><tr><th>Item</th><th>Qty</th><th>Unit</th><th>Total</th></tr>");

        for (OrderItem item : order.getItems()) {
            html.append("<tr><td>").append(item.getItemName())
                    .append("</td><td>").append(item.getQuantity())
                    .append("</td><td>").append(item.getUnitPrice())
                    .append("</td><td>").append(item.getLineTotal())
                    .append("</td></tr>");
        }

    html.append("</table>")
        .append("<div class='summary'>")
        .append("<span>Subtotal</span><strong>").append(safe(order.getSubtotal())).append("</strong>")
        .append("<span>Tax</span><strong>").append(safe(order.getTax())).append("</strong>")
        .append("<span>Delivery Fee</span><strong>").append(safe(order.getDeliveryFee())).append("</strong>")
        .append("<span>Discount</span><strong>").append(safe(order.getDiscount())).append("</strong>")
        .append("<span class='total'>Grand Total</span><strong class='total'>").append(safe(order.getGrandTotal())).append("</strong>")
        .append("</div>")
        .append("</div></body></html>");
        return html.toString();
    }

    private static BigDecimal safe(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }
}
