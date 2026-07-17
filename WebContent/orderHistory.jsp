<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Order" %>
<%@ page import="com.dcl.model.OrderItem" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .order-card {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-left: 4px solid var(--color-impossible-red);
            border-radius: var(--radius-cards);
            margin-bottom: 24px;
            overflow: hidden;
            transition: transform 0.3s, border-color 0.3s;
        }
        .order-card:hover {
            transform: translateY(-4px);
            border-color: rgba(225, 6, 0, 0.3);
        }
        
        .order-header {
            background-color: var(--color-velvet-wine);
            border-bottom: 1px solid var(--color-butcher-black);
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .order-header-left { display: flex; gap: 32px; flex-wrap: wrap; }
        
        .info-group { display: flex; flex-direction: column; gap: 4px; }
        .info-label {
            font-family: var(--font-sans-meat);
            font-size: 12px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
        }
        .info-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            color: var(--color-bone-white);
        }
        
        .order-status {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 14px;
            color: #80f0b0;
            background-color: rgba(0, 200, 90, 0.1);
            padding: 6px 12px;
            border-radius: 4px;
            border: 1px solid rgba(0, 200, 90, 0.3);
            text-transform: uppercase;
        }
        
        .order-body { padding: 24px; }
        .restaurant-name {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 24px;
            color: var(--color-impossible-red);
            text-transform: uppercase;
            margin-bottom: 16px;
        }
        
        .item-list { list-style: none; padding: 0; margin: 0; }
        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px dashed rgba(255, 199, 198, 0.2);
        }
        .item-row:last-child { border-bottom: none; }
        .item-left { display: flex; gap: 12px; align-items: baseline; }
        .item-qty {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-impossible-red);
        }
        .item-name { color: var(--color-bone-white); }
        .item-price {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-bone-white);
        }
        
        .order-footer {
            background-color: var(--color-velvet-wine);
            border-top: 1px solid var(--color-butcher-black);
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .delivery-address {
            font-size: 14px;
            color: var(--color-blush-highlight);
            max-width: 60%;
        }
        .order-total {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 24px;
            color: var(--color-impossible-red);
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
            <a href="CartServlet" class="nav-item">🛒 Cart</a>
            <%
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span class="nav-welcome">Hey, <%= currentUser.getUsername() %></span>
                <a href="OrderHistoryServlet" class="nav-item">My Orders</a>
                <a href="UserServlet?action=logout" class="btn-primary">Logout ›</a>
            <% } else { %>
                <a href="login.jsp" class="btn-primary">Sign In ›</a>
            <% } %>
        </div>
    </nav>

    <div class="section-heading-block" style="padding-bottom: 0;">
        <p class="section-bracket-eyebrow">◂ Your History ▸</p>
        <h1 class="section-display" style="margin-bottom: 40px;">MY ORDERS</h1>
    </div>

    <div style="max-width: 1000px; margin: 0 auto; padding: 0 24px 80px;">
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            List<String> restaurantNames = (List<String>) request.getAttribute("restaurantNames");
            List<List<OrderItem>> allOrderItems = (List<List<OrderItem>>) request.getAttribute("allOrderItems");
            List<List<String>> allItemNames = (List<List<String>>) request.getAttribute("allItemNames");

            if (orders == null || orders.isEmpty()) {
        %>
        <div class="text-center" style="margin-top: 80px;">
            <span style="font-size: 80px; display: block; margin-bottom: 24px; opacity: 0.5;">📋</span>
            <h1 class="form-title" style="margin-bottom: 16px;">NO ORDERS YET</h1>
            <p style="color: var(--color-blush-highlight); margin-bottom: 32px; font-size: 16px;">You haven't placed any orders yet. Let's change that!</p>
            <a href="RestaurantServlet" class="btn-primary" style="font-size: 16px; padding: 14px 28px;">ORDER NOW ›</a>
        </div>
        <%
            } else {
                for (int i = 0; i < orders.size(); i++) {
                    Order order = orders.get(i);
                    String restName = restaurantNames.get(i);
                    List<OrderItem> items = allOrderItems.get(i);
                    List<String> itemNames = allItemNames.get(i);
        %>
        <div class="order-card">
            <div class="order-header">
                <div class="order-header-left">
                    <div class="info-group">
                        <span class="info-label">Order Placed</span>
                        <span class="info-value"><%= order.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(order.getCreatedDate()) : "N/A" %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Order ID</span>
                        <span class="info-value">#<%= order.getOrderId() %></span>
                    </div>
                    <div class="info-group">
                        <span class="info-label">Payment</span>
                        <span class="info-value"><%= order.getPaymentMode() %></span>
                    </div>
                </div>
                <span class="order-status"><%= order.getStatus() %></span>
            </div>

            <div class="order-body">
                <div class="restaurant-name"><%= restName %></div>
                <ul class="item-list">
                    <%
                        for (int j = 0; j < items.size(); j++) {
                            OrderItem item = items.get(j);
                            String itemName = itemNames.get(j);
                    %>
                    <li class="item-row">
                        <div class="item-left">
                            <span class="item-qty">×<%= item.getQuantity() %></span>
                            <span class="item-name"><%= itemName %></span>
                        </div>
                        <span class="item-price">₹<%= String.format("%.2f", item.getItemTotal()) %></span>
                    </li>
                    <% } %>
                </ul>
            </div>

            <div class="order-footer">
                <div class="delivery-address">
                    <strong>Deliver to:</strong> <%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "N/A" %>
                </div>
                <div class="order-total">₹<%= String.format("%.2f", order.getTotalAmount()) %></div>
            </div>
        </div>
        <% } } %>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
