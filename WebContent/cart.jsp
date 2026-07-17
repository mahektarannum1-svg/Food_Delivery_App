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
    <title>Your Cart — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .cart-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-top: 40px;
        }
        @media (max-width: 900px) { .cart-layout { grid-template-columns: 1fr; } }
        
        .cart-items-panel, .cart-summary {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-cards);
        }
        
        .panel-header {
            padding: 16px 24px;
            border-bottom: 1px solid var(--color-butcher-black);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .panel-title {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-bone-white);
            text-transform: uppercase;
        }
        .panel-count {
            font-family: var(--font-sans-meat);
            font-size: 14px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
        }
        
        .cart-item {
            display: flex;
            align-items: center;
            padding: 16px 24px;
            border-bottom: 1px solid var(--color-butcher-black);
            gap: 16px;
        }
        .cart-item:last-child { border-bottom: none; }
        
        .item-icon {
            width: 48px;
            height: 48px;
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .item-details { flex: 1; }
        .item-name {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 18px;
            color: var(--color-bone-white);
            text-transform: uppercase;
        }
        .item-unit-price {
            font-size: 14px;
            color: var(--color-blush-highlight);
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-buttons);
            overflow: hidden;
        }
        .qty-btn {
            background: transparent;
            color: var(--color-bone-white);
            border: none;
            width: 32px;
            height: 32px;
            font-weight: 700;
            font-family: var(--font-sans-meat);
            cursor: pointer;
        }
        .qty-btn:hover { background-color: var(--color-impossible-red); }
        .qty-display {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            color: var(--color-bone-white);
            width: 32px;
            text-align: center;
        }
        
        .item-total {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 22px;
            color: var(--color-impossible-red);
            min-width: 80px;
            text-align: right;
        }
        
        .btn-remove {
            background: transparent;
            color: var(--color-blush-highlight);
            border: none;
            cursor: pointer;
            font-size: 18px;
            width: 32px;
            height: 32px;
        }
        .btn-remove:hover { color: var(--color-impossible-red); }
        
        .cart-summary {
            padding: 24px;
            height: fit-content;
        }
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
        
        .empty-icon { font-size: 80px; display: block; text-align: center; margin-bottom: 24px; opacity: 0.5; }
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
        <a href="RestaurantServlet" class="nav-welcome" style="margin-bottom: 24px; display: inline-block;">← CONTINUE SHOPPING</a>
        <p class="section-bracket-eyebrow">◂ Your Selection ▸</p>
        <h1 class="section-display" style="margin-bottom: 0;">YOUR CART</h1>
    </div>

    <div style="max-width: 1280px; margin: 0 auto; padding: 0 24px 80px; width: 100%;">
        <%
            Cart cart = (Cart) request.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
        %>
        <div class="text-center" style="margin-top: 80px;">
            <span class="empty-icon">🛒</span>
            <h1 class="form-title" style="margin-bottom: 16px;">CART'S EMPTY</h1>
            <p style="color: var(--color-blush-highlight); margin-bottom: 32px;">Add some delicious items to get started!</p>
            <a href="RestaurantServlet" class="btn-primary" style="font-size: 16px; padding: 14px 28px;">Browse Restaurants ›</a>
        </div>
        <%
            } else {
                List<CartItem> items = cart.getItems();
                double cartTotal = cart.getCartTotal();
        %>
        <div class="cart-layout">
            <div class="cart-items-panel">
                <div class="panel-header">
                    <span class="panel-title">Items</span>
                    <span class="panel-count"><%= items.size() %> item<%= items.size() != 1 ? "s" : "" %></span>
                </div>
                <% for (CartItem item : items) { %>
                <div class="cart-item">
                    <div class="item-icon">🍽️</div>
                    <div class="item-details">
                        <div class="item-name"><%= item.getItemName() %></div>
                        <div class="item-unit-price">₹<%= String.format("%.0f", item.getItemPrice()) %> per item</div>
                    </div>
                    
                    <div class="quantity-controls">
                        <form action="CartServlet" method="post" style="margin: 0; display: inline;">
                            <input type="hidden" name="itemId" value="<%= item.getCartItemId() %>">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                            <button class="qty-btn" type="submit" <%= item.getQuantity() == 1 ? "disabled" : "" %>>−</button>
                        </form>
                        <span class="qty-display"><%= item.getQuantity() %></span>
                        <form action="CartServlet" method="post" style="margin: 0; display: inline;">
                            <input type="hidden" name="itemId" value="<%= item.getCartItemId() %>">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                            <button class="qty-btn" type="submit">+</button>
                        </form>
                    </div>

                    <div class="item-total">₹<%= String.format("%.0f", item.getItemTotal()) %></div>

                    <form action="CartServlet" method="post" style="margin: 0; display: inline;" onsubmit="return confirm('Remove this item?')">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                        <button type="submit" class="btn-remove">✕</button>
                    </form>
                </div>
                <% } %>
            </div>

            <div class="cart-summary">
                <div class="summary-title">Order Summary</div>
                <div class="summary-row">
                    <span>Items (<%= items.size() %>)</span>
                    <span>₹<%= String.format("%.0f", cartTotal) %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>₹40</span>
                </div>
                <div class="summary-row">
                    <span>GST (5%)</span>
                    <span>₹<%= String.format("%.0f", cartTotal * 0.05) %></span>
                </div>
                <hr class="summary-divider">
                <div class="summary-total">
                    <span class="summary-total-label">Total</span>
                    <span class="summary-total-value">₹<%= String.format("%.0f", cartTotal + 40 + (cartTotal * 0.05)) %></span>
                </div>
                <form action="checkout" method="get" style="margin-top: 32px;">
                    <button type="submit" class="btn-primary" style="width: 100%; font-size: 16px; padding: 14px 24px;">PROCEED TO CHECKOUT ›</button>
                </form>
            </div>
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
