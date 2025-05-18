package model.inventory;

import java.sql.Date;

public class StockUsageLog {
    private long id;
    private Date usageDate;
    private long itemId;
    private InventoryItem item; // For convenience
    private long recordedBy;
    private String notes;
    private double quantityUsed;
    
    public StockUsageLog() {}
    
    // Getters and setters
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public Date getUsageDate() {
        return usageDate;
    }
    
    public void setUsageDate(Date usageDate) {
        this.usageDate = usageDate;
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
    
    public long getRecordedBy() {
        return recordedBy;
    }
    
    public void setRecordedBy(long recordedBy) {
        this.recordedBy = recordedBy;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public double getQuantityUsed() {
        return quantityUsed;
    }
    
    public void setQuantityUsed(double quantityUsed) {
        this.quantityUsed = quantityUsed;
    }
}
