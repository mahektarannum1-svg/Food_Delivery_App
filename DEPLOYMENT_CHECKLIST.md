# 📋 Deployment & Testing Checklist

## Pre-Deployment Checklist

### ✅ Eclipse Setup
- [ ] Eclipse IDE is open
- [ ] Project is imported in workspace
- [ ] No compilation errors in Problems view
- [ ] Apache Tomcat v10.0 is configured
- [ ] Project facets are correct (Dynamic Web Module 4.0)

### ✅ Database Setup
- [ ] MySQL server is running
- [ ] Database "instant_food" exists
- [ ] Tables exist: orders, order_items, menu, restaurant, user
- [ ] `orders` table has `status` column (VARCHAR)
- [ ] Sample data exists (restaurants, menus, users)
- [ ] Database connection works (test with DBConnection.java)

### ✅ Configuration
- [ ] DBConnection.java has correct credentials
  - Database: instant_food
  - Host: localhost:3306
  - Username: root
  - Password: admin (or your password)
- [ ] MySQL Connector JAR is in WebContent/WEB-INF/lib/
- [ ] web.xml is properly configured

---

## Deployment Steps

### Step 1: Clean Build
- [ ] Right-click project → Clean
- [ ] Right-click project → Build Project
- [ ] Verify no errors in Console

### Step 2: Start Server
- [ ] Right-click project → Run As → Run on Server
- [ ] Select Apache Tomcat v10.0
- [ ] Click Finish
- [ ] Wait for server to start (check Console)
- [ ] Look for "Server startup in X milliseconds"

### Step 3: Verify URLs
- [ ] Open browser
- [ ] Navigate to: http://localhost:8080/JEE_Food_APP/
- [ ] Should see home page or redirect to login

---

## Functional Testing Checklist

### 🔐 Authentication
- [ ] Can access login page: `/login.jsp`
- [ ] Can login with valid credentials
- [ ] Invalid credentials show error
- [ ] Session is created (check browser DevTools → Application → Cookies)
- [ ] After login, redirects to restaurants page

### 🏪 Browse Restaurants
- [ ] Can access restaurants page: `/RestaurantServlet`
- [ ] Restaurants display in grid
- [ ] Each restaurant shows name, cuisine, rating, delivery time
- [ ] Clicking restaurant opens menu page
- [ ] Cart badge appears in navbar (🛒 View Cart)

### 🍕 Menu Page
- [ ] Menu page loads: `/MenuServlet?restaurantId=X`
- [ ] Menu items display for selected restaurant
- [ ] Each item shows name, description, price
- [ ] "Add to Cart" button appears on available items
- [ ] "Not Available" shows for unavailable items
- [ ] Can click "Add to Cart" button

### ➕ Add to Cart
- [ ] Click "Add to Cart" on a menu item
- [ ] Success message appears: "✓ Item added to cart successfully!"
- [ ] Cart badge updates (shows number: 1, 2, 3...)
- [ ] Can add multiple items
- [ ] Can add same item multiple times (quantity increases)
- [ ] Can add items from different sections

### 🛒 View Cart
- [ ] Click "🛒 View Cart" in navbar
- [ ] Cart page loads: `/ViewCartServlet`
- [ ] All added items appear
- [ ] Each item shows:
  - [ ] Item name
  - [ ] Restaurant name
  - [ ] Unit price
  - [ ] Quantity
  - [ ] Item total (price × quantity)
- [ ] Cart badge number matches item count
- [ ] Order summary shows:
  - [ ] Items subtotal
  - [ ] Delivery fee (₹40)
  - [ ] GST (5%)
  - [ ] Total amount

### 🔢 Update Quantity
- [ ] Click **+** button on an item
- [ ] Quantity increases by 1
- [ ] Item total updates (price × new quantity)
- [ ] Order total updates
- [ ] Click **−** button on an item
- [ ] Quantity decreases by 1
- [ ] Item total updates
- [ ] Order total updates
- [ ] When quantity reaches 0, item is removed

### 🗑️ Remove Item
- [ ] Click "Remove" button on an item
- [ ] Confirmation dialog appears (optional)
- [ ] Item is removed from cart
- [ ] Order total updates
- [ ] Cart badge updates
- [ ] If last item removed, empty cart message appears

### 🏷️ Empty Cart
- [ ] Remove all items from cart
- [ ] Empty cart message appears:
  - [ ] 🛒 icon
  - [ ] "Your cart is empty" text
  - [ ] "Browse Restaurants" button
- [ ] Click "Browse Restaurants"
- [ ] Redirects to restaurants page
- [ ] Cart badge disappears or shows 0

### 🔄 Navigation
- [ ] All navbar links work
- [ ] Can navigate: Home → Restaurants → Menu → Cart
- [ ] Back buttons work correctly
- [ ] "Continue Shopping" redirects to restaurants
- [ ] Can add items from multiple restaurants

---

## Database Verification

### Check Cart Data
Open MySQL Workbench and run these queries:

#### 1. Verify Cart Orders Exist
```sql
SELECT * FROM orders WHERE status = 'CART';
```
**Expected**: Should show orders with status='CART' for logged-in users

#### 2. Verify Cart Items Exist
```sql
SELECT 
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.item_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'CART';
```
**Expected**: Should show items in cart orders

#### 3. Verify Totals are Correct
```sql
SELECT 
    o.order_id,
    o.total_amount AS stored_total,
    COALESCE(SUM(oi.item_total), 0) AS calculated_total,
    (o.total_amount - COALESCE(SUM(oi.item_total), 0)) AS difference
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART'
GROUP BY o.order_id, o.total_amount;
```
**Expected**: difference should be 0 (or very close to 0)

#### 4. Verify No Orphaned Items
```sql
SELECT COUNT(*) FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
```
**Expected**: 0 rows

#### 5. Verify No Empty Carts
```sql
SELECT COUNT(*) FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART' AND oi.order_item_id IS NULL;
```
**Expected**: 0 rows

---

## Security Testing

### Session Management
- [ ] Cannot access cart without logging in
- [ ] Accessing `/ViewCartServlet` without login redirects to login page
- [ ] User can only see their own cart items
- [ ] Logout clears session
- [ ] After logout, cannot access cart

### SQL Injection Prevention
- [ ] Try entering `' OR '1'='1` in quantity field (should fail safely)
- [ ] Special characters in inputs don't break queries
- [ ] All database queries use PreparedStatements

### Input Validation
- [ ] Cannot set negative quantity
- [ ] Cannot set quantity to non-numeric value
- [ ] Invalid menuId parameters handled gracefully
- [ ] Invalid restaurantId parameters handled gracefully

---

## Performance Testing

### Response Time
- [ ] Menu page loads in < 1 second
- [ ] Add to cart responds in < 500ms
- [ ] View cart loads in < 1 second
- [ ] Update quantity responds in < 500ms

### Database Load
- [ ] Check query execution time in MySQL logs
- [ ] Verify indexes exist (if needed)
- [ ] No N+1 query problems (should use JOINs)

### Concurrent Users (Optional)
- [ ] Login with multiple users in different browsers
- [ ] Each user has separate cart
- [ ] No cart data mixing between users

---

## UI/UX Testing

### Desktop (1920x1080)
- [ ] All elements visible
- [ ] Grid layouts work
- [ ] Buttons are clickable
- [ ] Text is readable
- [ ] Images display properly

### Tablet (768px width)
- [ ] Responsive layout adjusts
- [ ] All features accessible
- [ ] Touch-friendly buttons

### Mobile (375px width)
- [ ] Single column layout
- [ ] Cart items stack vertically
- [ ] Buttons are large enough
- [ ] Text is readable

### Browser Compatibility
- [ ] Chrome: All features work
- [ ] Firefox: All features work
- [ ] Edge: All features work
- [ ] Safari (if available): All features work

---

## Error Handling

### Network Errors
- [ ] Database connection failure shows error message
- [ ] Server error (500) handled gracefully
- [ ] Page not found (404) handled

### User Errors
- [ ] Adding unavailable item shows message
- [ ] Invalid operations show friendly errors
- [ ] Empty required fields validated

---

## Console Checks

### Browser Console (F12 → Console)
- [ ] No JavaScript errors
- [ ] No 404 errors for resources
- [ ] No CORS errors

### Tomcat Console
- [ ] No exceptions during startup
- [ ] No SQL errors during operations
- [ ] No NullPointerExceptions
- [ ] Servlet mappings loaded correctly

---

## Final Verification

### Code Quality
- [ ] No compilation warnings
- [ ] All imports resolved
- [ ] Code follows project conventions
- [ ] Comments are clear

### Documentation
- [ ] README files are readable
- [ ] Implementation guide is complete
- [ ] SQL queries are tested
- [ ] Architecture diagrams are clear

### Files Present
- [ ] All 3 new servlets exist
- [ ] cart.jsp exists
- [ ] CartHelper.java exists
- [ ] Modified JSPs have changes
- [ ] Documentation files present

---

## Production Readiness

### Before Go-Live
- [ ] All tests passed
- [ ] Database backup created
- [ ] Error logging configured
- [ ] Performance acceptable
- [ ] Security validated
- [ ] User acceptance testing done

### Post-Deployment
- [ ] Monitor server logs
- [ ] Check error rates
- [ ] Verify user feedback
- [ ] Monitor database performance
- [ ] Track cart abandonment rate

---

## Troubleshooting Guide

### Issue: Login redirects back to login
**Fix**: Check session is being created in UserServlet

### Issue: Cart badge not showing
**Fix**: Add items and refresh, verify CartHelper.getCartItemCount()

### Issue: Database connection error
**Fix**: Verify MySQL is running, check DBConnection.java credentials

### Issue: Items not appearing in cart
**Fix**: Check Tomcat console for exceptions, verify SQL queries

### Issue: Totals not calculating
**Fix**: Check updateOrderTotal() method, verify SQL SUM query

### Issue: Empty cart not cleaning up
**Fix**: Check UpdateCartServlet deleteOrder() logic

### Issue: 404 for servlets
**Fix**: Verify @WebServlet annotations, check servlet mappings

### Issue: Session timeout
**Fix**: Configure session timeout in web.xml or increase default

---

## Success Criteria

### All Must Pass:
✅ User can login  
✅ User can browse restaurants  
✅ User can view menu  
✅ User can add items to cart  
✅ Cart badge updates correctly  
✅ User can view cart  
✅ User can update quantities  
✅ User can remove items  
✅ Totals calculate correctly  
✅ Database reflects changes  
✅ No errors in console  
✅ Security is enforced  
✅ UI is responsive  

### If All Pass:
🎉 **DEPLOYMENT SUCCESSFUL!** 🎉

---

## Post-Deployment Tasks

### Monitor
- [ ] Check server logs daily
- [ ] Monitor error rates
- [ ] Track cart conversion rate
- [ ] Gather user feedback

### Optimize (If Needed)
- [ ] Add database indexes
- [ ] Enable connection pooling
- [ ] Add caching where appropriate
- [ ] Optimize slow queries

### Plan Next Phase
- [ ] Design checkout process
- [ ] Plan payment integration
- [ ] Design order confirmation
- [ ] Plan email notifications

---

## Sign-Off

**Tested By**: ___________________  
**Date**: ___________________  
**Status**: [ ] PASS  [ ] FAIL  
**Notes**: ___________________  

---

**Remember**: This is your production checklist. Complete each item before deploying to live environment!

Good luck! 🚀
