package dal;

import models.Account;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    public Account getAccountByUsernameAndPassword(String username, String hashedPassword) {
        String sql = "SELECT * FROM Accounts WHERE Username = ? AND Password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setString(2, hashedPassword);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("AccountId"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Role"),
                    rs.getBoolean("Status")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean checkUsernameExists(String username) {
        String sql = "SELECT 1 FROM Accounts WHERE Username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM Accounts WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public void insertAccount(Account account) {
        String sql = "INSERT INTO Accounts (Username, Password, FullName, Email, Phone, Address, Role, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, account.getUsername());
            st.setString(2, account.getPassword());
            st.setString(3, account.getFullName());
            st.setString(4, account.getEmail());
            st.setString(5, account.getPhone());
            st.setString(6, account.getAddress());
            st.setString(7, account.getRole());
            st.setBoolean(8, account.isStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Accounts";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Account(
                    rs.getInt("AccountId"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Role"),
                    rs.getBoolean("Status")
                ));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Account getAccountById(int id) {
        String sql = "SELECT * FROM Accounts WHERE AccountId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("AccountId"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Role"),
                    rs.getBoolean("Status")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void updateAccountStatus(int id, boolean status) {
        String sql = "UPDATE Accounts SET Status = ? WHERE AccountId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, status);
            st.setInt(2, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public int countAccounts(String keyword, String role, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Accounts WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Username LIKE ? OR FullName LIKE ? OR Email LIKE ? OR Phone LIKE ?)");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND Role = ?");
            params.add(role.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add("1".equals(status));
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
            System.out.println("Error countAccounts: " + e.getMessage());
        }
        return 0;
    }

    public List<Account> searchAccountsPaging(String keyword, String role, String status, int page, int pageSize) {
        List<Account> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Accounts WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Username LIKE ? OR FullName LIKE ? OR Email LIKE ? OR Phone LIKE ?)");
            String k = "%" + keyword.trim() + "%";
            params.add(k);
            params.add(k);
            params.add(k);
            params.add(k);
        }
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND Role = ?");
            params.add(role.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND Status = ?");
            params.add("1".equals(status));
        }
        
        sql.append(" ORDER BY AccountId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Account(
                    rs.getInt("AccountId"),
                    rs.getString("Username"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    rs.getString("Role"),
                    rs.getBoolean("Status")
                ));
            }
        } catch (SQLException e) {
            System.out.println("Error searchAccountsPaging: " + e.getMessage());
        }
        return list;
    }

    public void updateProfile(int accountId, String fullName, String email, String phone, String address) {
        String sql = "UPDATE Accounts SET FullName = ?, Email = ?, Phone = ?, Address = ? WHERE AccountId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, fullName);
            st.setString(2, email);
            st.setString(3, phone);
            st.setString(4, address);
            st.setInt(5, accountId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updateProfile: " + e.getMessage());
        }
    }

    public void updatePassword(int accountId, String password) {
        String sql = "UPDATE Accounts SET Password = ? WHERE AccountId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, password);
            st.setInt(2, accountId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updatePassword: " + e.getMessage());
        }
    }

    public boolean checkEmailExistsExcept(String email, int accountId) {
        String sql = "SELECT 1 FROM Accounts WHERE Email = ? AND AccountId != ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setInt(2, accountId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }
}
