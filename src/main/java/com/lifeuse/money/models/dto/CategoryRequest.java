package com.lifeuse.money.models.dto;

import jakarta.validation.constraints.NotBlank;

public class CategoryRequest {

    @NotBlank(message = "Category name is required")
    private String name;

    private String icon;
    private String color;
    private Boolean essential;

    public CategoryRequest() {
        this.essential = false;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public Boolean getEssential() { return essential; }
    public void setEssential(Boolean essential) { this.essential = essential; }
}
