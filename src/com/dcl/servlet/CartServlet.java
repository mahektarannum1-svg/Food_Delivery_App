package com.dcl.servlet;

import java.io.IOException;
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
import com.dcl.model.Menu;
import com.dcl.model.User;
import com.dcl.DAOImpl.MenuDAOImpl;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // View cart - just forward to cart.jsp
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get cart from session
        Cart cart = (Cart) session.getAttribute("cart");
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        
        // Set attributes for cart.jsp
        request.setAttribute("cart", cart);
        request.setAttribute("restaurantId", restaurantId);
        
        RequestDispatcher rd = request.getRequestDispatcher("cart.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                handleAddItem(request, response, session);
            } else if ("update".equals(action)) {
                handleUpdateItem(request, response, session);
            } else if ("remove".equals(action)) {
                handleRemoveItem(request, response, session);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing cart");
        }
    }
    
    /**
     * Handle adding item to cart
     * Flow:
     * 1. Get session
     * 2. Get current cart from session
     * 3. If cart == null OR restaurantId changed → create new cart
     * 4. Add item to cart
     */
    private void handleAddItem(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        // Get parameters
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        int quantity = 1;
        
        // Get menu item price
        Menu menuItem = getMenuById(menuId);
        if (menuItem == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Menu item not found");
            return;
        }
        
        // Get current cart and restaurantId from session
        Cart cart = (Cart) session.getAttribute("cart");
        Integer currentRestaurantId = (Integer) session.getAttribute("restaurantId");
        
        // Check if cart exists
        if (cart == null) {
            cart = new Cart();
            cart.setRestaurantId(restaurantId);
            session.setAttribute("cart", cart);
            session.setAttribute("restaurantId", restaurantId);
        } else if (currentRestaurantId != null && !currentRestaurantId.equals(restaurantId)) {
            if (!cart.isEmpty()) {
                // Trying to add from a different restaurant while cart is not empty
                session.setAttribute("cartMessage", "Warning: You can only order from one restaurant at a time. Please clear your cart first.");
                String referer = request.getParameter("referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect("MenuServlet?restaurantId=" + restaurantId);
                }
                return;
            } else {
                // Cart is empty but restaurant changed
                cart.setRestaurantId(restaurantId);
                session.setAttribute("restaurantId", restaurantId);
            }
        }
        
        // Add or update item in cart
        CartItem existingItem = findCartItem(cart, menuId);
        if (existingItem != null) {
            // Item exists, update quantity
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            existingItem.setItemTotal(existingItem.getQuantity() * menuItem.getPrice());
        } else {
            // Item doesn't exist, add new one
            CartItem newItem = new CartItem();
            newItem.setProductId(menuId);
            newItem.setQuantity(quantity);
            newItem.setItemTotal(quantity * menuItem.getPrice());
            // Store additional info for display
            newItem.setItemName(menuItem.getName());
            newItem.setItemPrice(menuItem.getPrice());
            cart.addItem(newItem);
        }
        
        // Update cart total
        updateCartTotal(cart);
        
        // Redirect back to menu page with success message
        session.setAttribute("cartMessage", "Item added to cart!");
        String referer = request.getParameter("referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("MenuServlet?restaurantId=" + restaurantId);
        }
    }
    
    /**
     * Handle updating item quantity in cart
     */
    private void handleUpdateItem(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));
        
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect("CartServlet");
            return;
        }
        
        // Check if itemId is provided (new approach)
        String itemIdParam = request.getParameter("itemId");
        if (itemIdParam != null && !itemIdParam.isEmpty()) {
            int itemId = Integer.parseInt(itemIdParam);
            // Find item by cartItemId
            CartItem itemToUpdate = findCartItemById(cart, itemId);
            
            if (itemToUpdate != null) {
                if (newQuantity <= 0) {
                    // Remove if quantity <= 0
                    cart.removeItemById(itemId);
                } else {
                    // Update quantity and total
                    itemToUpdate.setQuantity(newQuantity);
                    itemToUpdate.setItemTotal(newQuantity * itemToUpdate.getItemPrice());
                }
                updateCartTotal(cart);
            }
        } else {
            // Fallback to productId if itemId not provided (old approach)
            int productId = Integer.parseInt(request.getParameter("productId"));
            CartItem item = findCartItem(cart, productId);
            if (item != null) {
                if (newQuantity <= 0) {
                    cart.removeItem(productId);
                } else {
                    item.setQuantity(newQuantity);
                    item.setItemTotal(newQuantity * item.getItemPrice());
                }
                updateCartTotal(cart);
            }
        }
        
        // Clear cart if empty
        if (cart.getItems().isEmpty()) {
            session.removeAttribute("cart");
            session.removeAttribute("restaurantId");
        }
        
        response.sendRedirect("CartServlet");
    }
    
    /**
     * Handle removing item from cart
     */
    private void handleRemoveItem(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect("CartServlet");
            return;
        }
        
        // Remove item from cart
        cart.removeItem(productId);
        
        // If cart is empty, clear session
        if (cart.getItems().isEmpty()) {
            session.removeAttribute("cart");
            session.removeAttribute("restaurantId");
        } else {
            updateCartTotal(cart);
        }
        
        response.sendRedirect("CartServlet");
    }
    
    /**
     * Find cart item by product id
     */
    private CartItem findCartItem(Cart cart, int productId) {
        if (cart == null || cart.getItems() == null) {
            return null;
        }
        
        for (CartItem item : cart.getItems()) {
            if (item.getProductId() == productId) {
                return item;
            }
        }
        return null;
    }
    
    /**
     * Find cart item by cartItemId
     */
    private CartItem findCartItemById(Cart cart, int itemId) {
        if (cart == null || cart.getItems() == null) {
            return null;
        }
        
        for (CartItem item : cart.getItems()) {
            if (item.getCartItemId() == itemId) {
                return item;
            }
        }
        return null;
    }
    
    /**
     * Update cart total
     */
    private void updateCartTotal(Cart cart) {
        if (cart == null) {
            return;  // Nothing to update if cart doesn't exist
        }
        if (cart.getItems() == null) {
            cart.setCartTotal(0.0);
            return;
        }
        
        double total = 0.0;
        for (CartItem item : cart.getItems()) {
            total += item.getItemTotal();
        }
        cart.setCartTotal(total);
    }
    
    /**
     * Get menu item by id
     */
    private Menu getMenuById(int menuId) {
        try {
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            return menuDAO.getMenu(menuId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
