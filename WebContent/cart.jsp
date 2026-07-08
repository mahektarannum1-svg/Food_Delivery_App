<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Cart" %>
<%@ page import="com.dcl.model.CartItem" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart - Food Delivery</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        
        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px 20px;
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .navbar h1 {
            color: #ff6b6b;
            font-size: 24px;
        }
        
        .nav-links a {
            color: #333;
            text-decoration: none;
            margin-left: 20px;
        }
        
        .nav-links a:hover {
            color: #ff6b6b;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .back-button {
            background-color: #ff6b6b;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            text-decoration: none;
            display: inline-block;
        }
        
        .back-button:hover {
            background-color: #ff5252;
        }
        
        h2 {
            margin-bottom: 30px;
            color: #333;
        }
        
        .cart-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        
        .cart-items {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .cart-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-price {
            font-size: 14px;
            color: #999;
        }
        
        .item-quantity {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 20px;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0 20px;
        }
        
        .quantity-controls form {
            margin: 0;
        }
        
        .quantity-controls p {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
            min-width: 30px;
            text-align: center;
        }
        
        .quantity-btn {
            background-color: #ff6b6b;
            color: white;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px;
        }
        
        .quantity-btn:hover {
            background-color: #ff5252;
        }
        
        .quantity-display {
            font-size: 16px;
            font-weight: bold;
            min-width: 30px;
            text-align: center;
        }
        
        .item-total {
            font-size: 18px;
            font-weight: bold;
            color: #ff6b6b;
            min-width: 80px;
            text-align: right;
        }
        
        .remove-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
        }
        
        .remove-btn:hover {
            background-color: #c0392b;
        }
        
        .cart-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 100px;
        }
        
        .summary-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            color: #333;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            color: #666;
        }
        
        .summary-total {
            display: flex;
            justify-content: space-between;
            padding-top: 15px;
            border-top: 2px solid #eee;
            margin-top: 15px;
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        
        .checkout-btn {
            width: 100%;
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
        }
        
        .checkout-btn:hover {
            background-color: #ff5252;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .empty-cart-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }
        
        .empty-cart h3 {
            color: #666;
            margin-bottom: 20px;
        }
        
        @media (max-width: 768px) {
            .cart-container {
                grid-template-columns: 1fr;
            }
            
            .cart-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .item-quantity {
                margin: 10px 0;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div class="nav-links" style="display: flex; align-items: center;">
            <a href="index.jsp">Home</a>
            <a href="RestaurantServlet">Restaurants</a>
             <a href="CartServlet" style="margin-right: 20px;">🛒 View Cart</a>
             <% 
                 User currentUser = (User) session.getAttribute("user");
                 if (currentUser != null) {
             %>
                 <span style="margin-right: 20px; font-weight: bold; color: #333;">Welcome, <%= currentUser.getUsername() %>!</span>
                 <a href="OrderHistoryServlet" style="margin-right: 20px;">📋 My Orders</a>
                 <a href="UserServlet?action=logout" style="color: #c33; text-decoration: none; border: 1px solid #c33; padding: 4px 8px; border-radius: 4px; margin-left: 0;">Logout</a>
            <% } else { %>
                <a href="login.jsp" style="color: #333; text-decoration: none; border: 1px solid #333; padding: 4px 8px; border-radius: 4px; margin-left: 0;">Login / Register</a>
            <% } %>
        </div>
    </div>
    
    <div class="container">
        <a href="RestaurantServlet" class="back-button">← Continue Shopping</a>
        
        <h2>Shopping Cart</h2>
        
        <%
            Cart cart = (Cart) request.getAttribute("cart");
            Integer restaurantId = (Integer) request.getAttribute("restaurantId");
            
            if (cart == null || cart.isEmpty()) {
        %>
            <div class="empty-cart">
                <div class="empty-cart-icon">🛒</div>
                <h3>Your cart is empty</h3>
                <p style="color: #999; margin-bottom: 20px;">Add some delicious items to get started!</p>
                <a href="RestaurantServlet" class="back-button">Browse Restaurants</a>
            </div>
        <%
            } else {
                List<CartItem> items = cart.getItems();
                double cartTotal = cart.getCartTotal();
        %>
            <div class="cart-container">
                <div class="cart-items">
                    <%
                        for (CartItem item : items) {
                    %>
                    <div class="cart-item">
                        <div class="item-details">
                            <div class="item-name"><%= item.getItemName() %></div>
                            <div class="item-price">₹<%= String.format("%.0f", item.getItemPrice()) %> per item</div>
                        </div>
                        
                        <div class="quantity-controls">
                            <form action="CartServlet" method="post" style="display: inline;">
                                <input type="hidden" name="itemId" value="<%= item.getCartItemId() %>">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="quantity" value="<%= item.getQuantity() + 1 %>">
                                <button class="quantity-btn">+</button>
                            </form>
                            <p><%= item.getQuantity() %></p>
                            <form action="CartServlet" method="post" style="display: inline;">
                                <input type="hidden" name="itemId" value="<%= item.getCartItemId() %>">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="quantity" value="<%= item.getQuantity() - 1 %>">
                                <button class="quantity-btn" <% if (item.getQuantity() == 1) { %>disabled<% } %>>−</button>
                            </form>
                        </div>
                        
                        <div class="item-total">₹<%= String.format("%.0f", item.getItemTotal()) %></div>
                        
                        <form action="CartServlet" method="post" style="display: inline; margin: 0;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                            <button type="submit" class="remove-btn">Remove</button>
                        </form>
                    </div>
                    <%
                        }
                    %>
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
                    
                    <div class="summary-total">
                        <span>Total Amount</span>
                        <span>₹<%= String.format("%.0f", cartTotal + 40 + (cartTotal * 0.05)) %></span>
                    </div>
                    
                    <form action="checkout" method="get">
                        <button type="submit" class="checkout-btn">Proceed to Checkout</button>
                    </form>
                </div>
            </div>
        <%
            }
        %>
    </div>
    
    <script>
        // Remove confirmation
        document.querySelectorAll('.remove-btn').forEach(btn => {
            btn.parentElement.addEventListener('submit', function(e) {
                if (!confirm('Are you sure you want to remove this item?')) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
