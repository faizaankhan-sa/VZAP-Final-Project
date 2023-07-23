<%-- 
    Document   : ReadLandingPage
    Created on : 14 Jun 2023, 14:42:38
    Author     : Jarrod
--%>

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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Reader Landing Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-element-bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css"></script>
        <style>
            /* Custom CSS to fix the navbar position */
            #navbar-container {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 999;
            }

            body {
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);

            }

            .card {
                border-radius: 5px; /* Round the card corners */
                transition: transform 0.3s;
                height: 400px;
            }

            .card:hover {
                border-color: #007bff; /* Add blue border color on hover */
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.5); /* Add blue box shadow on hover */
            }

            .card-fixed {
                height: 400px; /* Adjust the height as per your requirement */
            }

            .card-img-top-fixed {
                width: 100%;
                height: 300px; /* Adjust the height as per your requirement */
                object-fit: cover;
            }

            .space {
                /* Adjust the margin-top as per your requirement */
                margin-bottom: 100px; /* Adjust the margin-bottom as per your requirement */
            }

            .other-space {
                margin-bottom: 40px;
            }

            carouselTitle {
                color: white;
            }

            .swiper-container {
                width: 100%;
                height: 100%;
            }

            .swiper-slide {
                text-align: center;
                font-size: 18px;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .swiper-slide img {
                display: block;
                width: 300px;
                height: 100%;
                color: #333333;
                object-fit: cover;
            }
            
            .favourites-swiper-container {
                width: 50%;
            }
            
            .favourites-swiper-slide {
                height: auto;
            }

        </style>

    </head>
    <body>
        <%
            Account user = (Account) request.getSession(false).getAttribute("user");

            if (user == null) {
        %>
        <script>
            window.location.replace("index.jsp");
        </script>
        <%
            }

            Reader reader = null;
            Writer writer = null;
            if (user != null && user.getUserType().equals("R")) {
                reader = (Reader) user;
            } else if (user != null && user.getUserType().equals("W")) {
                writer = (Writer) user;
            } else {

            }
            String message = (String) request.getAttribute("message");
            Boolean getStoriesCalled = (Boolean) request.getAttribute("getStoriesForReaderLandingPageCalled");
            Genre genre1 = (Genre) request.getAttribute("genre1");
            Genre genre2 = (Genre) request.getAttribute("genre2");
            Genre genre3 = (Genre) request.getAttribute("genre3");
            List<Story> genre1Stories = (List<Story>) request.getAttribute("genre1Stories");
            List<Story> genre2Stories = (List<Story>) request.getAttribute("genre2Stories");
            List<Story> genre3Stories = (List<Story>) request.getAttribute("genre3Stories");
            List<Story> highestRated = (List<Story>) request.getAttribute("highestRated");
            List<Story> mostViewed = (List<Story>) request.getAttribute("mostViewed");
            List<Story> topPicks = (List<Story>) request.getAttribute("topPicks");
            List<Story> recommendedStories = (List<Story>) request.getAttribute("recommendedStories");
            List<Story> favouriteStories = (List<Story>) request.getAttribute("favouriteStories");
            if (getStoriesCalled == null) {
                getStoriesCalled = false;
            }
            if (topPicks == null && recommendedStories == null && !getStoriesCalled) {
        %>
        <script>
            window.location.replace("StoryController?submit=getStoriesForReaderLandingPage");
        </script>
        <% } %>

        <div id="navbar-container">
            <nav class="navbar navbar-expand-lg navbar-dark bg-black">
                <div class="container">
                    <button class="btn btn-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar" aria-expanded="false" style="position: absolute; left: 0;">
                        <i class="bi bi-list"></i> <!-- More Icon -->
                    </button>
                    <div class="container-fluid">
                        <a class="navbar-brand" href="http://localhost:8080/RIPClientMaven/">
                            <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                            READERS ARE INNOVATORS
                        </a>
                    </div>
                    <div class="d-flex align-items-center">
                        <form  action="StoryController" method="post">
                            <input class="form-control me-2" type="search" placeholder="Search for titles, genres, blurbs..." aria-label="Search" name="searchValue" required>
                            <input type="hidden" name="submit" value="searchForGenreAndStories">
                        </form>
                    </div>
                </div>
            </nav>
        </div>

        <div class="space"></div>
        <%
            if (user != null) {
        %>
        
        <%
            if (message != null) {
        %>
        <div class="alert alert-primary mt-5" role="alert">
            <h4 class="alert-heading"><%= message%></h4>
        </div> 
        <%
            }
        %>
        
        <div class="other-space"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (favouriteStories != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;">Your Favourite Stories</h3>

            <!-- Favourite Stories Swiper -->
            <div class="container">
                <swiper-container class="favourites-swiper-container" speed="500" navigation="true" space-between="10" slides-per-view="auto" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : favouriteStories) {
                    %>
                    <swiper-slide class="favourites-swiper-slide">
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="topPicks"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (topPicks != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;">Top Picks</h3>

            <!-- Top Picks Swiper -->
            <div class="container" >
                <swiper-container initialSlide="4" speed="300" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : topPicks) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="recommendedStories"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (recommendedStories != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;">Recommended Based On Your Favourite Genres</h3>

            <!-- Top Picks Swiper -->
            <div class="container" >
                <swiper-container initialSlide="4" speed="300" class="recommendedStories" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : recommendedStories) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="mostViewed"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (mostViewed != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;">Most Viewed Stories This Month</h3>

            <!-- Top Picks Swiper -->
            <div class="container" >
                <swiper-container initialSlide="4" speed="300" class="mostViewed" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : mostViewed) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="highestRated"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (highestRated != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;">Highest Rated Stories This Month</h3>

            <!-- Top Picks Swiper -->
            <div class="container" >
                <swiper-container initialSlide="4" speed="300" class="highestRated" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : highestRated) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="genre1"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (genre1 != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;"><%=genre1.getName()%> Stories</h3>

            <!-- Top Picks Swiper -->
            <div class="container">
                <swiper-container initialSlide="4" speed="300" class="genre1" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : genre1Stories) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="genre2"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (genre2 != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;"><%=genre2.getName()%> Stories</h3>

            <!-- Top Picks Swiper -->
            <div class="container">
                <swiper-container initialSlide="4" speed="300" class="genre2" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : genre2Stories) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space" id="genre3"></div>
        
        <div class="container mt-5">
            <div class="other-space"></div>
            <%
                if (genre3 != null) {
            %>

            <!-- Spacing -->
            <h3 class="text-center" style="color: white;"><%=genre3.getName()%> Stories</h3>

            <!-- Top Picks Swiper -->
            <div class="container">
                <swiper-container initialSlide="4" speed="300" class="genre3" navigation="true" space-between="10" slides-per-view="5" loop="true" mousewheel="true" effect="coverflow">
                    <%
                        for (Story story : genre3Stories) {
                    %>
                    <swiper-slide>
                        <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                            <div class="card text-white bg-black">
                                <%
                                    if (story.getImage() != null) {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="data:image/jpg;base64,<%=Base64.getEncoder().encodeToString(ArrayUtils.toPrimitive(story.getImage()))%>" alt="Book Image">
                                <%
                                } else {
                                %>
                                <img class="card-img-top card-img-top-fixed" src="book.svg" alt="Book Image">
                                <%
                                    }
                                %>
                                <div class="card-body">
                                    <h5 class="card-title"><%=story.getTitle()%></h5>
                                </div>
                            </div>
                        </a>
                    </swiper-slide>
                    <%
                        }
                    %>
                </swiper-container>
            </div>
            <%
                }
            %>
        </div>
        
        <div class="other-space"></div>

        <!-- Profile Pop Up Modal -->
        <!-- Modal Profile Details -->
        <div class="modal fade" id="profileDetails" aria-labelledby="profileDetails" tabindex="-1" style="display: none; color: white;" aria-hidden="true">
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
                    <div class="modal-footer">
                        <button class="btn btn-primary" data-bs-target="#profileForm" data-bs-toggle="modal">Edit Profile</button>
                        <%
                            if (writer == null) {
                        %>
                        <button class="btn btn-primary" data-bs-target="#applicationForm" data-bs-toggle="modal">Apply To Become A Writer</button>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Profile Edit Form -->
        <div class="modal fade" id="profileForm" aria-labelledby="profileForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content bg-dark text-white">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel2">Update Profile</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ReaderController" method="post">
                            <div class="mb-3">
                                <label for="name" class="col-form-label">First Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="<%=user.getName()%>">
                            </div>
                            <div class="mb-3">
                                <label for="surname" class="col-form-label">Last Name</label>
                                <input type="text" class="form-control" id="surname" name="surname" value="<%=user.getSurname()%>">
                            </div>
                            <div class="mb-3">
                                <label for="email" class="col-form-label">Email</label>
                                <input type="email" class="form-control" id="email"name="email" value="<%=user.getEmail()%>">
                            </div>
                            <div class="mb-3">
                                <label for="phoneNumber" class="col-form-label">Phone Number</label>
                                <input type="tel" pattern="[0-9]{3}[0-9]{3}[0-9]{4}" maxlength="10" minlength="10" class="form-control" id="phoneNumber" name="phoneNumber" value="<%=user.getPhoneNumber()%>">
                            </div>
                            <div class="mb-3">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Password..." minlength="8" maxlength="16">
                            </div>
                            <div class="mb-3">
                                <label for="passwordRepeat" class="visually-hidden">Repeat-Password</label>
                                <input type="password" class="form-control" id="passwordRepeat" name="passwordRepeat" placeholder="Repeat Password..." minlength="8" maxlength="16">
                            </div>
                            <input type="hidden" name="submit" value="updateReader">
                            <input type="hidden" name="currentPage" value="ReaderLandingPage.jsp">
                            <button type="submit" class="btn btn-primary mb-3">Save Changes</button>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <div class="btn-group" role="group">
                            <button class="btn btn-primary" data-bs-target="#profileDetails" data-bs-toggle="modal">Profile Details</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
            if (writer == null) {
        %>
        <!-- Modal Writer Application Form -->
        <div class="modal fade" id="applicationForm" aria-labelledby="applicationForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content bg-dark text-white">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel2">Apply To Be A Writer</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="ApplicationController" method="post">
                            <div class="row mb-3">
                                <textarea class="form-control" placeholder="Please enter your motivation to become a writer here..." name="motivation" id="motivation" style="height: 100px"></textarea>
                                <label for="motivation" class="col-form-label">Motivation</label>
                            </div>
                            <input type="hidden" name="submit" value="applyForWriter">
                            <button type="submit" class="btn btn-primary mb-3">Submit Application</button>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <div class="btn-group" role="group">
                            <button class="btn btn-primary" data-bs-target="#profileDetails" data-bs-toggle="modal">Profile Details</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%
            }
        %>
        <!-- End Of Modal -->
        <%
        } else {
        %>
        <div class="alert alert-primary mt-5" role="alert">
            <h4 class="alert-heading">You are not currently logged in.</h4>
        </div> 
        <%
            }
        %>

        <!-- Modal Refer Friend Form -->
        <div class="modal fade" id="referFriend" aria-labelledby="referFriend" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content bg-dark text-white">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel2">Share Our Platform!</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="MessageController" method="post">
                        <div class="modal-body">
                            <div class="row mb-3">
                                <label for="name" class="col-form-label mb-3">Name</label>
                                <input type="text" class="form-control" id="name" name="name">
                            </div>
                            <div class="row mb-3">
                                <label for="email" class="col-form-label mb-3">Email</label>
                                <input type="email" class="form-control" id="email"name="email">
                            </div>
                            <div class="row mb-3">
                                <label for="phoneNumber" class="col-form-label mb-3">Phone Number</label>
                                <input type="tel" pattern="[0-9]{3}[0-9]{3}[0-9]{4}" maxlength="10" minlength="10" class="form-control" id="phoneNumber" name="phoneNumber">
                            </div>
                            <input type="hidden" name="currentPage" value="ReaderLandingPage.jsp">
                            <input type="hidden" name="submit" value="sendReferralEmail">
                        </div>
                        <div class="modal-footer">
                            <div class="btn-group" role="group">
                                <button type="submit" class="btn btn-primary mb-3">Send</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>


        <!-- Side Bar Menu -->
        <div class="offcanvas offcanvas-start text-bg-dark" tabindex="-1" id="sidebar" aria-labelledby="sidebar">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasExampleLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <div class="d-grid" style="text-align: left;">
                    <%
                        if (user != null && (user.getUserType().equals("R") || user.getUserType().equals("W"))) {
                    %>
                    <!-- Button trigger profile modal -->
                    <button type="button" class="btn btn-dark text-start" data-bs-toggle="modal" data-bs-target="#profileDetails">
                        <i class="bi bi-person-fill"></i> Profile
                    </button>
                    <a class="btn btn-dark text-start" href="LoginController?submit=logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                    <%
                        }
                    %>
                    <%
                        if (writer != null) {
                    %>
                    <a class="btn btn-dark text-start" href="StoryController?submit=manageStories"><i class="bi bi-book"></i> Manage Stories</a>
                    <%
                        }
                    %>
                    <button class="btn btn-dark text-start" type="button" data-bs-toggle="modal" data-bs-target="#referFriend"><i class="bi bi-share"></i> Share</button>
                    <%
                        if (topPicks != null) {
                    %>
                    <button role="button" class="btn btn-dark text-start" type="button" onclick="scrollToTop()"> <i class="bi bi-caret-right-fill"></i> Favourite Stories</button>
                    <%
                        }
                    %>

                    <script>
                        function scrollToTop() {
                            document.body.scrollTop = 0;
                            document.documentElement.scrollTop = 0;
                        }
                    </script>
                    <%
                        if (topPicks != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#topPicks"><i class="bi bi-caret-right-fill"></i> Top Picks</a>
                    <%
                        }
                    %>
                    
                    <%
                        if (recommendedStories != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#recommendedStories"><i class="bi bi-caret-right-fill"></i> Recommended Stories</a>
                    <%
                        }
                    %>

                    <%
                        if (mostViewed != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#mostViewed"><i class="bi bi-caret-right-fill"></i> Most Viewed</a>
                    <%
                        }
                    %>

                    <%
                        if (highestRated != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#highestRated"><i class="bi bi-caret-right-fill"></i> Highest Rated</a>
                    <%
                        }
                    %>

                    <%
                        if (genre1 != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#genre1"><i class="bi bi-caret-right-fill"></i> <%=genre1.getName()%></a>
                    <%
                        }
                    %>

                    <%
                        if (genre2 != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#genre2"><i class="bi bi-caret-right-fill"></i> <%=genre2.getName()%></a>
                    <%
                        }
                    %>

                    <%
                        if (genre3 != null) {
                    %>
                    <a role="button" class="btn btn-dark text-start" href="#genre3"><i class="bi bi-caret-right-fill"></i> <%=genre3.getName()%></a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </body>
</html>
