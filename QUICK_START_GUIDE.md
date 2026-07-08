# Quick Start Guide - Cart Functionality

## 🎯 What's Been Implemented

Your JEE Food App now has a fully functional shopping cart system that uses your existing **Order** and **OrderItem** database tables.

---

## 🗂️ New Files Created

### Servlets (in `src/com/dcl/servlet/`):
1. **AddToCartServlet.java** - Adds menu items to cart
2. **ViewCartServlet.java** - Displays cart contents  
3. **UpdateCartServlet.java** - Updates quantities and removes items

### JSP (in `WebContent/`):
1. **cart.jsp** - Shopping cart page UI

### Utility (in `src/com/dcl/utility/`):
1. **CartHelper.java** - Helper methods for cart operations

### Modified Files:
1. **menu.jsp** - Added working "Add to Cart" buttons
2. **restaurants.jsp** - Added cart link with badge

---

## 📖 How It Works

### The Key Concept:
Your **orders** table serves dual purpose:
- Orders with `status = 'CART'` → Shopping cart items
- Orders with other statuses → Completed/pending orders

### User Flow:
```
Login → Browse Restaurants → Select Restaurant → View Menu 
→ Click "Add to Cart" → Item added to order with status='CART'
→ View Cart → Update quantities or Remove items → Proceed to Checkout
```

---

## 🚀 How to Test

### Step 1: Start the Application
1. Open Eclipse
2. Right-click project → Run As → Run on Server
3. Select Apache Tomcat v10.0

### Step 2: Login
- Navigate to: `http://localhost:8080/JEE_Food_APP/login.jsp`
- Login with your test user credentials

### Step 3: Browse and Add to Cart
1. Click "Restaurants" from navbar
2. Click on any restaurant card
3. Browse menu items
4. Click "Add to Cart" on any available item
5. You'll see a success message: "✓ Item added to cart successfully!"
6. Notice the cart badge shows item count (red circle with number)

### Step 4: View Cart
1. Click "🛒 View Cart" from navbar
2. See all your cart items
3. Try these actions:
   - Click **+** to increase quantity
   - Click **−** to decrease quantity
   - Click **Remove** to delete item
4. Notice the total amount updates automatically

### Step 5: Verify Database
Open MySQL Workbench and run:

```sql
-- See cart orders
SELECT * FROM orders WHERE status = 'CART';

-- See cart items
SELECT o.order_id, o.user_id, o.status, oi.product_id, oi.quantity, oi.item_total
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART';
```

---

## 🎨 UI Features

### Menu Page:
- ✅ "Add to Cart" button on each menu item
- ✅ Success message when item added
- ✅ Cart badge showing total items (red circle)
- ✅ Navigation links to restaurants and cart

### Cart Page:
- ✅ List of all cart items with details
- ✅ Item name, restaurant name, price
- ✅ Quantity controls (+/− buttons)
- ✅ Remove button for each item
- ✅ Order summary with:
  - Subtotal
  - Delivery Fee (₹40)
  - GST (5%)
  - **Total Amount**
- ✅ "Proceed to Checkout" button (placeholder)
- ✅ Empty cart message when no items

---

## 🔍 Technical Details

### Database Operations:

**When you click "Add to Cart":**
```
1. Check if you have a CART order for this restaurant
2. If NO → Create new order with status='CART'
3. If YES → Use existing order
4. Add item to order_items table
5. Update order's total_amount
```

**When you update quantity:**
```
1. Calculate new item_total = price × new_quantity
2. Update order_items table
3. Recalculate and update order's total_amount
```

**When you remove item:**
```
1. Delete from order_items table
2. Update order's total_amount
3. If no items left → Delete the order
```

---

## 📊 URL Mapping

| URL | Description |
|-----|-------------|
| `/MenuServlet?restaurantId=X` | View restaurant menu |
| `/AddToCartServlet` (POST) | Add item to cart |
| `/ViewCartServlet` | View shopping cart |
| `/UpdateCartServlet` (POST) | Update cart (quantity/remove) |

---

## 🛠️ Form Parameters

### Add to Cart Form:
```html
<form action="AddToCartServlet" method="post">
    <input type="hidden" name="menuId" value="123">
    <input type="hidden" name="restaurantId" value="456">
    <button type="submit">Add to Cart</button>
</form>
```

### Update Quantity Form:
```html
<form action="UpdateCartServlet" method="post">
    <input type="hidden" name="action" value="updateQuantity">
    <input type="hidden" name="orderItemId" value="789">
    <input type="hidden" name="quantity" value="3">
    <button type="submit">Update</button>
</form>
```

### Remove Item Form:
```html
<form action="UpdateCartServlet" method="post">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="orderItemId" value="789">
    <button type="submit">Remove</button>
</form>
```

---

## 🔐 Security

- ✅ All servlets check if user is logged in
- ✅ Users can only access their own cart
- ✅ SQL injection prevention using PreparedStatements
- ✅ Input validation for quantities and IDs

---

## 📱 Responsive Design

The cart page is fully responsive:
- Desktop: Two-column layout (items | summary)
- Mobile: Single-column layout (stacked)
- All buttons are touch-friendly
- Readable fonts and spacing

---

## ⚡ Performance

- Efficient SQL queries with JOINs
- Minimal database round-trips
- Session-based user tracking
- Prepared statement caching

---

## 🐛 Troubleshooting

### Issue: "Not logged in" redirect
**Solution:** Make sure you're logged in first via login.jsp

### Issue: Cart badge not showing
**Solution:** Add at least one item to cart and refresh

### Issue: Database error
**Solution:** 
- Check database connection in `DBConnection.java`
- Verify tables exist: `orders`, `order_items`, `menu`, `restaurant`
- Ensure `orders.status` column exists and is VARCHAR

### Issue: Items not appearing in cart
**Solution:**
- Check browser console for errors
- Verify servlet mappings in `@WebServlet` annotations
- Check Tomcat logs for exceptions

---

## 🎯 Next Steps (Future Enhancements)

1. **Checkout Process:**
   - Change order status from 'CART' to 'PENDING'
   - Add payment gateway integration
   - Generate order confirmation

2. **Order History:**
   - View past orders
   - Track order status
   - Reorder functionality

3. **Enhanced Cart:**
   - Apply discount coupons
   - Special instructions per item
   - Save for later option

4. **Notifications:**
   - Email order confirmation
   - SMS updates
   - In-app notifications

---

## 📞 Need Help?

If something doesn't work:
1. Check **Tomcat Console** for error logs
2. Open **browser developer tools** (F12) → Console tab
3. Verify database connection and table structure
4. Ensure you're logged in with a valid user

---

## ✅ Implementation Complete!

Your cart system is ready to use. The implementation:
- ✅ Uses your Order/OrderItem tables (not Cart/CartItem)
- ✅ Follows your existing project structure
- ✅ Matches your coding style
- ✅ Integrates seamlessly with existing code
- ✅ Provides a complete user experience

**Happy Coding! 🚀**
