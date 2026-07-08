package com.dcl.model;

public class CartItem {
    private int cartItemId;
    private int cartId;
    private int productId;
    private int quantity;
    private double itemPrice;
    private double itemTotal;
    private String itemName;

    public CartItem() {}

    public CartItem(int cartId, int productId, int quantity) {
        this.cartId = cartId;
        this.productId = productId;
        this.quantity = quantity;
    }

    public CartItem(int productId, int quantity, double itemPrice, String itemName) {
        this.productId = productId;
        this.quantity = quantity;
        this.itemPrice = itemPrice;
        this.itemName = itemName;
        this.itemTotal = quantity * itemPrice;
    }

    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getItemPrice() { return itemPrice; }
    public void setItemPrice(double itemPrice) { this.itemPrice = itemPrice; }

    public double getItemTotal() { return itemTotal; }
    public void setItemTotal(double itemTotal) { this.itemTotal = itemTotal; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    @Override
    public String toString() {
        return "CartItem{" + "cartItemId=" + cartItemId + ", productId=" + productId + 
               ", quantity=" + quantity + ", itemPrice=" + itemPrice + 
               ", itemTotal=" + itemTotal + ", itemName='" + itemName + '\'' + '}';
    }
}
