package model;

public class Category {
    private int categoryId;
    private String name;

    // ✅ Default constructor (required for DAO)
    public Category() {
    }

    // ✅ Parameterized constructor
    public Category(int categoryId, String name) {
        this.categoryId = categoryId;
        this.name = name;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Category{id=" + categoryId + ", name='" + name + "'}";
    }
}
