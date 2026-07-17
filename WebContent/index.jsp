<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BITE — Food Delivery, Reimagined</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        /* Specific overrides for index page masked images */
        .hero-masked-img {
            position: absolute;
            width: 300px;
            height: 300px;
            object-fit: cover;
            /* Irregular organic shapes */
            clip-path: polygon(15% 0%, 85% 5%, 100% 45%, 85% 95%, 20% 100%, 0% 50%);
            z-index: 1;
            transition: transform 0.6s cubic-bezier(0.16, 1, 0.3, 1), filter 0.6s, box-shadow 0.6s;
            filter: grayscale(20%) contrast(120%);
        }
        .hero-masked-img:hover {
            transform: scale(1.1) rotate(0deg) !important;
            filter: grayscale(0%) contrast(130%);
            z-index: 10;
        }
        .hero-masked-1 {
            top: 10%;
            left: 5%;
            transform: rotate(-10deg);
        }
        .hero-masked-2 {
            bottom: 10%;
            right: 5%;
            clip-path: polygon(0% 15%, 85% 0%, 100% 60%, 75% 100%, 10% 85%);
            transform: rotate(5deg);
        }
        .hero-content {
            position: relative;
            z-index: 2;
        }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
            <%
                com.dcl.model.User currentUser = (com.dcl.model.User) session.getAttribute("user");
                if (currentUser != null) {
            %>
                <span class="nav-welcome">Hey, <%= currentUser.getUsername() %></span>
                <a href="OrderHistoryServlet" class="nav-item">My Orders</a>
                <a href="UserServlet?action=logout" class="btn-primary">Logout ›</a>
            <%
                } else {
            %>
                <a href="login.jsp" class="btn-primary">Sign In ›</a>
            <%
                }
            %>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="hero-section">
        <img src="https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=800&auto=format&fit=crop" class="hero-masked-img hero-masked-1" alt="Burger">
        <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800&auto=format&fit=crop" class="hero-masked-img hero-masked-2" alt="Fries">
        
        <div class="hero-content">
            <p class="hero-eyebrow">◂ Hot & Ready In 30 Min ▸</p>
            <h1 class="hero-display">ORDER<br>FOOD</h1>
            <h2 class="hero-aside">(FROM REAL RESTAURANTS)</h2>
            <div class="pill-group" style="margin-top: 16px;">
                <a href="RestaurantServlet" class="btn-primary">Browse Restaurants ›</a>
                <% if (currentUser == null) { %>
                <a href="register.jsp" class="btn-ghost">Create Account</a>
                <% } %>
            </div>
        </div>
    </section>

    <!-- SECTION 2: WHY CHOOSE US -->
    <section class="section-heading-block interactive-section" style="background-color: var(--color-burgundy-stage); border-top: 1px solid var(--color-butcher-black); border-bottom: 1px solid var(--color-butcher-black); transition: background-color 0.4s;">
        <p class="section-bracket-eyebrow">◂ Why Choose Us ▸</p>
        <h2 class="section-display">THE<br>DIFFERENCE</h2>
    </section>
    
    <style>
        .interactive-section:hover {
            background-color: #5c0529 !important;
            box-shadow: inset 0 0 40px rgba(225,6,0,0.1);
        }
    </style>

    <!-- FEATURES GRID -->
    <section class="card-grid">
        <div class="card">
            <h3 class="card-title">Fast Delivery</h3>
            <p class="card-desc">Your food arrives in 30 minutes or we'll make it right — every single time.</p>
        </div>
        <div class="card">
            <h3 class="card-title">Quality Food</h3>
            <p class="card-desc">Fresh, hygienic dishes from the best curated restaurants in your city.</p>
        </div>
        <div class="card">
            <h3 class="card-title">Great Prices</h3>
            <p class="card-desc">Everyday affordable prices with special deals. No surprise fees, ever.</p>
        </div>
        <div class="card">
            <h3 class="card-title">Safe Payment</h3>
            <p class="card-desc">Multiple secure payment options — UPI, cards, or cash on delivery.</p>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
