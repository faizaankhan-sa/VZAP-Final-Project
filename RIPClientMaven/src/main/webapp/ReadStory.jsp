<%-- 
    Document   : ReadStory
    Created on : 21 Jun 2023, 11:15:52
    Author     : faiza
--%>

<%@page import="Utils.GetProperties"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Full Story Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
    </head>
    <style>
        .card-img-top-fixed {
            width: 100%;
            height: 400px; /* Adjust the height as per your requirement */
            object-fit: cover;
        }

        body {
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
        }


    </style>
    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Account user = (Account) request.getSession(false).getAttribute("user");
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <a class="navbar-brand" href="<%=clientUrl%>ReaderLandingPage.jsp">
                    <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                    READERS ARE INNOVATORS
                </a>

                <%
                    if (user == null || (user.getUserType().equals("E") || user.getUserType().equals("A"))) {
                %>
                <script>
                    window.location.replace("<%=clientUrl%>");
                </script>
                <%
                    }
                %>

            </div>
        </nav>
        <%
            Story story = (Story) request.getAttribute("story");
            if (user != null && (user.getUserType().equals("W") || user.getUserType().equals("R"))) {
        %>

        <div class="container" style="margin-top: -18px;">
            <div class="row mt-5">
                <div class="col mt-5">
                    <div class="card card-fixed text-bg-dark bg-opacity-25">
                        <%
                            if (story.getImage() != null) {
                        %>
                        <img class="card-img-top card-img-top-fixed border-image"
                             src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>"
                             alt="Book Image">
                        <%
                        } else {
                        %>
                        <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                        <%
                            }
                        %>
                        <div class="card-header" style="background-color: black;">
                            Full Story
                        </div>
                        <div class="card-body" style="background-color: black;">
                            <h3 class="card-title"><%=story.getTitle()%></h3>
                            <p class="card-text"><%=story.getContent()%></p>
                        </div>
                        <div class="card-footer text-body-secondary" style="background-color: black;">
                            <a href="StoryController?submit=viewStory&storyId=<%=story.getId()%>" class="btn btn-primary">Back To Details Page</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
        } else {
        %>
        <div class="alert alert-primary mx-auto my-auto" role="alert">
            <h4 class="alert-heading">You are currently not logged in.</h4>
        </div>
        <script>
            window.location.replace("<%=clientUrl%>");
        </script>
        <%
            }
        %>
    </body>
</html>
