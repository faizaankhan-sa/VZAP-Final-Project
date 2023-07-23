<%-- 
    Document   : index
    Created on : 13 Jun 2023, 14:26:23
    Author     : jarro
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>RIP Landing Page</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        
        <style>
            html,
            body {
                height: 100%;
            }

            body {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            }

            .registration-form {
                max-width: 400px;
                margin: 0 auto;
                padding: 20px;
                border: none; /* Remove the border */
                border-radius: 5px;
                background-color: black;
                color: #ffffff;
            }

            .registration-button,
            .wide-button {
                width: 100%;
            }

            .login-link {
                text-align: center;
                margin-top: 10px;
            }

            .wide-dropdown {
                width: 100%;
            }
        </style>
  
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </head>
    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            List<Genre> genres = (List<Genre>) request.getAttribute("genres");
            Account user = (Account) request.getSession(false).getAttribute("user");
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <a class="navbar-brand" href="<%=clientUrl%>">
                    <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                    READERS ARE INNOVATORS
                </a>
            </div>
        </nav>

        <div class="container mt-4">
            <div class="row">
                <div class="col-sm-12 col-md-8 col-lg-6 mx-auto">
                    <form action="LoginController" method="post" class="registration-form">
                        <h3 class="text-center mb-4">Registration</h3>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="mb-3">
                                    <input type="text" name="name" required class="form-control" id="name" placeholder="Enter your name">
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="mb-3">
                                    <input type="text" name="surname" class="form-control" required placeholder="Enter your surname">
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <input type="email" name="email" class="form-control" required placeholder="Enter your email">
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" name="password" maxlength="16" minlength="8" required placeholder="Enter your password">
                        </div>
                        <div class="mb-3">
                            <input type="number" class="form-control" name="phoneNumber"pattern="[0-9]{3}[0-9]{3}[0-9]{4}" maxlength="10" minlength="10" required placeholder="Enter your phone number">
                        </div>

                        <div class="dropdown">
                            <button class="btn btn-secondary dropdown-toggle wide-dropdown" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                Select Genres
                            </button>
                            <ul class="dropdown-menu checkbox-menu allow-focus wide-dropdown" aria-labelledby="dropdownMenuButton">
                                <%
                                    if (genres != null) {
                                        for (Genre genre : genres) {
                                %>
                                <li>
                                    <label>
                                        <input type="checkbox" name="<%= genre.getId()%>" value="<%= genre.getId()%>"> <%= genre.getName()%>
                                    </label>
                                </li>
                                <%
                                        }
                                    }
                                %>
                            </ul>
                        </div>
                            <br>

                        <div class="text-center">
                            <input type="hidden" name="submit" value="register">
                            <input type="submit" value="Register" class="btn btn-primary registration-button">
                        </div>

                    </form>
                </div>
            </div>
        </div>

    </body>
</html>
