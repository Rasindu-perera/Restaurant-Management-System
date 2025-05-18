package model.inventory;

import java.sql.Date;

public class PurchaseItem {
    private long id;
    private long purchaseId;
    private long itemId;
    private InventoryItem item; // For convenience
    private double quantity;
    private double unitPrice;
    private Date expiryDate;
    private String batchNumber;
    private Purchase purchase;
    
    public PurchaseItem() {}
    
    // Getters and setters
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public long getPurchaseId() {
        return purchaseId;
    }
    
    public void setPurchaseId(long purchaseId) {
        this.purchaseId = purchaseId;
    }
    
    public long getItemId() {
        return itemId;
    }
    
    public void setItemId(long itemId) {
        this.itemId = itemId;
    }
    
    public InventoryItem getItem() {
        return item;
    }
    
    public void setItem(InventoryItem item) {
        this.item = item;
        if (item != null) {
            this.itemId = item.getItemId();
        }
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
    
    public Date getExpiryDate() {
        return expiryDate;
    }
    
    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
    
    public String getBatchNumber() {
        return batchNumber;
    }
    
    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }
    
    public Purchase getPurchase() {
        return purchase;
    }
    
    public void setPurchase(Purchase purchase) {
        this.purchase = purchase;
    }
    
    // Calculate total cost for this item
    public double getTotalCost() {
        return quantity * unitPrice;
    }
}
