package dal;

import models.ReportSummary;
import models.RevenueByMonth;
import models.TopSellingFlower;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportDAO extends DBContext {

    public ReportSummary getReportSummary() {
        ReportSummary summary = new ReportSummary();
        
        String sqlRevenueToday = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE CONVERT(date, OrderDate) = CONVERT(date, GETDATE()) AND Status != N'Đã hủy'";
        String sqlRevenueMonth = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Orders WHERE MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE()) AND Status != N'Đã hủy'";
        String sqlTotalOrders = "SELECT COUNT(*) FROM Orders";
        String sqlTotalCustomers = "SELECT COUNT(*) FROM Accounts WHERE Role = 'customer'";

        try {
            // Revenue Today
            PreparedStatement st1 = connection.prepareStatement(sqlRevenueToday);
            ResultSet rs1 = st1.executeQuery();
            if (rs1.next()) {
                summary.setRevenueToday(rs1.getDouble(1));
            }

            // Revenue This Month
            PreparedStatement st2 = connection.prepareStatement(sqlRevenueMonth);
            ResultSet rs2 = st2.executeQuery();
            if (rs2.next()) {
                summary.setRevenueThisMonth(rs2.getDouble(1));
            }

            // Total Orders
            PreparedStatement st3 = connection.prepareStatement(sqlTotalOrders);
            ResultSet rs3 = st3.executeQuery();
            if (rs3.next()) {
                summary.setTotalOrders(rs3.getInt(1));
            }

            // Total Customers
            PreparedStatement st4 = connection.prepareStatement(sqlTotalCustomers);
            ResultSet rs4 = st4.executeQuery();
            if (rs4.next()) {
                summary.setTotalCustomers(rs4.getInt(1));
            }

        } catch (SQLException e) {
            System.out.println("Error getReportSummary: " + e.getMessage());
        }

        return summary;
    }

    public List<RevenueByMonth> getRevenueByMonth(int year) {
        List<RevenueByMonth> list = new ArrayList<>();
        // Khởi tạo 12 tháng
        for (int i = 1; i <= 12; i++) {
            list.add(new RevenueByMonth(i, 0));
        }

        String sql = "SELECT MONTH(OrderDate) as Month, ISNULL(SUM(TotalAmount), 0) as TotalRevenue " +
                     "FROM Orders " +
                     "WHERE YEAR(OrderDate) = ? AND Status != N'Đã hủy' " +
                     "GROUP BY MONTH(OrderDate)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int m = rs.getInt("Month");
                double rev = rs.getDouble("TotalRevenue");
                // Cập nhật lại giá trị trong danh sách
                if (m >= 1 && m <= 12) {
                    list.get(m - 1).setTotalRevenue(rev);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getRevenueByMonth: " + e.getMessage());
        }

        return list;
    }

    public List<TopSellingFlower> getTopSellingFlowers(int limit) {
        List<TopSellingFlower> list = new ArrayList<>();
        String sql = "SELECT TOP (?) f.FlowerId, f.FlowerName, ISNULL(SUM(od.Quantity), 0) as TotalQuantity " +
                     "FROM Flowers f " +
                     "JOIN OrderDetails od ON f.FlowerId = od.FlowerId " +
                     "JOIN Orders o ON o.OrderId = od.OrderId " +
                     "WHERE o.Status != N'Đã hủy' " +
                     "GROUP BY f.FlowerId, f.FlowerName " +
                     "ORDER BY TotalQuantity DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new TopSellingFlower(
                    rs.getInt("FlowerId"),
                    rs.getString("FlowerName"),
                    rs.getInt("TotalQuantity")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error getTopSellingFlowers: " + e.getMessage());
        }
        return list;
    }
}
