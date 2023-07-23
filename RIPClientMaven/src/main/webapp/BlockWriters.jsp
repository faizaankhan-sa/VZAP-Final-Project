<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Block Writers</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <style>
            html,
            body {
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
                color: white;
            }
            .other-space{
                margin-bottom: 100px;
            }
            .head-title{
                padding-left: 30px;
            }

        </style>
    </head>
    <body>
        <!--navbar-->
        <div class="space-div"></div>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Account user = (Account) request.getSession(false).getAttribute("user");
            String message = (String) request.getAttribute("message");
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
                    <div class="d-flex align-items-center">
                        <%
                            if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))) {
                        %>
                        <!-- Button trigger profile modal -->
                        <%
                            }
                        %>
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

        <%
            List<Writer> writers = (List<Writer>) request.getAttribute("writers");
            String searchValue = (String) request.getAttribute("searchValue");
            Integer pageNumber = (Integer) request.getAttribute("pageNumber");
            Integer offsetAmount = 10;
        %>

        <%
            if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))) {
        %>
        <div class="container mt-5 bg-black">
            <%
                if (message != null) {
            %>
            <div class="other-space"></div>
            <div class="alert alert-primary mt-5" role="alert">
                <h4 class="alert-heading"><%= message%></h4>
            </div> 
            <%
                }
            %>
            <div class="head-title">
                <h1>Block Writers</h1>
                <p>Select writers to block below.</p>
            </div>
            <%
                if (writers != null) {
            %>
            <div class="container">
                <form class="d-flex p-2" action="WriterController" method="post">
                    <input class="form-control me-2" type="search" placeholder="Search for writer..." aria-label="Search" name="searchValue" required>
                    <input type="hidden" name="submit" value="searchForWriter">
                </form>
                <form action="WriterController" method="post" onsubmit="return validateForm()">
                    <div class="container mt-3">
                        <h2>Writers</h2>
                        <table class="table">
                            <thead class="table-dark">
                                <tr>
                                    <th></th>
                                    <th>First Name</th>
                                    <th>Last Name</th>
                                    <th>Email</th>
                                    <th>Phone Number</th>
                                    <th>Submitted Stories</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Writer writer : writers) {
                                %>
                                <tr>
                                    <td>
                                        <input class="form-check-input me-1" type="checkbox" name="writerIds" value="<%=writer.getId()%>" id="<%=writer.getId()%>">
                                        <label class="form-check-label" for="<%=writer.getId()%>"></label>
                                    </td>
                                    <td><%=writer.getName()%></td>
                                    <td><%=writer.getSurname()%></td>
                                    <td><%=writer.getEmail()%></td>
                                    <td><%=writer.getPhoneNumber()%></td>
                                    <td><%=writer.getSubmittedStoryIds().size()%></td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="row">
                        <div class="col">
                            <input type="hidden" id="id" name="submit" value="blockWriters">
                            <input type="submit" class="btn btn-primary" value="Block Writers" >
                        </div>
                        <div class="col-5">
                        </div>
                        <div class="col">
                            <%if (pageNumber != null && pageNumber > 0) {%>
                            <a class="btn btn-primary" href="WriterController?submit=nextPageOfWriters<% if (searchValue != null) {%>&searchValue=<%=searchValue%><%}%>&currentId=<%= writers.get(0).getId()%>&pageNumber=<%=(pageNumber - 1)%>&next=false">Previous</a>
                            <%}%>
                            <%if (writers.size() == offsetAmount) {%>
                            <a class="btn btn-primary " href="WriterController?submit=nextPageOfWriters<% if (searchValue != null) {%>&searchValue=<%=searchValue%><%}%>&currentId=<%= writers.get(writers.size() - 1).getId()%>&pageNumber=<%=(pageNumber + 1)%>&next=true">Next</a>
                            <%}%>
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


        </div>

        <%
        } else {
        %>
        <div class="alert alert-danger mt-5" role="alert">
            No writers found.
        </div>
        <%
            }
        %>
    </div>
    <%
    } else {
    %>
    <div class="alert alert-danger mt-5" role="alert">
        You do not have permission to access this page.
    </div>
    <script>
        window.location.replace("<%=clientUrl%>");
    </script>
    <%
        }
    %>

    <script>
        function validateForm() {
            var checkboxes = document.querySelectorAll('input[type="checkbox"]');
            var checkedOne = Array.prototype.slice.call(checkboxes).some(x => x.checked);

            if (!checkedOne) {
                alert("Please select at least one writer to block.");
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
