package com.dcl.servlet;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.dcl.DAOImpl.UserDAOImpl;
import com.dcl.model.User;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UserServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equals("logout")) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("index.jsp");
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equals("login")) {
            handleLogin(request, response);
        } else if (action != null && action.equals("register")) {
            handleRegister(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            UserDAOImpl userDAO = new UserDAOImpl();
            User user = userDAO.login(email, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userName", user.getUsername());
                // Redirect admin to admin dashboard, customers to restaurants
                if (user.getRole() == User.Role.ADMIN) {
                    response.sendRedirect("AdminServlet");
                } else {
                    response.sendRedirect("RestaurantServlet");
                }
            } else {
                request.setAttribute("error", "Invalid email or password");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        
        try {
            UserDAOImpl userDAO = new UserDAOImpl();
            
            // Check if email already exists
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "Email is already registered. Please login or use a different email.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            User newUser = new User(username, password, email, address, User.Role.CUSTOMER);
            newUser.setCreatedDate(new java.sql.Timestamp(System.currentTimeMillis()));
            userDAO.addUser(newUser);
            
            request.setAttribute("success", "Registration successful! Please login.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/register.jsp");
            dispatcher.forward(request, response);
        }
    }
}
