package model.inventory;

import java.sql.Timestamp;

public class WasteLog {
    private long id;
    private double quantity;
    private long itemId;
    private InventoryItem item; // For convenience
    private long recordedBy;
    private Timestamp wasteDate;
    private String notes;
    private WasteReason reason;
    
    public enum WasteReason {
        SPOILAGE,
        ACCIDENT,
        OVER_PREPARATION,
        OTHER
    }
    
    public WasteLog() {}
    
    // Getters and setters
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public double getQuantity() {
        return quantity;
    }
    
    public void setQuantity(double quantity) {
        this.quantity = quantity;
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
    
    public Timestamp getWasteDate() {
        return wasteDate;
    }
    
    public void setWasteDate(Timestamp wasteDate) {
        this.wasteDate = wasteDate;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public WasteReason getReason() {
        return reason;
    }
    
    public void setReason(WasteReason reason) {
        this.reason = reason;
    }
    
    // Convert string to enum
    public void setReasonFromString(String reasonStr) {
        try {
            this.reason = WasteReason.valueOf(reasonStr);
        } catch (IllegalArgumentException e) {
            this.reason = WasteReason.OTHER;
        }
    }
}
