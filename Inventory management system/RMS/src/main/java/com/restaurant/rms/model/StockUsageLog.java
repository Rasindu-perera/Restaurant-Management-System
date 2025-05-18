package com.restaurant.rms.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.Date;

@Data
@Entity
@Table(name = "stock_usage_logs")
public class StockUsageLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "item_id", nullable = false)
    private InventoryItem item;

    @Column(name = "quantity_used", nullable = false)  // Must match exact DB column name
    private Double quantityUsed = 0.0;  // Initialize with default value

    @Temporal(TemporalType.DATE)
    @Column(name = "usage_date", nullable = false)
    private Date usageDate = new Date();

    @Column(length = 500)
    private String notes;

    @ManyToOne
    @JoinColumn(name = "recorded_by", nullable = false)
    private User recordedBy;

    // Constructor to ensure initialization
    public StockUsageLog() {
        this.quantityUsed = 0.0;
        this.usageDate = new Date();
    }
}