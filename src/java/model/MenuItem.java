package model;

/**
 * Represents a menu item in the restaurant system
 * @author RasinduPerera
 */
public class MenuItem {
    private int id;
    private String name;
    private double price;
    private String category;
    private String imageUrl;
    private int categoryId;
    private String description;    // Added for item description
    private boolean available;     // Added for item availability
    private int preparationTime;   // Added for preparation time in minutes

    // Default constructor
    public MenuItem() {
        this.available = true; // Default to available
    }

    // Full constructor
    public MenuItem(int id, String name, double price, String category, String imageUrl, 
                   String description, boolean available, int preparationTime) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.category = category;
        this.imageUrl = imageUrl;
        this.description = description;
        this.available = available;
        this.preparationTime = preparationTime;
    }

    // Basic constructor
    public MenuItem(int id, String name, double price, String category, String imageUrl) {
        this(id, name, price, category, imageUrl, "", true, 0);
    }

    // Getters and Setters with validation
    public int getId() {
        return id;
    }

    public void setId(int id) {
        if (id < 0) {
            throw new IllegalArgumentException("ID cannot be negative");
        }
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        if (price < 0) {
            throw new IllegalArgumentException("Price cannot be negative");
        }
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        if (category == null || category.trim().isEmpty()) {
            throw new IllegalArgumentException("Category cannot be null or empty");
        }
        this.category = category;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        if (categoryId < 0) {
            throw new IllegalArgumentException("Category ID cannot be negative");
        }
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public int getPreparationTime() {
        return preparationTime;
    }

    public void setPreparationTime(int preparationTime) {
        if (preparationTime < 0) {
            throw new IllegalArgumentException("Preparation time cannot be negative");
        }
        this.preparationTime = preparationTime;
    }

    // Utility methods
    public String getFormattedPrice() {
        return String.format("Rs. %.2f", price);
    }

    public boolean isValid() {
        return id > 0 && 
               name != null && !name.trim().isEmpty() && 
               price >= 0 && 
               category != null && !category.trim().isEmpty() && 
               categoryId > 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        MenuItem other = (MenuItem) obj;
        return id == other.id;
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public String toString() {
        return String.format("MenuItem{id=%d, name='%s', price=%.2f, category='%s', available=%b}", 
            id, name, price, category, available);
    }
}