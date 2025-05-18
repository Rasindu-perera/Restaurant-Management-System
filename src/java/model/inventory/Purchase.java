package model.inventory;

import java.sql.Timestamp;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

public class Purchase {
    private long purchaseId;
    private long supplierId;
    private Supplier supplier; // For convenience
    private Timestamp purchaseDate;
    private Time purchaseTime;
    private String invoiceNumber;
    private double totalCost;
    private String notes;
    private long createdBy;
    private List<PurchaseItem> items = new ArrayList<>();
    private String unit;
    private String itemName;
    private long itemId;
    private double quantity;
    private double unitPrice;
    
    public Purchase() {}
    
    // Getters and setters
    public long getPurchaseId() {
        return purchaseId;
    }
    
    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
    }
    
    public long getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(long supplierId) {
        this.supplierId = supplierId;
    }
    
    public Supplier getSupplier() {
        return supplier;
    }
    
    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
        if (supplier != null) {
            this.supplierId = supplier.getSupplierId();
        }
    }
    
    public Timestamp getPurchaseDate() {
        return purchaseDate;
    }
    
    public void setPurchaseDate(Timestamp purchaseDate) {
        this.purchaseDate = purchaseDate;
    }
    
    public Time getPurchaseTime() {
        return purchaseTime;
    }
    
    public void setPurchaseTime(Time purchaseTime) {
        this.purchaseTime = purchaseTime;
    }
    
    public String getInvoiceNumber() {
        return invoiceNumber;
    }
    
    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }
    
    public double getTotalCost() {
        return totalCost;
    }
    
    public void setTotalCost(double totalCost) {
        this.totalCost = totalCost;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public long getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(long createdBy) {
        this.createdBy = createdBy;
    }
    
    public List<PurchaseItem> getItems() {
        return items;
    }
    
    public void setItems(List<PurchaseItem> items) {
        this.items = items;
    }
    
    public void addItem(PurchaseItem item) {
        items.add(item);
    }
    
    // Calculate total cost based on items
    public void calculateTotalCost() {
        double total = 0;
        for (PurchaseItem item : items) {
            total += item.getQuantity() * item.getUnitPrice();
        }
        this.totalCost = total;
    }
    
    public double getQuantity() {
        return quantity;
    }

    public void setQuantity(double quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public long getItemId() {
        return itemId;
    }

    public void setItemId(long itemId) {
        this.itemId = itemId;
    }
}
