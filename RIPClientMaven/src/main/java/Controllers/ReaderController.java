/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.Account;
import Models.Reader;
import Models.Writer;
import ServiceLayers.ReaderService_Impl;
import ServiceLayers.ReaderService_Interface;
import ServiceLayers.WriterService_Impl;
import ServiceLayers.WriterService_Interface;
import Utils.PasswordEncryptor;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author 27713
 */
@WebServlet(name = "ReaderController", urlPatterns = {"/ReaderController"})
public class ReaderController extends HttpServlet {

    private ReaderService_Interface readerService;
    private WriterService_Interface writerService;
    private Reader reader;
    private HttpSession session;

    public ReaderController() {
        this.readerService = new ReaderService_Impl();
        this.writerService = new WriterService_Impl();
        this.reader = null;
        this.session = null;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        session = request.getSession(false);
        switch (request.getParameter("submit")) {
            case "updateReader":
                String message ="";
                reader = (Reader) session.getAttribute("user");
                String password = request.getParameter("password");
                String passwordRepeat = request.getParameter("passwordRepeat");
                if (!password.isEmpty() && !passwordRepeat.isEmpty() && !password.equals(passwordRepeat)) {
                    message = "Failed to update password: Passwords entered did not match.<br>";
                } else {
                    reader.setPasswordHash(PasswordEncryptor.hashPassword(password, reader.getSalt()));
                }
                reader.setEmail(request.getParameter("email"));
                reader.setName(request.getParameter("name"));
                reader.setSurname(request.getParameter("surname"));
                reader.setPhoneNumber(request.getParameter("phoneNumber"));
                session.setAttribute("user", (Account) reader);
                request.setAttribute("message", message + readerService.updateReaderDetails(reader));
                request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                break;
                
            case "updateFavouriteGenres":
                String[] selectedGenres = request.getParameterValues("selectedGenres");
                System.out.println(Arrays.toString(selectedGenres));
                if (session == null) {
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                } else if (selectedGenres != null) {
                    Account user = (Account) session.getAttribute("user");
                    List<Integer> genreIds = new ArrayList<>();
                    for (String genreId : selectedGenres) {
                        genreIds.add(Integer.valueOf(genreId));
                    }
                    if (user.getUserType().equals("R")) {
                        reader = readerService.getReader(user.getEmail());
                        reader.setFavouriteGenreIds(genreIds);
                        readerService.updateReaderDetails(reader);
                        session.setAttribute("user", reader);
                    } else {
                        Writer writer = writerService.getWriter(user.getId());
                        writer.setFavouriteGenreIds(genreIds);
                        session.setAttribute("user", writer);   
                    }
                    request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                }
                break;

            case "allowPasswordChangeOnLogin":
                System.out.println("Password change called.");
                String verifyToken = request.getParameter("verifyToken");
                Integer readerId = Integer.valueOf(request.getParameter("readerId"));
                String originalToken = readerService.getVerifyToken(readerId);
                reader = readerService.getReaderById(readerId);
                Boolean tokensMatch = false;
                if (verifyToken.equals(originalToken)) {
                    tokensMatch = true;
                }

                if (reader != null) {
                    request.setAttribute("email", reader.getEmail());
                    request.setAttribute("tokensMatch", tokensMatch);
                } else {
                    request.setAttribute("message", "Change password link failed.");
                }

                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;

            case "changePasswordForLogin":
                password = request.getParameter("password");
                String repeatPassword = request.getParameter("repeatPassword");
                String email = request.getParameter("email");
                reader = readerService.getReader(email);
                message = "";
                if (!password.equals(repeatPassword)) {
                    message = "The passwords you entered did not match. Please try again.";
                } else if(PasswordEncryptor.hashPassword(password, reader.getSalt()).equals(reader.getPasswordHash())) {
                    message = "Previous password entered. Please enter a new password.";
                } else {
                    reader.setPasswordHash(PasswordEncryptor.hashPassword(password, reader.getSalt()));
                    message = readerService.updateReaderDetails(reader);
                }
                request.setAttribute("message", message);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;

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
