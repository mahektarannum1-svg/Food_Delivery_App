package com.dcl.utility;

import com.dcl.DAOImpl.MenuDAOImpl;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.model.Menu;
import com.dcl.model.Restaurant;

public class SeedNewData {

    public static void seedRestaurants() {
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        Restaurant[] restaurants = {
            new Restaurant("Tokyo Drift Sushi", "Japanese", 35, "101 Neon Street", 4.8, true, "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500&q=80"),
            new Restaurant("El Matador", "Mexican", 25, "202 Fiesta Blvd", 4.6, true, "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&q=80"),
            new Restaurant("Green Earth Cafe", "Vegan", 20, "303 Plant Lane", 4.9, true, "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500&q=80")
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

    public static void seedMenuData() {
        MenuDAOImpl menuDAO = new MenuDAOImpl();
        
        // Menus for Restaurant 4 (Tokyo Drift Sushi)
        Menu[] tokyoMenu = {
            new Menu(4, 1, "Spicy Tuna Roll", "Fresh tuna with spicy mayo", 450.0, true, null),
            new Menu(4, 1, "Dragon Roll", "Eel, cucumber, and avocado", 550.0, true, null),
            new Menu(4, 2, "Miso Soup", "Traditional Japanese soup", 150.0, true, null),
            new Menu(4, 1, "Salmon Sashimi", "Premium cuts of fresh salmon", 600.0, true, null),
            new Menu(4, 3, "Matcha Mochi", "Green tea mochi ice cream", 200.0, true, null),
            new Menu(4, 4, "Sake (Small)", "Warm Japanese rice wine", 350.0, true, null)
        };
        
        // Menus for Restaurant 5 (El Matador)
        Menu[] elMatadorMenu = {
            new Menu(5, 1, "Beef Burrito", "Large burrito with beef and beans", 350.0, true, null),
            new Menu(5, 1, "Chicken Tacos (3)", "Soft shell tacos with grilled chicken", 280.0, true, null),
            new Menu(5, 2, "Nachos Supreme", "Loaded nachos with cheese and jalapeños", 220.0, true, null),
            new Menu(5, 1, "Quesadilla", "Cheese and mushroom quesadilla", 250.0, true, null),
            new Menu(5, 3, "Churros", "Fried dough pastry with chocolate dip", 180.0, true, null),
            new Menu(5, 4, "Horchata", "Traditional rice and cinnamon drink", 150.0, true, null)
        };
        
        // Menus for Restaurant 6 (Green Earth Cafe)
        Menu[] greenEarthMenu = {
            new Menu(6, 1, "Vegan Burger", "Plant-based patty with vegan cheese", 380.0, true, null),
            new Menu(6, 1, "Quinoa Bowl", "Quinoa, roasted veggies, tahini", 320.0, true, null),
            new Menu(6, 2, "Kale Salad", "Fresh kale with lemon dressing", 240.0, true, null),
            new Menu(6, 1, "Tofu Wrap", "Spiced tofu with greens in a wrap", 290.0, true, null),
            new Menu(6, 3, "Vegan Brownie", "Dairy-free dark chocolate brownie", 190.0, true, null),
            new Menu(6, 4, "Kombucha", "Fermented fizzy tea", 160.0, true, null)
        };
        
        Menu[][] allNewMenus = {tokyoMenu, elMatadorMenu, greenEarthMenu};
        
        for (Menu[] rMenu : allNewMenus) {
            for (Menu menu : rMenu) {
                try {
                    menuDAO.addMenu(menu);
                    System.out.println("Added menu item: " + menu.getName());
                } catch (Exception e) {
                    System.out.println("Error adding menu item: " + menu.getName() + " - " + e.getMessage());
                }
            }
        }
    }

    public static void main(String[] args) {
        System.out.println("Seeding new restaurants...");
        seedRestaurants();
        System.out.println("Seeding new menus...");
        seedMenuData();
        System.out.println("Data seeding completed!");
    }
}
