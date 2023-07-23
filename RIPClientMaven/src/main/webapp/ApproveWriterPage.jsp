<%-- 
    Document   : ApproveWriterPage
    Created on : 20 Jun 2023, 14:53:44
    Author     : faiza
--%>

<%@page import="Utils.GetProperties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.*"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Approve Writer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <style>
        body{
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
        }

        /* Custom CSS to fix the navbar position */
        #navbar-container {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1;
        }

        body{
            background-color: #333333;
        }

        .space {
            /* Adjust the margin-top as per your requirement */
            margin-bottom: 75px; /* Adjust the margin-bottom as per your requirement */
        }
        .space-one{
            margin-bottom: 30px;
        }

        .other-space {
            margin-bottom: 40px;
        }

        .space-div{
            height: 80px;
        }

        .welcome{
            background-color: #333333;
            color: white;
        }
    </style>
    <body>
        <%
            GetProperties properties = new GetProperties("config.properties");
            String clientUrl = properties.get("clientUrl");
            Account user = (Account) request.getSession(false).getAttribute("user");
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


        <div class="other-space"></div>
        <%
            if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))) {
                String message = (String) request.getAttribute("message");
                List<Application> applications = (List<Application>) request.getAttribute("applications");
        %>
        <%
            if (message != null) {
        %>
        <div class="alert alert-primary mx-auto mt-5" role="alert">
            <h4 class="alert-heading"><%= message%></h4>
        </div>
        <%
            }
        %>
        <%
            if (applications != null && !applications.isEmpty()) {
        %>
        <div class="container mt-5">
            <div class="row mt-3">
                <h2 class="text-center text-white">Approve Writer Applications</h2>
                <form action="ApplicationController" method="get">
                    <table class="table">
                        <thead class="table-dark">
                            <tr>
                                <th></th>
                                <th>Name</th>
                                <th>Surname</th>
                                <th>Motivation To Become Writer</th>
                            </tr>
                        </thead>
                        <%-- Iterate over the list of applications and display their details --%>
                        <%
                            for (Application app : applications) {
                        %>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="form-check">
                                        <input name="readerIds" class="form-check-input" type="checkbox" value="<%=app.getReaderId()%>" id="<%=app.getReaderId()%>">
                                        <label class="form-check-label" for="<%=app.getReaderId()%>"></label>
                                    </div>
                                </td>
                                <td><%=app.getReaderName()%></td>
                                <td><%=app.getReaderSurname()%></td>
                                <td><%=app.getMotivation()%></td>
                            </tr>
                        </tbody>
                        <%
                            }
                        %>
                    </table>
                    <div class="btn-group">
                        <button type="submit" name="submit" value="approveApplications" class="btn btn-primary">Approve Applications</button>
                        <button type="submit" name="submit" value="rejectApplications" class="btn btn-primary">Reject Applications</button>
                    </div>
                </form>
            </div>
        </div>

        <%
        } else {
        %>
        <div class="alert alert-primary mx-auto my-auto" role="alert">
            <h4 class="alert-heading">There are currently applications to approve.</h4>
        </div>
        <%
            }
        %>
        
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
