<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Story</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="jquery-3.7.0.min.js"></script>
    </head>
    <style>
        .other-space{
            margin-bottom: -15px;
        }

        body {
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
        }


    </style>
    <script>

        Filevalidation = () => {
            const fi = document.getElementById('imageFile');
            // Check if any file is selected.
            if (fi.files.length > 0) {
                const fsize = fi.files[0].size;
                const file = Math.round((fsize / 1024));
                // The size of the file.
                if (file >= 512) {
                    document.getElementById('imageMessage').style.display = "block";
                } else {
                    document.getElementById('imageMessage').style.display = "none";
                    var image = document.getElementById('storyImage');
                    image.src = URL.createObjectURL(fi.files[0]);
                    image.style.display = "block";
                    image.style.width = "200px";
                    image.style.height = "200px";
                }
            }
        }

    </script>
    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Writer user = (Writer) request.getSession(false).getAttribute("user");
            String homePageUrl = clientUrl;
            if (user != null && (user.getUserType().equals("R") || user.getUserType().equals("W"))) {
                homePageUrl += "ReaderLandingPage.jsp";
            } else {
                homePageUrl += "index.jsp";
            }
        %>
        <div id="navbar-container">
            <!-- Navbar -->
            <nav class="navbar navbar-expand-lg navbar-dark bg-black">
                <div class="container">
                    <a class="navbar-brand" href="<%=homePageUrl%>">
                        <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24"
                             style="filter: invert(1)">
                        READERS ARE INNOVATORS
                    </a>

                </div>
            </nav>
        </div>
        <%
            List<Genre> genres = (List<Genre>) request.getSession(false).getAttribute("genres");
        %>
        <div class="other-space"></div>
        <div class="container mt-5">
            <%
                if (user != null) {
            %>
            <div class="row">
                <div class="col-12">
                    <div class="alert alert-primary mt-5" role="alert" id="imageMessage" style="display: none;">
                        <h4 class="alert-heading">Image uploaded exceed size limit. Please upload images less than 512kb.</h4>
                    </div>
                    <div class="card text-white bg-black">
                        <form action="StoryController" method="post" enctype="multipart/form-data">

                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <h3 id="exampleModalToggleLabel2">Write a new story</h3>
                                        <label for="title" class="form-label">Title:</label>
                                        <input class="form-control" type="text" id="title" name="title" required>
                                    </div>
                                </div>
                                <div class="row mb-3 justify-content-center">
                                    <div class="col-6 text-center">
                                        <img class="img-thumbnail" id="storyImage" src="" alt="" style="display: none; object-fit: cover;">
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <label for="imageFile" class="form-label">Upload Image:</label>
                                        <input class="form-control" type="file" id="imageFile" name="image" accept="image/*" onchange="Filevalidation()">
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <label for="story" class="form-label">Story:</label>
                                        <textarea class="form-control" id="story" name="story" rows="10" required></textarea>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <label for="summary" class="form-label">Summary:</label>
                                        <textarea class="form-control" id="summary" name="summary" rows="5" required></textarea>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-12">
                                        <div class="dropdown">
                                            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                                Select Genres
                                            </button>
                                            <ul class="dropdown-menu checkbox-menu allow-focus" aria-labelledby="dropdownMenuButton">
                                                <% for (Genre genre : genres) {%>
                                                <li>
                                                    <label>
                                                        <input type="checkbox" name="<%= genre.getId()%>" value="<%= genre.getId()%>">
                                                        <%= genre.getName()%> 
                                                    </label>
                                                </li>
                                                <% } %>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" id="commentsEnabled" name="commentsEnabled" value="true">
                                        <label class="form-check-label" for="commentsEnabled">Comments Enabled</label>
                                    </div>
                                </div>

                            </div>
                            <div class="card-footer">
                                <input type="hidden" name="submit" value="addStory">

                                <input class="btn btn-primary" type="submit" name="submitStory" value="Submit">
                                <input class="btn btn-primary" type="submit" name="submitStory" value="Save To Drafts">

                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%
            } else {
            %>
            <div class="alert alert-primary mt-5" role="alert">
                <h4 class="alert-heading">You are not currently logged in.</h4>
            </div>
            <script>
                window.location.replace("<%=clientUrl%>");
            </script>
            <%
                }
            %>
        </div>
    </body>
</html>
