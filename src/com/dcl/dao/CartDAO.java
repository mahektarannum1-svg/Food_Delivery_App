package com.dcl.dao;

import java.util.List;
import com.dcl.model.Cart;
import com.dcl.model.CartItem;

public interface CartDAO {
    void addCart(Cart c);
    Cart getCartByUser(int userId);
    List<CartItem> getCartItems(int cartId);
    void addItemToCart(int cartId, int productId, int quantity);
    void updateCartItemQuantity(int cartItemId, int newQuantity);
    void removeItemFromCart(int cartItemId);
    void clearCart(int cartId);
}
