# Business Rules Document
## JEE Food App - Business Logic and Constraints

**Version:** 1.0  
**Date:** December 2024  
**Business Analyst:** Development Team  

---

## Overview

This document defines all business rules, constraints, and logic that govern the JEE Food App's operation. These rules ensure data integrity, proper user experience, and correct business process flow throughout the application.

## User Management Rules

### 1. User Registration Rules

**BR-001: Unique User Credentials**
- **Rule:** Each email address can be associated with only one user account
- **Implementation:** Database unique constraint on `user.email`
- **Violation Handling:** Show error "An account with this email already exists"
- **Business Justification:** Prevent duplicate accounts and ensure proper user identification

**BR-002: Username Uniqueness**
- **Rule:** Each username must be unique across all user accounts
- **Implementation:** Database unique constraint on `user.username`
- **Violation Handling:** Show error "This username is already taken"
- **Business Justification:** Ensure clear user identification and prevent confusion

**BR-003: Password Security Requirements**
- **Rule:** Passwords must be at least 6 characters long
- **Implementation:** Server-side validation in UserServlet
- **Violation Handling:** Show error "Password must be at least 6 characters long"
- **Business Justification:** Maintain basic account security standards

**BR-004: User Role Assignment**
- **Rule:** New users are automatically assigned "CUSTOMER" role
- **Implementation:** Default value in database schema
- **Business Justification:** Ensure proper permission levels for regular users

### 2. Authentication Rules

**BR-005: Session-Based Authentication**
- **Rule:** User authentication state is maintained via HTTP sessions
- **Implementation:** User object stored in session after successful login
- **Timeout:** Sessions expire after 30 minutes of inactivity
- **Business Justification:** Balance security with user convenience

**BR-006: Password Verification**
- **Rule:** Login requires exact match of email and hashed password
- **Implementation:** SHA-256 hashing with unique salt per user
- **Security:** Passwords never stored in plain text
- **Business Justification:** Protect user credentials from security breaches

## Restaurant Management Rules

### 3. Restaurant Display Rules

**BR-007: Active Restaurant Display**
- **Rule:** Only restaurants with `is_active = true` are shown to customers
- **Implementation:** Filter in RestaurantDAO.getAllRestaurants()
- **Business Justification:** Hide temporarily closed or inactive restaurants

**BR-008: Restaurant Information Requirements**
- **Rule:** All restaurants must have name, cuisine type, address, and delivery time
- **Implementation:** Database NOT NULL constraints
- **Business Justification:** Ensure customers have essential information for ordering

**BR-009: Restaurant Rating Constraints**
- **Rule:** Restaurant ratings must be between 0.00 and 5.00
- **Implementation:** Database check constraint
- **Business Justification:** Maintain consistent rating scale

### 4. Menu Management Rules

**BR-010: Menu Item Availability**
- **Rule:** Only available menu items (`is_available = true`) are shown to customers
- **Implementation:** Filter in MenuDAO queries
- **Business Justification:** Prevent orders for out-of-stock items

**BR-011: Menu Item Pricing**
- **Rule:** All menu items must have positive price values
- **Implementation:** Database check constraint `price >= 0.00`
- **Business Justification:** Prevent negative or zero pricing errors

**BR-012: Restaurant-Menu Relationship**
- **Rule:** Each menu item belongs to exactly one restaurant
- **Implementation:** Foreign key constraint with CASCADE delete
- **Business Justification:** Maintain data integrity and proper business relationships

## Shopping Cart Rules

### 5. Cart Creation and Management

**BR-013: Single Restaurant Cart Rule**
- **Rule:** A shopping cart can contain items from only one restaurant at a time
- **Implementation:** Session-based validation in CartServlet
- **Violation Handling:** Warn user and clear cart when switching restaurants
- **Business Justification:** Simplify order processing and delivery logistics

**BR-014: Cart Session Storage**
- **Rule:** Shopping carts are stored in HTTP sessions, not database
- **Implementation:** Cart object maintained in session attributes
- **Limitation:** Cart contents lost if session expires or user switches devices
- **Business Justification:** Reduce database load and improve performance

**BR-015: Restaurant Switch Behavior**
- **Rule:** Adding items from different restaurant clears existing cart
- **Implementation:** Restaurant ID comparison in CartServlet
- **User Experience:** Show warning dialog before clearing cart
- **Business Justification:** Enforce single-restaurant rule while informing user

### 6. Cart Item Rules

**BR-016: Quantity Limits**
- **Rule:** Cart item quantities must be between 1 and 99
- **Implementation:** Client-side and server-side validation
- **Violation Handling:** Reset to valid range with user notification
- **Business Justification:** Prevent extreme quantities that may indicate errors

**BR-017: Duplicate Item Handling**
- **Rule:** Adding existing menu item increases quantity instead of creating duplicate entry
- **Implementation:** Check for existing productId in cart before adding
- **Business Justification:** Maintain clean cart structure and accurate totals

**BR-018: Item Availability Validation**
- **Rule:** Only available menu items can be added to cart
- **Implementation:** Check `menu.is_available` before cart operations
- **Violation Handling:** Show error "This item is currently unavailable"
- **Business Justification:** Prevent orders for out-of-stock items

### 7. Cart Calculation Rules

**BR-019: Item Total Calculation**
- **Rule:** Item total = quantity × item price
- **Implementation:** Automatic calculation in CartItem model
- **Precision:** Currency values stored with 2 decimal places
- **Business Justification:** Ensure accurate pricing calculations

**BR-020: Cart Total Calculation**
- **Rule:** Cart total = sum of all item totals (before fees and taxes)
- **Implementation:** Calculated in Cart.getCartTotal() method
- **Real-time Updates:** Recalculated after every cart modification
- **Business Justification:** Provide accurate subtotal for user decision-making

## Order Processing Rules

### 8. Checkout Rules

**BR-021: Authentication Required for Checkout**
- **Rule:** Users must be logged in to proceed with checkout
- **Implementation:** Session validation in CheckoutServlet
- **Violation Handling:** Redirect to login page
- **Business Justification:** Ensure order attribution and delivery information accuracy

**BR-022: Non-Empty Cart Requirement**
- **Rule:** Cart must contain at least one item to proceed with checkout
- **Implementation:** Cart validation in CheckoutServlet
- **Violation Handling:** Redirect to cart page with message
- **Business Justification:** Prevent empty orders from being processed

**BR-023: Delivery Address Requirement**
- **Rule:** Orders must include a delivery address of at least 10 characters
- **Implementation:** Form validation in checkout process
- **Violation Handling:** Show error and retain form data
- **Business Justification:** Ensure successful order delivery

**BR-024: Payment Method Requirement**
- **Rule:** Orders must specify a valid payment method
- **Valid Options:** Credit Card, Debit Card, UPI, Cash on Delivery
- **Implementation:** Dropdown validation in checkout form
- **Business Justification:** Ensure proper payment processing and delivery coordination

### 9. Order Calculation Rules

**BR-025: Order Total Composition**
- **Rule:** Order total = subtotal + delivery fee + GST
- **Subtotal:** Sum of all cart item totals
- **Delivery Fee:** Fixed ₹40.00 per order
- **GST:** 5% of subtotal amount
- **Implementation:** Calculated in CheckoutServlet before order creation
- **Business Justification:** Transparent pricing structure for customers

**BR-026: Order Total Precision**
- **Rule:** All monetary values stored with 2 decimal places
- **Implementation:** DECIMAL(10,2) database columns
- **Rounding:** Standard rounding rules for currency
- **Business Justification:** Accurate financial calculations and reporting

### 10. Order Creation Rules

**BR-027: Order Status Initialization**
- **Rule:** New orders created with status "Confirmed"
- **Implementation:** Default value set in order creation
- **Status Progression:** Confirmed → Pending → Preparing → Out for Delivery → Delivered
- **Business Justification:** Clear order lifecycle tracking

**BR-028: Order Item Snapshot**
- **Rule:** Order items store snapshot of menu item details at time of order
- **Stored Data:** Item name, price, quantity, total
- **Implementation:** Copy values from menu items to order items
- **Business Justification:** Preserve order details even if menu changes later

**BR-029: Transaction Integrity**
- **Rule:** Order and order items must be created in single database transaction
- **Implementation:** Transaction management in OrderDAOImpl
- **Rollback:** Complete rollback if any part fails
- **Business Justification:** Ensure data consistency and prevent partial orders

## Data Validation Rules

### 11. Input Validation Rules

**BR-030: Email Format Validation**
- **Rule:** Email addresses must follow standard email format
- **Implementation:** Server-side validation using regex patterns
- **Examples:** Valid: user@example.com, Invalid: userexample.com
- **Business Justification:** Ensure reliable customer communication

**BR-031: Phone Number Validation**
- **Rule:** Phone numbers must contain only digits and be 10-15 characters
- **Implementation:** Input validation in user registration
- **Optional Field:** Phone number is not required for registration
- **Business Justification:** Enable alternative customer contact method

**BR-032: Numeric Field Validation**
- **Rule:** Numeric fields (prices, quantities, IDs) must contain only valid numbers
- **Implementation:** Type validation and range checking
- **Error Handling:** Show specific error messages for invalid inputs
- **Business Justification:** Prevent data corruption and application errors

## Security Rules

### 12. Data Protection Rules

**BR-033: Password Storage Security**
- **Rule:** Passwords must never be stored in plain text
- **Implementation:** SHA-256 hashing with unique salt per password
- **Salt Generation:** Random 16-byte salt for each password
- **Business Justification:** Protect user credentials from data breaches

**BR-034: SQL Injection Prevention**
- **Rule:** All database queries must use prepared statements
- **Implementation:** PreparedStatement objects throughout DAO layer
- **No String Concatenation:** Never build SQL with string concatenation
- **Business Justification:** Prevent malicious database attacks

**BR-035: Session Security**
- **Rule:** Sessions must expire after period of inactivity
- **Timeout:** 30 minutes of inactivity
- **Implementation:** Server-side session management
- **Business Justification:** Prevent unauthorized access to user accounts

## Error Handling Rules

### 13. User Experience Rules

**BR-036: Graceful Error Display**
- **Rule:** All errors must be presented in user-friendly language
- **Implementation:** Generic error messages instead of technical details
- **Examples:** "Unable to process request" instead of "SQLException"
- **Business Justification:** Maintain professional user experience

**BR-037: Data Preservation on Errors**
- **Rule:** User form data should be preserved when validation errors occur
- **Implementation:** Re-populate form fields after validation failures
- **Exception:** Never re-populate password fields
- **Business Justification:** Reduce user frustration and improve conversion

**BR-038: Operation Recovery**
- **Rule:** Users should be able to retry failed operations
- **Implementation:** Maintain cart state during checkout errors
- **Error Messages:** Include guidance for successful completion
- **Business Justification:** Maximize order completion rates

## Performance Rules

### 14. Database Efficiency Rules

**BR-039: Query Optimization**
- **Rule:** Database queries should be optimized for performance
- **Implementation:** Appropriate indexes on frequently queried columns
- **Connection Management:** Proper connection opening and closing
- **Business Justification:** Ensure responsive user experience

**BR-040: Session Management Efficiency**
- **Rule:** Session data should be kept minimal and relevant
- **Implementation:** Store only essential objects in session
- **Cleanup:** Remove temporary data after use
- **Business Justification:** Maintain server performance and memory usage

## Future Enhancement Rules

### 15. Scalability Rules

**BR-041: Database Design for Growth**
- **Rule:** Database structure should support future features
- **Implementation:** Proper normalization and relationship design
- **Extension Points:** Additional user types, order tracking, reviews
- **Business Justification:** Enable platform growth without major restructuring

**BR-042: API Readiness**
- **Rule:** Business logic should be separable from presentation layer
- **Implementation:** Clear separation between servlets and JSP
- **Future State:** Enable REST API development
- **Business Justification:** Support mobile apps and third-party integrations

---

**Document Status:** Approved  
**Next Review Date:** Q2 2025  
**Business Rules Board:** Development Team, Product Team, QA Team