package dal;

import models.ActivityLog;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO extends DBContext {

    public void insertLog(ActivityLog log) {
        String sql = "INSERT INTO ActivityLogs (AccountId, Username, ActionType, Description, IpAddress, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            if (log.getAccountId() != null) {
                st.setInt(1, log.getAccountId());
            } else {
                st.setNull(1, java.sql.Types.INTEGER);
            }
            
            if (log.getUsername() != null) {
                st.setString(2, log.getUsername());
            } else {
                st.setNull(2, java.sql.Types.NVARCHAR);
            }
            
            st.setString(3, log.getActionType());
            st.setString(4, log.getDescription());
            
            if (log.getIpAddress() != null) {
                st.setString(5, log.getIpAddress());
            } else {
                st.setNull(5, java.sql.Types.VARCHAR);
            }
            
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error inserting log: " + e.getMessage());
        }
    }

    public int countLogs(String actionType, String username, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ActivityLogs WHERE 1=1 ");
        
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND ActionType = ? ");
        }
        if (username != null && !username.isEmpty()) {
            sql.append(" AND Username LIKE ? ");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND CAST(CreatedAt AS DATE) <= ? ");
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (actionType != null && !actionType.isEmpty()) {
                st.setString(paramIndex++, actionType);
            }
            if (username != null && !username.isEmpty()) {
                st.setString(paramIndex++, "%" + username + "%");
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                st.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                st.setString(paramIndex++, toDate);
            }
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting logs: " + e.getMessage());
        }
        return 0;
    }

    public List<ActivityLog> searchLogsPaging(String actionType, String username, String fromDate, String toDate, int page, int pageSize) {
        List<ActivityLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM ActivityLogs WHERE 1=1 "
        );
        
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND ActionType = ? ");
        }
        if (username != null && !username.isEmpty()) {
            sql.append(" AND Username LIKE ? ");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND CAST(CreatedAt AS DATE) <= ? ");
        }
        
        sql.append(" ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (actionType != null && !actionType.isEmpty()) {
                st.setString(paramIndex++, actionType);
            }
            if (username != null && !username.isEmpty()) {
                st.setString(paramIndex++, "%" + username + "%");
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                st.setString(paramIndex++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                st.setString(paramIndex++, toDate);
            }
            
            st.setInt(paramIndex++, (page - 1) * pageSize);
            st.setInt(paramIndex++, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("LogId"));
                
                int accountId = rs.getInt("AccountId");
                if (!rs.wasNull()) {
                    log.setAccountId(accountId);
                }
                
                log.setUsername(rs.getString("Username"));
                log.setActionType(rs.getString("ActionType"));
                log.setDescription(rs.getString("Description"));
                log.setIpAddress(rs.getString("IpAddress"));
                log.setCreatedAt(rs.getTimestamp("CreatedAt"));
                
                list.add(log);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching logs: " + e.getMessage());
        }
        return list;
    }
}
