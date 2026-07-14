package models;

public class TopSellingFlower {
    private int flowerId;
    private String flowerName;
    private int totalQuantitySold;

    public TopSellingFlower() {
    }

    public TopSellingFlower(int flowerId, String flowerName, int totalQuantitySold) {
        this.flowerId = flowerId;
        this.flowerName = flowerName;
        this.totalQuantitySold = totalQuantitySold;
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

    public int getTotalQuantitySold() {
        return totalQuantitySold;
    }

    public void setTotalQuantitySold(int totalQuantitySold) {
        this.totalQuantitySold = totalQuantitySold;
    }
}
