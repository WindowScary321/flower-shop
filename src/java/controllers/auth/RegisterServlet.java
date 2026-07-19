package controllers.auth;

import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Account;
import utils.PasswordHasher;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");
        
        // Return values to form if error
        request.setAttribute("username", username);
        request.setAttribute("fullname", fullname);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        
        if (username == null || username.trim().isEmpty()
                || fullname == null || fullname.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || confirm == null || confirm.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ tất cả các trường bắt buộc.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            request.setAttribute("error", "Email không đúng định dạng");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("0[0-9]{9,10}")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ (Bắt đầu bằng 0, độ dài 10-11 số)");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.matches("^(?=.*[a-zA-Z])(?=.*\\d).{8,}$")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ và số");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        AccountDAO dao = new AccountDAO();
        if (dao.checkUsernameExists(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        String hashedPassword = PasswordHasher.hash(password);
        Account newAccount = new Account(0, username, hashedPassword, fullname, email, phone, "customer", true);
        dao.insertAccount(newAccount);
        
        request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
