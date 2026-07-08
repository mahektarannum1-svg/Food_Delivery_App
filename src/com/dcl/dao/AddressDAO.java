package com.dcl.dao;

import java.util.List;
import com.dcl.model.Address;

public interface AddressDAO {
    void addAddress(Address a);
    void updateAddress(Address a);
    void deleteAddress(int id);
    Address getAddress(int id);
    List<Address> getAddressesByUser(int userId);
    Address getDefaultAddress(int userId);
    void setDefaultAddress(int userId, int addressId);
}
