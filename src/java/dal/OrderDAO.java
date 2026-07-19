package dal;

import models.Order;
import models.OrderDetail;
import models.CartItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    /**
     * Tạo đơn hàng mới với Transaction để đảm bảo tính toàn vẹn.
     * Bước 1: Trừ tồn kho (Flowers.Quantity).
     * Bước 2: INSERT vào Orders.
     * Bước 3: INSERT vào OrderDetails.
     * Nếu bất kỳ bước nào lỗi, toàn bộ thao tác bị ROLLBACK.
     */
    public int createOrder(Order order, List<CartItem> cartItems) {
        int orderId = -1;
        try {
            connection.setAutoCommit(false);

            // Bước 1: Kiểm tra & trừ tồn kho
            String decreaseStock = "UPDATE Flowers SET Quantity = Quantity - ? WHERE FlowerId = ? AND Quantity >= ?";
            for (CartItem item : cartItems) {
                PreparedStatement st = connection.prepareStatement(decreaseStock);
                st.setInt(1, item.getQuantity());
                st.setInt(2, item.getFlower().getFlowerId());
                st.setInt(3, item.getQuantity());
                int rowsAffected = st.executeUpdate();
                if (rowsAffected == 0) {
                    // Không đủ hàng -> Rollback
                    connection.rollback();
                    connection.setAutoCommit(true);
                    return -2; // -2 = hết hàng
                }
            }

            // Bước 2: Tạo đơn hàng
            String insertOrder = "INSERT INTO Orders (TotalAmount, ReceiverName, ReceiverAddress, ReceiverPhone, Status, AccountId, PaymentMethod, PaymentStatus) VALUES (?, ?, ?, ?, N'\u0043\u0068\u1EDD\u0020\u0078\u1EED\u0020\u006C\u00FD', ?, ?, 0)";
            PreparedStatement stOrder = connection.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS);
            stOrder.setDouble(1, order.getTotalAmount());
            stOrder.setString(2, order.getReceiverName());
            stOrder.setString(3, order.getReceiverAddress());
            stOrder.setString(4, order.getReceiverPhone());
            stOrder.setInt(5, order.getAccountId());
            stOrder.setString(6, order.getPaymentMethod() != null ? order.getPaymentMethod() : "COD");
            stOrder.executeUpdate();

            ResultSet rs = stOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            // Bước 3: Thêm từng mục chi tiết đơn hàng
            String insertDetail = "INSERT INTO OrderDetails (OrderId, FlowerId, Quantity, UnitPrice) VALUES (?, ?, ?, ?)";
            PreparedStatement stDetail = connection.prepareStatement(insertDetail);
            for (CartItem item : cartItems) {
                stDetail.setInt(1, orderId);
                stDetail.setInt(2, item.getFlower().getFlowerId());
                stDetail.setInt(3, item.getQuantity());
                stDetail.setDouble(4, item.getFlower().getPrice());
                stDetail.addBatch();
            }
            stDetail.executeBatch();

            connection.commit();
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { System.out.println(ex); }
            System.out.println("Error createOrder: " + e.getMessage());
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { System.out.println(e); }
        }
        return orderId;
    }

    public List<Order> getOrdersByAccountId(int accountId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE AccountId = ? ORDER BY OrderDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, accountId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getOrdersByAccountId: " + e.getMessage());
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders ORDER BY OrderDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllOrders: " + e.getMessage());
        }
        return list;
    }

    public Order getOrderById(int id) {
        String sql = "SELECT * FROM Orders WHERE OrderId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return extractOrder(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getOrderById: " + e.getMessage());
        }
        return null;
    }

    public void updateOrderStatusAndDeliveryTime(int orderId, String newStatus, Timestamp deliveryTime) {
        String sql = "UPDATE Orders SET Status = ?, DeliveryTime = ? WHERE OrderId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setTimestamp(2, deliveryTime);
            st.setInt(3, orderId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updateOrderStatusAndDeliveryTime: " + e.getMessage());
        }
    }

    public void updatePaymentStatus(int orderId, boolean paymentStatus) {
        String sql = "UPDATE Orders SET PaymentStatus = ? WHERE OrderId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, paymentStatus);
            st.setInt(2, orderId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updatePaymentStatus: " + e.getMessage());
        }
    }

    /**
     * Hủy đơn hàng: Chỉ cho phép hủy khi đang ở trạng thái "Chờ xử lý".
     * Đồng thời hoàn lại số lượng hàng tồn kho.
     */
    public boolean cancelOrder(int orderId, int accountId) {
        try {
            // Verify order belongs to the account and is cancellable
            String checkSql = "SELECT * FROM Orders WHERE OrderId = ? AND AccountId = ? AND Status = N'\u0043\u0068\u1EDD\u0020\u0078\u1EED\u0020\u006C\u00FD'";
            PreparedStatement stCheck = connection.prepareStatement(checkSql);
            stCheck.setInt(1, orderId);
            stCheck.setInt(2, accountId);
            ResultSet rs = stCheck.executeQuery();
            if (!rs.next()) {
                return false;
            }

            connection.setAutoCommit(false);

            // Hoàn lại tồn kho
            String restoreStock = "UPDATE Flowers SET Quantity = Quantity + od.Quantity FROM Flowers f JOIN OrderDetails od ON f.FlowerId = od.FlowerId WHERE od.OrderId = ?";
            PreparedStatement stRestore = connection.prepareStatement(restoreStock);
            stRestore.setInt(1, orderId);
            stRestore.executeUpdate();

            // Cập nhật trạng thái đơn hàng
            String cancelSql = "UPDATE Orders SET Status = N'\u0110\u00E3\u0020\u0068\u1EE7\u0079' WHERE OrderId = ?";
            PreparedStatement stCancel = connection.prepareStatement(cancelSql);
            stCancel.setInt(1, orderId);
            stCancel.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { System.out.println(ex); }
            System.out.println("Error cancelOrder: " + e.getMessage());
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { System.out.println(e); }
        }
        return false;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("OrderId"));
        o.setOrderDate(rs.getTimestamp("OrderDate"));
        o.setTotalAmount(rs.getDouble("TotalAmount"));
        o.setReceiverName(rs.getString("ReceiverName"));
        o.setReceiverAddress(rs.getString("ReceiverAddress"));
        o.setReceiverPhone(rs.getString("ReceiverPhone"));
        o.setStatus(rs.getString("Status"));
        o.setAccountId(rs.getInt("AccountId"));
        o.setPaymentMethod(rs.getString("PaymentMethod"));
        o.setPaymentStatus(rs.getBoolean("PaymentStatus"));
        o.setDeliveryTime(rs.getTimestamp("DeliveryTime"));
        return o;
    }

    public int countOrders(int accountId, String status, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Orders WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (accountId > 0) {
            sql.append(" AND AccountId = ?");
            params.add(accountId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND OrderDate >= ?");
            params.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND OrderDate <= ?");
            params.add(toDate + " 23:59:59");
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error countOrders: " + e.getMessage());
        }
        return 0;
    }

    public List<Order> searchOrdersPaging(int accountId, String status, String fromDate, String toDate, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Orders WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (accountId > 0) {
            sql.append(" AND AccountId = ?");
            params.add(accountId);
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add(status.trim());
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND OrderDate >= ?");
            params.add(fromDate + " 00:00:00");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND OrderDate <= ?");
            params.add(toDate + " 23:59:59");
        }
        
        sql.append(" ORDER BY OrderDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractOrder(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searchOrdersPaging: " + e.getMessage());
        }
        return list;
    }
}
