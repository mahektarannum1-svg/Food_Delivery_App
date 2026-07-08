package com.dcl.utility;

import com.dcl.DAOImpl.MenuDAOImpl;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.model.Menu;
import com.dcl.model.Restaurant;

public class DataSeeder {
    
    public static void seedMenuData() {
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        
        // Sample menu items for restaurant ID 1
        Menu[] menuItems = {
            new Menu(1, 1, "Margherita Pizza", "Fresh tomatoes, mozzarella, basil", 299.0, true, null),
            new Menu(1, 1, "Pepperoni Pizza", "Pepperoni, mozzarella, tomato sauce", 399.0, true, null),
            new Menu(1, 2, "Caesar Salad", "Romaine lettuce, croutons, parmesan", 199.0, true, null),
            new Menu(1, 3, "Chocolate Brownie", "Rich chocolate brownie with ice cream", 149.0, true, null),
            new Menu(1, 4, "Fresh Orange Juice", "Freshly squeezed orange juice", 99.0, true, null),
            new Menu(1, 1, "BBQ Chicken Pizza", "BBQ sauce, grilled chicken, onions", 449.0, true, null),
            
            // Sample menu items for restaurant ID 2
            new Menu(2, 1, "Chicken Biryani", "Aromatic basmati rice with spiced chicken", 349.0, true, null),
            new Menu(2, 1, "Mutton Curry", "Tender mutton in spicy gravy", 399.0, true, null),
            new Menu(2, 1, "Paneer Butter Masala", "Creamy paneer in rich tomato gravy", 279.0, true, null),
            new Menu(2, 2, "Naan Bread", "Soft wheat bread baked in tandoor", 49.0, true, null),
            new Menu(2, 4, "Lassi", "Traditional yogurt drink", 79.0, true, null),
            new Menu(2, 3, "Gulab Jamun", "Sweet milk dumplings in sugar syrup", 99.0, true, null),
            
            // Sample menu items for restaurant ID 3
            new Menu(3, 1, "Cheeseburger", "Beef patty with cheese, lettuce, tomato", 249.0, true, null),
            new Menu(3, 1, "Chicken Wings", "Spicy buffalo chicken wings", 299.0, true, null),
            new Menu(3, 2, "French Fries", "Crispy golden french fries", 99.0, true, null),
            new Menu(3, 4, "Cola", "Refreshing cola drink", 59.0, true, null),
            new Menu(3, 3, "Apple Pie", "Classic apple pie with vanilla ice cream", 179.0, true, null),
            new Menu(3, 1, "Fish & Chips", "Battered fish with crispy fries", 349.0, true, null)
        };
        
        // Add menu items to database
        for (Menu menu : menuItems) {
            try {
                menuDAO.addMenu(menu);
                System.out.println("Added menu item: " + menu.getName());
            } catch (Exception e) {
                System.out.println("Error adding menu item: " + menu.getName() + " - " + e.getMessage());
            }
        }
    }
    
    public static void seedRestaurants() {
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        Restaurant[] restaurants = {
            new Restaurant("Pizza Palace", "Italian", 30, "123 Main St", 4.5, true, "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=500&q=80"),
            new Restaurant("Spice Route", "Indian", 45, "456 Curry Ln", 4.7, true, "https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500&q=80"),
            new Restaurant("Burger Barn", "American", 20, "789 Grill Ave", 4.2, true, "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500&q=80")
        };
        
        for (Restaurant r : restaurants) {
            try {
                restaurantDAO.addRestaurant(r);
                System.out.println("Added restaurant: " + r.getName());
            } catch (Exception e) {
                System.out.println("Error adding restaurant: " + r.getName() + " - " + e.getMessage());
            }
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Seeding restaurant data...");
        seedRestaurants();
        System.out.println("Seeding menu data...");
        seedMenuData();
        System.out.println("Data seeding completed!");
    }
}
