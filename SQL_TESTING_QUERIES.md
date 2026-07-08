# SQL Testing Queries for Cart Implementation

## 📊 Database Testing & Verification

Use these SQL queries in **MySQL Workbench** to test and verify the cart functionality.

---

## 🔍 View All Cart Orders

```sql
-- See all orders that are currently in CART status
SELECT 
    o.order_id,
    o.user_id,
    u.username,
    o.restaurant_id,
    r.name AS restaurant_name,
    o.total_amount,
    o.status,
    o.created_date
FROM orders o
INNER JOIN user u ON o.user_id = u.user_id
INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'CART'
ORDER BY o.created_date DESC;
```

---

## 🛒 View All Items in Carts

```sql
-- See all items in all users' carts with details
SELECT 
    o.order_id,
    u.username,
    r.name AS restaurant_name,
    m.name AS menu_item,
    m.price AS unit_price,
    oi.quantity,
    oi.item_total,
    o.total_amount AS order_total
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN user u ON o.user_id = u.user_id
INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
INNER JOIN menu m ON oi.product_id = m.menu_id
WHERE o.status = 'CART'
ORDER BY u.username, r.name, m.name;
```

---

## 👤 View Specific User's Cart

```sql
-- Replace 1 with actual user_id
SELECT 
    oi.order_item_id,
    m.name AS item_name,
    m.description,
    m.price AS unit_price,
    oi.quantity,
    oi.item_total,
    r.name AS restaurant_name
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
INNER JOIN menu m ON oi.product_id = m.menu_id
INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
WHERE o.user_id = 1 AND o.status = 'CART';
```

---

## 📈 Cart Statistics by User

```sql
-- Get cart item count and total for each user
SELECT 
    u.user_id,
    u.username,
    COUNT(DISTINCT oi.order_item_id) AS total_items,
    COUNT(DISTINCT o.order_id) AS cart_orders_count,
    COALESCE(SUM(o.total_amount), 0) AS cart_total
FROM user u
LEFT JOIN orders o ON u.user_id = o.user_id AND o.status = 'CART'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.user_id, u.username
HAVING total_items > 0
ORDER BY cart_total DESC;
```

---

## 🏪 Cart Items by Restaurant

```sql
-- See which restaurants have items in users' carts
SELECT 
    r.restaurant_id,
    r.name AS restaurant_name,
    COUNT(DISTINCT o.order_id) AS active_carts,
    COUNT(oi.order_item_id) AS total_items,
    SUM(oi.quantity) AS total_quantity,
    COALESCE(SUM(oi.item_total), 0) AS potential_revenue
FROM restaurant r
INNER JOIN orders o ON r.restaurant_id = o.restaurant_id AND o.status = 'CART'
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY r.restaurant_id, r.name
ORDER BY potential_revenue DESC;
```

---

## 🔢 Check Cart Item Count for User

```sql
-- Get total number of items in a user's cart (for badge counter)
SELECT COUNT(*) AS cart_count
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.user_id = 1 AND o.status = 'CART';
```

---

## 💰 Calculate Cart Total for User

```sql
-- Get total amount for user's cart
SELECT 
    COALESCE(SUM(total_amount), 0) AS cart_total
FROM orders
WHERE user_id = 1 AND status = 'CART';
```

---

## 🧹 Clean Up Empty Cart Orders

```sql
-- Find and display orders with no items (should be deleted automatically)
SELECT 
    o.order_id,
    o.user_id,
    u.username,
    o.status,
    o.created_date
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN user u ON o.user_id = u.user_id
WHERE o.status = 'CART' 
  AND oi.order_item_id IS NULL;

-- Delete empty cart orders (if any exist - should be handled by servlet)
DELETE o
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART' 
  AND oi.order_item_id IS NULL;
```

---

## 🔍 Find Duplicate Items in Same Cart

```sql
-- Check if any user has duplicate menu items in their cart 
-- (should not happen - servlet merges quantities)
SELECT 
    o.order_id,
    o.user_id,
    oi.product_id,
    COUNT(*) AS duplicate_count
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART'
GROUP BY o.order_id, o.user_id, oi.product_id
HAVING duplicate_count > 1;
```

---

## 📊 Most Popular Cart Items

```sql
-- See which menu items are most frequently added to carts
SELECT 
    m.menu_id,
    m.name AS menu_item,
    r.name AS restaurant_name,
    COUNT(oi.order_item_id) AS times_in_cart,
    SUM(oi.quantity) AS total_quantity,
    COALESCE(SUM(oi.item_total), 0) AS potential_revenue
FROM menu m
INNER JOIN order_items oi ON m.menu_id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.order_id AND o.status = 'CART'
INNER JOIN restaurant r ON m.restaurant_id = r.restaurant_id
GROUP BY m.menu_id, m.name, r.name
ORDER BY times_in_cart DESC, total_quantity DESC
LIMIT 10;
```

---

## 🎯 Test Data Validation

```sql
-- Verify data integrity: all order_items have valid orders
SELECT 
    oi.order_item_id,
    oi.order_id,
    o.order_id AS valid_order
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
-- Should return 0 rows

-- Verify data integrity: all order_items have valid menu items
SELECT 
    oi.order_item_id,
    oi.product_id,
    m.menu_id AS valid_menu
FROM order_items oi
LEFT JOIN menu m ON oi.product_id = m.menu_id
WHERE m.menu_id IS NULL;
-- Should return 0 rows

-- Verify data integrity: all CART orders have items
SELECT 
    o.order_id,
    o.user_id,
    COUNT(oi.order_item_id) AS item_count
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART'
GROUP BY o.order_id, o.user_id
HAVING item_count = 0;
-- Should return 0 rows (empty carts should be deleted)
```

---

## 📅 Cart Age Analysis

```sql
-- Find old carts (items added more than 24 hours ago)
SELECT 
    o.order_id,
    u.username,
    r.name AS restaurant_name,
    COUNT(oi.order_item_id) AS items,
    o.total_amount,
    o.created_date,
    TIMESTAMPDIFF(HOUR, o.created_date, NOW()) AS hours_old
FROM orders o
INNER JOIN user u ON o.user_id = u.user_id
INNER JOIN restaurant r ON o.restaurant_id = r.restaurant_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART'
GROUP BY o.order_id, u.username, r.name, o.total_amount, o.created_date
HAVING hours_old > 24
ORDER BY hours_old DESC;
```

---

## 🧪 Sample Insert Queries (Testing)

```sql
-- Manually create a test cart order
INSERT INTO orders (user_id, restaurant_id, total_amount, status, payment_mode)
VALUES (1, 1, 0.0, 'CART', 'PENDING');

-- Get the generated order_id
SET @order_id = LAST_INSERT_ID();

-- Add items to the cart
INSERT INTO order_items (order_id, product_id, quantity, item_total)
VALUES 
    (@order_id, 1, 2, 200.0),  -- 2x item at ₹100 each
    (@order_id, 2, 1, 150.0);  -- 1x item at ₹150

-- Update the order total
UPDATE orders 
SET total_amount = (SELECT SUM(item_total) FROM order_items WHERE order_id = @order_id)
WHERE order_id = @order_id;

-- Verify
SELECT * FROM orders WHERE order_id = @order_id;
SELECT * FROM order_items WHERE order_id = @order_id;
```

---

## 🗑️ Clean Up Test Data

```sql
-- Delete all CART orders (careful! Only use for testing)
DELETE oi FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'CART';

DELETE FROM orders WHERE status = 'CART';

-- Verify cleanup
SELECT COUNT(*) AS cart_orders FROM orders WHERE status = 'CART';
SELECT COUNT(*) AS cart_items FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'CART';
```

---

## 🔄 Convert Cart to Order (Manual Test)

```sql
-- Simulate checkout: Change cart to pending order
UPDATE orders
SET status = 'PENDING',
    payment_mode = 'CARD',
    created_date = NOW()
WHERE order_id = 1 AND status = 'CART';

-- Verify
SELECT * FROM orders WHERE order_id = 1;
```

---

## 📈 Performance Check

```sql
-- Check if indexes exist for cart queries
SHOW INDEX FROM orders WHERE Key_name LIKE '%status%';
SHOW INDEX FROM orders WHERE Key_name LIKE '%user_id%';
SHOW INDEX FROM order_items WHERE Key_name LIKE '%order_id%';

-- Explain query performance
EXPLAIN SELECT COUNT(*) 
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.user_id = 1 AND o.status = 'CART';
```

---

## 🎯 Recommended Indexes (If Needed)

```sql
-- Add composite index for faster cart lookups
CREATE INDEX idx_orders_user_status 
ON orders(user_id, status);

-- Add index on order_items for faster joins
CREATE INDEX idx_order_items_order_product 
ON order_items(order_id, product_id);

-- Check index usage
SHOW INDEX FROM orders;
SHOW INDEX FROM order_items;
```

---

## 🔍 Debugging Queries

### Problem: Cart badge not showing correct count
```sql
-- Check what the CartHelper.getCartItemCount() returns
SELECT COUNT(*) as count 
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.user_id = 1 AND o.status = 'CART';
```

### Problem: Total amount not calculating correctly
```sql
-- Verify order total matches sum of items
SELECT 
    o.order_id,
    o.total_amount AS stored_total,
    COALESCE(SUM(oi.item_total), 0) AS calculated_total,
    (o.total_amount - COALESCE(SUM(oi.item_total), 0)) AS difference
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART'
GROUP BY o.order_id, o.total_amount
HAVING ABS(difference) > 0.01;  -- Allow for floating point errors
```

### Problem: Item prices don't match
```sql
-- Check if item_total = price × quantity
SELECT 
    oi.order_item_id,
    m.name,
    m.price,
    oi.quantity,
    oi.item_total AS stored_total,
    (m.price * oi.quantity) AS calculated_total,
    (oi.item_total - (m.price * oi.quantity)) AS difference
FROM order_items oi
INNER JOIN menu m ON oi.product_id = m.menu_id
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'CART'
HAVING ABS(difference) > 0.01;
```

---

## 📋 Full Cart Report

```sql
-- Comprehensive cart report for admins
SELECT 
    u.user_id,
    u.username,
    u.email,
    COUNT(DISTINCT o.order_id) AS cart_count,
    COUNT(DISTINCT r.restaurant_id) AS restaurants_count,
    COUNT(oi.order_item_id) AS total_items,
    SUM(oi.quantity) AS total_quantity,
    COALESCE(SUM(o.total_amount), 0) AS total_value,
    MIN(o.created_date) AS oldest_cart,
    MAX(o.created_date) AS newest_cart
FROM user u
LEFT JOIN orders o ON u.user_id = o.user_id AND o.status = 'CART'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN restaurant r ON o.restaurant_id = r.restaurant_id
GROUP BY u.user_id, u.username, u.email
HAVING cart_count > 0
ORDER BY total_value DESC;
```

---

## 🎯 Quick Testing Checklist

Run these queries after testing the application:

```sql
-- 1. Cart orders exist
SELECT COUNT(*) FROM orders WHERE status = 'CART';

-- 2. Cart items exist
SELECT COUNT(*) FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'CART';

-- 3. No orphaned items
SELECT COUNT(*) FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 4. No empty carts
SELECT COUNT(*) FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'CART' AND oi.order_item_id IS NULL;

-- 5. Totals are correct
SELECT COUNT(*) FROM orders o
WHERE o.status = 'CART' 
  AND ABS(o.total_amount - COALESCE((
      SELECT SUM(item_total) 
      FROM order_items 
      WHERE order_id = o.order_id
  ), 0)) > 0.01;
```

All counts should be appropriate (no orphans, no empty carts, correct totals).

---

**Use these queries to verify your cart implementation is working correctly!** 🎯
