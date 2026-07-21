package models;

import java.sql.Timestamp;

public class ActivityLog {
    private int logId;
    private Integer accountId;
    private String username;
    private String actionType;
    private String description;
    private String ipAddress;
    private Timestamp createdAt;

    public ActivityLog() {
    }

    public ActivityLog(int logId, Integer accountId, String username, String actionType, String description, String ipAddress, Timestamp createdAt) {
        this.logId = logId;
        this.accountId = accountId;
        this.username = username;
        this.actionType = actionType;
        this.description = description;
        this.ipAddress = ipAddress;
        this.createdAt = createdAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public Integer getAccountId() {
        return accountId;
    }

    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
