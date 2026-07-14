package models;

public class ReportSummary {
    private double revenueToday;
    private double revenueThisMonth;
    private int totalOrders;
    private int totalCustomers;

    public ReportSummary() {
    }

    public ReportSummary(double revenueToday, double revenueThisMonth, int totalOrders, int totalCustomers) {
        this.revenueToday = revenueToday;
        this.revenueThisMonth = revenueThisMonth;
        this.totalOrders = totalOrders;
        this.totalCustomers = totalCustomers;
    }

    public double getRevenueToday() {
        return revenueToday;
    }

    public void setRevenueToday(double revenueToday) {
        this.revenueToday = revenueToday;
    }

    public double getRevenueThisMonth() {
        return revenueThisMonth;
    }

    public void setRevenueThisMonth(double revenueThisMonth) {
        this.revenueThisMonth = revenueThisMonth;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }
}
