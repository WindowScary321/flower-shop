package controllers.admin;

import dal.ActivityLogDAO;
import models.ActivityLog;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminActivityLogServlet", urlPatterns = {"/admin/activity-logs"})
public class AdminActivityLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String actionType = request.getParameter("actionType");
        String username = request.getParameter("username");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 20;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        ActivityLogDAO dao = new ActivityLogDAO();
        int totalRecords = dao.countLogs(actionType, username, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<ActivityLog> logs = dao.searchLogsPaging(actionType, username, fromDate, toDate, page, pageSize);
        dao.close();
        
        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("actionType", actionType != null ? actionType : "");
        request.setAttribute("username", username != null ? username : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

        request.getRequestDispatcher("/admin/activity-logs.jsp").forward(request, response);
    }
}
