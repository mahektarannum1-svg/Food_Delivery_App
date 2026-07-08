package com.dcl.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.dcl.dao.RestaurantDAO;
import com.dcl.model.Restaurant;
import com.dcl.utility.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    @Override
    public void addRestaurant(Restaurant r) {
        String sql = "INSERT INTO restaurant (name, cuisine_type, delivery_time, address, rating, is_active, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisineType());
            ps.setInt(3, r.getDeliveryTime());
            ps.setString(4, r.getAddress());
            ps.setDouble(5, r.getRating());
            ps.setBoolean(6, r.isActive());
            ps.setString(7, r.getImageUrl());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    r.setRestaurantId(rs.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void updateRestaurant(Restaurant r) {
        String sql = "UPDATE restaurant SET name=?, cuisine_type=?, delivery_time=?, address=?, rating=?, is_active=?, image_url=? WHERE restaurant_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getCuisineType());
            ps.setInt(3, r.getDeliveryTime());
            ps.setString(4, r.getAddress());
            ps.setDouble(5, r.getRating());
            ps.setBoolean(6, r.isActive());
            ps.setString(7, r.getImageUrl());
            ps.setInt(8, r.getRestaurantId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int id) {
        String sql = "DELETE FROM restaurant WHERE restaurant_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int id) {
        String sql = "SELECT * FROM restaurant WHERE restaurant_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRestaurant(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        String sql = "SELECT * FROM restaurant WHERE is_active = TRUE";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                restaurants.add(mapResultSetToRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return restaurants;
    }

    private Restaurant mapResultSetToRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getInt("restaurant_id"));
        r.setName(rs.getString("name"));
        r.setCuisineType(rs.getString("cuisine_type"));
        r.setDeliveryTime(rs.getInt("delivery_time"));
        r.setAddress(rs.getString("address"));
        r.setRating(rs.getDouble("rating"));
        r.setActive(rs.getBoolean("is_active"));
        r.setImageUrl(rs.getString("image_url"));
        return r;
    }
}
