<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Order" %>
<%@ page import="com.dcl.model.OrderItem" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - Food Delivery App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            color: #333;
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
        
        .navbar a {
            color: #333;
            text-decoration: none;
            margin-left: 20px;
        }
        
        .navbar a:hover {
            color: #ff6b6b;
        }
        
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        h2 {
            margin-bottom: 30px;
            color: #333;
        }
        
        .order-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            overflow: hidden;
            border-left: 5px solid #ff6b6b;
        }
        
        .order-header {
            background-color: #fafafa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .order-header-left {
            display: flex;
            gap: 25px;
        }
        
        .info-group {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 11px;
            text-transform: uppercase;
            color: #777;
            font-weight: bold;
            margin-bottom: 3px;
        }
        
        .info-value {
            font-size: 14px;
            font-weight: 500;
        }
        
        .order-status {
            background-color: #e8f5e9;
            color: #2e7d32;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
            align-self: center;
        }
        
        .order-body {
            padding: 20px;
        }
        
        .restaurant-name {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        
        .item-list {
            list-style: none;
            margin-bottom: 15px;
        }
        
        .item-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px dashed #f0f0f0;
            font-size: 14px;
        }
        
        .item-row:last-child {
            border-bottom: none;
        }
        
        .item-details {
            display: flex;
            gap: 10px;
        }
        
        .item-qty {
            color: #ff6b6b;
            font-weight: bold;
        }
        
        .item-price {
            font-weight: bold;
        }
        
        .order-footer {
            background-color: #fafafa;
            padding: 15px 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .delivery-address {
            font-size: 13px;
            color: #666;
            max-width: 60%;
        }
        
        .order-total {
            font-size: 18px;
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .no-orders {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .no-orders p {
            font-size: 18px;
            color: #666;
            margin-bottom: 20px;
        }
        
        .btn {
            background-color: #ff6b6b;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.2s;
            display: inline-block;
        }
        
        .btn:hover {
            background-color: #ff5252;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div style="display: flex; align-items: center;">
            <a href="RestaurantServlet">Restaurants</a>
            <% 
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span style="margin-left: 20px; font-weight: bold;">Welcome, <%= currentUser.getUsername() %>!</span>
                <a href="CartServlet">🛒 View Cart</a>
                <a href="UserServlet?action=logout" style="color: #c33; border: 1px solid #c33; padding: 4px 8px; border-radius: 4px;">Logout</a>
            <% } else { %>
                <a href="login.jsp" style="border: 1px solid #333; padding: 4px 8px; border-radius: 4px;">Login / Register</a>
            <% } %>
        </div>
    </div>
    
    <div class="container">
        <h2>My Order History</h2>
        
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            List<String> restaurantNames = (List<String>) request.getAttribute("restaurantNames");
            List<List<OrderItem>> allOrderItems = (List<List<OrderItem>>) request.getAttribute("allOrderItems");
            List<List<String>> allItemNames = (List<List<String>>) request.getAttribute("allItemNames");
            
            if (orders == null || orders.isEmpty()) {
        %>
            <div class="no-orders">
                <p>You haven't placed any orders yet!</p>
                <a href="RestaurantServlet" class="btn">Order Now</a>
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
                            <span class="info-value">
                                <%= order.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(order.getCreatedDate()) : "N/A" %>
                            </span>
                        </div>
                        <div class="info-group">
                            <span class="info-label">Order ID</span>
                            <span class="info-value">#<%= order.getOrderId() %></span>
                        </div>
                        <div class="info-group">
                            <span class="info-label">Payment Mode</span>
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
                                <div class="item-details">
                                    <span class="item-qty">x<%= item.getQuantity() %></span>
                                    <span><%= itemName %></span>
                                </div>
                                <span class="item-price">₹<%= String.format("%.2f", item.getItemTotal()) %></span>
                            </li>
                        <%
                            }
                        %>
                    </ul>
                </div>
                
                <div class="order-footer">
                    <div class="delivery-address">
                        <strong>Deliver to:</strong> <%= order.getDeliveryAddress() != null ? order.getDeliveryAddress() : "N/A" %>
                    </div>
                    <div class="order-total">
                        Total Paid: ₹<%= String.format("%.2f", order.getTotalAmount()) %>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>
