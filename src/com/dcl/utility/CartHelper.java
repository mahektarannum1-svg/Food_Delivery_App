package com.dcl.utility;

import javax.servlet.http.HttpSession;
import com.dcl.model.Cart;

/**
 * Utility helper for Cart operations (session-based cart).
 * Used by JSP pages to get cart item count without importing servlet API classes.
 */
public class CartHelper {

    /**
     * Returns the number of distinct items in the session cart.
     * Returns 0 if no cart exists in session.
     *
     * @param session the current HttpSession
     * @return number of items in cart
     */
    public static int getCartItemCount(HttpSession session) {
        if (session == null) {
            return 0;
        }
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            return 0;
        }
        return cart.getItemCount();
    }
}
