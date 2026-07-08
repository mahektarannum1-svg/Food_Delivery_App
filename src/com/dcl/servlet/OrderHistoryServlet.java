package com.dcl.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dcl.model.User;
import com.dcl.model.Order;
import com.dcl.model.OrderItem;
import com.dcl.DAOImpl.OrderDAOImpl;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.DAOImpl.MenuDAOImpl;
import com.dcl.model.Restaurant;
import com.dcl.model.Menu;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Redirect to login if not authenticated
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            OrderDAOImpl orderDAO = new OrderDAOImpl();
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            MenuDAOImpl menuDAO = new MenuDAOImpl();

            // Fetch all orders for this user
            List<Order> orders = orderDAO.getOrdersByUser(user.getUserId());

            // For each order, fetch restaurant name and order items with product names
            List<String> restaurantNames = new ArrayList<>();
            List<List<OrderItem>> allOrderItems = new ArrayList<>();
            List<List<String>> allItemNames = new ArrayList<>();

            for (Order order : orders) {
                // Get restaurant name
                Restaurant restaurant = restaurantDAO.getRestaurant(order.getRestaurantId());
                restaurantNames.add(restaurant != null ? restaurant.getName() : "Unknown Restaurant");

                // Get order items
                List<OrderItem> items = orderDAO.getOrderItems(order.getOrderId());
                allOrderItems.add(items);

                // Get item names from menu
                List<String> itemNames = new ArrayList<>();
                for (OrderItem item : items) {
                    Menu menu = menuDAO.getMenu(item.getProductId());
                    itemNames.add(menu != null ? menu.getName() : "Item #" + item.getProductId());
                }
                allItemNames.add(itemNames);
            }

            request.setAttribute("orders", orders);
            request.setAttribute("restaurantNames", restaurantNames);
            request.setAttribute("allOrderItems", allOrderItems);
            request.setAttribute("allItemNames", allItemNames);

            RequestDispatcher rd = request.getRequestDispatcher("orderHistory.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading order history: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("orderHistory.jsp");
            rd.forward(request, response);
        }
    }
}
