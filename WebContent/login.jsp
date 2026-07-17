<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <a href="index.jsp" class="nav-welcome">← Back to Home</a>
    </nav>

    <div style="flex: 1; display: flex; align-items: center; justify-content: center; padding: 60px 24px;">
        <div class="form-container">
            <p class="section-bracket-eyebrow text-center">◂ Welcome Back ▸</p>
            <h1 class="form-title">SIGN<br>IN</h1>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                if (error != null) {
            %>
                <div class="alert-error"><%= error %></div>
            <%
                }
                if (success != null) {
            %>
                <div class="alert-success"><%= success %></div>
            <%
                }
            %>

            <form method="POST" action="UserServlet">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input class="form-input" type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-input" type="password" id="password" name="password" required>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%;">Sign In ›</button>

                <div class="text-center mt-4" style="font-size: var(--text-caption); color: var(--color-blush-highlight);">
                    DON't HAVE AN ACCOUNT? <a href="register.jsp" style="color: var(--color-impossible-red); font-weight: 700;">SIGN UP HERE</a>
                </div>
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
