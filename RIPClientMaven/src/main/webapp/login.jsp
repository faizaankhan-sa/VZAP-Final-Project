<%-- 
    Document   : index
    Created on : 13 Jun 2023, 14:26:23
    Author     : jarro
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RIP Landing Page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="jquery-3.7.0.min.js"></script>
        <style>
            html,
            body {
                height: 100%;
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            }

            body {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }

            .login-form {
                max-width: 400px;
                margin: 0 auto;
                padding: 20px;
                border: none; /* Remove the border */
                border-radius: 5px;
                background-color: black;
                color: #ffffff;
                /*                box-shadow: 0 0 100px rgba(255, 255, 255, 0.1);  Add a subtle box shadow */
            }


            .login-form h3 {
                color: #ffffff;
            }

            .login-button {
                width: 100%;
            }

            .not-member {
                text-align: center;
                margin-top: 10px;
                color: #ffffff;
            }
        </style>
        <script>

            <%
                Boolean tokensMatch = (Boolean) request.getAttribute("tokensMatch");
                String email = (String) request.getAttribute("email");
                if (tokensMatch != null && tokensMatch) {
            %>
            $(document).ready(function () {
                console.log("Tokens matched. User may change password.");
                $("#changePasswordForm").modal("show");
            });
            <%
                }
            %>

            function validateForm(formName) {
                let currentForm = forms[formName];
                
                if (formName === "changePasswordForm") {
                    let password = currentForm["password"];
                    let passwordRepeat = currentForm["repeatPassword"];
                    if (password!==passwordRepeat) {
                        console.log("passwords did not match!");
                        return false;
                    } else {
                        return true;
                    }
                }
            }
        </script>

    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <a class="navbar-brand" href="<%=clientUrl%>">
                    <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                    READERS ARE INNOVATORS
                </a>
            </div>
        </nav>
        <%
            String message = (String) request.getAttribute("message");
            Reader user = (Reader) request.getAttribute("user");
            if (message != null) {
        %>
        <div class="alert alert-info" role="alert">
            <h4 class="alert-heading"><%= message%></h4>
        </div>
        <%
            }
        %>
        <div class="container mt-4">
            <div class="row">
                <div class="col-sm-12 col-md-8 col-lg-6 mx-auto">
                    <form id="loginForm" action="LoginController" method="post" class="login-form">
                        <h3 class="text-center mb-4">Login</h3>
                        <div class="mb-3">
                            <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" maxlength="16" minlength="8" required>
                        </div>
                        <div class="text-center">
                            <input type="submit" value="Login" class="btn btn-primary login-button">
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="not-member">
                                    <div class="row">
                                        <p>Not a member?</p>
                                    </div>
                                    <div class="row">
                                        <a href="LoginController?submit=getGenresForRegister">Register</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col">
                                <div class="not-member">
                                    <div class="row">
                                        <p>Forgot Password?</p>
                                    </div>
                                    <div class="row">
                                        <button class="btn btn-link" type="button" data-bs-toggle="modal" data-bs-target="#forgotPasswordForm">Change Password</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <input type="hidden" value="login" name="submit" class="btn btn-primary login-button">
                    </form>
                </div>
            </div>
        </div>


        <%-- Forgot Password Modal --%>
        <div class="modal fade" id="forgotPasswordForm" aria-labelledby="forgotPasswordForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-white bg-dark">
                    <form action="MessageController" method="post" onsubmit="validateForm('forgotPasswordForm')">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="editorForm">Please enter your email</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="email" class="col-form-label" required>Email</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" name="submit" value="sendForgotPasswordEmail">
                            <button type="submit" class="btn btn-primary mb-3">Change Password</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <%
            if (tokensMatch != null && tokensMatch) {
        %>
        <%-- Change Password Modal --%>
        <div class="modal fade" id="changePasswordForm" aria-labelledby="changePasswordForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-white bg-dark">
                    <form action="ReaderController" method="post">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5">Please enter your new password</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password..." minlength="8" maxlength="16"required>
                            </div>
                            <div class="mb-3">
                                <label for="passwordRepeat" class="col-form-label">Repeat-Password</label>
                                <input type="password" class="form-control" id="repeatPassword" name="repeatPassword" placeholder="Repeat Password..." minlength="8" maxlength="16" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" name="email" value="<%=email%>">
                            <input type="hidden" name="submit" value="changePasswordForLogin">
                            <button type="submit" class="btn btn-primary mb-3">Change Password</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>
