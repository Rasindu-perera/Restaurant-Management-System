package model.inventory;

public class Category {
    private long categoryId;
    private String name;
    // No description field in database
    
    public Category() {}
    
    public Category(long categoryId, String name) {
        this.categoryId = categoryId;
        this.name = name;
    }
    
    // Getters and setters
    public long getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(long categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    // Added for backward compatibility
    public String getDescription() {
        return ""; // Database doesn't have this field
    }
    
    public void setDescription(String description) {
        // No-op - Database doesn't have this field
    }
    
    @Override
    public String toString() {
        return name;
    }
}
