package com.restaurant.rms.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;

@Data
@Entity
@Table(name = "waste_log")
public class WasteLog {

    public enum WasteReason {
        SPOILAGE, OVER_PREPARATION, ACCIDENT, OTHER
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "item_id", nullable = false, insertable = false, updatable = false)
    private InventoryItem item;

    @Column(name = "item_id", nullable = false)
    private Long itemId;

    @Column(name = "quantity", nullable = false)
    private double quantity;

    @Enumerated(EnumType.STRING)
    @Column(name = "reason", nullable = false)
    private WasteReason reason;

    @Column(name = "waste_date", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date wasteDate;

    @Column(name = "notes")
    private String notes;

    @Column(name = "recorded_by", nullable = false)
    private Long recordedBy;

    // Add setter for itemId
    public void setItemId(Long itemId) {
        this.itemId = itemId;
    }
}