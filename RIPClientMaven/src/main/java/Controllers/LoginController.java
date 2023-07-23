/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Models.*;
import ServiceLayers.GenreService_Impl;
import ServiceLayers.GenreService_Interface;
import ServiceLayers.LoginService_Impl;
import ServiceLayers.LoginService_Interface;
import ServiceLayers.MailService_Impl;
import ServiceLayers.MailService_Interface;
import ServiceLayers.ReaderService_Impl;
import ServiceLayers.ReaderService_Interface;
import ServiceLayers.SMSService_Impl;
import ServiceLayers.SMSService_Interface;
import Utils.PasswordEncryptor;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author jarro
 */
@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    private GenreService_Interface genreService;
    private LoginService_Interface loginService;
    private ReaderService_Interface readerService;
    private MailService_Interface mailService;
    private HttpSession session;

    public LoginController() {
        genreService = new GenreService_Impl();
        loginService = new LoginService_Impl();
        readerService = new ReaderService_Impl();
        mailService = new MailService_Impl();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        switch (request.getParameter("submit")) {
            case "login":
                session = request.getSession(true);
                Account user = new Reader();
                user.setEmail(request.getParameter("email"));
                user.setPasswordHash(request.getParameter("password"));
                HashMap<String, String> details = loginService.getUserSalt(user.getEmail());
                System.out.println(details);
                String message = "Login Credentials Invalid: password was incorrect.";
                if (Boolean.parseBoolean(details.get("userFound"))&&Boolean.parseBoolean(details.get("userVerified"))) {
                    switch (details.get("userType")) {
                        case "R":
                            Reader reader = new Reader();
                            reader.setSalt(details.get("salt"));
                            reader.setPasswordHash(request.getParameter("password"));
                            reader.setEmail(request.getParameter("email"));
                            reader = loginService.loginReader(reader);
                            if (reader != null) {
                                message = "Login successful.";
                                request.setAttribute("message", message);
                                session.setAttribute("user", reader);
                                session.setAttribute("genres", genreService.getAllGenres());
                                request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                            } else {
                                request.setAttribute("message", message);
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                            }
                            break;

                        case "W":
                            Writer writer = new Writer();
                            writer.setSalt(details.get("salt"));
                            writer.setPasswordHash(request.getParameter("password"));
                            writer.setEmail(request.getParameter("email"));
                            writer = loginService.loginWriter(writer);
                            if (writer != null) {
                                message = "Login successful.";
                                request.setAttribute("message", message);
                                session.setAttribute("user", writer);
                                session.setAttribute("genres", genreService.getAllGenres());
                                request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                            } else {
                                request.setAttribute("message", message);
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                            }
                            break;

                        case "E":
                            Editor editor = new Editor();
                            editor.setSalt(details.get("salt"));
                            editor.setPasswordHash(request.getParameter("password"));
                            editor.setEmail(request.getParameter("email"));
                            editor = loginService.loginEditor(editor);
                            if (editor != null) {
                                message = "Login successful.";
                                request.setAttribute("message", message);
                                session.setAttribute("user", editor);
                                session.setAttribute("genres", genreService.getAllGenres());
                                request.getRequestDispatcher("EditorLandingPage.jsp").forward(request, response);
                            } else {
                                request.setAttribute("message", message);
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                            }
                            break;

                        case "A":
                            editor = new Editor();
                            editor.setSalt(details.get("salt"));
                            editor.setPasswordHash(request.getParameter("password"));
                            editor.setEmail(request.getParameter("email"));
                            editor = loginService.loginEditor(editor);
                            if (editor != null) {
                                message = "Login successful.";
                                request.setAttribute("message", message);
                                session.setAttribute("user", editor);
                                session.setAttribute("genres", genreService.getAllGenres());
                                request.getRequestDispatcher("EditorLandingPage.jsp").forward(request, response);
                            } else {
                                request.setAttribute("message", message);
                                request.getRequestDispatcher("login.jsp").forward(request, response);
                            }
                            break;

                        default:
                            request.setAttribute("message", "Something went wrong logging in.");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                } else if(!Boolean.parseBoolean(details.get("userFound"))) {
                    message = "Login Credentials Invalid: Email not found.";
                    request.setAttribute("message", message);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                } else {
                    message = "Please verify your account.";
                    request.setAttribute("message", message);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
                break;
            case "register":
                message = "This email already exists.";
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                if (!readerService.userExists(email)) {
                    Reader reader = new Reader();
                    reader.setEmail(email);
                    reader.setSalt(PasswordEncryptor.generateSalt());
                    reader.setPasswordHash(PasswordEncryptor.hashPassword(password, reader.getSalt()));
                    reader.setName(request.getParameter("name"));
                    reader.setSurname(request.getParameter("surname"));
                    reader.setPhoneNumber(request.getParameter("phoneNumber"));
                    List<Genre> genres = genreService.getAllGenres();
                    List<Integer> genreIds = new ArrayList<>();
                    for (Genre genre : genres) {
                        if (request.getParameter(String.valueOf(genre.getId())) != null) {
                            genreIds.add(genre.getId());
                        }
                    }
                    reader.setFavouriteGenreIds(genreIds);
                    message = loginService.register(reader);
                    reader.setPasswordHash(password);
                    reader = loginService.loginReader(reader);
                    if (reader != null) {
                        message += "<br>" + mailService.sendVerficationEmail(reader);
                        request.setAttribute("user", reader);
                    }
                }
                request.setAttribute("message", message);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
            case "getGenresForRegister":
                request.setAttribute("genres", genreService.getAllGenres());
                request.getRequestDispatcher("register.jsp").forward(request, response);
                break;
            case "verifyReader":
                Integer readerId = Integer.valueOf(request.getParameter("readerId"));
                String verifyToken = request.getParameter("verifyToken");
                
                if (readerService.isVerified(readerId)) {
                    message = "Your account has already been verified.";
                } else if (verifyToken.equals(readerService.getVerifyToken(readerId))) {
                    message = readerService.setVerified(readerId);
                } else {
                    message = "Something went wrong verifying your account.";
                }
                request.setAttribute("message", message);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                break;
            case "logout":
                if (session != null) {
                    session.removeAttribute("user");
                }
                request.getRequestDispatcher("index.jsp").forward(request, response);
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
