package controllers.employee;

import dal.OrderDAO;
import models.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EmployeeManageOrderServlet", urlPatterns = {"/employee/manage-orders"})
public class ManageOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        int totalRecords = orderDAO.countOrders(0, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Order> orders = orderDAO.searchOrdersPaging(0, status, fromDate, toDate, page, pageSize);
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status != null ? status : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

        request.getRequestDispatcher("/employee/manage-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("newStatus");
                // Employee chỉ được đặt trạng thái giao hàng
                if (newStatus != null && (newStatus.equals("Đang giao") || newStatus.equals("Đã giao"))) {
                    orderDAO.updateOrderStatus(orderId, newStatus);
                    request.getSession().setAttribute("successMsg", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công.");
                } else {
                    request.getSession().setAttribute("errorMsg", "Nhân viên không có quyền đặt trạng thái này.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "ID đơn hàng không hợp lệ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/employee/manage-orders");
    }
}
