<%--
    Document   : EditStoryPage
    Created on : 21 Jun 2023, 15:02:51
    Author     : faiza
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<!DOCTYPE html>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-element-bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"></script>
        <title>Edit Story</title>
    </head>
    <style>
        /* Custom CSS to fix the navbar position */
        #navbar-container {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1;
        }

        .other-space {
            margin-bottom: 150px;
        }

        .space-one {
            margin-bottom: 20px;
        }

        body {
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            color: white;
        }
        .approve-container{

        }

        swiper-container {
            width: 100%;
            height: 300px;
        }

        swiper-slide {
            font-size: 18px;
            height: auto;
            width: 100%;
            -webkit-box-sizing: border-box;
            box-sizing: border-box;
            padding: 30px;
        }

        .blurb-swiper {
            height: 90px;
            color: black;
        }
    </style>
    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Account user = (Account) request.getSession(false).getAttribute("user");
            List<Story> submittedStories = (List<Story>) request.getAttribute("submittedStories");
            List<Genre> genres = (List<Genre>) request.getSession(false).getAttribute("genres");
            String message = (String) request.getAttribute("message");
        %>

        <%
            if (user == null) {
        %>
        <script>
            window.location.replace("<%=clientUrl%>");
        </script>
        <%
            }
        %>
        <div id="navbar-container">
            <nav class="navbar navbar-expand-lg navbar-dark bg-black">
                <div class="container">
                    <button class="btn btn-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar" aria-expanded="false" style="position: absolute; left: 0;">
                        <i class="bi bi-list"></i> <!-- More Icon -->
                    </button>
                    <div class="container-fluid">
                        <a class="navbar-brand position-relative" href="<%=clientUrl%>EditorLandingPage.jsp">
                            <img src="book.svg" alt="Book Icon" class="me-2 " width="24" height="24" style="filter: invert(1)" >READERS ARE INNOVATORS</a>
                    </div>
                </div>
            </nav>
        </div>


        <!--side-navbar-->
        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="sidebar" aria-labelledby="sidebar">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasExampleLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <div class="d-grid">
                    <button class="btn btn-dark " type="button" data-bs-toggle="modal" data-bs-target="#profileDetails"><i class="bi bi-person-fill"></i> Profile</button>
                    <a class="btn btn-dark " href="LoginController?submit=logout"><i class="bi bi-box-arrow-right"></i>Logout</a>
                </div>
            </div>
        </div>

        <!-- Profile Pop Up Modal -->
        <!-- Modal -->
        <div class="modal fade" id="profileDetails" aria-labelledby="profileDetails" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content bg-dark text-white">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel">Profile Details</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <img src="person-square.svg" alt="Profile" class="rounded-circle p-1 bg-primary" width="110">
                        <div class="mb-3 row">
                            <label for="name" class="col col-form-label">First Name</label>
                            <div class="col-8">
                                <input type="text" class="form-control-plaintext text-white" id="name" name="name" value="<%=user.getName()%>" readonly>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="surname" class="col col-form-label">Last Name</label>
                            <div class="col-8 text-white">
                                <input type="text" class="form-control-plaintext text-white" id="surname" name="surname" value="<%=user.getSurname()%>" readonly>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="email" class="col col-form-label">Email</label>
                            <div class="col-8">
                                <input type="email" class="form-control-plaintext text-white" id="email" name="email" value="<%=user.getEmail()%>" readonly>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="phoneNumber" class="col col-form-label">Phone Number</label>
                            <div class="col-8">
                                <input type="tel" class="form-control-plaintext text-white" id="phoneNumber" name="phoneNumber" value="<%=user.getPhoneNumber()%>" readonly>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div class="other-space"></div>

        <div class="container mt-8">
            <div class="container mt-5">
                <%
                    if (message != null) {
                %>
                <div class="alert alert-success" role="alert">
                    <h4 class="alert-heading"><%= message%></h4>
                </div>
                <%
                    }
                %>
                <%
                    if (submittedStories != null) {
                %>
                <h2>Submitted Stories</h2>

                <div class="container mt-5  text-center" style="align-items: center;">
                    <div class="row bg-dark">
                        <div class="col">
                            <h4 class="text-white text-center">Title</h4>
                        </div>
                        <div class="col">
                            <h4 class="text-white text-center">Summary</h4>
                        </div>
                        <div class="col">
                        </div>
                    </div>
                    <%
                        for (Story story : submittedStories) {
                    %>
                    <div class="row rows-cols-auto bg-white text-black text-center" style="border-block-end: 2px solid black; height: 100px;  align-items: center;">
                        <div class="col">
                            <h6 class="text-start"><%=story.getTitle()%></h6>
                        </div>
                        <div class="col">
                            <swiper-container class="blurb-swiper" scrollbar-draggable="true" class="mySwiper" scrollbar="true" direction="vertical" slides-per-view="auto" free-mode="true" mousewheel="true">
                                <swiper-slide>
                                    <p class="text-start text-black"><%=story.getBlurb()%></p>
                                </swiper-slide>
                            </swiper-container>
                        </div>
                        <div class="col">
                            <div class="row">
                                <div class="col mx-auto my-auto text-center">
                                    <button class="btn btn-dark" type="button" data-bs-toggle="collapse" data-bs-target="#story<%=story.getId()%>" aria-expanded="false" aria-controls="tory<%=story.getId()%>Collapse">
                                        <i class="bi bi-caret-down-fill"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row rows-cols-auto collapse text-center bg-black" id="story<%=story.getId()%>" style=" align-items: center;">
                        <div class="col" style="width: 30%;" style="align-items: center;">
                            <div class="row text-center">
                                <div class="image-container" style="height: 60%;">
                                    <%
                                        if (story.getImage() != null) {
                                    %>
                                    <img class="img-thumbnail img-fluid"
                                         src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>"
                                         alt="Book Image">
                                    <%
                                    } else {
                                    %>
                                    <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                            <div class="row text-center">
                                <div class="col text-center">
                                    <span>
                                        <%
                                            if (genres != null) {
                                                for (Genre genre : genres) {
                                                    if (story.getGenreIds().contains(genre.getId())) {
                                        %>
                                        <%=genre.getName() + " "%>
                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="col" style="width: 70%; align-items: center;">
                            <div class="row">
                                <div class="col">
                                    <div class="row my-auto bg-dark">
                                        <swiper-container scrollbar-draggable="true" class="mySwiper" scrollbar="true" direction="vertical" slides-per-view="auto" free-mode="true" mousewheel="true" mousewheel-sensitivity="0.4">
                                            <swiper-slide>
                                                <h4 class="text-center text-white"><%=story.getTitle()%></h4>
                                                <p class="text-start text-white"><%=story.getContent()%></p>
                                            </swiper-slide>
                                        </swiper-container>
                                    </div>
                                    <div class="row mt-2">
                                        <div class="btn-group" role="group">
                                            <a class="btn btn-primary"
                                               href="StoryController?submit=rejectStoryFromEditor&storyId=<%=story.getId()%>">
                                                Deny
                                            </a>
                                            <a class="btn btn-primary"
                                               href="StoryController?submit=goToEditStoryPage&storyId=<%=story.getId()%>">
                                                Edit
                                            </a>
                                            <a class="btn btn-primary"
                                               href="StoryController?submit=submitStoryFromSelectStoryToEditPage&storyId=<%=story.getId()%>">
                                                Approve
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <%
                } else {
                %>
                <div class="alert alert-primary mt-5" role="alert">
                    <h4 class="alert-heading">There are currently no stories to approve.</h4>
                </div>
                <%
                    }
                %>
            </div>
        </div>

        <div class="space-one"></div>
    </body>
</html>
