package com.restaurant.rms.service;

import com.restaurant.rms.dao.SupplierDAO;
import com.restaurant.rms.model.Supplier;

import java.util.List;

public class SupplierService {
    private final SupplierDAO supplierDAO;

    public SupplierService() {
        this.supplierDAO = new SupplierDAO();
    }

    public List<Supplier> getAllSuppliers() {
        return supplierDAO.getAllSuppliers();
    }

    public Supplier getSupplierById(Long id) {
        return supplierDAO.getSupplierById(id);
    }

    public void saveSupplier(Supplier supplier) {
        supplierDAO.saveSupplier(supplier);
    }

    public void updateSupplier(Supplier supplier) {
        supplierDAO.updateSupplier(supplier);
    }

    public void deleteSupplier(Long id) {
        supplierDAO.deleteSupplier(id);
    }
}