package controllers;

import models.Account;
import dal.AccountDAO;
import utils.PasswordHasher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/customer/profile", "/employee/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        AccountDAO accountDAO = new AccountDAO();
        String error = null;
        String success = null;

        if ("updateInfo".equals(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String currentPassword = request.getParameter("currentPassword");

            if (fullName == null || fullName.trim().isEmpty()) {
                error = "Họ và tên không được để trống";
            } else if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                error = "Email không hợp lệ";
            } else if (phone == null || !phone.matches("^0\\d{9,10}$")) {
                error = "Số điện thoại phải bắt đầu bằng 0 và có 10 hoặc 11 chữ số";
            }

            if (error == null) {
                if (accountDAO.checkEmailExistsExcept(email, user.getAccountId())) {
                    error = "Email này đã được sử dụng bởi tài khoản khác";
                }
            }

            if (error == null) {
                boolean isNameChanged = !fullName.trim().equals(user.getFullName());
                boolean isEmailChanged = !email.trim().equals(user.getEmail());
                if (isNameChanged || isEmailChanged) {
                    if (currentPassword == null || currentPassword.isEmpty()) {
                        error = "Bạn phải nhập mật khẩu xác nhận để thay đổi Họ tên hoặc Email";
                    } else {
                        String hashedInputPass = PasswordHasher.hash(currentPassword);
                        if (!hashedInputPass.equals(user.getPassword())) {
                            error = "Mật khẩu xác nhận không chính xác";
                        }
                    }
                }
            }

            if (error == null) {
                accountDAO.updateProfile(user.getAccountId(), fullName.trim(), email.trim(), phone.trim(), address != null ? address.trim() : "");
                user.setFullName(fullName.trim());
                user.setEmail(email.trim());
                user.setPhone(phone.trim());
                user.setAddress(address != null ? address.trim() : "");
                session.setAttribute("user", user);
                success = "Cập nhật thông tin cá nhân thành công";
            }

        } else if ("changePassword".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || oldPassword.isEmpty()) {
                error = "Vui lòng nhập mật khẩu cũ";
            } else if (newPassword == null || newPassword.length() < 6) {
                error = "Mật khẩu mới phải có ít nhất 6 ký tự";
            } else if (!newPassword.equals(confirmPassword)) {
                error = "Xác nhận mật khẩu mới không khớp";
            }

            if (error == null) {
                String hashedOld = PasswordHasher.hash(oldPassword);
                if (!hashedOld.equals(user.getPassword())) {
                    error = "Mật khẩu cũ không chính xác";
                }
            }

            if (error == null) {
                String hashedNew = PasswordHasher.hash(newPassword);
                accountDAO.updatePassword(user.getAccountId(), hashedNew);
                user.setPassword(hashedNew);
                session.setAttribute("user", user);
                success = "Đổi mật khẩu thành công";
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
        }
        if (success != null) {
            request.setAttribute("success", success);
        }
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}
