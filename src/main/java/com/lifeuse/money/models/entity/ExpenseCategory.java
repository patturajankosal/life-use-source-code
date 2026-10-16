package com.lifeuse.money.models.entity;

import java.time.Instant;

public class ExpenseCategory {

    private Long id;
    private Long userId;
    private String name;
    private String icon;
    private String color;
    private boolean essential;
    private boolean system;
    private Instant createdAt;

    public ExpenseCategory() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public boolean isEssential() { return essential; }
    public void setEssential(boolean essential) { this.essential = essential; }

    public boolean isSystem() { return system; }
    public void setSystem(boolean system) { this.system = system; }

    public Instant getCreatedAt() { return createdAt; }
    public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }
}
