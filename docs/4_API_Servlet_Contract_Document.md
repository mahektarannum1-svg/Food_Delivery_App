# API/Servlet Contract Document
## JEE Food App - Servlet Interface Specifications

**Version:** 1.0  
**Date:** December 2024  
**API Team:** Development Team  

---

## Overview

This document defines the interface contracts for all servlets in the JEE Food App. Each servlet acts as a web controller, handling HTTP requests and responses. The contracts specify URL mappings, request parameters, response formats, and expected behaviors.

## General Servlet Conventions

### URL Mapping Standards
- All servlet URLs use camelCase or descriptive naming
- RESTful-like patterns where applicable
- Clear, intuitive endpoint names

### Request/Response Format
- **Content Type:** `application/x-www-form-urlencoded` for POST requests
- **Response Type:** HTML content via JSP forwarding or HTTP redirects
- **Character Encoding:** UTF-8
- **Session Management:** HTTP Session for state persistence

### Error Handling
- Errors displayed via request attributes
- Success messages via session or request attributes
- Graceful fallback to appropriate JSP pages
- Logging of technical errors for debugging

### Security
- Session validation for protected endpoints
- Input validation and sanitization
- SQL injection prevention via prepared statements
- Authentication required for user-specific operations

---

## Servlet Contracts

## 1. UserServlet

**URL Mapping:** `/user`  
**Purpose:** Handle user authentication, registration, and session management  
**Class:** `com.dcl.servlet.UserServlet`

### Endpoints

#### 1.1 User Login

**HTTP Method:** POST  
**URL:** `/user`  
**Action Parameter:** `login`

**Request Parameters:**
```
action: "login" (required)
email: String (required, valid email format)
password: String (required, 6-50 characters)
```

**Request Example:**
```html
<form action="user" method="post">
    <input type="hidden" name="action" value="login">
    <input type="email" name="email" value="user@example.com" required>
    <input type="password" name="password" required>
    <input type="submit" value="Login">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/RestaurantServlet` or `/restaurants.jsp`
- **Session:** User object stored in `session.getAttribute("user")`
- **Session:** User ID stored in `session.getAttribute("userId")`

**Error Response:**
- **HTTP Status:** 200 (Forward to login page)
- **Destination:** `login.jsp`
- **Request Attribute:** `error` - "Invalid email or password"
- **Preserved Data:** Email field value preserved for user convenience

**Validation Rules:**
- Email must be valid format
- Password cannot be empty
- User must exist in database
- Password must match stored hash

**Session Effects:**
- Creates HTTP session on successful login
- Stores User object: `session.setAttribute("user", user)`
- Stores User ID: `session.setAttribute("userId", userId)`

#### 1.2 User Registration

**HTTP Method:** POST  
**URL:** `/user`  
**Action Parameter:** `register`

**Request Parameters:**
```
action: "register" (required)
username: String (required, 3-30 characters, alphanumeric)
email: String (required, valid email format, unique)
password: String (required, 6-50 characters)
fullName: String (optional, 1-100 characters)
phoneNumber: String (optional, 10-15 digits)
```

**Request Example:**
```html
<form action="user" method="post">
    <input type="hidden" name="action" value="register">
    <input type="text" name="username" required>
    <input type="email" name="email" required>
    <input type="password" name="password" required>
    <input type="text" name="fullName">
    <input type="tel" name="phoneNumber">
    <input type="submit" value="Register">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `login.jsp`
- **Session Attribute:** `success` - "Registration successful. Please login."

**Error Response:**
- **HTTP Status:** 200 (Forward to registration page)
- **Destination:** `register.jsp` (or login.jsp with registration form)
- **Request Attribute:** `error` - Specific error message
- **Preserved Data:** All field values except password

**Possible Error Messages:**
- "Username already exists"
- "Email already registered"
- "Invalid email format"
- "Password must be at least 6 characters"
- "Registration failed. Please try again."

**Validation Rules:**
- Username: 3-30 characters, alphanumeric only
- Email: Valid format, must be unique
- Password: Minimum 6 characters
- Full name: Maximum 100 characters
- Phone: Numeric only, 10-15 digits

**Database Effects:**
- Creates new user record with hashed password and salt
- Sets default role to "CUSTOMER"
- Sets created_date to current timestamp

#### 1.3 User Logout

**HTTP Method:** GET or POST  
**URL:** `/user`  
**Action Parameter:** `logout`

**Request Parameters:**
```
action: "logout" (required)
```

**Request Example:**
```html
<a href="user?action=logout">Logout</a>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/` (home page or login page)
- **Session:** Session invalidated

**Session Effects:**
- Invalidates entire HTTP session
- Clears user authentication state
- Preserves no user data after logout

---

## 2. RestaurantServlet

**URL Mapping:** `/RestaurantServlet`  
**Purpose:** Display all available restaurants  
**Class:** `com.dcl.servlet.RestaurantServlet`

### Endpoints

#### 2.1 Display All Restaurants

**HTTP Method:** GET  
**URL:** `/RestaurantServlet`

**Request Parameters:** None

**Request Example:**
```html
<a href="RestaurantServlet">View All Restaurants</a>
```

**Success Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `restaurants.jsp`
- **Request Attribute:** `restaurants` - `List<Restaurant>` containing all restaurants
- **Request Attribute:** `user` - Current logged-in user (if available)

**Response Data Structure:**
```java
// Request Attributes
List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
User user = (User) request.getAttribute("user");

// Restaurant object contains:
// - restaurantId, restaurantName, cuisineType
// - deliveryTime, rating, address
// - imagePath, isActive status
```

**Error Response:**
- **HTTP Status:** 200 (Forward with empty list)
- **Destination:** `restaurants.jsp`
- **Request Attribute:** `error` - "No restaurants available at this time"

**Database Operations:**
- Executes: `SELECT * FROM restaurant WHERE is_active = true`
- Orders by: `rating DESC, restaurant_name ASC`
- No filters applied in current implementation

**JSP Display Requirements:**
- Show restaurant grid layout
- Display restaurant image, name, cuisine type
- Show rating (stars), delivery time
- Provide link to menu: `menu?restaurantId={id}`

---

## 3. GetAllRestaurantsServlet

**URL Mapping:** `/GetAllRestaurantsServlet`  
**Purpose:** Alternative endpoint for restaurant listing (legacy support)  
**Class:** `com.dcl.servlet.GetAllRestaurantsServlet`

### Endpoints

#### 3.1 Get All Restaurants (Legacy)

**HTTP Method:** GET  
**URL:** `/GetAllRestaurantsServlet`

**Behavior:** Identical to RestaurantServlet
**Purpose:** Provides backward compatibility for existing links
**Recommendation:** Use `/RestaurantServlet` for new implementations

---

## 4. MenuServlet

**URL Mapping:** `/menu`  
**Purpose:** Display menu items for a specific restaurant  
**Class:** `com.dcl.servlet.MenuServlet`

### Endpoints

#### 4.1 Display Restaurant Menu

**HTTP Method:** GET  
**URL:** `/menu`

**Request Parameters:**
```
restaurantId: Integer (required, must be valid restaurant ID)
```

**Request Example:**
```html
<a href="menu?restaurantId=1">View Menu</a>
```

**Success Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `menu.jsp`
- **Request Attribute:** `menuItems` - `List<Menu>` for the restaurant
- **Request Attribute:** `restaurant` - `Restaurant` object
- **Request Attribute:** `restaurantId` - Integer ID for form submissions

**Response Data Structure:**
```java
// Request Attributes
List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
Integer restaurantId = (Integer) request.getAttribute("restaurantId");

// Menu object contains:
// - menuId, itemName, description, price
// - category, imagePath, isAvailable
// - restaurantId (foreign key)
```

**Error Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `menu.jsp`
- **Request Attribute:** `error` - "Menu not available" or "Restaurant not found"
- **Request Attribute:** `menuItems` - Empty list

**Validation Rules:**
- restaurantId must be numeric
- restaurantId must exist in database
- Only shows available menu items (`is_available = true`)

**Database Operations:**
- Executes: `SELECT * FROM menu WHERE restaurant_id = ? AND is_available = true`
- Executes: `SELECT * FROM restaurant WHERE restaurant_id = ?`
- Orders menu items by: `category ASC, item_name ASC`

**JSP Display Requirements:**
- Show restaurant name and details at top
- Display menu items with images, descriptions, prices
- Provide "Add to Cart" functionality for each item
- Handle out-of-stock items appropriately

---

## 5. CartServlet

**URL Mapping:** `/cart`  
**Purpose:** Manage shopping cart operations  
**Class:** `com.dcl.servlet.CartServlet`

### Endpoints

#### 5.1 Display Cart

**HTTP Method:** GET  
**URL:** `/cart`

**Request Parameters:** None

**Request Example:**
```html
<a href="cart">View Cart</a>
```

**Success Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `cart.jsp`
- **Request Attribute:** `cart` - `Cart` object from session
- **Request Attribute:** `restaurantId` - Integer ID of current restaurant

**Response Data Structure:**
```java
// Request Attributes
Cart cart = (Cart) request.getAttribute("cart");
Integer restaurantId = (Integer) request.getAttribute("restaurantId");

// Cart object contains:
// - List<CartItem> items
// - cartTotal (calculated)
// - restaurantId
// - userId
```

**Empty Cart Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `cart.jsp`
- **Request Attribute:** `cart` - null or empty cart
- **Display:** "Your cart is empty" message with link to restaurants

#### 5.2 Add Item to Cart

**HTTP Method:** POST  
**URL:** `/cart`

**Request Parameters:**
```
action: "add" (required)
productId: Integer (required, valid menu item ID)
quantity: Integer (optional, defaults to 1, range 1-99)
restaurantId: Integer (required, must match menu item's restaurant)
```

**Request Example:**
```html
<form action="cart" method="post">
    <input type="hidden" name="action" value="add">
    <input type="hidden" name="productId" value="123">
    <input type="hidden" name="restaurantId" value="5">
    <input type="number" name="quantity" value="1" min="1" max="99">
    <input type="submit" value="Add to Cart">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart` (shows updated cart)
- **Session:** Updated cart object in session

**Restaurant Switch Response:**
- **Behavior:** If restaurantId differs from current cart's restaurant
- **Action:** Clear existing cart, create new cart with new restaurant
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session:** New cart object replacing old one

**Error Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session Attribute:** `error` - Error message
- **Possible Errors:**
  - "Menu item not found"
  - "Invalid quantity specified"
  - "Menu item not available"

**Business Rules:**
- Only one restaurant allowed per cart
- Switching restaurants clears existing cart
- Duplicate items increment quantity instead of creating new cart item
- Maximum quantity per item: 99
- Items must be available (`is_available = true`)

**Session Operations:**
```java
// Cart management in session
HttpSession session = request.getSession();
Cart cart = (Cart) session.getAttribute("cart");

// Create new cart if none exists or restaurant switch
if (cart == null || !cart.getRestaurantId().equals(restaurantId)) {
    cart = new Cart();
    cart.setRestaurantId(restaurantId);
    session.setAttribute("cart", cart);
}
```

#### 5.3 Update Cart Item Quantity

**HTTP Method:** POST  
**URL:** `/cart`

**Request Parameters:**
```
action: "update" (required)
itemId: Integer (required, cart item ID, not product ID)
quantity: Integer (required, range 1-99)
```

**Request Example:**
```html
<form action="cart" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="itemId" value="456">
    <input type="number" name="quantity" value="3" min="1" max="99">
    <input type="submit" value="Update">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session:** Updated cart with new quantities and totals

**Error Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session Attribute:** `error` - "Item not found in cart" or "Invalid quantity"

**Validation Rules:**
- itemId must exist in current cart
- quantity must be between 1 and 99
- Cart totals automatically recalculated

#### 5.4 Remove Item from Cart

**HTTP Method:** POST  
**URL:** `/cart`

**Request Parameters:**
```
action: "remove" (required)
productId: Integer (required, menu item ID) OR
itemId: Integer (required, cart item ID)
```

**Request Example:**
```html
<form action="cart" method="post">
    <input type="hidden" name="action" value="remove">
    <input type="hidden" name="productId" value="123">
    <input type="submit" value="Remove">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session:** Updated cart with item removed

**Error Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Session Attribute:** `error` - "Item not found in cart"

**Implementation Notes:**
- Supports both productId (legacy) and itemId (preferred)
- Cart totals automatically recalculated after removal
- Empty cart remains in session until new items added

---

## 6. CheckoutServlet

**URL Mapping:** `/checkout`  
**Purpose:** Handle order checkout process  
**Class:** `com.dcl.servlet.CheckoutServlet`

### Endpoints

#### 6.1 Display Checkout Form

**HTTP Method:** GET  
**URL:** `/checkout`

**Request Parameters:** None

**Request Example:**
```html
<a href="checkout">Proceed to Checkout</a>
```

**Success Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `checkout.jsp`
- **Request Attribute:** `cart` - Cart object from session
- **Request Attribute:** `user` - Current logged-in user

**Authentication Required Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `login.html` or `login.jsp`
- **Condition:** No user in session

**Empty Cart Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `/cart`
- **Condition:** Cart is null or empty

**Validation Checks:**
1. User must be logged in
2. Cart must exist in session
3. Cart must contain items
4. All cart items must be available

#### 6.2 Process Order

**HTTP Method:** POST  
**URL:** `/checkout`

**Request Parameters:**
```
address: String (required, 10-500 characters, delivery address)
paymentMethod: String (required, valid payment option)
```

**Valid Payment Methods:**
- "Credit Card"
- "Debit Card"  
- "UPI"
- "Cash on Delivery"

**Request Example:**
```html
<form action="checkout" method="post">
    <textarea name="address" required>
        123 Main Street, Apt 4B
        Springfield, IL 62701
    </textarea>
    
    <select name="paymentMethod" required>
        <option value="">-- Select Payment Method --</option>
        <option value="Credit Card">Credit Card</option>
        <option value="Debit Card">Debit Card</option>
        <option value="UPI">UPI</option>
        <option value="Cash on Delivery">Cash on Delivery</option>
    </select>
    
    <input type="submit" value="Place Order">
</form>
```

**Success Response:**
- **HTTP Status:** 302 (Redirect)
- **Location:** `orderConfirmation.jsp`
- **Session Attributes:**
  - `orderConfirmed`: `true`
  - `orderId`: Generated order ID
  - `orderTotal`: Final calculated amount
  - `deliveryFee`: Delivery fee amount
  - `gst`: GST amount

**Order Calculation:**
```
Subtotal = Sum of all cart item totals
Delivery Fee = ₹40.00 (fixed)
GST = Subtotal × 0.05 (5%)
Total Amount = Subtotal + Delivery Fee + GST
```

**Error Response:**
- **HTTP Status:** 200 (Forward)
- **Destination:** `checkout.jsp`
- **Request Attribute:** `error` - Error message
- **Request Attribute:** `cart` - Original cart preserved
- **Request Attribute:** `user` - User object preserved

**Possible Error Messages:**
- "Please fill in all required fields"
- "Invalid payment method selected"
- "Address must be at least 10 characters"
- "Error processing order. Please try again."

**Database Operations:**
1. **Begin Transaction**
2. **Insert Order:**
   ```sql
   INSERT INTO orders (user_id, restaurant_id, total_amount, status, 
                      payment_mode, delivery_address, created_date)
   VALUES (?, ?, ?, 'Confirmed', ?, ?, NOW())
   ```
3. **Insert Order Items:**
   ```sql
   INSERT INTO order_items (order_id, product_id, quantity, item_total)
   VALUES (?, ?, ?, ?)
   ```
4. **Commit Transaction**

**Session Effects After Successful Order:**
- Cart cleared: `session.removeAttribute("cart")`
- Restaurant ID cleared: `session.removeAttribute("restaurantId")`
- Order confirmation data stored temporarily
- User session maintained

**Validation Rules:**
- Address: Required, 10-500 characters
- Payment method: Required, must be one of valid options
- Cart: Must exist and contain items
- User: Must be logged in
- Items: All items must still be available

---

## Error Handling Standards

### Standard Error Response Format

**JSP Error Display Pattern:**
```jsp
<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <div class="error-message">
        <%= error %>
    </div>
<%
    }
%>
```

**Success Message Pattern:**
```jsp
<%
    String success = (String) session.getAttribute("success");
    if (success != null) {
        session.removeAttribute("success"); // Display once
%>
    <div class="success-message">
        <%= success %>
    </div>
<%
    }
%>
```

### Common Error Messages

**Authentication Errors:**
- "Please log in to continue"
- "Invalid email or password"
- "Session expired. Please log in again"

**Cart Errors:**
- "Your cart is empty"
- "Item not found"
- "Invalid quantity specified"
- "This restaurant's items have been removed from your cart"

**Checkout Errors:**
- "Please fill in all required fields"
- "Invalid payment method"
- "Order processing failed. Please try again"

**System Errors:**
- "Service temporarily unavailable"
- "Database connection error"
- "An unexpected error occurred"

## Session Attributes Reference

### User Authentication
```java
// After successful login
session.setAttribute("user", userObject);        // User object
session.setAttribute("userId", userObject.getUserId()); // User ID
```

### Shopping Cart
```java
// Cart management
session.setAttribute("cart", cartObject);        // Cart object
session.setAttribute("restaurantId", restaurantId); // Current restaurant
```

### Order Processing
```java
// After successful order
session.setAttribute("orderConfirmed", true);    // Order success flag
session.setAttribute("orderId", generatedId);    // Order ID
session.setAttribute("orderTotal", totalAmount); // Final amount
session.setAttribute("deliveryFee", 40.0);       // Delivery fee
session.setAttribute("gst", gstAmount);           // GST amount
```

### Temporary Messages
```java
// Error messages
request.setAttribute("error", "Error message");  // Request scope
session.setAttribute("error", "Error message");  // Session scope

// Success messages
session.setAttribute("success", "Success message"); // Session scope
```

## Request Attribute Reference

### Common Attributes
```java
// Data passed to JSP
request.setAttribute("restaurants", restaurantList);
request.setAttribute("menuItems", menuItemList);
request.setAttribute("cart", cartObject);
request.setAttribute("user", userObject);
request.setAttribute("restaurantId", restaurantId);

// Error/Success messages
request.setAttribute("error", "Error message");
request.setAttribute("success", "Success message");
```

## Response Codes and Behaviors

### HTTP Status Codes Used

**200 OK (Forward to JSP):**
- Display forms and data
- Show error messages with form data
- Render success pages

**302 Found (Redirect):**
- After successful form submissions
- After login/logout
- After cart operations
- After order placement

### Redirect vs Forward Decision Matrix

| Scenario | Action | Reason |
|----------|--------|---------|
| Successful form submission | Redirect | Prevent duplicate submissions |
| Display form with errors | Forward | Preserve form data and error messages |
| After login success | Redirect | Clean URL, prevent back button issues |
| Display data pages | Forward | Direct rendering, no state change |
| After cart operations | Redirect | Update URL, refresh cart display |
| Show error pages | Forward | Preserve request context and error details |

---

**Document Status:** Approved  
**Next Review Date:** Q2 2025  
**API Review Board:** Development Team, QA Team