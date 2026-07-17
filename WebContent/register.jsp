<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <a href="login.jsp" class="nav-welcome">← Back to Sign In</a>
    </nav>

    <div style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 60px 24px;">
        <div class="form-container">
            <p class="section-bracket-eyebrow text-center">◂ Join the Club ▸</p>
            <h1 class="form-title">SIGN<br>UP</h1>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="alert-error"><%= error %></div>
            <%
                }
            %>

            <form method="POST" action="UserServlet">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input class="form-input" type="text" id="username" name="username" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input class="form-input" type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-input" type="password" id="password" name="password" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="role">Account Type</label>
                    <select class="form-input" id="role" name="role">
                        <option value="CUSTOMER">Customer</option>
                        <option value="RESTAURANT_OWNER">Restaurant Owner</option>
                    </select>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%;">Create Account ›</button>
            </form>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-logo">BITE</div>
        <p class="footer-text">© 2025 BITE FOOD DELIVERY. ALL RIGHTS RESERVED.</p>
    </footer>

</body>
</html>
