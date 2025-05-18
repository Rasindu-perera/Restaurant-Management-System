package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int tableId;
    private int orderId;
    private int waiterId;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    // Constructors
    public Feedback() {}

    public Feedback(int tableId, int orderId, int waiterId, int rating) {
        this.tableId = tableId;
        this.orderId = orderId;
        this.waiterId = waiterId;
        this.rating = rating;
    }

    // Getters and setters
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public int getTableId() {
        return tableId;
    }

    public void setTableId(int tableId) {
        this.tableId = tableId;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
