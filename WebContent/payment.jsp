<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dcl.model.Order" %>
<%@ page import="com.dcl.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment — BITE</title>
    <link rel="stylesheet" href="css/impossible.css">
    <style>
        .page-body {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px 80px;
        }
        .payment-shell { width: 100%; max-width: 580px; margin-top: 40px; }
        
        .order-summary-box, .payment-form-panel {
            background-color: var(--color-burgundy-stage);
            border: 1px solid var(--color-butcher-black);
            border-radius: var(--radius-cards);
            padding: 24px;
            margin-bottom: 24px;
        }
        
        .summary-box-title {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-bone-white);
            text-transform: uppercase;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--color-impossible-red);
            margin-bottom: 16px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 16px;
            color: var(--color-blush-highlight);
        }
        .summary-row span:last-child { color: var(--color-bone-white); }
        .summary-row.address-row { flex-direction: column; gap: 4px; }
        .summary-row.address-row span:last-child {
            color: var(--color-bone-white);
            word-break: break-word;
            padding-top: 4px;
        }
        
        .summary-divider {
            border: none;
            border-top: 1px solid var(--color-butcher-black);
            margin: 16px 0;
        }
        
        .grand-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .grand-total-label {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            color: var(--color-bone-white);
            text-transform: uppercase;
        }
        .grand-total-value {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 32px;
            color: var(--color-impossible-red);
        }
        
        .card-row { display: flex; gap: 16px; }
        .card-row .form-group { flex: 1; }
        
        .cod-box {
            background-color: var(--color-velvet-wine);
            border: 1px solid var(--color-butcher-black);
            border-radius: 8px;
            padding: 24px;
            text-align: center;
        }
        .cod-icon { font-size: 40px; display: block; margin-bottom: 12px; }
        .cod-text { color: var(--color-blush-highlight); font-size: 16px; line-height: 1.5; }
        .cod-amount {
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 24px;
            color: var(--color-impossible-red);
        }
        
        .btn-pay {
            width: 100%;
            background-color: var(--color-impossible-red);
            color: var(--color-bone-white);
            font-family: var(--font-sans-meat);
            font-weight: 700;
            font-size: 20px;
            text-transform: uppercase;
            padding: 16px 24px;
            border-radius: var(--radius-buttons);
            border: none;
            cursor: pointer;
            margin-top: 16px;
        }
        .btn-pay:hover { background-color: #ff1910; }
        .btn-pay:disabled { background-color: rgba(225,6,0,0.4); cursor: not-allowed; }
        
        .sandbox-notice {
            background-color: var(--color-velvet-wine);
            border-left: 4px solid var(--color-impossible-red);
            color: var(--color-blush-highlight);
            padding: 12px 16px;
            margin-bottom: 24px;
            font-size: 14px;
            border: 1px solid var(--color-butcher-black);
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="nav-logo">BITE</a>
        <div class="nav-links">
            <a href="index.jsp" class="nav-item">Home</a>
            <a href="RestaurantServlet" class="nav-item">Restaurants</a>
        </div>
    </nav>

    <div class="page-body">
        <div class="payment-shell">
            <%
                Order tempOrder = (Order) session.getAttribute("tempOrder");
                Double deliveryFee = (Double) session.getAttribute("tempDeliveryFee");
                Double gst = (Double) session.getAttribute("tempGst");

                if (tempOrder == null) {
            %>
            <div class="text-center" style="margin-top: 80px;">
                <p style="color: var(--color-blush-highlight); font-size: 20px; margin-bottom: 24px;">Session expired or order details not found.</p>
                <a href="CartServlet" class="btn-primary">← BACK TO CART</a>
            </div>
            <%
                } else {
                    double total = tempOrder.getTotalAmount();
                    double feeVal = deliveryFee != null ? deliveryFee : 40.0;
                    double gstVal = gst != null ? gst : 0.0;
                    double subtotal = total - feeVal - gstVal;
            %>
            
            <div class="section-heading-block" style="padding: 0; margin-bottom: 24px;">
                <p class="section-bracket-eyebrow">◂ Secure Checkout ▸</p>
                <h1 class="section-display" style="margin-bottom: 0;">PAYMENT</h1>
            </div>

            <div class="sandbox-notice">
                <span>⚠️ This is a sandbox environment. Do not enter real financial details.</span>
            </div>

            <div class="order-summary-box">
                <div class="summary-box-title">Order Summary</div>
                <div class="summary-row">
                    <span>Payment Method</span>
                    <span style="font-weight: 700; font-family: var(--font-sans-meat); font-size: 18px;"><%= tempOrder.getPaymentMode() %></span>
                </div>
                <div class="summary-row address-row">
                    <span>Delivery Address</span>
                    <span><%= tempOrder.getDeliveryAddress() %></span>
                </div>
                <hr class="summary-divider">
                <div class="summary-row">
                    <span>Items Subtotal</span>
                    <span>₹<%= String.format("%.0f", subtotal) %></span>
                </div>
                <div class="summary-row">
                    <span>Delivery Fee</span>
                    <span>₹<%= String.format("%.0f", feeVal) %></span>
                </div>
                <div class="summary-row">
                    <span>GST (5%)</span>
                    <span>₹<%= String.format("%.0f", gstVal) %></span>
                </div>
                <hr class="summary-divider">
                <div class="grand-total-row">
                    <span class="grand-total-label">Grand Total</span>
                    <span class="grand-total-value">₹<%= String.format("%.0f", total) %></span>
                </div>
            </div>

            <div class="payment-form-panel">
                <form action="checkout" method="post" id="paymentForm">
                    <input type="hidden" name="action" value="confirm">
                    
                    <% if ("Credit Card".equals(tempOrder.getPaymentMode()) || "Debit Card".equals(tempOrder.getPaymentMode())) { %>
                        <div class="form-group">
                            <label class="form-label" for="cardNumber">Card Number</label>
                            <input class="form-input" type="text" id="cardNumber" placeholder="1111-2222-3333-4444" required pattern="\d{4}-?\d{4}-?\d{4}-?\d{4}">
                        </div>
                        <div class="card-row">
                            <div class="form-group">
                                <label class="form-label" for="expiry">Expiry Date</label>
                                <input class="form-input" type="text" id="expiry" placeholder="MM/YY" required pattern="(0[1-9]|1[0-2])\/[0-9]{2}">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="cvv">CVV</label>
                                <input class="form-input" type="password" id="cvv" placeholder="•••" required pattern="\d{3}">
                            </div>
                        </div>
                    <% } else if ("UPI".equals(tempOrder.getPaymentMode())) { %>
                        <div class="form-group">
                            <label class="form-label" for="upiId">UPI ID</label>
                            <input class="form-input" type="text" id="upiId" placeholder="username@upi" required pattern=".+@.+">
                        </div>
                    <% } else { %>
                        <div class="cod-box">
                            <span class="cod-icon">💵</span>
                            <div class="cod-text">
                                You'll pay <span class="cod-amount">₹<%= String.format("%.0f", total) %></span> via Cash on Delivery when your order arrives at your doorstep.
                            </div>
                        </div>
                    <% } %>
                    
                    <button type="submit" class="btn-pay" id="payBtn">PAY & PLACE ORDER ›</button>
                </form>
            </div>
            <% } %>
        </div>
    </div>

    <script>
        document.getElementById('paymentForm').addEventListener('submit', function() {
            const btn = document.getElementById('payBtn');
            btn.disabled = true;
            btn.innerText = 'PROCESSING…';
        });
    </script>
</body>
</html>
