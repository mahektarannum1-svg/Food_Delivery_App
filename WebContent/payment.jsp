<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dcl.model.Order" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Simulation - Food Delivery</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Outfit', 'Inter', Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }
        
        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
            padding: 15px 20px;
            position: sticky;
            top: 0;
            z-index: 100;
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
            margin-left: 20px;
            font-weight: 500;
        }
        
        .navbar a:hover {
            color: #ff6b6b;
        }
        
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .payment-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border: 1px solid #eaeaea;
        }
        
        .header-title {
            text-align: center;
            margin-bottom: 25px;
        }
        
        .header-title h2 {
            font-size: 24px;
            color: #2d3748;
            margin-bottom: 8px;
        }
        
        .header-title p {
            color: #718096;
            font-size: 14px;
        }
        
        .order-summary-box {
            background: #f7fafc;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px dashed #cbd5e0;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
            color: #4a5568;
        }
        
        .summary-row:last-child {
            margin-bottom: 0;
        }
        
        .grand-total {
            border-top: 1px solid #e2e8f0;
            padding-top: 12px;
            margin-top: 12px;
            font-size: 18px;
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: #2d3748;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.2s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #ff6b6b;
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.15);
        }
        
        .card-row {
            display: flex;
            gap: 15px;
        }
        
        .card-row .form-group {
            flex: 1;
        }
        
        .pay-btn {
            width: 100%;
            background-color: #ff6b6b;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(255, 107, 107, 0.2);
        }
        
        .pay-btn:hover {
            background-color: #ff5252;
        }
        
        .payment-sim-alert {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
            color: #0d47a1;
            padding: 15px;
            border-radius: 4px;
            font-size: 13px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍕 Food Delivery App</h1>
        <div>
            <a href="index.jsp">Home</a>
            <a href="RestaurantServlet">Restaurants</a>
        </div>
    </div>
    
    <div class="container">
        <%
            Order tempOrder = (Order) session.getAttribute("tempOrder");
            Double deliveryFee = (Double) session.getAttribute("tempDeliveryFee");
            Double gst = (Double) session.getAttribute("tempGst");
            
            if (tempOrder == null) {
        %>
            <div style="background: white; border-radius: 8px; padding: 60px 20px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                <p style="color: #666; margin-bottom: 20px;">Session expired or order details not found.</p>
                <a href="CartServlet" style="background-color: #ff6b6b; color: white; padding: 10px 20px; border-radius: 5px; text-decoration: none;">← Back to Cart</a>
            </div>
        <%
            } else {
                double total = tempOrder.getTotalAmount();
                double feeVal = deliveryFee != null ? deliveryFee : 40.0;
                double gstVal = gst != null ? gst : 0.0;
                double subtotal = total - feeVal - gstVal;
        %>
        
        <div class="payment-card">
            <div class="header-title">
                <h2>Simulated Payment</h2>
                <p>Complete your transaction securely (Simulation Mode)</p>
            </div>
            
            <div class="payment-sim-alert">
                <span>🛡️</span>
                <span>This is a safe sandbox environment. Do not enter actual credit card or real financial details.</span>
            </div>
            
            <div class="order-summary-box">
                <div class="summary-row">
                    <span>Selected Payment Method:</span>
                    <strong><%= tempOrder.getPaymentMode() %></strong>
                </div>
                <div class="summary-row">
                    <span>Delivery Address:</span>
                    <span style="text-align: right; max-width: 60%; word-break: break-all;"><%= tempOrder.getDeliveryAddress() %></span>
                </div>
                <div class="summary-row" style="border-top: 1px solid #e2e8f0; margin-top: 10px; padding-top: 10px;">
                    <span>Items Subtotal:</span>
                    <span>₹<%= String.format("%.0f", subtotal) %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee:</span>
                    <span>₹<%= String.format("%.0f", feeVal) %></span>
                </div>
                <div class="summary-row">
                    <span>GST (5%):</span>
                    <span>₹<%= String.format("%.0f", gstVal) %></span>
                </div>
                <div class="summary-row grand-total">
                    <span>Grand Total:</span>
                    <span>₹<%= String.format("%.0f", total) %></span>
                </div>
            </div>
            
            <form action="checkout" method="post" id="paymentForm">
                <input type="hidden" name="action" value="confirm">
                
                <% if ("Credit Card".equals(tempOrder.getPaymentMode()) || "Debit Card".equals(tempOrder.getPaymentMode())) { %>
                    <div class="form-group">
                        <label for="cardNumber">Card Number</label>
                        <input type="text" id="cardNumber" placeholder="1111-2222-3333-4444" required pattern="\d{4}-?\d{4}-?\d{4}-?\d{4}">
                    </div>
                    
                    <div class="card-row">
                        <div class="form-group">
                            <label for="expiry">Expiry Date</label>
                            <input type="text" id="expiry" placeholder="MM/YY" required pattern="(0[1-9]|1[0-2])\/[0-9]{2}">
                        </div>
                        <div class="form-group">
                            <label for="cvv">CVV</label>
                            <input type="password" id="cvv" placeholder="123" required pattern="\d{3}">
                        </div>
                    </div>
                <% } else if ("UPI".equals(tempOrder.getPaymentMode())) { %>
                    <div class="form-group">
                        <label for="upiId">UPI ID</label>
                        <input type="text" id="upiId" placeholder="username@upi" required pattern=".+@.+">
                    </div>
                <% } else { %>
                    <div class="form-group" style="background-color: #f7fafc; padding: 15px; border-radius: 6px; border: 1px solid #e2e8f0; text-align: center; color: #4a5568;">
                        <span style="font-size: 24px; display: block; margin-bottom: 5px;">💵</span>
                        You will pay <strong>₹<%= String.format("%.0f", total) %></strong> via Cash on Delivery when your order is delivered to your doorstep.
                    </div>
                <% } %>
                
                <button type="submit" class="pay-btn">Pay & Place Order</button>
            </form>
        </div>
        
        <% } %>
    </div>
    
    <script>
        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            const btn = document.querySelector('.pay-btn');
            btn.disabled = true;
            btn.innerText = "Processing Payment...";
            btn.style.backgroundColor = "#cbd5e0";
            btn.style.cursor = "not-allowed";
        });
    </script>
</body>
</html>
