package com.dcl.utility;

import java.sql.*;

public class DiagnoseUsers {
    public static void main(String[] args) throws Exception {
        Connection con = DBConnection.getConnection();
        Statement st = con.createStatement();
        ResultSet r = st.executeQuery("SELECT user_id, username, email, role, password, password_salt FROM user");
        System.out.println("=== USER TABLE DIAGNOSIS ===");
        while (r.next()) {
            String salt = r.getString("password_salt");
            String pass = r.getString("password");
            System.out.println("ID=" + r.getInt("user_id") 
                + " username=" + r.getString("username")
                + " email=" + r.getString("email")
                + " role=" + r.getString("role")
                + " salt=" + (salt == null ? "NULL!" : salt.substring(0, Math.min(8, salt.length())) + "...")
                + " passLen=" + (pass == null ? "NULL" : pass.length()));
        }
        con.close();
    }
}
