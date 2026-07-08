<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Cart" %>
<%@ page import="com.dcl.model.CartItem" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - Food Delivery</title>
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
        
        .checkout-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        
        .checkout-form {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .form-section h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #ff6b6b;
            padding-bottom: 10px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: Arial, sans-serif;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #ff6b6b;
            box-shadow: 0 0 5px rgba(255, 107, 107, 0.3);
        }
        
        .user-info {
            display: flex;
            gap: 20px;
        }
        
        .user-info-field {
            flex: 1;
        }
        
        .user-info-field label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }
        
        .user-info-field p {
            padding: 12px;
            background-color: #f5f5f5;
            border: 1px solid #ddd;
            border-radius: 5px;
            color: #666;
        }
        
        .order-summary {
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
        
        .order-items {
            margin-bottom: 15px;
            max-height: 300px;
            overflow-y: auto;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
            color: #666;
        }
        
        .order-item-name {
            flex: 1;
        }
        
        .order-item-qty {
            color: #999;
            margin: 0 10px;
        }
        
        .order-item-price {
            font-weight: bold;
            color: #333;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            color: #666;
            font-size: 14px;
        }
        
        .summary-total {
            display: flex;
            justify-content: space-between;
            padding-top: 12px;
            border-top: 2px solid #eee;
            margin-top: 12px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }
        
        .submit-btn {
            width: 100%;
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 20px;
            font-weight: bold;
        }
        
        .submit-btn:hover {
            background-color: #ff5252;
        }
        
        .submit-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .required {
            color: #ff6b6b;
        }
        
        @media (max-width: 768px) {
            .checkout-container {
                grid-template-columns: 1fr;
            }
            
            .order-summary {
                position: static;
            }
            
            .user-info {
                flex-direction: column;
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
        <a href="CartServlet" class="back-button">← Back to Cart</a>
        
        <h2>Checkout</h2>
        
        <%
            String error = (String) request.getAttribute("error");
            Cart cart = (Cart) request.getAttribute("cart");
            User user = (User) request.getAttribute("user");
            
            if (error != null) {
        %>
            <div class="error-message"><%= error %></div>
        <%
            }
            
            if (cart != null && !cart.isEmpty() && user != null) {
                List<CartItem> items = cart.getItems();
                double subtotal = cart.getCartTotal();
                double deliveryFee = 40;
                double gst = subtotal * 0.05;
                double totalAmount = subtotal + deliveryFee + gst;
        %>
        
        <div class="checkout-container">
            <form class="checkout-form" action="checkout" method="post">
                <!-- User Information Section -->
                <div class="form-section">
                    <h3>Your Information</h3>
                    
                    <div class="user-info">
                        <div class="user-info-field">
                            <label>Name</label>
                            <p><%= user.getFullName() != null ? user.getFullName() : user.getUsername() %></p>
                        </div>
                        
                        <div class="user-info-field">
                            <label>Email</label>
                            <p><%= user.getEmail() %></p>
                        </div>
                    </div>
                </div>
                
                <!-- Delivery Address Section -->
                <div class="form-section">
                    <h3>Delivery Address</h3>
                    
                    <div class="form-group">
                        <label for="address">Address <span class="required">*</span></label>
                        <textarea id="address" name="address" placeholder="Enter your full delivery address (house no., street, city, postal code)" required></textarea>
                    </div>
                </div>
                
                <!-- Payment Method Section -->
                <div class="form-section">
                    <h3>Payment Method</h3>
                    
                    <div class="form-group">
                        <label for="paymentMethod">Select Payment Method <span class="required">*</span></label>
                        <select id="paymentMethod" name="paymentMethod" required>
                            <option value="">-- Choose Payment Method --</option>
                            <option value="Credit Card">💳 Credit Card</option>
                            <option value="Debit Card">🏦 Debit Card</option>
                            <option value="UPI">📱 UPI</option>
                            <option value="Cash on Delivery">💵 Cash on Delivery</option>
                        </select>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn">Place Order</button>
            </form>
            
            <!-- Order Summary Section -->
            <div class="order-summary">
                <div class="summary-title">Order Summary</div>
                
                <div class="order-items">
                    <%
                        for (CartItem item : items) {
                    %>
                    <div class="order-item">
                        <div class="order-item-name"><%= item.getItemName() %></div>
                        <div class="order-item-qty">x<%= item.getQuantity() %></div>
                        <div class="order-item-price">₹<%= String.format("%.0f", item.getItemTotal()) %></div>
                    </div>
                    <%
                        }
                    %>
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
                
                <div class="summary-total">
                    <span>Total Amount</span>
                    <span>₹<%= String.format("%.0f", totalAmount) %></span>
                </div>
            </div>
        </div>
        
        <%
            } else {
        %>
        
        <div style="background: white; border-radius: 8px; padding: 60px 20px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <p style="color: #666; margin-bottom: 20px;">Your cart is empty or you are not logged in.</p>
            <a href="CartServlet" class="back-button">← Back to Cart</a>
        </div>
        
        <%
            }
        %>
    </div>
</body>
</html>
