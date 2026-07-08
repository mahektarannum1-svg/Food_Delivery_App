# 🐛 PROBLEMS.md — Food Delivery App Issue Tracker

> Items will be removed from this list as they are fixed.
> Last updated: 2026-07-08

---

## 🔴 CRITICAL — Breaks the App

### P-01 · DBConnection: Wrong database name & hardcoded credentials
- **File:** [DBConnection.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/utility/DBConnection.java) line 8
- **Issue:** URL uses `instant_food` but the actual database is named `InstantFood`. Also, MySQL credentials might fail if the password doesn't match the environment (we need to test the connection first).
- **Status:** Pending

### P-02 · CheckoutServlet: Unused imports & compilation warnings
- **File:** [CheckoutServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/CheckoutServlet.java) line 4
- **Issue:** `import java.sql.SQLException;` is imported but never used, which can cause warnings depending on compiler settings.
- **Status:** Pending

### P-03 · CheckoutServlet: Silently swallows exceptions and displays order ID 0
- **File:** [CheckoutServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/CheckoutServlet.java) line 127
- **Issue:** If `orderDAO.addOrder()` fails or doesn't generate keys, it fails silently. The user is still redirected to `orderConfirmation.jsp` showing order ID `#0`.
- **Status:** Pending

### P-04 · OrderDAOImpl: `delivery_address` and `created_date` columns are NOT saved to the database
- **File:** [OrderDAOImpl.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/DAOImpl/OrderDAOImpl.java) line 19
- **Issue:** The insert query is `INSERT INTO orders (user_id, restaurant_id, total_amount, status, payment_mode) VALUES (?, ?, ?, ?, ?)`. It completely omits the `delivery_address` and `created_date` columns, meaning the address entered by the user at checkout is never saved!
- **Status:** Pending

### P-05 · OrderDAOImpl: `mapResultSetToOrder()` misses the `delivery_address` column
- **File:** [OrderDAOImpl.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/DAOImpl/OrderDAOImpl.java) line 151
- **Issue:** When reading orders from the database, it maps `created_date` but completely misses `delivery_address`.
- **Status:** Pending

### P-06 · Cart: `itemIdCounter` is `static` and shared across all active sessions
- **File:** [Cart.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/model/Cart.java) line 12
- **Issue:** `private static int itemIdCounter = 0;` means if User A adds an item, the counter becomes 1. If User B adds an item in a separate session, the counter becomes 2. This is thread-unsafe and causes unpredictable `cartItemId` behaviors for session-based shopping carts.
- **Status:** Pending

### P-07 · restaurants.jsp: View Cart displays count and allows access without checking user session
- **File:** [restaurants.jsp](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/WebContent/restaurants.jsp)
- **Issue:** The page has header links but doesn't check if the user is logged in. It displays "View Cart" and allows clicking it even if no user is in session (which redirects to login.jsp without explanation). Also, it lacks an explicit "Login/Register" or "Logout" button in the navbar.
- **Status:** Pending

### P-08 · menu.jsp: Lack of session check and Login/Logout link in the navbar
- **File:** [menu.jsp](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/WebContent/menu.jsp)
- **Issue:** Similar to P-07, there is no conditional Login/Logout option in the header navbar.
- **Status:** Pending

---

## 🟡 MEDIUM — Functional Gaps / Logic Errors

### P-09 · No realistic sample data seeded for Restaurants
- **File:** [DataSeeder.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/utility/DataSeeder.java)
- **Issue:** Only seed menu items are defined, and it assumes restaurant IDs 1, 2, and 3 already exist in the database. If the database is empty, the menu items cannot be added due to foreign key constraints, or the user won't see any restaurants.
- **Status:** Pending

### P-10 · CartServlet: Changing restaurants silently clears the cart
- **File:** [CartServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/CartServlet.java) line 100
- **Issue:** If a user already has items in their cart from Restaurant A and adds an item from Restaurant B, the existing cart is silently overwritten. There is no warning.
- **Status:** Pending

### P-11 · index.jsp: Broken encoding emoji in features section
- **File:** [index.jsp](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/WebContent/index.jsp) line 134
- **Issue:** The first feature icon contains corrupted characters `` instead of a rocket/delivery emoji.
- **Status:** Pending

### P-12 · No Payment page implementation
- **File:** [checkout.jsp](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/WebContent/checkout.jsp) & [CheckoutServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/CheckoutServlet.java)
- **Issue:** Clicking "Place Order" on the checkout page immediately submits the order to the database. The functional requirements request a simple simulated payment page before final confirmation.
- **Status:** Pending

### P-13 · UserServlet: Registration doesn't check for duplicate emails
- **File:** [UserServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/UserServlet.java) line 75
- **Issue:** Registration processes the email directly. If the email is already registered, the DB insert will fail (or insert a duplicate if constraints are missing).
- **Status:** Pending

---

## 🟢 LOW — Code Quality / Improvements

### P-14 · Duplicate/Dead Code Servlet
- **File:** [GetAllRestaurantsServlet.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/servlet/GetAllRestaurantsServlet.java)
- **Issue:** This servlet is identical in functionality to `RestaurantServlet` but is not referenced by the welcome file or other JSPs.
- **Status:** Pending

### P-15 · RestaurantDAOImpl: Fetches inactive restaurants
- **File:** [RestaurantDAOImpl.java](file:///C:/Users/welcome/eclipse-workspace/JEE_Food_APP/src/com/dcl/DAOImpl/RestaurantDAOImpl.java) line 90
- **Issue:** `getAllRestaurants()` fetches all records from the database without filtering out inactive ones (`is_active = FALSE`).
- **Status:** Pending
