package com.restaurant.rms.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "inventory_items")
public class InventoryItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "item_id")
    private Long id;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "current_quantity", nullable = false)
    private Double currentQuantity;

    @Column(nullable = false)
    private String unit;

    @Column(name = "min_stock_level")
    private Double minStockLevel;

    @Column(name = "storage_location")
    private String storageLocation;

    @Column(name = "cost_per_unit")
    private Double costPerUnit;
}