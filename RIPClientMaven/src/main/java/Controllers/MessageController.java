/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import ServiceLayers.MailService_Impl;
import ServiceLayers.MailService_Interface;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Jarrod
 */
@WebServlet(name = "MessageController", urlPatterns = {"/MessageController"})
public class MessageController extends HttpServlet {
    private MailService_Interface mailService;

    public MessageController() {
        this.mailService = new MailService_Impl();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getParameter("submit")) {
            case "sendVerificationEmail":
                request.setAttribute("message", mailService.sendMail(request.getParameter("email"), request.getParameter("content"), request.getParameter("subject")));
                request.getRequestDispatcher("TestEmail.jsp").forward(request, response);
                break;
            case "sendReferralEmail":
                request.setAttribute("message", mailService.sendReferralEmail(request.getParameter("email"), request.getParameter("name"), request.getParameter("phoneNumber")));
                request.getRequestDispatcher(request.getParameter("currentPage")).forward(request, response);
                break;
            case "sendForgotPasswordEmail" :
                request.setAttribute("message", mailService.sendChangePasswordEmail(request.getParameter("email")));
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
            default:
                throw new AssertionError();
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
