package model;
/**
 *
 * @author RasinduPerera
 */
public class Waiter {
    private int waiterId;
    private String name;

    public Waiter() {}

    public Waiter(int waiterId, String name) {
        this.waiterId = waiterId;
        this.name = name;
    }

    public int getWaiterId() {
        return waiterId;
    }

    public void setWaiterId(int waiterId) {
        this.waiterId = waiterId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
