package com.dcl.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.dcl.dao.MenuDAO;
import com.dcl.model.Menu;
import com.dcl.utility.DBConnection;

/**
 * MenuDAOImpl - DAO implementation for menu/product operations.
 *
 * IMPORTANT: The database uses the table name "products" (not "menu").
 * The columns map as follows:
 *   DB column          → Java field
 *   product_id         → menuId
 *   restaurant_id      → restaurantId
 *   category_id        → categoryId
 *   name               → name
 *   description        → description
 *   price              → price
 *   is_available       → isAvailable
 *   image_url          → imageUrl
 */
public class MenuDAOImpl implements MenuDAO {

    @Override
    public void addMenu(Menu m) {
        String sql = "INSERT INTO products (restaurant_id, category_id, name, description, price, is_available, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, m.getRestaurantId());
            ps.setInt(2, m.getCategoryId());
            ps.setString(3, m.getName());
            ps.setString(4, m.getDescription());
            ps.setDouble(5, m.getPrice());
            ps.setBoolean(6, m.isAvailable());
            ps.setString(7, m.getImageUrl());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    m.setMenuId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateMenu(Menu m) {
        String sql = "UPDATE products SET restaurant_id=?, category_id=?, name=?, description=?, price=?, is_available=?, image_url=? WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, m.getRestaurantId());
            ps.setInt(2, m.getCategoryId());
            ps.setString(3, m.getName());
            ps.setString(4, m.getDescription());
            ps.setDouble(5, m.getPrice());
            ps.setBoolean(6, m.isAvailable());
            ps.setString(7, m.getImageUrl());
            ps.setInt(8, m.getMenuId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int id) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int id) {
        String sql = "SELECT * FROM products WHERE product_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMenu(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                menus.add(mapResultSetToMenu(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menus;
    }

    @Override
    public List<Menu> getMenuByRestaurant(int restaurantId) {
        List<Menu> menus = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE restaurant_id=? AND is_available = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    menus.add(mapResultSetToMenu(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return menus;
    }

    /**
     * Maps a ResultSet row from the "products" table to a Menu object.
     * product_id → menuId, all other fields map directly.
     */
    private Menu mapResultSetToMenu(ResultSet rs) throws SQLException {
        Menu m = new Menu();
        m.setMenuId(rs.getInt("product_id"));
        m.setRestaurantId(rs.getInt("restaurant_id"));
        m.setCategoryId(rs.getInt("category_id"));
        m.setName(rs.getString("name"));
        m.setDescription(rs.getString("description"));
        m.setPrice(rs.getDouble("price"));
        m.setAvailable(rs.getBoolean("is_available"));
        m.setImageUrl(rs.getString("image_url"));
        return m;
    }
}
