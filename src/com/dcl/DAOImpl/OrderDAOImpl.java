package com.dcl.DAOImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.dcl.dao.OrderDAO;
import com.dcl.model.Order;
import com.dcl.model.OrderItem;
import com.dcl.utility.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public void addOrder(Order o, List<OrderItem> items) {
        String sqlOrder = "INSERT INTO orders (user_id, restaurant_id, total_amount, status, payment_mode, delivery_address, created_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlOrderItem = "INSERT INTO order_items (order_id, product_id, quantity, item_total) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Insert order
                try (PreparedStatement psOrder = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                    psOrder.setInt(1, o.getUserId());
                    psOrder.setInt(2, o.getRestaurantId());
                    psOrder.setDouble(3, o.getTotalAmount());
                    psOrder.setString(4, o.getStatus());
                    psOrder.setString(5, o.getPaymentMode());
                    psOrder.setString(6, o.getDeliveryAddress());
                    
                    if (o.getCreatedDate() != null) {
                        psOrder.setTimestamp(7, o.getCreatedDate());
                    } else {
                        psOrder.setTimestamp(7, new java.sql.Timestamp(System.currentTimeMillis()));
                    }
                    
                    psOrder.executeUpdate();

                    try (ResultSet rs = psOrder.getGeneratedKeys()) {
                        if (rs.next()) {
                            o.setOrderId(rs.getInt(1));
                        }
                    }
                }

                // Insert order items
                try (PreparedStatement psItem = con.prepareStatement(sqlOrderItem)) {
                    for (OrderItem item : items) {
                        psItem.setInt(1, o.getOrderId());
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setDouble(4, item.getItemTotal());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }

                con.commit();
            } catch (SQLException e) {
                con.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Order getOrder(int id) {
        String sql = "SELECT * FROM orders WHERE order_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrder(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setItemTotal(rs.getDouble("item_total"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                orders.add(mapResultSetToOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapResultSetToOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=? WHERE order_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setPaymentMode(rs.getString("payment_mode"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        o.setCreatedDate(rs.getTimestamp("created_date"));
        return o;
    }
}
