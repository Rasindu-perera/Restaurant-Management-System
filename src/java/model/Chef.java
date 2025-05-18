package model;

public class Chef {
    private int chefId;
    private String name;

    public Chef() {}

    public Chef(int chefId, String name) {
        this.chefId = chefId;
        this.name = name;
    }

    public int getChefId() {
        return chefId;
    }

    public void setChefId(int chefId) {
        this.chefId = chefId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
} 