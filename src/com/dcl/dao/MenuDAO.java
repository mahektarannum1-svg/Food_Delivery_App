package com.dcl.dao;

import java.util.List;
import com.dcl.model.Menu;

public interface MenuDAO {
    void addMenu(Menu m);
    void updateMenu(Menu m);
    void deleteMenu(int id);
    Menu getMenu(int id);
    List<Menu> getAllMenus();
    List<Menu> getMenuByRestaurant(int restaurantId);
}
