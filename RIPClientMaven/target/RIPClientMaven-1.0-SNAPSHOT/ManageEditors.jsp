<%-- 
    Document   : ManageEditors
    Created on : 23 Jun 2023, 09:21:55
    Author     : Jarrod
--%>

<%@page import="jakarta.json.Json"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Models.*"%>
<%@page import="jakarta.json.JsonObject"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Manage Editors</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="jquery-3.7.0.min.js"></script>
    </head>
    <style>

        body {
            background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
            color: white;
        }

        .other-space{
            margin-bottom: 100px;
        }

        .modal-body {
            color: white;

        }

        .modal-footer {
            color: white;

        }

        .modal-header {
            color: white;

        }
        .smaller-table{
            width: 90%;

        }
    </style>
    <body>
        <%
            Account user = (Account) request.getSession(false).getAttribute("user");
        %>
        <!--navbar-->
        <div class="space-div"></div>
        <%
            String message = (String) request.getAttribute("message");
        %>

        <div id="navbar-container">
            <nav class="navbar navbar-expand-lg navbar-dark bg-black">
                <div class="container">
                    <button class="btn btn-dark" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar" aria-expanded="false" style="position: absolute; left: 0;">
                        <i class="bi bi-list"></i> <!-- More Icon -->
                    </button>
                    <div class="container-fluid">
                        <a class="navbar-brand position-relative" href="http://localhost:8080/RIPClientMaven/EditorLandingPage.jsp">
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
        %>
        <%!
            private JsonObject createEditorJsObj(Editor editor) {
                JsonObject editorJson = Json.createObjectBuilder()
                        .add("name", editor.getName())
                        .add("surname", editor.getSurname())
                        .add("email", editor.getEmail())
                        .add("phoneNumber", String.valueOf(editor.getPhoneNumber()))
                        .add("id", String.valueOf(editor.getId())).build();
                return editorJson;
            }
        %>
        <%-- Retrieve the list of editors from the request attribute --%>
        <%
            List<Editor> editors = (List<Editor>) request.getAttribute("editors");
        %>

        <%
            if (message != null) {
        %>
        <div class="alert alert-info mx-auto mt-5" role="alert">
            <h4 class="alert-heading"><%= message%></h4>
        </div>
        <%
            }
        %>
        <%-- Check if there are any editors available --%>
        <% if (editors != null) { %>
        <%-- Display the editor's details here --%>
        <div class="container mt-8 bg-black">
            <div class="row ">


                <h1>Manage Editors</h1>



                <div class="container other-space" style="display: flex; justify-content: center;">
                    <table class="smaller-table table">
                        <thead class="table-dark">
                            <tr>
                                <th></th>
                                <th>First Name</th>
                                <th>Last Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Approved Stories</th>
                            </tr>
                        </thead>
                        <%-- Iterate over the list of editors and display their details --%>
                        <%
                            for (Editor editor : editors) {
                                JsonObject editorJson = createEditorJsObj(editor);
                        %>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="mb-3">
                                        <input type="button" class="btn btn-primary editFormBtn" name="Edit" data-editor='<%= editorJson%>' value="Edit">
                                    </div>
                                    <div class="mb-3">
                                        <a class="btn btn-primary" href="EditorController?submit=deleteEditor&editorId=<%= editor.getId()%>" role="button">
                                            Delete
                                        </a>
                                    </div>
                                </td>
                                <td><%=editor.getName()%></td>
                                <td><%=editor.getSurname()%></td>
                                <td><%=editor.getEmail()%></td>
                                <td><%=editor.getPhoneNumber()%></td>
                                <td><%=editor.getApprovalCount()%></td>
                            </tr>
                        </tbody>
                        <%
                            }
                        %>
                    </table>
                </div>
                <div class="container text-center">
                    <div class="row">
                        <div class="col">

                        </div>
                        <div class="col">
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEditorForm">Add New Editor</button>
                        </div>
                        <div class="col">

                        </div>
                    </div>
                </div>

            </div>
        </div>
        <%
        } else {
        %>
        <div class="alert alert-primary mx-auto my-auto" role="alert">
            <h4 class="alert-heading">There are currently no editors on the system.</h4>
        </div>
        <%
            }
        %>

        <!-- Method to fill in editors details into modal-->
        <script type="text/javascript">
            $(document).ready(function () {
                $(".editFormBtn").click(function () {
                    console.log("Button clicked");
                    var editorString = $(this).data('editor');
                    console.log(editorString);
                    var editor = JSON.parse(JSON.stringify(editorString));
                    console.log(editor.name);
                    $("#editorNameInput").val(editor.name);
                    $("#editorSurnameInput").val(editor.surname);
                    $("#editorEmailInput").val(editor.email);
                    $("#editorPhoneNumberInput").val(editor.phoneNumber);
                    $("#editorId").val(editor.id);
                    $(".editorModal").modal("toggle");
                });
            });
        </script>



        <%-- Add a form here to add a new editor to the system --%>
        <div class="modal fade" id="addEditorForm" aria-labelledby="addEditorForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
                <form action="EditorController" method="post">
                    <div class="modal-content bg-dark">
                        <div class="modal-header bg-dark">
                            <h1 class="modal-title fs-5" id="editorForm">Add An Editor</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3 row">
                                <label for="name" class="col col-form-label">First Name</label>
                                <div class="col-8">
                                    <input type="text" class="form-control" id="name" name="name" required>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="surname" class="col col-form-label">Last Name</label>
                                <div class="col-8 text-white">
                                    <input type="text" class="form-control" id="surname" name="surname" required>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="email" class="col col-form-label">Email</label>
                                <div class="col-8">
                                    <input type="email" class="form-control" id="email" name="email" required>
                                </div>
                            </div>
                            <div class="mb-3 row">
                                <label for="phoneNumber" class="col col-form-label">Phone Number</label>
                                <div class="col-8">
                                    <input type="tel" class="form-control text-white" id="phoneNumber" name="phoneNumber" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="editorPassword" class="col-form-label">Password</label>
                                <input type="password" class="form-control" id="editorPassword" name="password" placeholder="Password..." minlength="8" maxlength="16">
                            </div>
                            <div class="mb-3">
                                <label for="editorPasswordRepeat" class="visually-hidden">Repeat-Password</label>
                                <input type="password" class="form-control" id="editorPasswordRepeat" name="passwordRepeat" placeholder="Repeat Password..." minlength="8" maxlength="16">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="hidden" name="submit" value="addEditor">
                            <button type="submit" class="btn btn-primary mb-3">Add Editor</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Modal to update an editors details -->
        <div class="modal fade editorModal" id="editorForm" aria-labelledby="editorForm" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable bg-dark">
                <div class="modal-content bg-dark">
                    <div class="modal-header bg-dark">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel2">Update Editor Details</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-bodybd-dark">
                        <form action="EditorController" method="post">
                            <div class="mb-3">
                                <label for="editorNameInput" class="col-form-label">First Name</label>
                                <input type="text" class="form-control" id="editorNameInput" name="name">
                            </div>
                            <div class="mb-3">
                                <label for="editorSurnameInput" class="col-form-label">Last Name</label>
                                <input type="text" class="form-control" id="editorSurnameInput" name="surname">
                            </div>
                            <div class="mb-3">
                                <label for="editorEmailInput" class="col-form-label">Email</label>
                                <input type="email" class="form-control" id="editorEmailInput"name="email">
                            </div>
                            <div class="mb-3">
                                <label for="editorPhoneNumberInput" class="col-form-label">Phone Number</label>
                                <input type="tel" pattern="[0-9]{3}[0-9]{3}[0-9]{4}" maxlength="10" minlength="10" class="form-control" id="editorPhoneNumberInput" name="phoneNumber">
                            </div>
                            <div class="mb-3">
                                <label for="editorPassword" class="col-form-label">Password</label>
                                <input type="password" class="form-control" id="editorPassword" name="password" placeholder="Password..." minlength="8" maxlength="16">
                            </div>
                            <div class="mb-3">
                                <label for="editorPasswordRepeat" class="visually-hidden">Repeat-Password</label>
                                <input type="password" class="form-control" id="editorPasswordRepeat" name="passwordRepeat" placeholder="Repeat Password..." minlength="8" maxlength="16">
                            </div>
                            <input type="hidden" name="editorId" id="editorId">
                            <input type="hidden" name="submit" value="updateEditor">
                            <button type="submit" class="btn btn-primary mb-3">Save Changes</button>
                        </form>
                    </div>
                    <div class="modal-footer">
                    </div>
                </div>
            </div>
        </div>
        <!-- Profile Pop Up Modal -->
        <!-- Modal -->
        <div class="modal fade" id="profileDetails" aria-labelledby="profileDetails" tabindex="-1" style="display: none;" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content bg-dark text-white">
                    <div class="modal-header bg-dark">
                        <h1 class="modal-title fs-5" id="exampleModalToggleLabel">Profile Details</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body bg-dark">
                        <img src="person-square.svg" alt="Profile" class="rounded-circle p-1 bg-primary" width="110">
                        <div class="mb-3 row">
                            <label for="name" class="col col-form-label">First Name</label>
                            <div class="col-8">
                                <input type="text" class="form-control-plaintext text-white" id="name" name="name" value="<%=user.getName()%>" readonly>
                            </div>
                        </div>
                        <div class="mb-3 row">
                            <label for="surname" class="col col-form-label">Last Name</label>
                            <div class="col-8">
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
            window.location.replace("http://localhost:8080/RIPClientMaven/");
        </script>
        <%
            }
        %>
    </body>
</html>
