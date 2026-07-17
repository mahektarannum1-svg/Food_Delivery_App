<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .page-body {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 80px 24px 60px;
        }
        
        .confirm-card {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-cards);
            padding: 48px;
            max-width: 600px;
            width: 100%;
            text-align: center;
        }
        
        .success-emoji { font-size: 80px; display: block; margin-bottom: 24px; }
        .warning-emoji { font-size: 80px; display: block; margin-bottom: 24px; }
        
        .confirm-sub {
            font-size: 16px;
            color: var(--color-blush-highlight);
            margin-bottom: 40px;
        }
        
        .order-id-box {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: 8px;
            padding: 16px 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .order-id-label {
            font-family: var(--font-sans-meat);
            font-size: 16px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
        }
        .order-id-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 28px;
            color: var(--color-impossible-red);
        }
        
        .detail-list {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            text-align: left;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--color-butcher-black);
        }
        .detail-row:last-child { border-bottom: none; }
        .detail-label {
            font-family: var(--font-sans-meat);
            font-size: 16px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
        }
        .detail-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            color: var(--color-bone-white);
        }
        
        .total-box {
            background-color: var(--color-impossible-red);
            border: 1px solid var(--color-butcher-black);
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
        }
        .total-label {
            font-family: var(--font-sans-meat);
            font-size: 16px;
            color: var(--color-bone-white);
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .total-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 48px;
            color: var(--color-bone-white);
            line-height: 1;
        }
        
        .delivery-banner {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-left: 4px solid #00c060;
            padding: 16px;
            margin-bottom: 24px;
            text-align: left;
        }
        .delivery-text {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            color: #80f0b0;
            text-transform: uppercase;
        }
        
        .info-banner {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-left: 4px solid #2196f3;
            padding: 16px;
            margin-bottom: 32px;
            text-align: left;
            font-size: 14px;
            color: rgba(173,216,255,0.8);
            line-height: 1.5;
        }
        
        .action-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        
        .btn-secondary {
            background: transparent;
            color: var(--color-bone-white);
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            text-transform: uppercase;
            padding: 14px 28px;
            border-radius: var(--radius-buttons);
            border: 2px solid var(--color-butcher-black);
            cursor: pointer;
            text-decoration: none;
        }
        .btn-secondary:hover { background-color: var(--color-butcher-black); }
        
        @media (max-width: 600px) {
            .confirm-card { padding: 32px 24px; }
            .action-buttons { flex-direction: column; }
            .btn-primary, .btn-secondary { width: 100%; text-align: center; }
            .order-id-box { flex-direction: column; gap: 8px; text-align: center; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
            <%
                com.dcl.model.User currentUser = (com.dcl.model.User) session.getAttribute("user");
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

    <div class="page-body">
        <div class="confirm-card">
            <%
                Boolean orderConfirmed = (Boolean) session.getAttribute("orderConfirmed");
                Integer orderId = (Integer) session.getAttribute("orderId");
                Double orderTotal = (Double) session.getAttribute("orderTotal");
                Double deliveryFee = (Double) session.getAttribute("deliveryFee");
                Double gst = (Double) session.getAttribute("gst");

                session.removeAttribute("orderConfirmed");
                session.removeAttribute("orderId");
                session.removeAttribute("orderTotal");
                session.removeAttribute("deliveryFee");
                session.removeAttribute("gst");

                if (orderConfirmed != null && orderConfirmed == true && orderId != null) {
            %>
            <span class="success-emoji">✅</span>
            <p class="section-bracket-eyebrow">◂ Order Placed ▸</p>
            <h1 class="section-display" style="margin-bottom: 16px;">ORDER CONFIRMED</h1>
            <p class="confirm-sub">Thank you for your order. We're preparing your delicious food!</p>

            <div class="order-id-box">
                <span class="order-id-label">Order ID</span>
                <span class="order-id-value">#<%= orderId %></span>
            </div>

            <div class="detail-list">
                <div class="detail-row">
                    <span class="detail-label">Status</span>
                    <span class="detail-value">✓ Confirmed</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Date</span>
                    <span class="detail-value"><%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(new java.util.Date()) %></span>
                </div>
            </div>

            <div class="total-box">
                <div class="total-label">Total Amount Paid</div>
                <div class="total-value">₹<%= String.format("%.0f", orderTotal) %></div>
            </div>

            <div class="delivery-banner">
                <div class="delivery-text">⏱ Estimated Delivery: 30–45 minutes</div>
            </div>

            <div class="info-banner">
                <strong>💡 Tip:</strong> Track your order in the My Orders section. Our delivery partner will contact you before arrival.
            </div>

            <div class="action-buttons">
                <a href="RestaurantServlet" class="btn-primary" style="font-size: 16px; padding: 14px 28px;">ORDER MORE ›</a>
                <a href="index.jsp" class="btn-secondary">BACK TO HOME</a>
            </div>
            <% } else { %>
            <span class="warning-emoji">⚠️</span>
            <p class="section-bracket-eyebrow">◂ Something Went Wrong ▸</p>
            <h1 class="section-display" style="margin-bottom: 16px;">OOPS!</h1>
            <p class="confirm-sub">Something went wrong with your order. Please try again.</p>

            <div class="action-buttons">
                <a href="CartServlet" class="btn-primary" style="font-size: 16px; padding: 14px 28px;">BACK TO CART ›</a>
                <a href="index.jsp" class="btn-secondary">BACK TO HOME</a>
            </div>
            <% } %>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="footer" style="margin-top: auto;">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
