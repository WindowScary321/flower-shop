package controllers.admin;

import dal.AccountDAO;
import models.Account;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageAccountServlet", urlPatterns = {"/admin/manage-accounts"})
public class ManageAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "toggleStatus": toggleStatus(request, response); break;
            default: listAccounts(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addAccount(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
        }
    }

    private void addAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        AccountDAO accountDAO = new AccountDAO();
        if (accountDAO.checkUsernameExists(username)) {
            accountDAO.close();
            request.getSession().setAttribute("errorMsg", "Tên đăng nhập đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
            return;
        }

        if (accountDAO.checkEmailExists(email)) {
            accountDAO.close();
            request.getSession().setAttribute("errorMsg", "Email đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
            return;
        }

        String defaultHashedPassword = utils.PasswordHasher.hash("password123");

        Account a = new Account();
        a.setUsername(username);
        a.setPassword(defaultHashedPassword);
        a.setFullName(request.getParameter("fullName"));
        a.setEmail(email);
        a.setPhone(request.getParameter("phone"));
        a.setRole(request.getParameter("role"));
        a.setStatus(true);

        accountDAO.insertAccount(a);
        accountDAO.close();
        request.getSession().setAttribute("successMsg", "Thêm tài khoản thành công! Mật khẩu mặc định là: password123");
        response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

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

        AccountDAO accountDAO = new AccountDAO();
        int totalRecords = accountDAO.countAccounts(keyword, role, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Account> accounts = accountDAO.searchAccountsPaging(keyword, role, status, page, pageSize);
        accountDAO.close();
        
        request.setAttribute("accounts", accounts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("role", role != null ? role : "");
        request.setAttribute("status", status != null ? status : "");

        request.getRequestDispatcher("/admin/manage-accounts.jsp").forward(request, response);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            AccountDAO accountDAO = new AccountDAO();
            Account currentAcc = accountDAO.getAccountById(id);
            if (currentAcc != null) {
                Account loggedInAdmin = (Account) request.getSession().getAttribute("user");
                if (loggedInAdmin != null && loggedInAdmin.getAccountId() == id) {
                    request.getSession().setAttribute("errorMsg", "Không thể tự khóa tài khoản của chính mình!");
                } else {
                    boolean newStatus = !currentAcc.isStatus();
                    accountDAO.updateAccountStatus(id, newStatus);
                    request.getSession().setAttribute("successMsg",
                        newStatus ? "Đã mở khóa tài khoản thành công!" : "Đã khóa tài khoản thành công!");
                }
            }
            accountDAO.close();
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
    }
}
