<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.dcl.model.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — BITE</title>
    <meta name="description" content="Admin panel to view all users and their orders.">
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        /* ── ADMIN LAYOUT ── */
        .admin-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px 80px;
        }

        /* ── STAT CARDS ROW ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-bottom: 48px;
        }
        .stat-card {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-top: 4px solid var(--color-impossible-red);
            border-radius: var(--radius-cards);
            padding: 24px;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--glow-box-strong);
        }
        .stat-num {
            font-family: var(--font-sans-meat);
            font-size: 56px;
            font-weight: 700;
            line-height: 1;
            color: var(--color-impossible-red);
            text-shadow: var(--glow-red);
            display: block;
        }
        .stat-label {
            font-family: var(--font-sans-meat);
            font-size: 14px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-top: 6px;
        }

        /* ── USER BLOCKS ── */
        .user-block {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-cards);
            margin-bottom: 24px;
            overflow: hidden;
            transition: box-shadow 0.3s;
        }
        .user-block:hover {
            box-shadow: var(--glow-box);
        }

        .user-header {
            background-color: var(--color-velvet-wine);
            border-bottom: 1px solid var(--color-butcher-black);
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            cursor: pointer;
            user-select: none;
        }
        .user-header:hover { background-color: #350217; }

        .user-name {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 22px;
            color: var(--color-bone-white);
            text-transform: uppercase;
        }
        .user-meta {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
            align-items: center;
        }
        .user-meta-item {
            font-family: var(--font-sans-meat);
            font-size: 13px;
            color: var(--color-blush-highlight);
            text-transform: uppercase;
        }
        .user-meta-item span {
            color: var(--color-bone-white);
            font-weight: 700;
        }
        .order-count-badge {
            background-color: var(--color-impossible-red);
            color: var(--color-bone-white);
            font-family: var(--font-sans-meat);
            font-size: 13px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            box-shadow: var(--glow-red);
        }
        .toggle-icon {
            font-size: 18px;
            color: var(--color-blush-highlight);
            transition: transform 0.3s;
        }

        /* ── COLLAPSIBLE ORDER LIST ── */
        .user-orders {
            display: none;
            padding: 16px 24px;
        }
        .user-orders.open { display: block; }

        .order-card-admin {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-left: 4px solid var(--color-impossible-red);
            border-radius: 8px;
            margin-bottom: 12px;
            overflow: hidden;
        }
        .order-card-admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            padding: 12px 16px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .order-id-text {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 16px;
            color: var(--color-bone-white);
        }
        .order-meta-row {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            font-size: 13px;
            color: var(--color-blush-highlight);
            font-family: var(--font-sans-meat);
        }
        .order-status-admin {
            font-family: var(--font-sans-meat);
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .status-pending { background: rgba(255,180,0,0.12); color: #ffd060; border: 1px solid rgba(255,180,0,0.3); }
        .status-placed, .status-confirmed { background: rgba(0,200,90,0.12); color: #80f0b0; border: 1px solid rgba(0,200,90,0.3); }
        .status-delivered { background: rgba(0,150,255,0.12); color: #80d0ff; border: 1px solid rgba(0,150,255,0.3); }

        .order-items-list {
            padding: 12px 16px;
            list-style: none;
        }
        .order-item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 6px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.06);
            font-size: 14px;
        }
        .order-item-row:last-child { border: none; }
        .item-qty-admin {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-impossible-red);
            margin-right: 8px;
        }
        .item-price-admin {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            color: var(--color-bone-white);
        }
        .order-total-admin {
            padding: 10px 16px;
            text-align: right;
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-impossible-red);
            border-top: 1px solid rgba(255,255,255,0.05);
        }
        .no-orders-user {
            padding: 16px;
            text-align: center;
            color: rgba(255,199,198,0.4);
            font-family: var(--font-sans-meat);
            font-size: 14px;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <span class="nav-welcome">Admin Panel</span>
            <a href="AdminServlet" class="nav-item">Dashboard</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
            <a href="UserServlet?action=logout" class="btn-primary">Logout ›</a>
        </div>
    </nav>

    <!-- PAGE HEADER -->
    <div class="section-heading-block" style="padding-bottom: 24px;">
        <p class="section-bracket-eyebrow">◂ Control Panel ▸</p>
        <h1 class="section-display">ADMIN<br>DASHBOARD</h1>
    </div>

    <%
        List<User> allUsers = (List<User>) request.getAttribute("allUsers");
        Map<Integer, List<Map<String, Object>>> userOrdersMap =
            (Map<Integer, List<Map<String, Object>>>) request.getAttribute("userOrdersMap");
        int totalUsers = (int) request.getAttribute("totalUsers");
        int totalOrders = (int) request.getAttribute("totalOrders");

        // Count real customers (non-admin)
        int customerCount = 0;
        if (allUsers != null) {
            for (User u : allUsers) {
                if (u.getRole() != User.Role.ADMIN) customerCount++;
            }
        }
    %>

    <div class="admin-wrapper">

        <!-- STATS -->
        <div class="stats-row">
            <div class="stat-card">
                <span class="stat-num"><%= customerCount %></span>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <span class="stat-num"><%= totalOrders %></span>
                <div class="stat-label">All Orders</div>
            </div>
            <div class="stat-card">
                <span class="stat-num">6</span>
                <div class="stat-label">Restaurants</div>
            </div>
        </div>

        <!-- USERS & ORDERS -->
        <h2 style="font-family: var(--font-sans-meat); font-size: 24px; color: var(--color-blush-highlight);
                   text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 20px; border-bottom: 1px solid var(--color-butcher-black); padding-bottom: 12px;">
            ◂ Users &amp; Their Orders ▸
        </h2>

        <%
        if (allUsers == null || customerCount == 0) {
        %>
        <div class="no-orders-user" style="padding: 60px; font-size: 20px;">No users registered yet.</div>
        <%
        } else {
            int idx = 0;
            for (User u : allUsers) {
                if (u.getRole() == User.Role.ADMIN) continue;
                List<Map<String, Object>> userOrders = userOrdersMap.getOrDefault(u.getUserId(), new ArrayList<>());
        %>
        <div class="user-block">
            <div class="user-header" onclick="toggleOrders(<%= u.getUserId() %>)">
                <div style="display:flex; gap:16px; align-items:center;">
                    <div class="user-name"><%= u.getUsername() %></div>
                    <% if (!userOrders.isEmpty()) { %>
                    <span class="order-count-badge"><%= userOrders.size() %> orders</span>
                    <% } %>
                </div>
                <div class="user-meta">
                    <div class="user-meta-item">📧 <span><%= u.getEmail() %></span></div>
                    <% if (u.getAddress() != null && !u.getAddress().isEmpty()) { %>
                    <div class="user-meta-item">📍 <span><%= u.getAddress() %></span></div>
                    <% } %>
                    <div class="user-meta-item">Joined <span><%=
                        u.getCreatedDate() != null ?
                        new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getCreatedDate()) : "N/A"
                    %></span></div>
                    <span class="toggle-icon" id="icon-<%= u.getUserId() %>">▼</span>
                </div>
            </div>

            <div class="user-orders" id="orders-<%= u.getUserId() %>">
                <% if (userOrders.isEmpty()) { %>
                <div class="no-orders-user">No completed orders yet.</div>
                <% } else {
                    for (Map<String, Object> orderInfo : userOrders) {
                        Order o = (Order) orderInfo.get("order");
                        String restName = (String) orderInfo.get("restaurantName");
                        List<OrderItem> items = (List<OrderItem>) orderInfo.get("items");
                        List<String> itemNames = (List<String>) orderInfo.get("itemNames");
                        String status = o.getStatus() != null ? o.getStatus().toLowerCase() : "pending";
                %>
                <div class="order-card-admin">
                    <div class="order-card-admin-header">
                        <div>
                            <div class="order-id-text">Order #<%= o.getOrderId() %> — <%= restName %></div>
                            <div class="order-meta-row" style="margin-top:4px;">
                                <span><%= o.getCreatedDate() != null ? new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(o.getCreatedDate()) : "N/A" %></span>
                                <span>💳 <%= o.getPaymentMode() %></span>
                                <% if (o.getDeliveryAddress() != null) { %><span>📍 <%= o.getDeliveryAddress() %></span><% } %>
                            </div>
                        </div>
                        <span class="order-status-admin status-<%= status %>"><%= o.getStatus() %></span>
                    </div>
                    <ul class="order-items-list">
                        <% for (int j = 0; j < items.size(); j++) {
                            OrderItem item = items.get(j);
                            String iName = j < itemNames.size() ? itemNames.get(j) : "Item";
                        %>
                        <li class="order-item-row">
                            <div>
                                <span class="item-qty-admin">×<%= item.getQuantity() %></span>
                                <span style="color: var(--color-bone-white);"><%= iName %></span>
                            </div>
                            <span class="item-price-admin">₹<%= String.format("%.2f", item.getItemTotal()) %></span>
                        </li>
                        <% } %>
                    </ul>
                    <div class="order-total-admin">Total: ₹<%= String.format("%.2f", o.getTotalAmount()) %></div>
                </div>
                <% } } %>
            </div>
        </div>
        <% idx++; } } %>
    </div>

    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE ADMIN PANEL. ALL RIGHTS RESERVED.</p>
    </footer>

    <script>
        function toggleOrders(userId) {
            var panel = document.getElementById('orders-' + userId);
            var icon  = document.getElementById('icon-' + userId);
            if (panel.classList.contains('open')) {
                panel.classList.remove('open');
                icon.textContent = '▼';
                icon.style.transform = 'rotate(0deg)';
            } else {
                panel.classList.add('open');
                icon.textContent = '▲';
                icon.style.transform = 'rotate(0deg)';
            }
        }
    </script>

</body>
</html>
