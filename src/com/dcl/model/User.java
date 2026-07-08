package com.dcl.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String password;
    private String email;
    private String address;
    private Role role;
    private Timestamp createdDate;
    private Timestamp lastLoginDate;

    public enum Role {
        CUSTOMER,
        ADMIN;

        /**
         * Case-insensitive lookup for Role enum values.
         * Handles database values stored in any case (e.g., "customer", "Customer", "CUSTOMER").
         */
        public static Role fromString(String value) {
            if (value == null) {
                throw new IllegalArgumentException("Role value cannot be null");
            }
            return Role.valueOf(value.trim().toUpperCase());
        }
    }
    
    public User(String username, String password, String email, String address, Role role) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
    }

    public User() {}

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Timestamp lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    /**
     * Returns the user's display name.
     * Since there is no separate full_name column in the DB, we return username.
     */
    public String getFullName() {
        return username;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                ", role=" + role +
                ", createdDate=" + createdDate +
                ", lastLoginDate=" + lastLoginDate +
                '}';
    }
}
