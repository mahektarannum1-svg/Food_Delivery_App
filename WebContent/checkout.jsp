<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Cart" %>
<%@ page import="com.dcl.model.CartItem" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .checkout-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-top: 40px;
        }
        @media (max-width: 900px) { .checkout-layout { grid-template-columns: 1fr; } }
        
        .checkout-form-panel, .order-summary-panel {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-cards);
            padding: 32px;
        }
        .order-summary-panel {
            height: fit-content;
        }
        
        .form-section { margin-bottom: 32px; }
        .form-section-title {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-bone-white);
            text-transform: uppercase;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--color-impossible-red);
            margin-bottom: 20px;
        }
        
        .user-info-row { display: flex; gap: 16px; margin-bottom: 16px; }
        .user-info-field { flex: 1; }
        .info-label-text {
            display: block;
            font-family: var(--font-sans-meat);
            font-size: 14px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .info-value-box {
            padding: 12px 16px;
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: 4px;
            color: var(--color-bone-white);
        }
        
        .required-star { color: var(--color-impossible-red); }
        
        textarea.form-input { resize: vertical; min-height: 100px; }
        select.form-input {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%23ffc7c6' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 40px;
        }
        select.form-input option { background: var(--color-burgundy-stage); color: var(--color-bone-white); }
        
        .summary-title {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 24px;
            color: var(--color-bone-white);
            text-transform: uppercase;
            margin-bottom: 24px;
            border-bottom: 1px solid var(--color-butcher-black);
            padding-bottom: 12px;
        }
        .order-items-list {
            margin-bottom: 24px;
            border-bottom: 1px solid var(--color-butcher-black);
            padding-bottom: 16px;
        }
        .order-item-row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 12px;
            font-size: 14px;
        }
        .order-item-name { flex: 1; color: var(--color-bone-white); }
        .order-item-qty {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-impossible-red);
            margin: 0 12px;
        }
        .order-item-price {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-bone-white);
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 16px;
            font-size: 16px;
            color: var(--color-blush-highlight);
        }
        .summary-row span:last-child { color: var(--color-bone-white); }
        .summary-divider {
            border: none;
            border-top: 1px solid var(--color-butcher-black);
            margin: 16px 0;
        }
        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .summary-total-label {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-bone-white);
            text-transform: uppercase;
        }
        .summary-total-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 32px;
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
        <a href="CartServlet" class="nav-welcome" style="margin-bottom: 24px; display: inline-block;">← BACK TO CART</a>
        <p class="section-bracket-eyebrow">◂ Almost There ▸</p>
        <h1 class="section-display" style="margin-bottom: 0;">CHECKOUT</h1>
    </div>

    <div style="max-width: 1280px; margin: 0 auto; padding: 0 24px 80px; width: 100%;">
        <%
            String error = (String) request.getAttribute("error");
            Cart cart = (Cart) request.getAttribute("cart");
            User user = (User) request.getAttribute("user");

            if (error != null) {
        %>
            <div class="alert-error"><%= error %></div>
        <%
            }

            if (cart != null && !cart.isEmpty() && user != null) {
                List<CartItem> items = cart.getItems();
                double subtotal = cart.getCartTotal();
                double deliveryFee = 40;
                double gst = subtotal * 0.05;
                double totalAmount = subtotal + deliveryFee + gst;
        %>
        
        <div class="checkout-layout">
            <form class="checkout-form-panel" action="checkout" method="post">
                <div class="form-section">
                    <div class="form-section-title">YOUR INFORMATION</div>
                    <div class="user-info-row">
                        <div class="user-info-field">
                            <span class="info-label-text">Name</span>
                            <div class="info-value-box"><%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></div>
                        </div>
                        <div class="user-info-field">
                            <span class="info-label-text">Email</span>
                            <div class="info-value-box"><%= user.getEmail() %></div>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="form-section-title">DELIVERY ADDRESS</div>
                    <div class="form-group">
                        <label class="form-label" for="address">Address <span class="required-star">*</span></label>
                        <textarea class="form-input" id="address" name="address" placeholder="House no., Street, City, Postal code" required></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <div class="form-section-title">PAYMENT METHOD</div>
                    <div class="form-group">
                        <label class="form-label" for="paymentMethod">Select Method <span class="required-star">*</span></label>
                        <select class="form-input" id="paymentMethod" name="paymentMethod" required>
                            <option value="">-- Choose Payment Method --</option>
                            <option value="Credit Card">Credit Card</option>
                            <option value="Debit Card">Debit Card</option>
                            <option value="UPI">UPI</option>
                            <option value="Cash on Delivery">Cash on Delivery</option>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; font-size: 16px; padding: 14px 24px;">PLACE ORDER ›</button>
            </form>

            <div class="order-summary-panel">
                <div class="summary-title">Order Summary</div>
                <div class="order-items-list">
                    <% for (CartItem item : items) { %>
                    <div class="order-item-row">
                        <span class="order-item-name"><%= item.getItemName() %></span>
                        <span class="order-item-qty">×<%= item.getQuantity() %></span>
                        <span class="order-item-price">₹<%= String.format("%.0f", item.getItemTotal()) %></span>
                    </div>
                    <% } %>
                </div>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%.0f", subtotal) %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>₹<%= String.format("%.0f", deliveryFee) %></span>
                </div>
                <div class="summary-row">
                    <span>GST (5%)</span>
                    <span>₹<%= String.format("%.0f", gst) %></span>
                </div>
                <hr class="summary-divider">
                <div class="summary-total">
                    <span class="summary-total-label">Total</span>
                    <span class="summary-total-value">₹<%= String.format("%.0f", totalAmount) %></span>
                </div>
            </div>
        </div>
        
        <% } else { %>
        <div class="text-center" style="margin-top: 80px;">
            <p style="color: var(--color-blush-highlight); margin-bottom: 32px; font-size: 20px;">Cart is empty or you are not logged in.</p>
            <a href="CartServlet" class="btn-primary">← BACK TO CART</a>
        </div>
        <% } %>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
