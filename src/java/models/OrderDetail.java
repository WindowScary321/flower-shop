package models;

public class OrderDetail {
    private int orderDetailId;
    private int orderId;
    private int flowerId;
    private int quantity;
    private double unitPrice;
    
    // Extra fields for displaying flower info in order
    private String flowerName;
    private String unit;
    private String image;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailId, int orderId, int flowerId, int quantity, double unitPrice) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.flowerId = flowerId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public OrderDetail(int orderDetailId, int orderId, int flowerId, int quantity, double unitPrice, String flowerName, String unit, String image) {
        this.orderDetailId = orderDetailId;
        this.orderId = orderId;
        this.flowerId = flowerId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.flowerName = flowerName;
        this.unit = unit;
        this.image = image;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getFlowerId() {
        return flowerId;
    }

    public void setFlowerId(int flowerId) {
        this.flowerId = flowerId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
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

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
