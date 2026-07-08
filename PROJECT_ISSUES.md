# Project Issues

- [x] P-01 DBConnection: Verify database name (instant_food vs InstantFood) and credentials
- [x] P-02 CheckoutServlet: Unused imports & compilation warnings
- [x] P-03 CheckoutServlet: Silently swallows exceptions and displays order ID 0
- [x] P-04 OrderDAOImpl: Verify if `delivery_address` and `created_date` columns are saved to the DB
- [x] P-05 OrderDAOImpl: Verify if `mapResultSetToOrder()` misses the `delivery_address` column
- [x] P-06 Cart: `itemIdCounter` is `static` and shared across all active sessions
- [x] P-07 restaurants.jsp: View Cart displays count and allows access without checking user session
- [x] P-08 menu.jsp: Lack of session check and Login/Logout link in the navbar
- [x] P-09 DataSeeder: No realistic sample data seeded for Restaurants
- [x] P-10 CartServlet: Changing restaurants silently clears the cart
- [x] P-11 index.jsp: Broken encoding emoji in features section
- [x] P-12 Checkout/Payment: No Payment page implementation (simulate payment before confirmation)
- [x] P-13 UserServlet: Registration doesn't check for duplicate emails
- [x] P-14 GetAllRestaurantsServlet: Duplicate/Dead Code Servlet
- [x] P-15 RestaurantDAOImpl: Fetches inactive restaurants
- [x] Project Structure & Code Consistency Review
- [x] Verify Servlet-to-JSP and JSP-to-Servlet Flow
- [x] Final end-to-end testing of CRUD operations and application stability
