<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Food Delivery App</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 440px;
        }
        h1 {
            text-align: center;
            color: #ff6b6b;
            margin-bottom: 30px;
            font-size: 28px;
        }
        .form-group {
            margin-bottom: 18px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            color: #333;
            font-weight: bold;
            font-size: 14px;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            font-family: Arial, sans-serif;
        }
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #ff6b6b;
            box-shadow: 0 0 4px rgba(255, 107, 107, 0.3);
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #ff6b6b;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #ff5252;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }
        .login-link a {
            color: #ff6b6b;
            text-decoration: none;
            font-weight: bold;
        }
        .error {
            background-color: #fee;
            color: #c33;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #c33;
        }
        .success {
            background-color: #efe;
            color: #3c3;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border-left: 4px solid #3c3;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>🍕 Sign Up</h1>

        <%
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
            <div class="error"><%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="success"><%= success %></div>
        <% } %>

        <form method="POST" action="UserServlet">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label>Username <span style="color:#ff6b6b">*</span></label>
                <input type="text" name="username" placeholder="Choose a username" required minlength="3" maxlength="50">
            </div>

            <div class="form-group">
                <label>Email Address <span style="color:#ff6b6b">*</span></label>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label>Password <span style="color:#ff6b6b">*</span></label>
                <input type="password" name="password" placeholder="Create a password" required minlength="6">
            </div>

            <div class="form-group">
                <label>Delivery Address</label>
                <textarea name="address" placeholder="Enter your default delivery address (optional)"></textarea>
            </div>

            <button type="submit" class="btn">Create Account</button>

            <div class="login-link">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
        </form>
    </div>
</body>
</html>
