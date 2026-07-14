package dal;

import models.OrderDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDetailDAO extends DBContext {

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        // JOIN với Flowers để lấy thêm tên hoa và đơn vị tính phục vụ hiển thị
        String sql = "SELECT od.*, f.FlowerName, f.Unit, f.Image " +
                     "FROM OrderDetails od " +
                     "JOIN Flowers f ON od.FlowerId = f.FlowerId " +
                     "WHERE od.OrderId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                OrderDetail od = new OrderDetail();
                od.setOrderDetailId(rs.getInt("OrderDetailId"));
                od.setOrderId(rs.getInt("OrderId"));
                od.setFlowerId(rs.getInt("FlowerId"));
                od.setQuantity(rs.getInt("Quantity"));
                od.setUnitPrice(rs.getDouble("UnitPrice"));
                // Extra fields for display (use transient setters pattern or map directly in JSP via request)
                // Stored as attributes on request in servlet
                list.add(od);
            }
        } catch (SQLException e) {
            System.out.println("Error getOrderDetailsByOrderId: " + e.getMessage());
        }
        return list;
    }
}
