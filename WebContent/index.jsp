<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home - Food Delivery App</title>
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
            margin: 0 15px;
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .navbar a:hover {
            color: #ff6b6b;
        }
        
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 20px;
            text-align: center;
        }
        
        .hero h1 {
            font-size: 48px;
            margin-bottom: 10px;
        }
        
        .hero p {
            font-size: 20px;
            margin-bottom: 30px;
        }
        
        .btn {
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 12px 30px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #ff5252;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 60px;
        }
        
        .feature-card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .feature-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .feature-card h3 {
            margin-bottom: 10px;
            color: #333;
        }
        
        .feature-card p {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div>
            <a href="index.jsp">Home</a>
            <a href="RestaurantServlet">Restaurants</a>
             <%
                 com.dcl.model.User currentUser = (com.dcl.model.User) session.getAttribute("user");
                 if (currentUser != null) {
             %>
                 <span style="font-weight: 500; color: #666; margin-left: 15px;">Welcome, <%= currentUser.getUsername() %></span>
                 <a href="OrderHistoryServlet">📋 My Orders</a>
                 <a href="UserServlet?action=logout">Logout</a>
            <%
                } else {
            %>
                <a href="login.jsp">Login</a>
            <%
                }
            %>
        </div>
    </div>
    
    <div class="hero">
        <h1>Order Food Online</h1>
        <p>Fast delivery to your doorstep</p>
        <button class="btn" onclick="window.location.href='RestaurantServlet'">Browse Restaurants</button>
    </div>
    
    <div class="container">
        <h2 style="margin-bottom: 30px; color: #333;">Why Choose Us?</h2>
        <div class="features">
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <h3>Fast Delivery</h3>
                <p>Get your food delivered in 30 minutes</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">⭐</div>
                <h3>Quality Food</h3>
                <p>Fresh and hygienic food from best restaurants</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">💰</div>
                <h3>Great Prices</h3>
                <p>Affordable prices with special discounts</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🛡️</div>
                <h3>Safe Payment</h3>
                <p>Secure payment options available</p>
            </div>
        </div>
    </div>
</body>
</html>
