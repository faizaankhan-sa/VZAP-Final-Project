<%--
    Document   : EditStoryPage
    Created on : 20 Jun 2023, 17:21:52
    Author     : jarro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Story</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-NTWp1tUQpxgih3k9wV9iVDOZDHR9sYPm9/j1ZDrN8IEEeVn5k1vL/1XTmlfF4zXZ" crossorigin="anonymous"></script>
        <script src="jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-element-bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"></script>
        <style>
            /* Custom CSS to fix the navbar position */
            #navbar-container {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 9999;
            }



            .space {
                /* Adjust the margin-top as per your requirement */
                margin-bottom: 88px; /* Adjust the margin-bottom as per your requirement */
            }

            .other-space{
                margin-bottom: 40px;
            }

            body {
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            }

            h2 {
                color: white;
            }

            .form-white,
            .form-white label,
            .form-white input,
            .form-white textarea,
            .form-white select,
            .form-white .form-check-label,
            .form-white p {
                color: white;
            }

            .swiper-slide {
                text-align: center;
                font-size: 18px;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .swiper-container {
                width: 100px;
                height: 100px;
            }

            .genre-swiper {
                width: 80%;
                height: 200px;
                align-items: center;
                background-color: white;
                color: black;
            }
        </style>
        <script>
            $('.dropdown').unbind('show.bs.dropdown');
            $('.dropdown').unbind('hide.bs.dropdown');
            $('.dropdown').bind('show.bs.dropdown', function () {
                $('.fixed-table-body').css("overflow", "inherit");
            });
            $('.dropdown').bind('hide.bs.dropdown', function () {
                $('.fixed-table-body').css("overflow", "auto");
            });
        </script>
    </head>
    <script>
        var loadFile = function (event) {
            var image = document.getElementById('storyImage');
            image.src = URL.createObjectURL(event.target.files[0]);
        };
    </script>
    <body>
        <%
            Account user = (Account) request.getSession(false).getAttribute("user");
            String message = (String) request.getAttribute("message");
            Story story = (Story) request.getAttribute("story");
            List<Genre> genres = (List<Genre>) request.getSession(false).getAttribute("genres");
            String navBarRef = "http://localhost:8080/RIPClientMaven/";
        %>

        <%
            if (user != null && !user.getUserType().equals("R")) {

                if (user.getUserType().equals("W")) {
                    navBarRef += "ReaderLandingPage.jsp";
                } else {
                    navBarRef += "EditorLandingPage.jsp";
                }

        %>

        <%            if (message != null) {
        %>
        <h3><%=message%></h3>
        <%
            }
        %>
        <div id="navbar-container">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark bg-black">
                <div class="container">
                    <a class="navbar-brand" href="<%=navBarRef%>">
                        <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24"
                             style="filter: invert(1)">
                        READERS ARE INNOVATORS
                    </a>

                </div>
            </nav>
        </div>
        <%
            if (story != null) {
        %>
        <div class="space"></div>
        <div class="container mt-5">

            <div class="row">
                <div class="col-12">
                    <div class="card text-white bg-black">
                        <!-- Spacing -->

                        <form action="StoryController" method="post" enctype="multipart/form-data">
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <h3 class="text-left book-title">Edit Story</h3>
                                        <label for="title">Title</label>
                                        <input type="text" class="form-control" id="title" name="title" value="<%=story.getTitle()%>">
                                    </div>
                                </div>
                                <div class="row mb-3 justify-content-left">
                                    <div class="col-6 text-center">
                                        <!--                                            <label for="image">Image</label>-->
                                        <% if (story.getImage() != null) {%>
                                        <img style="width: 200px;
                                             height: 200px;
                                             object-fit: cover;" id="storyImage" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image" class="img-thumbnail">
                                        <input type="hidden" name="encodedImage" value="<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>">
                                        <% } else { %>
                                        <img style="width: 200px;
                                             height: 200px;
                                             object-fit: cover;" id="storyImage" class="img-thumbnail" src="book.svg" alt="Book Image">
                                        <input type="hidden" name="encodedImage" value="book.svg">
                                        <% } %>

                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <input class="form-control" type="file" id="image" name="image" accept="image/*" onchange="loadFile(event)">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Genres</label>
                                    <% if (genres != null) { %>
                                    <swiper-container scrollbar-draggable="true" class="mySwiper" scrollbar="true" direction="vertical" slides-per-view="auto" free-mode="true" mousewheel="true">

                                        <div class="check-form">
                                            <swiper-slide>
                                                <% for (Genre genre : genres) {%>
                                                <input type="checkbox" class="form-check-input" name="<%= genre.getId()%>" value="<%= genre.getId()%>" id="<%= genre.getId()%>"<% if (story.getGenreIds().contains(genre.getId())) { %> checked <% }%>>
                                                <label class="form-check-label" for="<%= genre.getId()%>"><%= genre.getName()%></label>
                                                <% } %>
                                            </swiper-slide>
                                        </div>
                                    </swiper-container>
                                    <% } else { %>
                                    <p>Failed to retrieve genres.</p>
                                    <% }%>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-12">
                                        <label for="summary">Blurb</label>
                                        <textarea class="form-control" id="summary" name="summary" rows="3" required><%=story.getBlurb()%></textarea>
                                    </div>
                                </div>


                                <div class="row mb-3">
                                    <div class="col-12">
                                        <label for="story">Story</label>
                                        <textarea class="form-control" id="story" name="story" rows="3" required><%=story.getContent()%></textarea>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="commentsEnabled" name="commentsEnabled" value="true"<%if (story.getCommentsEnabled()) {%>checked<%}%>>
                                        <label class="form-check-label" for="commentsEnabled">Comments Enabled</label>
                                    </div>
                                </div>


                                <input type="hidden" name="storyId" value="<%=story.getId()%>">
                                <input type="hidden" name="authorId" value="<%=story.getAuthorId()%>">

                                <% if (user.getUserType().equals("E") || user.getUserType().equals("A")) {%>
                                <input type="hidden" name="submit" value="approveEditedStoryFromEditor">
                                <button class="btn btn-primary" type="submit">Approve</button>
                                <a class="btn btn-danger" href="StoryController?submit=rejectStoryFromEditor&storyId=<%=story.getId()%>">Deny</a>
                                <% } %>
                                <% if (user.getUserType().equals("W")) { %>

                            </div>

                            <div class="card-footer">
                                <input type="hidden" name="submit" value="updateEditedStoryFromWriter">
                                <button class="btn btn-success" type="submit" name="submitStory" value="Submit">Submit</button>
                                <button class="btn btn-primary" type="submit" name="submitStory" value="Save To Drafts">Save To Drafts</button>
                                <% } %>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="other-space"></div>
        </div>
        <%
        } else {
        %>
        <div class="alert alert-danger" role="alert">
            <h4 class="alert-heading">Story not found.</h4>
        </div>
        <%
            }
        %>
        <%
        } else {
        %>
        <div class="alert alert-danger" role="alert">
            <h4 class="alert-heading">You do not have priviliges to edit a story.</h4>
        </div>
        <script>
            window.location.replace("http://localhost:8080/RIPClientMaven/");
        </script>
        <%
            }
        %>
    </body>
</html>