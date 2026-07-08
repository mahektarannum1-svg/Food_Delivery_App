package com.dcl.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dcl.model.Cart;
import com.dcl.model.CartItem;
import com.dcl.model.Order;
import com.dcl.model.OrderItem;
import com.dcl.model.User;
import com.dcl.DAOImpl.OrderDAOImpl;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAOImpl orderDAO;
    
    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get cart from session
        Cart cart = (Cart) session.getAttribute("cart");
        
        // Check if cart exists and is not empty
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            // Empty cart - redirect to cart page
            response.sendRedirect("CartServlet");
            return;
        }
        
        // Set cart and user as request attributes
        request.setAttribute("cart", cart);
        request.setAttribute("user", user);
        
        // Forward to checkout.jsp
        RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
        rd.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("confirm".equals(action)) {
            // Retrieve temporary order from session
            Order tempOrder = (Order) session.getAttribute("tempOrder");
            @SuppressWarnings("unchecked")
            List<OrderItem> tempOrderItems = (List<OrderItem>) session.getAttribute("tempOrderItems");
            Double deliveryFee = (Double) session.getAttribute("tempDeliveryFee");
            Double gst = (Double) session.getAttribute("tempGst");
            
            if (tempOrder == null || tempOrderItems == null || tempOrderItems.isEmpty()) {
                response.sendRedirect("CartServlet");
                return;
            }
            
            try {
                // Add order to database with items
                orderDAO.addOrder(tempOrder, tempOrderItems);
                
                // Critical validation: Verify generated order ID is not 0 (indicates failure)
                if (tempOrder.getOrderId() == 0) {
                    throw new Exception("Order could not be processed. Please try again.");
                }
                
                // Clear cart from session
                session.removeAttribute("cart");
                session.removeAttribute("restaurantId");
                
                // Set success message and order ID
                session.setAttribute("orderConfirmed", true);
                session.setAttribute("orderId", tempOrder.getOrderId());
                session.setAttribute("orderTotal", tempOrder.getTotalAmount());
                session.setAttribute("deliveryFee", deliveryFee != null ? deliveryFee : 40.0);
                session.setAttribute("gst", gst != null ? gst : 0.0);
                
                // Clean up temporary session data
                session.removeAttribute("tempOrder");
                session.removeAttribute("tempOrderItems");
                session.removeAttribute("tempDeliveryFee");
                session.removeAttribute("tempGst");
                
                // Redirect to confirmation page
                response.sendRedirect("orderConfirmation.jsp");
                
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Payment confirmation failed: " + e.getMessage());
                request.setAttribute("cart", cart);
                request.setAttribute("user", user);
                RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
                rd.forward(request, response);
            }
            return;
        }
        
        // Check if cart is valid and not empty for starting checkout
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("CartServlet");
            return;
        }
        
        try {
            // Extract form data
            String paymentMethod = request.getParameter("paymentMethod");
            String address = request.getParameter("address");
            
            // Validate inputs
            if (paymentMethod == null || paymentMethod.isEmpty() || 
                address == null || address.isEmpty()) {
                request.setAttribute("error", "Please fill in all required fields");
                request.setAttribute("cart", cart);
                request.setAttribute("user", user);
                RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
                rd.forward(request, response);
                return;
            }
            
            // Calculate total amount with delivery fee and GST
            double subtotal = 0;
            for (CartItem item : cart.getItems()) {
                subtotal += item.getItemTotal();
            }
            double deliveryFee = 40;
            double gst = subtotal * 0.05;
            double totalAmount = subtotal + deliveryFee + gst;
            
            // Create Order object (stored temporarily in session)
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setRestaurantId(cart.getRestaurantId());
            order.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            order.setPaymentMode(paymentMethod);
            order.setDeliveryAddress(address);
            order.setStatus("Confirmed");
            order.setTotalAmount(totalAmount);
            
            // Create OrderItem list from cart items
            List<OrderItem> orderItems = convertCartItemsToOrderItems(cart.getItems());
            
            // Store temporary order details in session to support simulated payment
            session.setAttribute("tempOrder", order);
            session.setAttribute("tempOrderItems", orderItems);
            session.setAttribute("tempDeliveryFee", deliveryFee);
            session.setAttribute("tempGst", gst);
            
            // Redirect to the simulated payment page
            response.sendRedirect("payment.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing checkout: " + e.getMessage());
            request.setAttribute("cart", cart);
            request.setAttribute("user", user);
            RequestDispatcher rd = request.getRequestDispatcher("checkout.jsp");
            rd.forward(request, response);
        }
    }
    
    /**
     * Convert CartItems to OrderItems for database storage
     */
    private List<OrderItem> convertCartItemsToOrderItems(List<CartItem> cartItems) {
        List<OrderItem> orderItems = new ArrayList<>();
        
        for (CartItem cartItem : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(cartItem.getProductId());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setItemTotal(cartItem.getItemTotal());
            orderItems.add(orderItem);
        }
        
        return orderItems;
    }
}
