package model;

/**
 * Represents an item in the shopping cart
 * @author RasinduPerera
 */
public class CartItem {
    private int itemId;        // Added for database operations
    private String itemName;   // Added for display purposes
    private double price;      // Added for price tracking
    private MenuItem item;     // Original menu item reference
    private int quantity;      // Quantity of the item

    // Default constructor
    public CartItem() {}

    // Constructor with MenuItem
    public CartItem(MenuItem item, int quantity) {
        this.item = item;
        this.quantity = quantity;
        this.itemId = item.getId();
        this.itemName = item.getName();
        this.price = item.getPrice();
    }

    // Constructor with direct values
    public CartItem(int itemId, String itemName, double price, int quantity) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.price = price;
        this.quantity = quantity;
    }

    // Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public MenuItem getItem() {
        return item;
    }

    public void setItem(MenuItem item) {
        this.item = item;
        if (item != null) {
            this.itemId = item.getId();
            this.itemName = item.getName();
            this.price = item.getPrice();
        }
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative");
        }
        this.quantity = quantity;
    }

    // Calculate subtotal for this item
    public double getSubtotal() {
        return price * quantity;
    }

    // Increment quantity
    public void incrementQuantity() {
        this.quantity++;
    }

    // Decrement quantity
    public void decrementQuantity() {
        if (this.quantity > 0) {
            this.quantity--;
        }
    }

    // Check if this cart item is valid
    public boolean isValid() {
        return itemId > 0 && itemName != null && !itemName.trim().isEmpty() 
               && price >= 0 && quantity > 0;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        CartItem other = (CartItem) obj;
        return itemId == other.itemId;
    }

    @Override
    public int hashCode() {
        return itemId;
    }

    @Override
    public String toString() {
        return String.format("CartItem{itemId=%d, name='%s', price=%.2f, quantity=%d}", 
            itemId, itemName, price, quantity);
    }
}