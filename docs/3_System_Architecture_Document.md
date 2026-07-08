# System Architecture Document
## JEE Food App - Online Food Delivery Platform

**Version:** 1.0  
**Date:** December 2024  
**Architecture Team:** Development Team  

---

## Executive Summary

This document describes the system architecture of the JEE Food App, a web-based food delivery platform built using traditional Java Enterprise Edition technologies. The application follows a layered MVC architecture with clear separation of concerns, utilizing servlets for web tier, POJOs for business logic, and DAO pattern for data persistence.

## Architecture Overview

### High-Level Architecture

```mermaid
graph TB
    subgraph "Client Tier"
        WB[Web Browser]
        MB[Mobile Browser]
    end
    
    subgraph "Presentation Tier"
        subgraph "Web Server (Tomcat)"
            JSP[JSP Pages]
            STATIC[Static Resources<br/>CSS, JS, Images]
        end
    end
    
    subgraph "Application Tier"
        subgraph "Servlet Container"
            SERVLET[Servlets<br/>Controllers]
            SESSION[HTTP Session<br/>Management]
        end
        
        subgraph "Business Logic"
            MODEL[Model Classes<br/>POJOs]
            UTIL[Utility Classes]
        end
    end
    
    subgraph "Data Access Tier"
        DAO[DAO Layer]
        JDBC[JDBC Connections]
    end
    
    subgraph "Data Tier"
        DB[(MySQL Database<br/>instant_food)]
    end
    
    WB --> JSP
    MB --> JSP
    JSP --> SERVLET
    SERVLET --> MODEL
    SERVLET --> SESSION
    MODEL --> DAO
    DAO --> JDBC
    JDBC --> DB
    
    style WB fill:#e1f5fe
    style MB fill:#e1f5fe
    style JSP fill:#f3e5f5
    style SERVLET fill:#fff3e0
    style MODEL fill:#e8f5e8
    style DAO fill:#fff8e1
    style DB fill:#ffebee
```

### Architecture Principles

1. **Separation of Concerns:** Clear distinction between presentation, business, and data layers
2. **Single Responsibility:** Each class and method has a single, well-defined purpose
3. **Dependency Inversion:** High-level modules don't depend on low-level modules
4. **Encapsulation:** Data and behavior are encapsulated within appropriate classes
5. **Scalability:** Architecture supports horizontal and vertical scaling
6. **Maintainability:** Code is organized for easy maintenance and updates

## Layered Architecture Design

### 1. Presentation Layer (View)

**Purpose:** Handle user interface and user interaction  
**Technologies:** JSP, HTML5, CSS3, JavaScript  
**Components:** Web pages, forms, stylesheets, client-side scripts  

```mermaid
graph LR
    subgraph "JSP Pages"
        A[index.jsp<br/>Landing Page]
        B[login.jsp<br/>Authentication]
        C[restaurants.jsp<br/>Restaurant List]
        D[menu.jsp<br/>Menu Display]
        E[cart.jsp<br/>Shopping Cart]
        F[checkout.jsp<br/>Order Form]
        G[orderConfirmation.jsp<br/>Success Page]
    end
    
    subgraph "Static Resources"
        H[CSS Files]
        I[JavaScript Files]
        J[Images]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
```

**Responsibilities:**
- Render dynamic HTML content using JSP
- Handle form submissions and user input
- Display data received from controllers
- Implement responsive design for mobile compatibility
- Provide client-side validation and interactivity

### 2. Web/Controller Layer (Controller)

**Purpose:** Handle HTTP requests and coordinate application flow  
**Technologies:** Java Servlets, HTTP Session  
**Components:** Servlet classes mapped to URL patterns  

```mermaid
graph TD
    subgraph "Servlet Controllers"
        US[UserServlet<br/>/user]
        RS[RestaurantServlet<br/>/RestaurantServlet]
        GRS[GetAllRestaurantsServlet<br/>/GetAllRestaurantsServlet]
        MS[MenuServlet<br/>/menu]
        CS[CartServlet<br/>/cart]
        CHS[CheckoutServlet<br/>/checkout]
    end
    
    subgraph "HTTP Operations"
        GET[GET Requests]
        POST[POST Requests]
    end
    
    subgraph "Session Management"
        SESS[HTTP Session]
        USER[User State]
        CART[Cart Data]
    end
    
    GET --> US
    POST --> US
    GET --> RS
    GET --> MS
    POST --> CS
    GET --> CHS
    POST --> CHS
    
    US --> SESS
    CS --> CART
    SESS --> USER
```

**Key Servlets:**

1. **UserServlet (`/user`)**
   - Login, logout, registration
   - Session management
   - Authentication handling

2. **RestaurantServlet (`/RestaurantServlet`)**
   - Display all restaurants
   - Restaurant filtering (future)
   - Restaurant details

3. **MenuServlet (`/menu`)**
   - Display restaurant menus
   - Menu item details
   - Category filtering

4. **CartServlet (`/cart`)**
   - Add items to cart
   - Update quantities
   - Remove items
   - Cart calculations

5. **CheckoutServlet (`/checkout`)**
   - Display checkout form
   - Process orders
   - Payment handling
   - Order confirmation

### 3. Business/Service Layer (Model)

**Purpose:** Implement business logic and data validation  
**Technologies:** Java POJOs, JavaBeans pattern  
**Components:** Entity classes, utility classes, business rules  

```mermaid
classDiagram
    class User {
        -int userId
        -String username
        -String email
        -String passwordHash
        -String passwordSalt
        -String role
        +getters/setters
        +toString()
    }
    
    class Restaurant {
        -int restaurantId
        -String restaurantName
        -String cuisineType
        -int deliveryTime
        -String address
        -double rating
        +getters/setters
    }
    
    class Menu {
        -int menuId
        -int restaurantId
        -String itemName
        -String description
        -double price
        -boolean isAvailable
        +getters/setters
    }
    
    class Cart {
        -int cartId
        -int userId
        -int restaurantId
        -double cartTotal
        -List~CartItem~ items
        +addItem()
        +removeItem()
        +calculateTotal()
    }
    
    class Order {
        -int orderId
        -int userId
        -int restaurantId
        -double totalAmount
        -String status
        -String paymentMode
        -String deliveryAddress
        +getters/setters
    }
    
    User ||--o{ Cart
    Restaurant ||--o{ Menu
    Cart ||--o{ CartItem
    User ||--o{ Order
    Order ||--o{ OrderItem
```

**Utility Classes:**
- **DBConnection:** Database connection management
- **PasswordUtil:** Password hashing and verification
- **CartHelper:** Cart operations and calculations
- **DataSeeder:** Database initialization with sample data

### 4. Data Access Layer (DAO)

**Purpose:** Handle database operations and data persistence  
**Technologies:** JDBC, PreparedStatements, MySQL  
**Components:** DAO interfaces and implementations  

```mermaid
graph TB
    subgraph "DAO Interfaces"
        UDAO[UserDAO]
        RDAO[RestaurantDAO]
        MDAO[MenuDAO]
        CDAO[CartDAO]
        ODAO[OrderDAO]
        ADAO[AddressDAO]
        REVDAO[ReviewDAO]
    end
    
    subgraph "DAO Implementations"
        UDAOI[UserDAOImpl]
        RDAOI[RestaurantDAOImpl]
        MDAOI[MenuDAOImpl]
        CDAOI[CartDAOImpl]
        ODAOI[OrderDAOImpl]
        ADAOI[AddressDAOImpl]
        REVDAOI[ReviewDAOImpl]
    end
    
    subgraph "Database Operations"
        CRUD[Create<br/>Read<br/>Update<br/>Delete]
        TRANS[Transaction<br/>Management]
        CONN[Connection<br/>Pooling]
    end
    
    UDAO --> UDAOI
    RDAO --> RDAOI
    MDAO --> MDAOI
    CDAO --> CDAOI
    ODAO --> ODAOI
    
    UDAOI --> CRUD
    RDAOI --> CRUD
    MDAOI --> CRUD
    CDAOI --> CRUD
    ODAOI --> TRANS
```

**DAO Pattern Benefits:**
- Abstraction of database operations
- Separation of data access logic from business logic
- Easy to unit test with mock implementations
- Database vendor independence
- Centralized SQL query management

### 5. Data Layer

**Purpose:** Data storage and retrieval  
**Technologies:** MySQL 8.0, InnoDB storage engine  
**Components:** Database tables, indexes, constraints, stored procedures  

## Component Interaction Flow

### 1. User Authentication Flow

```mermaid
sequenceDiagram
    participant Browser
    participant LoginJSP
    participant UserServlet
    participant UserDAO
    participant Database
    participant Session
    
    Browser->>LoginJSP: GET /login.jsp
    LoginJSP-->>Browser: Login form
    Browser->>UserServlet: POST /user (credentials)
    UserServlet->>UserDAO: getUserByEmail(email)
    UserDAO->>Database: SELECT * FROM user WHERE email=?
    Database-->>UserDAO: User record
    UserDAO-->>UserServlet: User object
    UserServlet->>UserServlet: Verify password hash
    UserServlet->>Session: setAttribute("user", user)
    UserServlet-->>Browser: Redirect to restaurants.jsp
```

### 2. Restaurant Browsing Flow

```mermaid
sequenceDiagram
    participant Browser
    participant RestaurantServlet
    participant RestaurantDAO
    participant Database
    participant RestaurantJSP
    
    Browser->>RestaurantServlet: GET /RestaurantServlet
    RestaurantServlet->>RestaurantDAO: getAllRestaurants()
    RestaurantDAO->>Database: SELECT * FROM restaurant
    Database-->>RestaurantDAO: Restaurant list
    RestaurantDAO-->>RestaurantServlet: List<Restaurant>
    RestaurantServlet->>RestaurantJSP: Forward with restaurant list
    RestaurantJSP-->>Browser: Restaurant grid display
```

### 3. Cart Management Flow

```mermaid
sequenceDiagram
    participant Browser
    participant CartServlet
    participant Session
    participant Cart
    participant CartJSP
    
    Browser->>CartServlet: POST /cart (action=add, productId=123)
    CartServlet->>Session: getAttribute("cart")
    Session-->>CartServlet: Cart object (or null)
    
    alt Cart is null or different restaurant
        CartServlet->>Cart: new Cart()
        CartServlet->>Session: setAttribute("cart", cart)
    end
    
    CartServlet->>Cart: addItem(cartItem)
    Cart->>Cart: calculateTotal()
    CartServlet->>Session: setAttribute("cart", updatedCart)
    CartServlet->>CartJSP: Forward with cart data
    CartJSP-->>Browser: Updated cart display
```

### 4. Order Processing Flow

```mermaid
sequenceDiagram
    participant Browser
    participant CheckoutServlet
    participant Session
    participant OrderDAO
    participant Database
    participant ConfirmJSP
    
    Browser->>CheckoutServlet: POST /checkout (address, payment)
    CheckoutServlet->>Session: getAttribute("cart")
    Session-->>CheckoutServlet: Cart with items
    CheckoutServlet->>CheckoutServlet: Create Order object
    CheckoutServlet->>CheckoutServlet: Calculate total (items + delivery + tax)
    
    CheckoutServlet->>Database: BEGIN TRANSACTION
    CheckoutServlet->>OrderDAO: addOrder(order, orderItems)
    OrderDAO->>Database: INSERT INTO orders
    OrderDAO->>Database: INSERT INTO order_items (multiple)
    Database-->>OrderDAO: Generated order_id
    OrderDAO->>Database: COMMIT
    
    CheckoutServlet->>Session: Clear cart
    CheckoutServlet->>Session: Set order confirmation data
    CheckoutServlet-->>Browser: Redirect to confirmation
    Browser->>ConfirmJSP: GET /orderConfirmation.jsp
    ConfirmJSP-->>Browser: Order success page
```

## Data Architecture

### Database Schema Design

```mermaid
erDiagram
    USER {
        int user_id PK
        string username UK
        string email UK
        string password_hash
        string password_salt
        string full_name
        string phone_number
        string role
        timestamp created_date
        timestamp updated_date
    }
    
    RESTAURANT {
        int restaurant_id PK
        string restaurant_name UK
        string cuisine_type
        string address
        string phone_number
        int delivery_time
        double rating
        string image_path
        boolean is_active
        timestamp created_date
    }
    
    MENU {
        int menu_id PK
        int restaurant_id FK
        string item_name
        string description
        double price
        string category
        string image_path
        boolean is_available
        timestamp created_date
    }
    
    CART {
        int cart_id PK
        int user_id FK
        int restaurant_id FK
        double cart_total
        timestamp created_date
        timestamp updated_date
    }
    
    CART_ITEM {
        int cart_item_id PK
        int cart_id FK
        int menu_id FK
        int quantity
        double item_total
        timestamp added_date
    }
    
    ORDERS {
        int order_id PK
        int user_id FK
        int restaurant_id FK
        double total_amount
        string status
        string payment_mode
        string delivery_address
        timestamp created_date
        timestamp updated_date
    }
    
    ORDER_ITEM {
        int order_item_id PK
        int order_id FK
        int menu_id FK
        string item_name
        double item_price
        int quantity
        double item_total
    }
    
    ADDRESS {
        int address_id PK
        int user_id FK
        string address_line
        string city
        string state
        string postal_code
        boolean is_default
        timestamp created_date
    }
    
    REVIEW {
        int review_id PK
        int user_id FK
        int restaurant_id FK
        int rating
        string comment
        timestamp created_date
    }
    
    USER ||--o{ CART : "has"
    USER ||--o{ ORDERS : "places"
    USER ||--o{ ADDRESS : "has"
    USER ||--o{ REVIEW : "writes"
    
    RESTAURANT ||--o{ MENU : "offers"
    RESTAURANT ||--o{ CART : "contains_items_from"
    RESTAURANT ||--o{ ORDERS : "receives"
    RESTAURANT ||--o{ REVIEW : "receives"
    
    CART ||--o{ CART_ITEM : "contains"
    ORDERS ||--o{ ORDER_ITEM : "contains"
    
    MENU ||--o{ CART_ITEM : "added_to"
    MENU ||--o{ ORDER_ITEM : "ordered_as"
```

### Database Design Principles

1. **Normalization:** Database is normalized to 3NF to eliminate redundancy
2. **Referential Integrity:** Foreign key constraints maintain data consistency
3. **Indexing:** Strategic indexes on frequently queried columns
4. **Data Types:** Appropriate data types for storage efficiency
5. **Constraints:** Check constraints for data validation
6. **Timestamps:** Audit trails with created_date and updated_date

### Index Strategy

```sql
-- Primary Keys (automatically indexed)
-- user_id, restaurant_id, menu_id, order_id, etc.

-- Foreign Key Indexes
CREATE INDEX idx_menu_restaurant_id ON menu(restaurant_id);
CREATE INDEX idx_cart_user_id ON cart(user_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_item_order_id ON order_item(order_id);

-- Search Optimization Indexes
CREATE INDEX idx_user_email ON user(email);
CREATE INDEX idx_restaurant_name ON restaurant(restaurant_name);
CREATE INDEX idx_menu_item_name ON menu(item_name);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(created_date);

-- Composite Indexes for Complex Queries
CREATE INDEX idx_menu_restaurant_available ON menu(restaurant_id, is_available);
CREATE INDEX idx_orders_user_date ON orders(user_id, created_date);
```

## Session Management Architecture

### Session Storage Strategy

The application uses HTTP sessions to maintain user state and shopping cart data:

```mermaid
graph TD
    subgraph "HTTP Session"
        USER_OBJ[User Object]
        CART_OBJ[Cart Object]
        RESTAURANT_ID[Restaurant ID]
        TEMP_DATA[Temporary Data]
    end
    
    subgraph "Session Lifecycle"
        CREATE[Session Creation]
        UPDATE[Session Update]
        VALIDATE[Session Validation]
        CLEANUP[Session Cleanup]
        EXPIRE[Session Expiration]
    end
    
    subgraph "Storage Contents"
        USER_DATA[userId, username, email, role]
        CART_DATA[cartId, restaurantId, items[], total]
        ORDER_DATA[orderId, orderTotal, deliveryFee, GST]
        ERROR_MSG[Error Messages]
        SUCCESS_MSG[Success Messages]
    end
    
    CREATE --> USER_OBJ
    UPDATE --> CART_OBJ
    VALIDATE --> USER_OBJ
    CLEANUP --> CART_OBJ
    EXPIRE --> USER_OBJ
    
    USER_OBJ --> USER_DATA
    CART_OBJ --> CART_DATA
    TEMP_DATA --> ORDER_DATA
    TEMP_DATA --> ERROR_MSG
    TEMP_DATA --> SUCCESS_MSG
```

### Session Management Rules

1. **User Authentication:**
   - User object stored in session after successful login
   - Session validated on protected pages
   - Session cleared on logout

2. **Cart Management:**
   - Cart stored as session attribute (not in database)
   - Single restaurant per cart enforced
   - Cart cleared when switching restaurants
   - Cart persists during user session

3. **Order Processing:**
   - Temporary order data stored in session during checkout
   - Session data cleared after order confirmation
   - Order permanently stored in database

4. **Session Security:**
   - 30-minute timeout for inactive sessions
   - Session ID regeneration on login
   - Secure session cookies in production

## Security Architecture

### Authentication and Authorization

```mermaid
graph TB
    subgraph "Authentication Flow"
        LOGIN[User Login]
        HASH[Password Hashing]
        VERIFY[Hash Verification]
        SESSION[Session Creation]
    end
    
    subgraph "Security Measures"
        SALT[Random Salt Generation]
        SHA256[SHA-256 Hashing]
        PREPARED[Prepared Statements]
        VALIDATION[Input Validation]
    end
    
    subgraph "Session Security"
        TIMEOUT[Session Timeout]
        REGENERATE[ID Regeneration]
        SECURE[Secure Cookies]
        CLEANUP[Session Cleanup]
    end
    
    LOGIN --> HASH
    HASH --> VERIFY
    VERIFY --> SESSION
    
    HASH --> SALT
    HASH --> SHA256
    LOGIN --> PREPARED
    LOGIN --> VALIDATION
    
    SESSION --> TIMEOUT
    SESSION --> REGENERATE
    SESSION --> SECURE
    SESSION --> CLEANUP
```

### Security Implementation Details

1. **Password Security:**
   - SHA-256 hashing with random salt
   - 16-byte salt generation using SecureRandom
   - Separate storage of hash and salt
   - Protection against rainbow table attacks

2. **SQL Injection Prevention:**
   - Prepared statements for all database queries
   - Parameter binding instead of string concatenation
   - Input validation and sanitization

3. **Session Security:**
   - HTTP-only session cookies
   - Secure flag for HTTPS connections
   - Session timeout after 30 minutes inactivity
   - Session ID regeneration on authentication

4. **Input Validation:**
   - Server-side validation for all form inputs
   - Type checking for numeric parameters
   - Length validation for string inputs
   - Email format validation

## Performance Architecture

### Response Time Optimization

```mermaid
graph LR
    subgraph "Database Layer"
        A[Connection Pooling]
        B[Query Optimization]
        C[Index Strategy]
        D[Transaction Management]
    end
    
    subgraph "Application Layer"
        E[Efficient Algorithms]
        F[Session Management]
        G[Memory Usage]
        H[Exception Handling]
    end
    
    subgraph "Web Layer"
        I[JSP Optimization]
        J[Static Resource Caching]
        K[Compression]
        L[Lazy Loading]
    end
    
    A --> E
    B --> E
    C --> E
    D --> E
    
    E --> I
    F --> I
    G --> I
    H --> I
    
    style A fill:#ffeb3b
    style E fill:#4caf50
    style I fill:#2196f3
```

### Scalability Considerations

1. **Database Scalability:**
   - Efficient indexing strategy
   - Connection pooling (future implementation)
   - Query optimization and monitoring
   - Database clustering support

2. **Application Scalability:**
   - Stateless servlet design
   - Session externalization (future)
   - Load balancing support
   - Microservices migration path

3. **Caching Strategy:**
   - Application-level caching
   - Database query caching
   - Static resource caching
   - CDN integration (future)

## Error Handling Architecture

### Error Handling Strategy

```mermaid
graph TD
    subgraph "Error Types"
        A[System Errors]
        B[Business Logic Errors]
        C[Validation Errors]
        D[Database Errors]
    end
    
    subgraph "Error Handling"
        E[Try-Catch Blocks]
        F[Error Logging]
        G[User-Friendly Messages]
        H[Error Recovery]
    end
    
    subgraph "Error Response"
        I[Error JSP Pages]
        J[Error Attributes]
        K[Redirect/Forward]
        L[Status Codes]
    end
    
    A --> E
    B --> E
    C --> E
    D --> E
    
    E --> F
    E --> G
    E --> H
    
    F --> I
    G --> J
    H --> K
    I --> L
```

### Error Handling Implementation

1. **Exception Hierarchy:**
   - System exceptions logged with full stack traces
   - Business exceptions converted to user messages
   - Validation errors displayed with form data
   - Database errors handled with transaction rollback

2. **Logging Strategy:**
   - Different log levels (ERROR, WARN, INFO, DEBUG)
   - Structured logging with context information
   - Log rotation and archival policies
   - Monitoring and alerting integration

3. **User Experience:**
   - Graceful error page display
   - Preservation of user form data
   - Clear error messages and guidance
   - Recovery options and navigation

## Deployment Architecture

### Development Environment

```mermaid
graph TB
    subgraph "Development Setup"
        A[Eclipse IDE]
        B[Embedded Tomcat]
        C[Local MySQL]
        D[Git Repository]
    end
    
    subgraph "Build Process"
        E[Java Compilation]
        F[JSP Compilation]
        G[WAR Packaging]
        H[Deployment]
    end
    
    subgraph "Testing"
        I[Unit Tests]
        J[Integration Tests]
        K[Manual Testing]
        L[Browser Testing]
    end
    
    A --> E
    B --> F
    C --> G
    D --> H
    
    E --> I
    F --> J
    G --> K
    H --> L
```

### Production Environment

```mermaid
graph TB
    subgraph "Production Infrastructure"
        A[Load Balancer<br/>Nginx/Apache]
        B[Application Server<br/>Tomcat Cluster]
        C[Database Server<br/>MySQL Master/Slave]
        D[Static Assets<br/>CDN/File Server]
    end
    
    subgraph "Monitoring & Logging"
        E[Application Monitoring<br/>JMX/APM]
        F[Log Aggregation<br/>ELK Stack]
        G[Database Monitoring<br/>MySQL Metrics]
        H[Health Checks<br/>Endpoint Monitoring]
    end
    
    subgraph "Security & Backup"
        I[SSL/TLS Certificates]
        J[Firewall Configuration]
        K[Database Backups]
        L[Application Backups]
    end
    
    A --> B
    B --> C
    B --> D
    
    B --> E
    A --> F
    C --> G
    E --> H
    
    A --> I
    A --> J
    C --> K
    B --> L
```

## Technology Integration

### Framework Integration

The application is designed for easy integration with modern frameworks:

1. **Spring Framework Integration:**
   - Replace manual servlet configuration with Spring MVC
   - Implement dependency injection for DAO classes
   - Add Spring Security for authentication
   - Utilize Spring Boot for simplified configuration

2. **ORM Integration:**
   - Replace JDBC with Hibernate or JPA
   - Implement entity relationships and lazy loading
   - Add connection pooling and caching
   - Utilize query optimization features

3. **Frontend Framework Integration:**
   - Replace JSP with REST API endpoints
   - Implement Single Page Application (SPA) with React/Angular
   - Add real-time updates with WebSockets
   - Implement progressive web app features

## Migration and Evolution Path

### Phase 1: Current Architecture (Completed)
- Servlet-based MVC architecture
- JSP views with embedded Java
- JDBC data access layer
- Session-based state management

### Phase 2: Framework Integration (Future)
- Spring Framework integration
- RESTful API development
- Modern frontend framework
- Improved security and validation

### Phase 3: Microservices Architecture (Future)
- Service decomposition
- API Gateway implementation
- Distributed caching
- Container orchestration

### Phase 4: Cloud-Native Architecture (Future)
- Cloud platform migration
- Serverless functions
- Managed database services
- Auto-scaling and load balancing

---

**Document Status:** Approved  
**Next Review Date:** Q2 2025  
**Architecture Review Board:** Development Team, Technical Leadership