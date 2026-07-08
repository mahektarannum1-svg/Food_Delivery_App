package com.dcl.model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int cartId;
    private int userId;
    private int restaurantId;
    private double cartTotal;
    private List<CartItem> items;
    private int itemIdCounter = 0;  // For generating unique IDs in session

    public Cart() {
        this.items = new ArrayList<>();
        this.cartTotal = 0.0;
    }

    public Cart(int userId) {
        this();
        this.userId = userId;
    }

    public Cart(int userId, int restaurantId) {
        this();
        this.userId = userId;
        this.restaurantId = restaurantId;
    }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public double getCartTotal() { return cartTotal; }
    public void setCartTotal(double cartTotal) { this.cartTotal = cartTotal; }

    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }

    /**
     * Add item to cart
     */
    public void addItem(CartItem item) {
        if (this.items == null) {
            this.items = new ArrayList<>();
        }
        // Set unique ID for session cart item
        item.setCartItemId(++itemIdCounter);
        this.items.add(item);
    }

    /**
     * Remove item from cart by product id
     */
    public void removeItem(int productId) {
        if (this.items != null) {
            this.items.removeIf(item -> item.getProductId() == productId);
        }
    }
    
    /**
     * Remove item from cart by cartItemId
     */
    public void removeItemById(int itemId) {
        if (this.items != null) {
            this.items.removeIf(item -> item.getCartItemId() == itemId);
        }
    }

    /**
     * Get item count
     */
    public int getItemCount() {
        if (this.items == null) {
            return 0;
        }
        return this.items.size();
    }

    /**
     * Check if cart is empty
     */
    public boolean isEmpty() {
        return this.items == null || this.items.isEmpty();
    }

    @Override
    public String toString() {
        return "Cart{" + "cartId=" + cartId + ", userId=" + userId + 
               ", restaurantId=" + restaurantId + ", cartTotal=" + cartTotal + 
               ", itemCount=" + getItemCount() + '}';
    }
}
