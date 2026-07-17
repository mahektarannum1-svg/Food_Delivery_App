package com.dcl.utility;

import java.sql.*;

/**
 * Fixes the database: resets all user passwords with proper hashing,
 * creates an admin user, ensures all existing users can login.
 */
public class FixUsersAndAdmin {
    public static void main(String[] args) throws Exception {
        Connection con = DBConnection.getConnection();

        // 1. Fix the demo user (ID=1) which has a bad "demoSalt" salt - reset to password "demo123"
        fixUserPassword(con, 1, "demo123");

        // 2. Ensure Mahek (ID=2) stays working — we don't know original password,
        //    so we reset it to "admin123" for convenience
        fixUserPassword(con, 2, "admin123");

        // 3. Fix all other broken users
        fixUserPassword(con, 5, "test123");
        fixUserPassword(con, 7, "test123");

        // 4. Create (or upsert) an ADMIN user
        String adminEmail = "admin@bite.com";
        PreparedStatement check = con.prepareStatement("SELECT user_id FROM user WHERE email=?");
        check.setString(1, adminEmail);
        ResultSet rs = check.executeQuery();
        if (!rs.next()) {
            // Create admin from scratch
            String salt = PasswordUtil.generateSalt();
            String hash = PasswordUtil.hashPassword("admin123", salt);
            PreparedStatement ins = con.prepareStatement(
                "INSERT INTO user (username, password, password_salt, email, address, role, created_date) VALUES (?,?,?,?,?,?,?)");
            ins.setString(1, "Admin");
            ins.setString(2, hash);
            ins.setString(3, salt);
            ins.setString(4, adminEmail);
            ins.setString(5, "HQ");
            ins.setString(6, "admin");
            ins.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            ins.executeUpdate();
            System.out.println("Created admin user: admin@bite.com / admin123");
        } else {
            // Admin already exists — just reset their password
            int adminId = rs.getInt("user_id");
            fixUserPassword(con, adminId, "admin123");
            // Ensure role is admin
            PreparedStatement roleUpdate = con.prepareStatement("UPDATE user SET role='admin' WHERE user_id=?");
            roleUpdate.setInt(1, adminId);
            roleUpdate.executeUpdate();
            System.out.println("Reset admin user password to admin123 and ensured role=admin");
        }
        rs.close();

        // 5. Verify by printing all users
        System.out.println("\n=== FINAL USER STATE ===");
        Statement st = con.createStatement();
        ResultSet all = st.executeQuery("SELECT user_id, username, email, role FROM user");
        while (all.next()) {
            System.out.println("ID=" + all.getInt(1) + " | " + all.getString(2) + " | " + all.getString(3) + " | role=" + all.getString(4));
        }

        con.close();
        System.out.println("\nDone! Login credentials:");
        System.out.println("  Admin: admin@bite.com / admin123");
        System.out.println("  Demo:  demo@food.com / demo123");
    }

    private static void fixUserPassword(Connection con, int userId, String newPassword) throws Exception {
        String salt = PasswordUtil.generateSalt();
        String hash = PasswordUtil.hashPassword(newPassword, salt);
        PreparedStatement ps = con.prepareStatement(
            "UPDATE user SET password=?, password_salt=? WHERE user_id=?");
        ps.setString(1, hash);
        ps.setString(2, salt);
        ps.setInt(3, userId);
        int rows = ps.executeUpdate();
        System.out.println("Fixed user ID=" + userId + " -> password=" + newPassword + " (" + rows + " rows updated)");
    }
}
