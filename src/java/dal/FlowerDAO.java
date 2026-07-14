package dal;

import models.Flower;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FlowerDAO extends DBContext {

    public List<Flower> getAllFlowers() {
        List<Flower> list = new ArrayList<>();
        String sql = "SELECT * FROM Flowers ORDER BY FlowerId DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractFlower(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getAllFlowers: " + e.getMessage());
        }
        return list;
    }
    
    public List<Flower> getActiveFlowers() {
        List<Flower> list = new ArrayList<>();
        String sql = "SELECT * FROM Flowers WHERE Status = 1 ORDER BY FlowerId DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractFlower(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveFlowers: " + e.getMessage());
        }
        return list;
    }

    public Flower getFlowerById(int id) {
        String sql = "SELECT * FROM Flowers WHERE FlowerId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return extractFlower(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getFlowerById: " + e.getMessage());
        }
        return null;
    }

    public void insertFlower(Flower f) {
        String sql = "INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, f.getFlowerName());
            st.setString(2, f.getUnit());
            st.setDouble(3, f.getPrice());
            st.setInt(4, f.getQuantity());
            st.setString(5, f.getImage());
            st.setString(6, f.getDescription());
            st.setInt(7, f.getCategoryId());
            st.setBoolean(8, f.isStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error insertFlower: " + e.getMessage());
        }
    }

    public void updateFlower(Flower f) {
        String sql = "UPDATE Flowers SET FlowerName=?, Unit=?, Price=?, Quantity=?, Image=?, Description=?, CategoryId=?, Status=? WHERE FlowerId=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, f.getFlowerName());
            st.setString(2, f.getUnit());
            st.setDouble(3, f.getPrice());
            st.setInt(4, f.getQuantity());
            st.setString(5, f.getImage());
            st.setString(6, f.getDescription());
            st.setInt(7, f.getCategoryId());
            st.setBoolean(8, f.isStatus());
            st.setInt(9, f.getFlowerId());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updateFlower: " + e.getMessage());
        }
    }

    public void deleteFlower(int id) {
        String sql = "DELETE FROM Flowers WHERE FlowerId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deleteFlower: " + e.getMessage());
        }
    }

    private Flower extractFlower(ResultSet rs) throws SQLException {
        Flower f = new Flower();
        f.setFlowerId(rs.getInt("FlowerId"));
        f.setFlowerName(rs.getString("FlowerName"));
        f.setUnit(rs.getString("Unit"));
        f.setPrice(rs.getDouble("Price"));
        f.setQuantity(rs.getInt("Quantity"));
        f.setImage(rs.getString("Image"));
        f.setDescription(rs.getString("Description"));
        f.setCategoryId(rs.getInt("CategoryId"));
        f.setStatus(rs.getBoolean("Status"));
        return f;
    }

    public List<Flower> searchFlowers(String keyword) {
        List<Flower> list = new ArrayList<>();
        String sql = "SELECT * FROM Flowers WHERE Status = 1 AND FlowerName LIKE ? ORDER BY FlowerId DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractFlower(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searchFlowers: " + e.getMessage());
        }
        return list;
    }

    public List<Flower> getFlowersByCategoryId(int categoryId) {
        List<Flower> list = new ArrayList<>();
        String sql = "SELECT * FROM Flowers WHERE Status = 1 AND CategoryId = ? ORDER BY FlowerId DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractFlower(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getFlowersByCategoryId: " + e.getMessage());
        }
        return list;
    }

    public int countFlowers(String keyword, int categoryId, double minPrice, double maxPrice, boolean statusOnly) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Flowers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (statusOnly) {
            sql.append(" AND Status = 1");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND FlowerName LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId > 0) {
            sql.append(" AND CategoryId = ?");
            params.add(categoryId);
        }
        if (minPrice > 0) {
            sql.append(" AND Price >= ?");
            params.add(minPrice);
        }
        if (maxPrice > 0 && maxPrice >= minPrice) {
            sql.append(" AND Price <= ?");
            params.add(maxPrice);
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
            System.out.println("Error countFlowers: " + e.getMessage());
        }
        return 0;
    }

    public List<Flower> searchFlowersPaging(String keyword, int categoryId, double minPrice, double maxPrice, boolean statusOnly, int page, int pageSize) {
        List<Flower> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Flowers WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (statusOnly) {
            sql.append(" AND Status = 1");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND FlowerName LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId > 0) {
            sql.append(" AND CategoryId = ?");
            params.add(categoryId);
        }
        if (minPrice > 0) {
            sql.append(" AND Price >= ?");
            params.add(minPrice);
        }
        if (maxPrice > 0 && maxPrice >= minPrice) {
            sql.append(" AND Price <= ?");
            params.add(maxPrice);
        }
        
        sql.append(" ORDER BY FlowerId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(extractFlower(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error searchFlowersPaging: " + e.getMessage());
        }
        return list;
    }
}

