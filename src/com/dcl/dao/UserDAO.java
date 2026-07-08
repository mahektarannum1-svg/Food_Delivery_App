package com.dcl.dao;

import java.util.List;
import com.dcl.model.User;

public interface UserDAO {
    void addUser(User u);
    void updateUser(User u);
    void deleteUser(int id);
    User getUser(int id);
    List<User> getAllUser();
    User login(String email, String plainPassword);
    User getUserByEmail(String email);
}
