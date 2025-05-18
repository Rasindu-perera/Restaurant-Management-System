package model;

import java.sql.Timestamp;

public class Table {
    private int tableId;
    private String tableName;
    private String status;   // Available, Occupied, Reserved
    private int waiterId;
    private Integer reservedBy;
    private Timestamp createdAt;

    // Constructor
    public Table(int tableId, String status, int waiterId) {
        this.tableId = tableId;
        this.status = status;
        this.waiterId = waiterId;
    }

    public Table() {
        // default constructor
    }

    // Getters and Setters
    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getWaiterId() {
        return waiterId;
    }

    public void setWaiterId(int waiterId) {
        this.waiterId = waiterId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Table{id=" + tableId + ", status='" + status + "', waiterId=" + waiterId + "}";
    }

    public Integer getReservedBy() {
        return reservedBy;
    }

    public void setReservedBy(Integer reservedBy) {
        this.reservedBy = reservedBy;
    }

    // Add this constructor to the existing Table class
    public Table(int tableId, String status, int waiterId, Integer reservedBy) {
        this.tableId = tableId;
        this.status = status;
        this.waiterId = waiterId;
        this.reservedBy = reservedBy;
    }
}
