package com.dcl.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.model.Restaurant;

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RestaurantServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Step 1: Create object of RestaurantDAOImpl
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            
            // Step 2: Get all restaurants list
            List<Restaurant> restaurantsList = restaurantDAO.getAllRestaurants();
            
            // Step 3: Put the restaurants list into request object (setAttribute)
            request.setAttribute("restaurantsList", restaurantsList);
            
            // Step 4: Create a RequestDispatcher Object
            RequestDispatcher dispatcher = request.getRequestDispatcher("/restaurants.jsp");
            
            // Step 5: Call restaurants.jsp (forward)
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading restaurants");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
