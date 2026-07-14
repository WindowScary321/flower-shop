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

@WebServlet(name = "AccountServlet", urlPatterns = {"/admin/manage-accounts"})
public class AccountServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "toggleStatus":
                toggleStatus(request, response);
                break;
            default:
                listAccounts(request, response);
                break;
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
        
        if (accountDAO.checkUsernameExists(username)) {
            request.getSession().setAttribute("errorMsg", "Tên đăng nhập đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
            return;
        }
        
        if (accountDAO.checkEmailExists(email)) {
            request.getSession().setAttribute("errorMsg", "Email đã tồn tại!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
            return;
        }

        // Tạo tài khoản (mặc định cho Password là 'password123' rồi hash)
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
        request.getSession().setAttribute("successMsg", "Thêm tài khoản thành công! Mật khẩu mặc định là: password123");
        response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
    }

    private void listAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Account> accounts = accountDAO.getAllAccounts();
        request.setAttribute("accounts", accounts);
        request.getRequestDispatcher("/admin/manage-accounts.jsp").forward(request, response);
    }

    private void toggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Account currentAcc = accountDAO.getAccountById(id);
            if (currentAcc != null) {
                // Prevent admin from banning themselves
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
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-accounts");
    }
}
