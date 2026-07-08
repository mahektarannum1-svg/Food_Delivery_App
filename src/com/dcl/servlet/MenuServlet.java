package com.dcl.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dcl.DAOImpl.MenuDAOImpl;
import com.dcl.DAOImpl.RestaurantDAOImpl;
import com.dcl.model.Menu;
import com.dcl.model.Restaurant;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public MenuServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Step 1: Get restaurantId parameter from request
            String restaurantIdParam = request.getParameter("restaurantId");
            if (restaurantIdParam == null || restaurantIdParam.trim().isEmpty()) {
                response.sendRedirect("RestaurantServlet");
                return;
            }
            int restId = Integer.parseInt(restaurantIdParam);

            // Step 2: Fetch restaurant details for display on menu page
            RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
            Restaurant restaurant = restaurantDAO.getRestaurant(restId);

            // Step 3: Get all menus by restaurant using restaurantId
            MenuDAOImpl menuImpl = new MenuDAOImpl();
            List<Menu> menusByRestaurant = menuImpl.getMenuByRestaurant(restId);

            // Step 4: Set attributes for menu.jsp
            request.setAttribute("menus", menusByRestaurant);
            request.setAttribute("restaurantId", restId);
            request.setAttribute("restaurant", restaurant);

            // Step 5: Forward to menu.jsp
            RequestDispatcher rd = request.getRequestDispatcher("menu.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid restaurant ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading menu");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
