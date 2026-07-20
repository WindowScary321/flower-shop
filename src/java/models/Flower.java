package models;

public class Flower {
    private int flowerId;
    private String flowerName;
    private String unit;
    private double price;
    private int quantity;
    private String image;
    private String description;
    private int categoryId;
    private int discount;
    private boolean status;

    public Flower() {
    }

    public Flower(int flowerId, String flowerName, String unit, double price, int quantity, String image, String description, int categoryId, int discount, boolean status) {
        this.flowerId = flowerId;
        this.flowerName = flowerName;
        this.unit = unit;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
        this.description = description;
        this.categoryId = categoryId;
        this.discount = discount;
        this.status = status;
    }

    public int getFlowerId() {
        return flowerId;
    }

    public void setFlowerId(int flowerId) {
        this.flowerId = flowerId;
    }

    public String getFlowerName() {
        return flowerName;
    }

    public void setFlowerName(String flowerName) {
        this.flowerName = flowerName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescription() {
        return description;
    }

    public String getFormattedDescription() {
        if (description == null) {
            return "";
        }
        String html = description;
        // Replace **bold** with <strong>bold</strong>
        html = html.replaceAll("\\*\\*(.*?)\\*\\*", "<strong>$1</strong>");
        // Replace *italic* with <em>italic</em>
        html = html.replaceAll("\\*(.*?)\\*", "<em>$1</em>");
        // Replace newlines with <br/> only if it doesn't already contain common HTML block elements to prevent double-spacing
        if (!html.contains("<p>") && !html.contains("<li>") && !html.contains("<br") && !html.contains("<div>")) {
            html = html.replace("\r\n", "<br/>").replace("\n", "<br/>");
        }
        return html;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public double getFinalPrice() {
        if (discount > 0) {
            return price * (100 - discount) / 100.0;
        }
        return price;
    }
}
