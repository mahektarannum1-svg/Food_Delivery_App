<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation - Food Delivery</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .navbar {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 15px 20px;
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
        
        .confirmation-container {
            background: white;
            border-radius: 12px;
            padding: 50px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 600px;
            width: 90%;
            text-align: center;
            margin-top: 80px;
        }
        
        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
            animation: scaleIn 0.6s ease-out;
        }
        
        .confirmation-title {
            font-size: 32px;
            color: #333;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .confirmation-subtitle {
            font-size: 16px;
            color: #666;
            margin-bottom: 40px;
        }
        
        .order-details {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: #666;
            font-weight: bold;
        }
        
        .detail-value {
            color: #333;
            font-weight: bold;
        }
        
        .order-id-box {
            background-color: #fff3cd;
            border-left: 4px solid #ff6b6b;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .order-id-label {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .order-id-value {
            font-size: 24px;
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .total-amount {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        
        .total-label {
            color: #666;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .total-value {
            font-size: 36px;
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .delivery-time {
            background-color: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 30px;
        }
        
        .delivery-time-text {
            color: #2e7d32;
            font-weight: bold;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #ff6b6b;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff5252;
        }
        
        .btn-secondary {
            background-color: #f0f0f0;
            color: #333;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        
        .info-message {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
            color: #1565c0;
            padding: 15px;
            border-radius: 4px;
            margin-top: 30px;
            font-size: 14px;
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
                opacity: 0;
            }
            to {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        @media (max-width: 768px) {
            .confirmation-container {
                padding: 30px;
                margin-top: 80px;
            }
            
            .confirmation-title {
                font-size: 24px;
            }
            
            .success-icon {
                font-size: 60px;
            }
            
            .total-value {
                font-size: 28px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div class="nav-links" style="display: flex; align-items: center;">
            <a href="index.jsp" style="margin-right: 20px;">Home</a>
            <a href="RestaurantServlet" style="margin-right: 20px;">Restaurants</a>
            <% 
                com.dcl.model.User currentUser = (com.dcl.model.User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span style="margin-right: 20px; font-weight: bold; color: #333;">Welcome, <%= currentUser.getUsername() %>!</span>
                <a href="OrderHistoryServlet" style="color: #333; text-decoration: none; margin-right: 20px;">📋 My Orders</a>
                <a href="UserServlet?action=logout" style="color: #c33; text-decoration: none; border: 1px solid #c33; padding: 4px 8px; border-radius: 4px; margin-left: 0;">Logout</a>
            <% } else { %>
                <a href="login.jsp" style="color: #333; text-decoration: none; border: 1px solid #333; padding: 4px 8px; border-radius: 4px; margin-left: 0;">Login / Register</a>
            <% } %>
        </div>
    </div>
    
    <div class="confirmation-container">
        <%
            Boolean orderConfirmed = (Boolean) session.getAttribute("orderConfirmed");
            Integer orderId = (Integer) session.getAttribute("orderId");
            Double orderTotal = (Double) session.getAttribute("orderTotal");
            Double deliveryFee = (Double) session.getAttribute("deliveryFee");
            Double gst = (Double) session.getAttribute("gst");
            
            // Clear the session attributes after retrieving
            session.removeAttribute("orderConfirmed");
            session.removeAttribute("orderId");
            session.removeAttribute("orderTotal");
            session.removeAttribute("deliveryFee");
            session.removeAttribute("gst");
            
            if (orderConfirmed != null && orderConfirmed == true && orderId != null) {
        %>
        
        <div class="success-icon">✅</div>
        
        <div class="confirmation-title">Order Confirmed!</div>
        <div class="confirmation-subtitle">Thank you for your order. We're preparing your delicious food!</div>
        
        <div class="order-details">
            <div class="order-id-box">
                <div class="order-id-label">Order ID</div>
                <div class="order-id-value">#<%= orderId %></div>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Order Status</span>
                <span class="detail-value">Confirmed</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Order Date</span>
                <span class="detail-value"><%= new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(new java.util.Date()) %></span>
            </div>
        </div>
        
        <div class="total-amount">
            <div class="total-label">Total Amount Payable</div>
            <div class="total-value">₹<%= String.format("%.0f", orderTotal) %></div>
        </div>
        
        <div class="delivery-time">
            <div class="delivery-time-text">⏱️ Estimated Delivery: 30-45 minutes</div>
        </div>
        
        <div class="info-message">
            <strong>💡 Tip:</strong> You can track your order status in the My Orders section. Our delivery partner will contact you before delivery.
        </div>
        
        <div class="action-buttons">
            <a href="RestaurantServlet" class="btn btn-primary">Order More Food</a>
            <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
        </div>
        
        <%
            } else {
        %>
        
        <div class="success-icon">⚠️</div>
        <div class="confirmation-title">Oops!</div>
        <div class="confirmation-subtitle">Something went wrong with your order.</div>
        
        <div class="action-buttons">
            <a href="CartServlet" class="btn btn-primary">Back to Cart</a>
            <a href="index.jsp" class="btn btn-secondary">Back to Home</a>
        </div>
        
        <%
            }
        %>
    </div>
</body>
</html>
