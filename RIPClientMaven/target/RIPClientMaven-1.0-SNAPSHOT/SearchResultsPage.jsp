<%-- 
    Document   : SearchResultsPage
    Created on : 20 Jun 2023, 19:19:09
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
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Reader Landing Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">

        <style>
            /* Custom CSS to fix the navbar position */
            #navbar-container {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 9999;
            }

            body {
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            }

            .card {
                border-radius: 5px; /* Round the card corners */
                transition: transform 0.3s;
                color: white; /* Set the card text color to white */
                background-color: black;
            }

            .card:hover {
                transform: translateY(-5px);
                border-color: #007bff; /* Add blue border color on hover */
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.5); /* Add blue box shadow on hover */
            }

            .card-fixed {
                height: 400px; /* Adjust the height as per your requirement */
            }

            .card-genre {
                height: 100px; /* Adjust the height as per your requirement */
            }

            .card-img-top-fixed {
                width: 100%;
                height: 250px; /* Adjust the height as per your requirement */
                object-fit: cover;
            }

            .space {
                /* Adjust the margin-top as per your requirement */
                margin-bottom: 100px; /* Adjust the margin-bottom as per your requirement */
            }
            
            .otherspace {
                /* Adjust the margin-top as per your requirement */
                margin-bottom: 60px; /* Adjust the margin-bottom as per your requirement */
            }
        </style>

    </head>
    <body>
        <%
            Account user = null;
            if (request.getSession(false) != null) {
                user = (Account) request.getSession(false).getAttribute("user");
            }
            String homePageUrl = "http://localhost:8080/RIPClientMaven/";
            if (user != null && (user.getUserType().equals("R") || user.getUserType().equals("W"))) {
                homePageUrl += "ReaderLandingPage.jsp";
            } else {
                homePageUrl += "index.jsp";
            }
            List<Genre> genresFromSearch = (List<Genre>) request.getAttribute("genresFromSearch");
            List<Story> storiesFromSearch = (List<Story>) request.getAttribute("storiesFromSearch");
            String searchValue = (String) request.getAttribute("searchValue");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            Integer offsetAmount = 20;
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
                        <form  action="StoryController" method="post">
                            <input class="form-control me-2" type="search" placeholder="Search for genres, titles, blurbs..." aria-label="Search" name="searchValue" required>
                            <input type="hidden" name="submit" value="searchForGenreAndStories">
                        </form>
                    </div>
                </div>
            </nav>
        </div>

        <div class="space"></div>
        <%
            if (storiesFromSearch != null && !storiesFromSearch.isEmpty()) {
        %>

        <div class="space"></div>
        <div class="container mt-5">
            <!-- Spacing -->
            <h3 class="text-center book-title" style="color: white;">Search Results In Stories</h3>
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4">

                <%
                    for (Story story : storiesFromSearch) {
                %>
                <a style="text-decoration: none;" href="StoryController?submit=viewStory&storyId=<%=story.getId()%>">
                    <div class="col">
                        <div class="card card-fixed">
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
                    </div>
                </a>
                <%
                    }
                %>
            </div>

            <div class="btn-group mt-5 mb-5 d-flex justify-content-center">
                <%
                    if (pageNumber != null && pageNumber > 0) {
                %>
                <a class="btn btn-primary ms-2" href="StoryController?submit=nextPageOfStorySearchResults&searchValue=<%= searchValue%>&pageNumber=<%=(pageNumber - 1)%>&currentId=<%=storiesFromSearch.get(0).getId()%>&next=false">Previous</a>
                <%
                    }
                %>
                <%
                    if (storiesFromSearch.size() == offsetAmount) {
                %>
                <a class="btn btn-primary ms-2" href="StoryController?submit=nextPageOfStorySearchResults&searchValue=<%= searchValue%>&pageNumber=<%=(pageNumber + 1)%>&currentId=<%=storiesFromSearch.get(storiesFromSearch.size() - 1).getId()%>&next=true">Next</a>
                <%
                    }
                %>
            </div>

        </div>
        <%
        } else if (pageNumber > 0) {
        %>
        <h4>No more results found for "<%=searchValue%>".</h4>
        <div class="btn-group mt-5 mb-5 mx-auto">
            <a class="btn btn-primary ms-2" href="StoryController?submit=nextPageOfStorySearchResults&searchValue=<%= searchValue%>&pageNumber=<%=(pageNumber - 1)%>&currentId=<%=storiesFromSearch.get(0).getId()%>&next=false">Previous</a>
        </div>
        <%
            }
        %>

        <%
            if (genresFromSearch != null && !genresFromSearch.isEmpty()) {
        %>
        <div class="container mt-5">
            <!-- Spacing -->
            <h3 class="text-center book-title" style="color: white;">Search Results In Genres</h3>
            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
                <%
                    for (Genre genre : genresFromSearch) {
                %>
                <div class="col">
                    <div class="card card-genre">
                        <div class="card-body">
                            <h5 class="card-title"><%=genre.getName()%></h5>
                            <a href="StoryController?submit=viewAllStoriesInGenre&genreId=<%=genre.getId()%>&genreName=<%=genre.getName()%>" class="btn btn-primary">View Stories</a>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>

        </div>
        <div class="otherspace"></div>
        <%
            }
        %>
        <%
            if (storiesFromSearch == null && genresFromSearch == null && pageNumber == 0) {
        %>
        <h3 class="text-center" style="color: white;">No results found for "<%=searchValue%>".</h3>
        <%
            }
        %>
    </body>
</html>
