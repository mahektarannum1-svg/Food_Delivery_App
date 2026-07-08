# JEE Food Delivery App — Agent README

> **For any AI agent** picking up this project: read this file in full before making any changes.

---

## Project Overview

A Java EE food delivery web application built with:
- **Servlets** (javax.servlet — Tomcat 9 API)
- **JSP** pages
- **JDBC** + MySQL
- **DAO Pattern** (interfaces + implementations)
- **Session-based cart** (no DB cart persistence)

---

## Project Structure

```
JEE_Food_APP/
├── src/com/dcl/
│   ├── model/          — POJO classes (User, Restaurant, Menu, Cart, CartItem, Order, OrderItem, etc.)
│   ├── dao/            — DAO interfaces
│   ├── DAOImpl/        — DAO implementations
│   ├── servlet/        — Servlet classes
│   └── utility/        — DBConnection, CartHelper, PasswordUtil, DataSeeder
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml     — Servlet mappings (javax namespace — Tomcat 9)
│   │   └── lib/        — mysql-connector-j-9.7.0.jar
│   ├── index.jsp       — Landing page
│   ├── login.jsp       — Login form
│   ├── register.jsp    — Registration form
│   ├── restaurants.jsp — Restaurant listing
│   ├── menu.jsp        — Menu items for selected restaurant
│   ├── cart.jsp        — Shopping cart
│   ├── checkout.jsp    — Checkout form
│   └── orderConfirmation.jsp — Order success page
```

---

## Database: `instant_food` on MySQL (localhost:3306)

**Credentials:** user=`root`, password=`admin`

### CRITICAL — Table Name Mapping (known gotcha)

| Java Layer calls it | Actual DB Table | Note |
|---------------------|-----------------|------|
| `menu` / Menu class | **`products`**  | The DB uses `products` not `menu`. MenuDAOImpl has been fixed to use `products`. |
| `menu_id` | **`product_id`** | MenuDAOImpl maps `product_id` → `menuId` |

### Tables and Key Columns

| Table | Key Columns |
|-------|-------------|
| `user` | user_id, username, email, password, password_salt, address, role (ENUM: CUSTOMER/ADMIN), created_date, last_login_date |
| `restaurant` | restaurant_id, name, cuisine_type, delivery_time, address, rating, is_active, image_url |
| **`products`** | product_id, restaurant_id, category_id, name, description, price, is_available, image_url |
| `categories` | category_id, name |
| `orders` | order_id, user_id, restaurant_id, total_amount, status, payment_mode, created_date |
| `order_items` | order_item_id, order_id, product_id, quantity, item_total |
| `cart` | cart_id, user_id *(not used — cart is session-based)* |
| `cart_items` | cart_item_id, cart_id, product_id, quantity *(not used — cart is session-based)* |
| `addresses` | address_id, user_id, label, address_line, city, zip_code, is_default |
| `reviews` | review_id, user_id, restaurant_id, rating, comment, created_date |

### Demo Data (pre-seeded)

- **Demo User:** `demo@food.com` / `demo123`
- **Restaurants:** Pizza Palace (Italian), Spice Route (Indian), Burger Barn (American)
- Each restaurant has 5-7 menu items

---

## Servlet URL Mappings

| Servlet | URL | Purpose |
|---------|-----|---------|
| `RestaurantServlet` | `/RestaurantServlet` | Lists all active restaurants |
| `GetAllRestaurantsServlet` | `/GetAllRestaurantsServlet` | Alias for above |
| `MenuServlet` | `/MenuServlet?restaurantId=N` | Shows menu for restaurant N |
| `CartServlet` GET | `/CartServlet` | View cart |
| `CartServlet` POST | `/CartServlet?action=add/update/remove` | Cart operations |
| `CheckoutServlet` GET | `/checkout` | Show checkout page |
| `CheckoutServlet` POST | `/checkout` | Place order → saves to DB → redirects to orderConfirmation.jsp |
| `UserServlet` GET | `/UserServlet?action=logout` | Logout |
| `UserServlet` POST | `/UserServlet?action=login` | Login |
| `UserServlet` POST | `/UserServlet?action=register` | Register |

---

## Cart Implementation

The cart is **session-based** (NOT database-persisted):
- `Cart` object stored in `session.getAttribute("cart")`
- `restaurantId` stored in `session.getAttribute("restaurantId")`  
- Switching restaurants clears the old cart automatically
- `CartHelper.getCartItemCount(session)` returns item count for navbar badge

---

## User Flow

```
index.jsp → RestaurantServlet → restaurants.jsp
         → MenuServlet?restaurantId=N → menu.jsp
         → CartServlet (POST action=add) → menu.jsp
         → CartServlet (GET) → cart.jsp
         → /checkout (GET) → checkout.jsp
         → /checkout (POST) → [saves order to DB] → orderConfirmation.jsp
```

Authentication required for cart and checkout (redirects to `login.jsp` if not logged in).

---

## Known Architecture Constraints

1. **DO NOT** introduce Spring, Spring Boot, JPA, Hibernate, or any new framework
2. **DO NOT** rename packages (`com.dcl`)
3. The app uses `javax.servlet.*` — this means **Tomcat 9**, NOT Tomcat 10 (which uses `jakarta.servlet.*`)
4. The `CartServlet` uses `@WebServlet` annotation AND has web.xml entry — both are fine (no conflict with servlet spec 3.1)
5. **Password hashing:** SHA-256 with random salt via `PasswordUtil`. Salt stored in `password_salt` column.

---

## Bugs Fixed (Already Resolved — Do NOT Re-introduce)

| Bug | Fix Applied |
|-----|-------------|
| `CartHelper.java` was empty (0 bytes) | Implemented `getCartItemCount(session)` |
| `MenuDAOImpl` queried non-existent `menu` table | Rewrote to use `products` table |
| `DBConnection` had static `Connection` field (thread-unsafe) | Removed static field; now creates fresh connection each call |
| `CheckoutServlet.init()` declared invalid checked exceptions | Removed try-catch from init() |
| `CheckoutServlet` redirected to `login.html` (doesn't exist) | Fixed to `login.jsp` |
| `User.getFullName()` didn't exist (checkout.jsp called it) | Added method returning `username` |
| `CartServlet.updateCartTotal()` NPE when cart==null | Added null guard |
| `web.xml` used old java.sun.com namespace | Fixed to xmlns.jcp.org |
| `CartServlet` and `CheckoutServlet` missing from web.xml | Added both servlet mappings |
| `register.jsp` was missing (login.jsp linked to it) | Created `register.jsp` |
| `OrderDAOImpl.addOrder()` had connection leak | Wrapped in try-with-resources |
| `restaurants.jsp` showed gradient even when imageUrl set | Fixed to render `<img>` tag |
| All DB tables were empty | Seeded 3 restaurants, 19 menu items, 1 demo user |

---

## How to Run

1. Ensure MySQL is running on localhost:3306
2. Database `instant_food` must exist with all tables populated
3. Import project into Eclipse as "Existing Project into Workspace"
4. Set server runtime to **Apache Tomcat 9.x** (NOT Tomcat 10)
5. Right-click project → Run As → Run on Server
6. Navigate to `http://localhost:8080/JEE_Food_APP/`
7. Login with `demo@food.com` / `demo123`

---

## Re-Seeding the Database

If you need to reset the data, run the seeder from the scratch directory:
```
C:\Users\welcome\.gemini\antigravity\brain\91abe67f-b165-42b8-8139-59d87841eab0\scratch\SeedDatabase.java
```
Compile and run with the MySQL connector JAR from `WebContent/WEB-INF/lib/`.
