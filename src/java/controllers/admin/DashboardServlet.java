package controllers.admin;

import dal.ReportDAO;
import models.ReportSummary;
import models.RevenueByMonth;
import models.TopSellingFlower;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ReportDAO reportDAO = new ReportDAO();
        ReportSummary summary = reportDAO.getReportSummary();
        
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        try {
            String yearParam = request.getParameter("year");
            if (yearParam != null && !yearParam.isEmpty()) {
                currentYear = Integer.parseInt(yearParam);
            }
        } catch (NumberFormatException e) {
        }
        
        List<RevenueByMonth> revenueData = reportDAO.getRevenueByMonth(currentYear);
        List<TopSellingFlower> topFlowers = reportDAO.getTopSellingFlowers(5);
        reportDAO.close();

        request.setAttribute("summary", summary);
        request.setAttribute("revenueData", revenueData);
        request.setAttribute("topFlowers", topFlowers);
        request.setAttribute("selectedYear", currentYear);
        
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
