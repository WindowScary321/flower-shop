package models;

public class RevenueByCategory {
    private String categoryName;
    private double totalRevenue;

    public RevenueByCategory() {
    }

    public RevenueByCategory(String categoryName, double totalRevenue) {
        this.categoryName = categoryName;
        this.totalRevenue = totalRevenue;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}
