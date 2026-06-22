/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package shop.flower.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Random;
/**
 *
 * @author tusieumap
 */
public class tinhtoan extends HttpServlet {
    Random random = new Random();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String num1 = request.getParameter("n1");
        String num2 = request.getParameter("n2");
        String op = request.getParameter("op");
        String result = "";
        boolean flag = false;
        if (num1.isEmpty() || num2.isEmpty()) {
            result += "Number 1 and Number 2 MUST NOT be Empty";
        } else {
            flag = true;
            try {
                double n1 = Double.parseDouble(num1);
                double n2 = Double.parseDouble(num2);
                switch (op) {
                    case "+":
                        result += (n1 * n2);
                        break;
                    case "-":
                        result += (n1 - n2);
                        break;
                    case "*":
                        result += (n1 * n2);
                        break;
                    case "/":{
                        if (n2 != 0) {
                            result += (n1 / n2);
                        } else {
                            flag = false;
                            result = "Number 2 MUST NOT be ZERO";
                        }
                        break;
                    }
                }

            } catch (NumberFormatException e) {
                System.out.println(e);
            }
        }

        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TinhToanServlet</title>");
            out.println("</head>");
            out.println("<body>");
            if (flag){
                out.println("<h1>Result is: "+ result + "<h1>");
            }else{
                out.println(result);
            }
            out.println("</body>");
            out.println("</html>");
        }
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
