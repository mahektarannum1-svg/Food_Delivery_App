package com.dcl.utility;

import java.sql.*;

public class ResetPassword {
    public static void main(String[] args) throws Exception {
        String email = "admin@medislot.com";
        String newPassword = "admin123";
        
        // Generate new salt and hash
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(newPassword, salt);
        
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "UPDATE user SET password=?, password_salt=?, role='CUSTOMER' WHERE email=?"
        );
        ps.setString(1, hash);
        ps.setString(2, salt);
        ps.setString(3, email);
        int rows = ps.executeUpdate();
        con.close();
        
        System.out.println("Updated " + rows + " user(s).");
        System.out.println("Email: " + email);
        System.out.println("New password: " + newPassword);
        System.out.println("Role set to: CUSTOMER (uppercase)");
    }
}
