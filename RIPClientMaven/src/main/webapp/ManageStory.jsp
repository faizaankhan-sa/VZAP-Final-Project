<%-- 
    Document   : ManageStory
    Created on : 22 Jun 2023, 09:11:19
    Author     : faiza
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="java.util.Arrays"%>
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
        <title>Manage Stories Page</title>
        <script>
            document.querySelector('table').addEventListener('click', (e) => {
                if (e.target.tagName === 'INPUT')
                    return;
                const row = e.target.tagName === 'TR' ? e.target : e.target.parentNode;
                const childCheckbox = row.querySelector('input[type="checkbox"]');
                childCheckbox.checked = !childCheckbox.checked;
            });
        </script>
    </head>
    <style>
        body {
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            color: white;
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
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <div class="container-fluid">
                    <a class="navbar-brand" href="<%=clientUrl%>ReaderLandingPage.jsp">
                        <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                        READERS ARE INNOVATORS
                    </a>
                </div>
            </div>
        </nav>

        <%
            List<Genre> genres = (List<Genre>) request.getSession(false).getAttribute("genres");
            List<Story> submittedStories = (List<Story>) request.getAttribute("submittedStories");
            List<Story> draftedStories = (List<Story>) request.getAttribute("draftedStories");
            String message = (String) request.getAttribute("message");
        %>

        <div class="container mt-5">
            <%
                if (message != null) {
            %>
            <div class="alert alert-primary mt-5" role="alert">
                <h4 class="alert-heading"><%= message%></h4>
            </div>
            <%
                }
            %>
            <div class="text-center mt-5">
                <h3>Submitted Stories</h3>
            </div>

            <%
                if (submittedStories != null) {
            %>
            <div class="container mt-5  text-center">
                <form action="StoryController" method="post">
                    <div class="row bg-dark" style="align-items: center;">
                        <div class="col">
                        </div>
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
                    <div class="row bg-white text-black text-center" style="border-block-end: 2px solid black; height: 100px; align-items: center;">
                        <div class="col">
                            <input aria-labelledBy="<%=story.getTitle()%>" class="form-check-input me-1 form-check-input bg-dark" type="checkbox" name="<%=story.getId()%>" value="<%=story.getId()%>" id="<%=story.getId()%>">
                            <label class="form-check-label" for="<%=story.getId()%>"></label>
                        </div>
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
                        <div class="col" style="width: 30%; align-items: center;">
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
                        <div class="col" style="width: 70%;  align-items: center;">
                            <div class="row">
                                <div class="col">
                                    <div class="row my-auto bg-dark">
                                        <swiper-container scrollbar-draggable="true" class="mySwiper" scrollbar="true" direction="vertical" slides-per-view="auto" free-mode="true" mousewheel="true">
                                            <swiper-slide>
                                                <h4 class="text-center text-white"><%=story.getTitle()%></h4>
                                                <p class="text-start text-white"><%=story.getContent()%></p>
                                            </swiper-slide>
                                        </swiper-container>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                    <input type="hidden" id="id" name="submit" value="moveStoriesToDrafts">
                    <input type="submit" class="btn btn-primary px-4" value="Move To Drafts">
                </form>
                <%
                } else {
                %>
                <div class="alert alert-primary" role="alert">
                    <h4 class="alert-heading">You currently have no submitted stories.</h4>
                </div>
                <%
                    }
                %>
            </div>


            <div class="container mt-5">
                <div class="text-center mt-3">
                    <h3>Drafts</h3>
                </div>
                <%
                    if (draftedStories != null) {
                %>
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
                        for (Story story : draftedStories) {
                    %>
                    <div class="row bg-white text-black text-center" style="border-block-end: 2px solid black; height: 100px; align-items: center;">
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
                        <div class="col" style="width: 30%;">
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
                        <div class="col" style="width: 70%;">
                            <div class="row">
                                <div class="col">
                                    <div class="row my-auto bg-dark">
                                        <swiper-container scrollbar-draggable="true" class="mySwiper" scrollbar="true" direction="vertical" slides-per-view="auto" free-mode="true" mousewheel="true">
                                            <swiper-slide>
                                                <h4 class="text-center text-white"><%=story.getTitle()%></h4>
                                                <p class="text-start text-white"><%=story.getContent()%></p>
                                            </swiper-slide>
                                        </swiper-container>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col">
                                    <div class="btn-group" role="group">
                                        <a class="btn btn-primary" href="StoryController?submit=deleteStoryFromManageStoryPage&storyId=<%=story.getId()%>">
                                            Delete
                                        </a>
                                        <a class="btn btn-primary" href="StoryController?submit=goToEditStoryPage&storyId=<%=story.getId()%>">
                                            Edit
                                        </a>
                                        <a class="btn btn-primary" href="StoryController?submit=submitStoryFromWriter&storyId=<%=story.getId()%>">
                                            Submit
                                        </a>
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
                <div class="alert alert-primary" role="alert">
                    <h4 class="alert-heading">You currently have no drafted stories.</h4>
                </div>
                <%
                    }
                %>
            </div>
            <div class="container-fluid mt-5 text-center">
                <a href="createStory.jsp" class="btn btn-primary px4">
                    Create New Story
                </a>
            </div>
        </div>
    </body>
</html>
