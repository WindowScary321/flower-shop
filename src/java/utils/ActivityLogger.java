package utils;

import dal.ActivityLogDAO;
import models.Account;
import models.ActivityLog;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class ActivityLogger {

    public static void log(HttpServletRequest request, String actionType, String description) {
        log(request, actionType, description, null);
    }

    public static void log(HttpServletRequest request, String actionType, String description, String usernameFallback) {
        try {
            Integer accountId = null;
            String username = usernameFallback;

            HttpSession session = request.getSession(false);
            if (session != null) {
                Account user = (Account) session.getAttribute("user");
                if (user != null) {
                    accountId = user.getAccountId();
                    username = user.getUsername();
                }
            }

            String ipAddress = request.getHeader("X-Forwarded-For");
            if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
                ipAddress = request.getRemoteAddr();
            }
            if (ipAddress != null && ipAddress.length() > 45) {
                ipAddress = ipAddress.substring(0, 45); // Max length in DB
            }

            ActivityLog log = new ActivityLog();
            log.setAccountId(accountId);
            log.setUsername(username);
            log.setActionType(actionType);
            log.setDescription(description);
            log.setIpAddress(ipAddress);

            ActivityLogDAO dao = new ActivityLogDAO();
            dao.insertLog(log);
            dao.close();
            
        } catch (Exception e) {
            // Do not crash the application if logging fails
            System.err.println("Failed to log activity: " + actionType + " - " + e.getMessage());
        }
    }
}
