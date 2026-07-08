<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Restaurant" %>
<%@ page import="com.dcl.model.User" %>
<%@ page import="com.dcl.utility.CartHelper" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurants - Food Delivery</title>
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
        }
        
        .navbar h1 {
            color: #ff6b6b;
            font-size: 24px;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        h2 {
            margin-bottom: 30px;
            color: #333;
        }
        
        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .restaurant-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        
        .restaurant-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .restaurant-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .restaurant-info {
            padding: 15px;
        }
        
        .restaurant-info h3 {
            font-size: 20px;
            margin-bottom: 5px;
            color: #333;
        }
        
        .restaurant-info p {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .restaurant-details {
            display: flex;
            justify-content: space-between;
            border-top: 1px solid #eee;
            padding-top: 10px;
        }
        
        .rating {
            color: #ff6b6b;
            font-weight: bold;
        }
        
        .delivery {
            color: #666;
            font-size: 13px;
        }
        
        .error {
            background-color: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .no-restaurants {
            text-align: center;
            padding: 40px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div style="display: flex; align-items: center;">
            <a href="index.jsp" style="color: #333; text-decoration: none; margin-right: 20px;">← Home</a>
            <% 
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span style="margin-right: 20px; font-weight: bold;">Welcome, <%= currentUser.getUsername() %>!</span>
                <a href="OrderHistoryServlet" style="color: #333; text-decoration: none; margin-right: 20px;">📋 My Orders</a>
                <a href="CartServlet" style="color: #333; text-decoration: none; position: relative; margin-right: 20px;">
                    🛒 View Cart
                    <%
                        int cartCount = CartHelper.getCartItemCount(session);
                        if (cartCount > 0) {
                    %>
                        <span style="position: absolute; top: -8px; right: -10px; background: #ff6b6b; color: white; border-radius: 50%; padding: 2px 6px; font-size: 12px;"><%= cartCount %></span>
                    <%
                        }
                    %>
                </a>
                <a href="UserServlet?action=logout" style="color: #c33; text-decoration: none; border: 1px solid #c33; padding: 4px 8px; border-radius: 4px;">Logout</a>
            <% } else { %>
                <a href="login.jsp" style="color: #333; text-decoration: none; border: 1px solid #333; padding: 4px 8px; border-radius: 4px;">Login / Register</a>
            <% } %>
        </div>
    </div>
    
    <div class="container">
        <h2>Available Restaurants</h2>
        
        <%
            List<Restaurant> restaurantsList = (List<Restaurant>) request.getAttribute("restaurantsList");
            
            if (restaurantsList == null || restaurantsList.isEmpty()) {
        %>
            <div class="no-restaurants">
                <p>No restaurants available at the moment.</p>
            </div>
        <%
            } else {
        %>
            <div class="restaurant-grid">
        <%
                for (Restaurant restaurant : restaurantsList) {
        %>
                <div class="restaurant-card" onclick="location.href='MenuServlet?restaurantId=<%= restaurant.getRestaurantId() %>'">
                    <div class="restaurant-image">
                        <% if (restaurant.getImageUrl() != null && !restaurant.getImageUrl().isEmpty()) { %>
                            <img src="<%= restaurant.getImageUrl() %>" alt="<%= restaurant.getName() %>"
                                 style="width: 100%; height: 100%; object-fit: cover;">
                        <% } %>
                    </div>
                    <div class="restaurant-info">
                        <h3><%= restaurant.getName() %></h3>
                        <p><%= restaurant.getCuisineType() %></p>
                        <div class="restaurant-details">
                            <span class="rating">⭐ <%= String.format("%.1f", restaurant.getRating()) %></span>
                            <span class="delivery"><%= restaurant.getDeliveryTime() %> min</span>
                        </div>
                    </div>
                </div>
        <%
                }
        %>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>
