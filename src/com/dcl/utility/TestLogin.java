package com.dcl.utility;

import java.sql.*;

public class TestLogin {
    public static void main(String[] args) throws Exception {
        Connection con = DBConnection.getConnection();
        
        // Show ALL users
        System.out.println("=== ALL USERS IN DB ===");
        Statement st = con.createStatement();
        ResultSet all = st.executeQuery("SELECT user_id, username, email, role, password, password_salt FROM user");
        while (all.next()) {
            String storedHash = all.getString("password");
            String storedSalt = all.getString("password_salt");
            System.out.println("\n[" + all.getInt("user_id") + "] " + all.getString("username") 
                + " | " + all.getString("email") + " | role=" + all.getString("role"));
            
            // Test admin123
            if (storedSalt != null) {
                boolean matchAdmin123 = PasswordUtil.hashPassword("admin123", storedSalt).equals(storedHash);
                boolean match12345678 = PasswordUtil.hashPassword("12345678", storedSalt).equals(storedHash);
                boolean match123456 = PasswordUtil.hashPassword("123456", storedSalt).equals(storedHash);
                System.out.println("   admin123 match: " + matchAdmin123);
                System.out.println("   12345678 match: " + match12345678);
                System.out.println("   123456 match: " + match123456);
            } else {
                System.out.println("   no salt - plain text password: " + storedHash);
            }
        }
        con.close();
    }
}
