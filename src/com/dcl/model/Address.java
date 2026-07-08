package com.dcl.model;

public class Address {
    private int addressId;
    private int userId;
    private String label;
    private String addressLine;
    private String city;
    private String zipCode;
    private boolean isDefault;

    public Address() {}

    public Address(int userId, String label, String addressLine, String city, String zipCode, boolean isDefault) {
        this.userId = userId;
        this.label = label;
        this.addressLine = addressLine;
        this.city = city;
        this.zipCode = zipCode;
        this.isDefault = isDefault;
    }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String addressLine) { this.addressLine = addressLine; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getZipCode() { return zipCode; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean aDefault) { isDefault = aDefault; }

    @Override
    public String toString() {
        return "Address{" + "addressId=" + addressId + ", label='" + label + '\'' + 
               ", city='" + city + '\'' + ", isDefault=" + isDefault + '}';
    }
}
