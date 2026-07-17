package com.dcl.servlet;

import java.io.IOException;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dcl.DAOImpl.MenuDAOImpl;
import com.dcl.DAOImpl.OrderDAOImpl;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.DAOImpl.UserDAOImpl;
import com.dcl.model.*;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Only admins allowed
        if (user == null || user.getRole() != User.Role.ADMIN) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            UserDAOImpl userDAO = new UserDAOImpl();
            OrderDAOImpl orderDAO = new OrderDAOImpl();
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            MenuDAOImpl menuDAO = new MenuDAOImpl();

            // Get all users (excluding admin)
            List<User> allUsers = userDAO.getAllUser();

            // For each user, get their orders with details
            // Map: userId -> list of enriched order info
            Map<Integer, List<Map<String, Object>>> userOrdersMap = new LinkedHashMap<>();

            for (User u : allUsers) {
                if (u.getRole() == User.Role.ADMIN) continue;

                List<Order> orders = orderDAO.getOrdersByUser(u.getUserId());
                List<Map<String, Object>> enrichedOrders = new ArrayList<>();

                for (Order order : orders) {
                    if ("CART".equals(order.getStatus())) continue; // skip incomplete carts

                    Map<String, Object> orderInfo = new LinkedHashMap<>();
                    orderInfo.put("order", order);

                    Restaurant restaurant = restaurantDAO.getRestaurant(order.getRestaurantId());
                    orderInfo.put("restaurantName", restaurant != null ? restaurant.getName() : "Unknown");

                    List<OrderItem> items = orderDAO.getOrderItems(order.getOrderId());
                    List<String> itemNames = new ArrayList<>();
                    for (OrderItem item : items) {
                        Menu menu = menuDAO.getMenu(item.getProductId());
                        itemNames.add(menu != null ? menu.getName() : "Item #" + item.getProductId());
                    }
                    orderInfo.put("items", items);
                    orderInfo.put("itemNames", itemNames);
                    enrichedOrders.add(orderInfo);
                }

                userOrdersMap.put(u.getUserId(), enrichedOrders);
            }

            request.setAttribute("allUsers", allUsers);
            request.setAttribute("userOrdersMap", userOrdersMap);
            request.setAttribute("totalUsers", allUsers.size());
            request.setAttribute("totalOrders", orderDAO.getAllOrders().size());

            RequestDispatcher rd = request.getRequestDispatcher("admin.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp");
        }
    }
}
