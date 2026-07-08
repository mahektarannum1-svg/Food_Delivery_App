<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Menu" %>
<%@ page import="com.dcl.model.User" %>
<%@ page import="com.dcl.model.Restaurant" %>
<%@ page import="com.dcl.utility.CartHelper" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Menu - Food Delivery</title>
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
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .menu-item {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .menu-item:hover {
            transform: translateY(-2px);
        }
        
        .menu-image {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }
        
        .menu-info {
            padding: 15px;
        }
        
        .menu-title {
            font-size: 18px;
            margin-bottom: 8px;
            color: #333;
        }
        
        .menu-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
            line-height: 1.4;
        }
        
        .menu-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #eee;
            padding-top: 15px;
        }
        
        .menu-price {
            font-size: 20px;
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .add-to-cart {
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .add-to-cart:hover {
            background-color: #ff5252;
        }
        
        .no-menu {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .restaurant-info {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div style="display: flex; align-items: center;">
            <a href="index.jsp" style="color: #333; text-decoration: none; margin-right: 20px;">Home</a>
            <a href="RestaurantServlet" style="color: #333; text-decoration: none; margin-right: 20px;">Restaurants</a>
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
        <a href="RestaurantServlet" class="back-button">← Back to Restaurants</a>
        
        <%
            String cartMessage = (String) session.getAttribute("cartMessage");
            if (cartMessage != null) {
                session.removeAttribute("cartMessage");
        %>
            <div style="background-color: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
                ✓ <%= cartMessage %>
            </div>
        <%
            }
        %>
        
        <div class="restaurant-info">
            <%
                Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
                String restaurantName = (restaurant != null) ? restaurant.getName() : "Restaurant Menu";
                String cuisineType = (restaurant != null) ? restaurant.getCuisineType() : "";
            %>
            <h2><%= restaurantName %></h2>
            <% if (!cuisineType.isEmpty()) { %>
            <p><%= cuisineType %> Cuisine &nbsp;|&nbsp; ⭐ <%= (restaurant != null) ? String.format("%.1f", restaurant.getRating()) : "" %> &nbsp;|&nbsp; 🕒 <%= (restaurant != null) ? restaurant.getDeliveryTime() : 30 %> min delivery</p>
            <% } else { %>
            <p>Choose from our delicious menu items</p>
            <% } %></div>
        
        <%
            @SuppressWarnings("unchecked")
            List<Menu> menus = (List<Menu>) request.getAttribute("menus");
            
            if (menus == null || menus.isEmpty()) {
        %>
            <div class="no-menu">
                <p>No menu items available for this restaurant.</p>
            </div>
        <%
            } else {
        %>
            <div class="menu-grid">
        <%
                for (Menu menu : menus) {
        %>
                <div class="menu-item">
                    <div class="menu-image">
                        <% if (menu.getImageUrl() != null && !menu.getImageUrl().isEmpty()) { %>
                            <img src="<%= menu.getImageUrl() %>" alt="<%= menu.getName() %>" 
                                 style="width: 100%; height: 100%; object-fit: cover;">
                        <% } else { %>
                            Dish Image
                        <% } %>
                    </div>
                    <div class="menu-info">
                        <div class="menu-title"><%= menu.getName() %></div>
                        <div class="menu-description"><%= menu.getDescription() %></div>
                        <div class="menu-footer">
                            <span class="menu-price">₹<%= String.format("%.0f", menu.getPrice()) %></span>
                            <% if (menu.isAvailable()) { %>
                                <form action="CartServlet" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= request.getAttribute("restaurantId") %>">
                                    <input type="hidden" name="referer" value="MenuServlet?restaurantId=<%= request.getAttribute("restaurantId") %>">
                                    <button type="submit" class="add-to-cart">Add to Cart</button>
                                </form>
                            <% } else { %>
                                <span style="color: #999;">Not Available</span>
                            <% } %>
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