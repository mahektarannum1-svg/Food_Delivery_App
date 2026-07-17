<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.dcl.model.Menu" %>
<%@ page import="com.dcl.model.User" %>
<%@ page import="com.dcl.model.Restaurant" %>
<%@ page import="com.dcl.utility.CartHelper" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu — BITE</title>
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
        .menu-image-wrapper {
            width: 100%; height: 200px;
            margin-bottom: 16px;
            border-bottom: 1px solid var(--color-butcher-black);
            margin: -24px -24px 16px -24px;
            width: calc(100% + 48px);
        }
        .menu-image-wrapper img {
            width: 100%; height: 100%; object-fit: cover;
        }
        .price-row {
            display: flex; justify-content: space-between; align-items: center; margin-top: 16px;
        }
        .price-text {
            font-family: var(--font-sans-meat); font-weight: 700; font-size: 24px; color: var(--color-impossible-red);
        }
        .cart-toast {
            background-color: var(--color-impossible-red);
            color: var(--color-bone-white);
            padding: 12px 24px;
            margin: 16px auto;
            max-width: 1280px;
            text-align: center;
            font-family: var(--font-sans-meat);
            font-weight: 700;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
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

    <%
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        String restaurantName = (restaurant != null) ? restaurant.getName() : "RESTAURANT MENU";
        String cuisineType = (restaurant != null) ? restaurant.getCuisineType() : "";
    %>

    <div class="section-heading-block" style="padding-bottom: 0;">
        <a href="RestaurantServlet" class="nav-welcome" style="margin-bottom: 24px; display: inline-block;">← BACK TO RESTAURANTS</a>
        <p class="section-bracket-eyebrow">◂ The Menu ▸</p>
        <h1 class="section-display" style="margin-bottom: 16px;"><%= restaurantName %></h1>
        <p class="hero-aside" style="font-size: 32px;"><%= cuisineType.toUpperCase() %> CUISINE</p>
    </div>

    <%
        String cartMessage = (String) session.getAttribute("cartMessage");
        if (cartMessage != null) {
            session.removeAttribute("cartMessage");
    %>
        <div class="cart-toast">✓ <%= cartMessage %></div>
    <% } %>

    <div class="card-grid">
        <%
            @SuppressWarnings("unchecked")
            List<Menu> menus = (List<Menu>) request.getAttribute("menus");

            if (menus == null || menus.isEmpty()) {
        %>
            <div class="text-center" style="grid-column: 1 / -1; margin-top: 40px;">
                <h3 class="card-title">NO MENU ITEMS AVAILABLE</h3>
            </div>
        <%
            } else {
                for (Menu menu : menus) {
                    String resolvedDishImage = menu.getImageUrl();
                    if (resolvedDishImage == null || resolvedDishImage.trim().isEmpty()) {
                        int index = menu.getMenuId() % 6;
                        if (index == 0) resolvedDishImage = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80";
                        else if (index == 1) resolvedDishImage = "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?auto=format&fit=crop&w=600&q=80";
                        else if (index == 2) resolvedDishImage = "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=600&q=80";
                        else if (index == 3) resolvedDishImage = "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80";
                        else if (index == 4) resolvedDishImage = "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=600&q=80";
                        else resolvedDishImage = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80";
                    }
        %>
            <div class="card">
                <div class="menu-image-wrapper">
                    <img src="<%= resolvedDishImage %>" alt="<%= menu.getName() %>">
                </div>
                <div class="card-title"><%= menu.getName() %></div>
                <div class="card-desc"><%= menu.getDescription() %></div>
                <div class="price-row">
                    <span class="price-text">₹<%= String.format("%.0f", menu.getPrice()) %></span>
                    <% if (menu.isAvailable()) { %>
                        <form action="CartServlet" method="post" style="margin: 0;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                            <input type="hidden" name="restaurantId" value="<%= request.getAttribute("restaurantId") %>">
                            <input type="hidden" name="referer" value="MenuServlet?restaurantId=<%= request.getAttribute("restaurantId") %>">
                            <button type="submit" class="btn-primary">ADD TO CART ›</button>
                        </form>
                    <% } else { %>
                        <span class="btn-ghost" style="border-color: rgba(255,255,255,0.3); color: rgba(255,255,255,0.3);">UNAVAILABLE</span>
                    <% } %>
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