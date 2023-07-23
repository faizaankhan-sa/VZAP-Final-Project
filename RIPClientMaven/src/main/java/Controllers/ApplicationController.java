/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Application;
import Models.Reader;
import ServiceLayers.ApplicationService_Impl;
import ServiceLayers.ApplicationService_Interface;
import ServiceLayers.MailService_Impl;
import ServiceLayers.MailService_Interface;
import ServiceLayers.WriterService_Impl;
import ServiceLayers.WriterService_Interface;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Jarrod
 */
@WebServlet(name = "ApplicationController", urlPatterns = {"/ApplicationController"})
public class ApplicationController extends HttpServlet {

    private ApplicationService_Interface applicationService;
    private WriterService_Interface writerService;
    private MailService_Interface mailService;
    private Application application;
    private Reader reader;
    private Integer readerId;

    public ApplicationController() {
        this.applicationService = new ApplicationService_Impl();
        this.writerService = new WriterService_Impl();
        this.mailService = new MailService_Impl();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getParameter("submit")) {
            case "getWriterApplications":
                request.setAttribute("applications", applicationService.getApplications());
                request.getRequestDispatcher("ApproveWriterPage.jsp").forward(request, response);
                break;
            case "approveApplications":
                List<Integer> accountIds = new ArrayList<>();
                String[] readerIdsStrings = request.getParameterValues("readerIds");
                String message = "No applications have been selected.";
                if (readerIdsStrings != null) {
                    for (String idString : readerIdsStrings) {
                        accountIds.add(Integer.valueOf(idString));
                    }
                    message = writerService.addWriters(accountIds) + "<br>" + applicationService.deleteApplications(accountIds) + "<br>" + mailService.notifyApprovedWriters(accountIds, Boolean.TRUE);

                }
                request.setAttribute("message", message);
                request.setAttribute("applications", applicationService.getApplications());
                request.getRequestDispatcher("ApproveWriterPage.jsp").forward(request, response);
                break;
            case "rejectApplications":
                accountIds = new ArrayList<>();
                readerIdsStrings = request.getParameterValues("readerIds");
                message = "No applications have been selected.";
                if (readerIdsStrings != null) {
                    for (String idString : readerIdsStrings) {
                        accountIds.add(Integer.valueOf(idString));
                    }
                    message = writerService.addWriters(accountIds) + "<br>" + applicationService.deleteApplications(accountIds) + "<br>" + mailService.notifyApprovedWriters(accountIds, Boolean.TRUE);

                }request.setAttribute("message", message);
                request.setAttribute("applications", applicationService.getApplications());
                request.getRequestDispatcher("ApproveWriterPage.jsp").forward(request, response);
                break;
            case "applyForWriter":
                reader = (Reader) request.getSession(false).getAttribute("user");
                String motivation = request.getParameter("motivation");
                application = new Application();
                application.setMotivation(motivation);
                application.setReaderId(reader.getId());
                application.setReaderName(reader.getName());
                application.setReaderSurname(reader.getSurname());
                request.setAttribute("message", applicationService.addApplication(application));
                request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
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
