/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Genre;
import Models.Writer;
import ServiceLayers.MailService_Impl;
import ServiceLayers.MailService_Interface;
import ServiceLayers.WriterService_Impl;
import ServiceLayers.WriterService_Interface;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author jarro
 */
@WebServlet(name = "WriterController", urlPatterns = {"/WriterController"})
public class WriterController extends HttpServlet {
    private final Integer WRITER_AMOUNT = 10;
    private MailService_Interface mailService;
    private WriterService_Interface writerService;
    private Integer writerId;
    private Writer writer;
    private String message;

    public WriterController() {
        this.writerService = new WriterService_Impl();
        this.mailService = new MailService_Impl();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getParameter("submit")) {
            case "goToBlockWriterPage":
                request.setAttribute("pageNumber", 0);
                request.setAttribute("writers", writerService.getWriters(WRITER_AMOUNT, 0));
                request.getRequestDispatcher("BlockWriters.jsp").forward(request, response);
                break;
            case "blockWriters":
                List<Integer> writerIds = new ArrayList<>();
                String[] writerIdStrings = request.getParameterValues("writerIds");
                for (String writerIdStr : writerIdStrings) {
                    writerIds.add(Integer.valueOf(writerIdStr));
                }
                if (writerIds.isEmpty()) {
                    message = "No writers were selected.";
                } else {
                    message = writerService.blockWriters(writerIds);
                    message += "<br>" + mailService.notifyBlockedWriters(writerIds);
                }
                request.setAttribute("pageNumber", 0);
                request.setAttribute("writers", writerService.getWriters(WRITER_AMOUNT, 0));
                request.setAttribute("message", message);
                request.getRequestDispatcher("BlockWriters.jsp").forward(request, response);
                break;
                
            case "searchForWriter":
                String searchValue = request.getParameter("searchValue");
                request.setAttribute("pageNumber", 0);
                request.setAttribute("searchValue", searchValue);
                request.setAttribute("writers", writerService.searchForWriters(searchValue, WRITER_AMOUNT, 0));
                request.getRequestDispatcher("BlockWriters.jsp").forward(request, response);
                break;
            case "nextPageOfWriters":
                Boolean nextValues = Boolean.valueOf(request.getParameter("next"));
                Integer currentId = Integer.valueOf(request.getParameter("currentId"));
                Integer pageNumber = Integer.valueOf(request.getParameter("pageNumber"));
                searchValue = request.getParameter("searchValue");
                List<Writer> writers;
                if (searchValue!=null) {
                    writers = writerService.searchForWriters(searchValue, WRITER_AMOUNT, pageNumber);
                    message = "Search results of \"" + searchValue + "\".";
                } else {
                    writers = writerService.getWriters(WRITER_AMOUNT, pageNumber);
                }
                request.setAttribute("pageNumber", pageNumber);
                request.setAttribute("searchValue", searchValue);
                request.setAttribute("writers", writers);
                request.getRequestDispatcher("BlockWriters.jsp").forward(request, response);
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
