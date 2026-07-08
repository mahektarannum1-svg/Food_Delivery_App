package com.dcl.model;

public class Menu {
    private int menuId;
    private int restaurantId;
    private int categoryId;
    private String name;
    private String description;
    private double price;
    private boolean isAvailable;
    private String imageUrl;

    public Menu() {}

    public Menu(int restaurantId, int categoryId, String name, String description, double price, boolean isAvailable, String imageUrl) {
        this.restaurantId = restaurantId;
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.isAvailable = isAvailable;
        this.imageUrl = imageUrl;
    }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    @Override
    public String toString() {
        return "Menu{" + "menuId=" + menuId + ", restaurantId=" + restaurantId + 
               ", name='" + name + '\'' + ", price=" + price + ", isAvailable=" + isAvailable + '}';
    }
}
