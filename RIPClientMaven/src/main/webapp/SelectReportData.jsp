<%--
    Document   : SelectReportData
    Created on : 29 Jun 2023, 15:15:51
    Author     : Jarrod
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Data Report</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function validateForm() {
    var checkboxes = document.getElementsByName('reportOptions');
    var startDate = document.getElementById('startDate');
    var endDate = document.getElementById('endDate');
    var monthSelect = document.getElementsByName('monthOfMostLikedStories')[0];
    var monthOfMostLikedStories = '';

    if (monthSelect.selectedIndex !== 0) {
        monthOfMostLikedStories = monthSelect.value;
    }

    var selectedDatesRequired = false;
    var mostLikedStoriesChecked = false;

    if (checkboxes.length == 0) {
            alert("Please select a data report option.");
            return false;
}

    for (var i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i].checked) {
            if (checkboxes[i].value === 'mostViewedStories') {
                selectedDatesRequired = true;
            }
            if (checkboxes[i].value === 'mostLikedStories') {
                mostLikedStoriesChecked = true;
            }
        }
    }

    if (selectedDatesRequired) {
        if (startDate.value === '' || endDate.value === '') {
            alert('Please enter both Start Date and End Date.');
            return false;
        }

        var startDateObj = new Date(startDate.value);
        var endDateObj = new Date(endDate.value);

        if (startDateObj >= endDateObj) {
            alert('End Date must be greater than Start Date.');
            return false;
        }
    }

    if (mostLikedStoriesChecked && monthOfMostLikedStories === '') {
        alert('Please select a month for Most Liked Stories.');
        return false;
    }

    return true;
}
</script>


        <style>
            .other-space {
                margin-bottom: 75px;
            }
            body {
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
                color: white;
            }
        </style>
    </head>
    <body>
        <% 
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Account user = (Account) request.getSession(false).getAttribute("user");
            String message = (String) request.getAttribute("message");
        %>

        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <a class="navbar-brand position-relative" href="<%=clientUrl%>EditorLandingPage.jsp">
                    <img src="book.svg" alt="Book Icon" class="me-2 " width="24" height="24" style="filter: invert(1)">READERS ARE INNOVATORS</a>
                <% if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))){ %>
                
                <% }%>
        </nav>

        <div class="other-space"></div>
        <% if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))) { %>
        <div class="container mt-5">
            <div class="row mt-5">
                <h3>Generate Data Report</h3>
                <form action="DataReportController" method="post" onsubmit="return validateForm()">
                    <div class="col-auto">
                        <div class="mb-3">
                            <div class="form-check">
                                <input name="reportOptions" class="form-check-input" type="checkbox" value="mostViewedStories" id="mostViewedStories">
                                <label class="form-check-label" for="mostViewedStories">
                                    Top 10 Most Viewed Stories
                                </label>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <label class="form-label" for="startDate">Start Date</label>
                                    <input class="form-control" type="date" id="startDate" name="startDate">
                                </div>
                                <div class="col">
                                    <label class="form-label" for="endDate">End Date</label>
                                    <input class="form-control" type="date" id="endDate" name="endDate">
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input name="reportOptions" class="form-check-input" type="checkbox" value="mostRatedStories" id="mostRatedStories">
                                <label class="form-check-label" for="mostRatedStories">
                                    Top 20 Most Rated Stories Of The Month
                                </label>
                            </div>
                        </div>

<div class="mb-3">
    <div class="form-check">
        <input name="reportOptions" class="form-check-input" type="checkbox" value="mostLikedStories" id="mostLikedStories">
        <label class="form-check-label" for="mostLikedStories">
            Top 20 Most Liked Stories
        </label>
    </div>
           <select name="monthOfMostLikedStories" class="form-select mt-2" aria-label="monthOfMostLikedStories">
    <option value="" disabled selected>Select a month</option>
    <option value="1">January</option>
    <option value="2">February</option>
    <option value="3">March</option>
    <option value="4">April</option>
    <option value="5">May</option>
    <option value="6">June</option>
    <option value="7">July</option>
    <option value="8">August</option>
    <option value="9">September</option>
    <option value="10">October</option>
    <option value="11">November</option>
    <option value="12">December</option>
</select>


</div>




                        <div class="mb-3">
                            <div class="form-check">
                                <input name="reportOptions" class="form-check-input" type="checkbox" value="topGenres" id="topGenres">
                                <label class="form-check-label" for="topGenres">
                                    Top 3 Genres Of The Month
                                </label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input name="reportOptions" class="form-check-input" type="checkbox" value="topWriters" id="topWriters">
                                <label class="form-check-label" for="topWriters">
                                    Top 30 Writers Of All Time (Based on views)
                                </label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input name="reportOptions" class="form-check-input" type="checkbox" value="topEditors" id="topEditors">
                                <label class="form-check-label" for="topEditors">
                                    Top 3 Editors Of All Time
                                </label>
                            </div>
                        </div>

                        <div class="mb-3">
                            <input type="hidden" name="submit" value="showcharts">
                            <button type="submit" class="btn btn-primary mb-3">Generate Reports</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-primary mx-auto my-auto" role="alert">
            <h4 class="alert-heading">You are not currently logged in.</h4>
        </div>
        <script>
            window.location.replace("h<%=clientUrl%>");
        </script>
        <% } %>
    </body>
</html>
