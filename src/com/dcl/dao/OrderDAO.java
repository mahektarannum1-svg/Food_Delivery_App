package com.dcl.dao;

import java.util.List;
import com.dcl.model.Order;
import com.dcl.model.OrderItem;

public interface OrderDAO {
    void addOrder(Order o, List<OrderItem> items);
    Order getOrder(int id);
    List<OrderItem> getOrderItems(int orderId);
    List<Order> getAllOrders();
    List<Order> getOrdersByUser(int userId);
    void updateOrderStatus(int orderId, String status);
}
