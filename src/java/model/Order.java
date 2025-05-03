package model;
/**
 *
 * @author RasinduPerera
 */
import java.util.List;

public class Order {
    private int orderId;
    private int waiterId;
    private int tableId;
    private String status;
    private List<CartItem> items;

    public Order() {}

    public Order(int orderId, int waiterId, int tableId, String status, List<CartItem> items) {
        this.orderId = orderId;
        this.waiterId = waiterId;
        this.tableId = tableId;
        this.status = status;
        this.items = items;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getWaiterId() {
        return waiterId;
    }

    public void setWaiterId(int waiterId) {
        this.waiterId = waiterId;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = items;
    }
}
