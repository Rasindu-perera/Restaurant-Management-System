package model.inventory;

public class InventoryItem {
    private long itemId;  // Not 'id'
    private String name;
    private double currentQuantity;  // Matches current_quantity in DB
    private String unit;
    private double costPerUnit;      // Matches cost_per_unit in DB
    private double minStockLevel;    // Matches min_stock_level in DB
    private String storageLocation;  // Matches storage_location in DB
    private long categoryId;
    private Category category;
    
    public InventoryItem() {}
    
    // Database-aligned getters and setters
    public long getItemId() {
        return itemId;
    }
    
    public void setItemId(long itemId) {
        this.itemId = itemId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public double getCurrentQuantity() {
        return currentQuantity;
    }
    
    public void setCurrentQuantity(double currentQuantity) {
        this.currentQuantity = currentQuantity;
    }
    
    // For backward compatibility (code using the old property names)
    public double getCurrentStock() {
        return currentQuantity;
    }
    
    public void setCurrentStock(double currentStock) {
        this.currentQuantity = currentStock;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public double getCostPerUnit() {
        return costPerUnit;
    }
    
    public void setCostPerUnit(double costPerUnit) {
        this.costPerUnit = costPerUnit;
    }
    
    // For backward compatibility
    public double getUnitPrice() {
        return costPerUnit;
    }
    
    public void setUnitPrice(double unitPrice) {
        this.costPerUnit = unitPrice;
    }
    
    public double getMinStockLevel() {
        return minStockLevel;
    }
    
    public void setMinStockLevel(double minStockLevel) {
        this.minStockLevel = minStockLevel;
    }
    
    public String getStorageLocation() {
        return storageLocation;
    }
    
    public void setStorageLocation(String storageLocation) {
        this.storageLocation = storageLocation;
    }
    
    public long getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }
    
    public Category getCategory() {
        return category;
    }
    
    public void setCategory(Category category) {
        this.category = category;
        if (category != null) {
            this.categoryId = category.getCategoryId();
        }
    }
    
    // Calculate if stock is low based on minimum stock level
    public boolean isLowStock() {
        return currentQuantity < minStockLevel;
    }
    
    // Calculate total stock value
    public double getTotalStockValue() {
        return currentQuantity * costPerUnit;
    }
    
    // For JSP display consistency
    public String getDescription() {
        return ""; // Database doesn't have this field
    }
    
    public void setDescription(String description) {
        // No-op - Database doesn't have this field
    }
}
