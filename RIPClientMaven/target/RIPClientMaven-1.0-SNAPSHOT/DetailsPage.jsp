<%@page import="java.time.LocalDateTime"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="Models.Story"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-element-bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"></script>
        <title>Story Details</title>
        <style>
            body {

                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            }

            .title-right {
                margin-left: 50px; /* Adjust the margin value as needed */
            }

            .border-image {
                border: 2px solid #ccc; /* Adjust border style and color as needed */
                border-radius: 5px; /* Optional: Adds rounded corners to the border */
            }

            .card {
                margin-top: 20px;
                box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);
                transition: 0.3s;
                background-color: black;
            }

            .card:hover {
                box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
            }

            .card-img-top-fixed {
                max-width: 100%;
                height: auto;
            }


            .rate {
                float: left;
                height: 46px;
                padding: 0 10px;
            }

            .rate:not(:checked) > input {
                position: absolute;
                top: -9999px;
            }

            .rate:not(:checked) > label {
                float: right;
                width: 1em;
                overflow: hidden;
                white-space: nowrap;
                cursor: pointer;
                font-size: 30px;
                color: #ccc;
            }

            .rate:not(:checked) > label:before {
                content: '★ ';
            }

            .rate > input:checked ~ label {
                color: #ffc700;
            }

            .rate:not(:checked) > label:hover,
            .rate:not(:checked) > label:hover ~ label {
                color: #deb217;
            }

            .rate > input:checked + label:hover,
            .rate > input:checked + label:hover ~ label,
            .rate > input:checked ~ label:hover,
            .rate > input:checked ~ label:hover ~ label,
            .rate > label:hover ~ input:checked ~ label {
                color: #c59b08;
            }

            /* Modified from: https://github.com/mukulkant/Star-rating-using-pure-css */

            swiper-container {
                width: 100%;
                height: 500px;
            }

            swiper-slide {
                font-size: 18px;
                height: auto;
                width: 100%;
                -webkit-box-sizing: border-box;
                box-sizing: border-box;
                padding: 30px;
            }

        </style>
        <script>
            function autoSubmit() {
                var ratingForm = document.getElementById("ratingForm");
                var ratingValue = ratingForm.elements["rate"].value;
                var storyId = ratingForm.elements["storyId"].value;
                var isAdding = ratingForm.elements["isAdding"].value;
                window.location.replace("StoryController?submit=rateStory&rate=" + ratingValue + "&storyId=" + storyId + "&isAdding=" + isAdding);
            }
        </script>
        <!-- StarRating -->
        <link rel="stylesheet" type="text/css" href="style.css">
    </head>
    <body>
        <%
            Reader reader = null;
            Account user = null;
            if (request.getSession(false) != null) {
                user = (Account) request.getSession(false).getAttribute("user");
            }
            String homePageUrl = "http://localhost:8080/RIPClientMaven/";
            if (user != null && (user.getUserType().equals("R") || user.getUserType().equals("W"))) {
                homePageUrl += "ReaderLandingPage.jsp";
                reader = (Reader) user;
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
                    <div class="d-flex align-items-center">
                        <form action="StoryController" method="post">
                            <input class="form-control me-2" type="search" placeholder="Search for genres, titles, blurbs..."
                                   aria-label="Search" name="searchValue" required>
                            <input type="hidden" name="submit" value="searchForGenreAndStories">
                        </form>
                    </div>
                </div>
            </nav>
        </div>

        <div class="container">
            <div class="card">
                <div class="card-body">
                    <%
                        Boolean userViewedStory = (Boolean) request.getAttribute("userViewedStory");
                        if (userViewedStory == null) {
                            userViewedStory = false;
                        }
                        String readerName = (String) request.getAttribute("readerName");
                        List<Comment> comments = (List<Comment>) request.getAttribute("comments");
                        Story story = (Story) request.getAttribute("story");
                        Rating userRating = (Rating) request.getAttribute("userRating");
                        String message = (String) request.getAttribute("message");
                        Boolean ratingExists = false;

                        if (userRating != null) {
                            ratingExists = true;
                        }
                        
                        if (message != null) {
                    %>
                    <div class="alert alert-primary mt-5" role="alert">
                        <h4 class="alert-heading"><%= message%></h4>
                    </div>
                    <%
                        }
                    %>

                    <%
                        if (readerName != null) {
                    %>
                    <div class="alert alert-primary mt-5" role="alert">
                        <h2 class="alert-heading">Story of the day</h2><br>
                        <h6 class="alert-heading">Welcome to Readers Are Innovators <%=readerName%>!</h6>
                    </div>
                    <%
                        }
                    %>
                    <%
                        if (story!=null) {
                    %>
                    <div class="story-container">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="image-container">
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
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="details-container">
                                    <h3 class="title title-right text-white"><%= story.getTitle()%></h3>
                                    <div class="blurb-container title-right">
                                        <p class="blurp text-white"><%= story.getBlurb()%></p>
                                    </div>
                                </div>
                                <div class="rating-container">
                                    <div class="rating-box title-right text-white">Rating: <%= story.getRating()%></div>
                                    <div class="likes-box title-right text-white">Likes: <%= story.getLikeCount()%></div>
                                    <div class="views-box title-right text-white">Views: <%= story.getViewCount()%></div>
                                </div>
                                <div class="button-container">
                                    <%
                                        if (reader != null) {
                                    %>
                                    <div class="readbutton-container">
                                        <%
                                            if (userViewedStory) {
                                        %>
                                        <form class="rate title-right" id="ratingForm" name="ratingForm" action="StoryController" method="get">
                                            <input type="radio" id="star5" name="rate" value="5" onclick="autoSubmit()"
                                                   <%if (ratingExists && userRating.getValue() == 5) {%> checked <%}%>>
                                            <label for="star5" title="text">5 stars</label>
                                            <input type="radio" id="star4" name="rate" value="4" onclick="autoSubmit()"
                                                   <%if (ratingExists && userRating.getValue() == 4) {%> checked <%}%>>
                                            <label for="star4" title="text">4 stars</label>
                                            <input type="radio" id="star3" name="rate" value="3" onclick="autoSubmit()"
                                                   <%if (ratingExists && userRating.getValue() == 3) {%> checked <%}%>>
                                            <label for="star3" title="text">3 stars</label>
                                            <input type="radio" id="star2" name="rate" value="2" onclick="autoSubmit()"
                                                   <%if (ratingExists && userRating.getValue() == 2) {%> checked <%}%>>
                                            <label for="star2" title="text">2 stars</label>
                                            <input type="radio" id="star1" name="rate" value="1" onclick="autoSubmit()"
                                                   <%if (ratingExists && userRating.getValue() == 1) {%> checked <%}%>>
                                            <label for="star1" title="text">1 star</label>
                                            <input type="hidden" name="isAdding" value="<%=!ratingExists%>">
                                            <input type="hidden" name="storyId" value="<%=story.getId()%>">

                                        </form>
                                            <%
                                                }
                                            %>



                                    </div>
                                    <br>
                                    <br>
                                    <a class="title-right btn btn-primary" href="StoryController?submit=readStory&storyId=<%=story.getId()%>"><i class="bi bi-book-fill"></i></a>

                                    <%
                                        if (userViewedStory || story.getAuthorId() == reader.getId()) {
                                    %>
                                    <%
                                        if (reader.getFavouriteStoryIds().contains(story.getId())) {
                                    %>

                                    <a class="btn btn-danger" href="StoryController?submit=unlikeStory&storyId=<%=story.getId()%>"><i class="bi bi-heart-fill"></i></a>
                                    <%
                                    } else {
                                    %>

                                    <a class="btn btn-danger" href="StoryController?submit=likeStory&storyId=<%=story.getId()%>"><i class="bi bi-heart"></i></a>
                                    <%
                                        }
                                    %>
                                    <%
                                        }
                                    %>
                                    <%
                                        if ((userViewedStory && story.getCommentsEnabled()) || story.getAuthorId() == reader.getId()) {
                                    %>
                                    <br>
                                    <br>
                                    <form class="title-right" action="StoryController" method="get">
                                        <div class="mb-3">

                                            <textarea placeholder="Leave a comment!" name="comment" id="comments" class="form-control" style="font-family:sans-serif; font-size:1.2em;"></textarea>
                                        </div>
                                        <input type="hidden" name="storyId" value="<%=story.getId()%>">
                                        <input type="submit" name="submit" value="commentStory" class="btn btn-primary">
                                    </form>

                                    <%
                                        }
                                    %>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container t-5">
                        <% if (story.getCommentsEnabled() && comments != null) { %>
                        <h3 class="text-white">Comments</h3>
                        <div class="d-flex justify-content-center row text-white bg-dark">
                            <swiper-container scrollbar="true" direction="vertical" slides-per-view="auto" scrollbar-draggable="true" free-mode="true" mousewheel="true">
                                <swiper-slide>
                                    <%
                                        for (Comment comment : comments) {
                                    %>
                                    <div class="card">
                                        <div class="card-content bg-white text-black">
                                            <div class="card-header">
                                                <div class="row">
                                                    <p class="card-title"><%= comment.getName() + " " + comment.getSurname()%></p>
                                                </div>
                                                <div class="row">
                                                    <p style="font-size: 11px;">
                                                        <%= comment.getDate().getDayOfWeek() + " " + comment.getDate().getDayOfMonth() + ", " + comment.getDate().getMonth() + " - " + comment.getDate().getYear() + " " + comment.getDate().getHour() + ":" + comment.getDate().getMinute()%>
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="card-body text-start">
                                                <p>
                                                    <%= comment.getMessage()%>
                                                </p>
                                            </div>
                                            <div class="card-footer">

                                            </div>
                                        </div>
                                    </div>
                                    <%
                                        }
                                    %>
                                </swiper-slide>
                            </swiper-container>
                        </div>
                        <% } %>
                    </div>
                    <div style="margin-top: 100px;" ></div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </body>
</html>
