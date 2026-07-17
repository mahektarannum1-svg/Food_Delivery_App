<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Restaurant" %>
<%@ page import="com.dcl.model.User" %>
<%@ page import="com.dcl.utility.CartHelper" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .cart-link { position: relative; display: inline-flex; align-items: center; }
        .cart-badge {
            position: absolute; top: -8px; right: -12px;
            background-color: var(--color-impossible-red);
            color: var(--color-bone-white);
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 10px;
            font-family: var(--font-sans-meat);
            font-weight: 700;
        }
        .restaurant-image-wrapper {
            width: 100%; height: 200px;
            margin-bottom: 16px;
            border-bottom: 1px solid var(--color-butcher-black);
            margin: -24px -24px 16px -24px;
            width: calc(100% + 48px);
        }
        .restaurant-image-wrapper img {
            width: 100%; height: 100%; object-fit: cover;
        }
        .meta-row {
            display: flex; justify-content: space-between; margin-top: 16px; align-items: center;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <%
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span class="nav-welcome">Hey, <%= currentUser.getUsername() %></span>
                <a href="OrderHistoryServlet" class="nav-item">My Orders</a>
                <a href="CartServlet" class="nav-item cart-link">
                    Cart
                    <%
                        int cartCount = CartHelper.getCartItemCount(session);
                        if (cartCount > 0) {
                    %>
                        <span class="cart-badge"><%= cartCount %></span>
                    <% } %>
                </a>
                <a href="UserServlet?action=logout" class="btn-primary">Logout ›</a>
            <% } else { %>
                <a href="login.jsp" class="btn-primary">Sign In ›</a>
            <% } %>
        </div>
    </nav>

    <div class="section-heading-block" style="padding-bottom: 0;">
        <p class="section-bracket-eyebrow">◂ Now Serving ▸</p>
        <h1 class="section-display" style="margin-bottom: 0;">RESTAURANTS</h1>
    </div>

    <div class="card-grid">
        <%
            List<Restaurant> restaurantsList = (List<Restaurant>) request.getAttribute("restaurantsList");
            if (restaurantsList == null || restaurantsList.isEmpty()) {
        %>
            <div class="text-center" style="grid-column: 1 / -1; margin-top: 40px;">
                <h3 class="card-title">No Restaurants Available</h3>
            </div>
        <%
            } else {
                for (Restaurant restaurant : restaurantsList) {
                    String resolvedImage = restaurant.getImageUrl();
                    if (resolvedImage == null || resolvedImage.trim().isEmpty()) {
                        int index = restaurant.getRestaurantId() % 5;
                        if (index == 0) resolvedImage = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=600&q=80";
                        else if (index == 1) resolvedImage = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=600&q=80";
                        else if (index == 2) resolvedImage = "https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=600&q=80";
                        else if (index == 3) resolvedImage = "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=600&q=80";
                        else resolvedImage = "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=600&q=80";
                    }
        %>
            <div class="card" style="cursor: pointer;" onclick="location.href='MenuServlet?restaurantId=<%= restaurant.getRestaurantId() %>'">
                <div class="restaurant-image-wrapper">
                    <img src="<%= resolvedImage %>" alt="<%= restaurant.getName() %>">
                </div>
                <div class="card-title"><%= restaurant.getName() %></div>
                <div class="card-desc"><%= restaurant.getCuisineType() %> Cuisine</div>
                <div class="meta-row">
                    <span style="color: var(--color-impossible-red); font-weight: 700;">★ <%= String.format("%.1f", restaurant.getRating()) %></span>
                    <span style="color: var(--color-bone-white);">⏱ <%= restaurant.getDeliveryTime() %> min</span>
                </div>
                <div style="margin-top: 16px;">
                    <a href="MenuServlet?restaurantId=<%= restaurant.getRestaurantId() %>" class="btn-ghost" style="width: 100%;">VIEW MENU ›</a>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
