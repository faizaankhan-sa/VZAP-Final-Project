<%@page import="Models.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Data Report</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
        <link href="https://getbootstrap.com/docs/5.3/assets/css/docs.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
        <style>


            /* Custom CSS to fix the navbar position */
            #navbar-container {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 9999;
            }

            .content-container {
                padding-top: 10px; /* Adjust the padding value as needed */
            }

            .card {
                border: 1px solid #ddd;
                border-radius: 5px;
                transition: transform 0.3s;
            }

            .card:hover {
                transform: translateY(-5px);
                border-color: #007bff;
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.5);
            }

            .card-fixed {
                height: 400px;
            }

            .card-img-top-fixed {
                width: 100%;
                height: 250px;
                object-fit: cover;
            }

            body{
                background: linear-gradient(180deg, #0d0d0d, #111111, #0d0d0d);
                color: white;
            }

            .other-space {
                margin-top: 50px;
                margin-bottom: 100px;
            }

            .canvas {
                width: 100%;
                max-width: 600px;
            }


        </style>
    </head>

    <body>
        <%
            Account user = (Account) request.getSession(false).getAttribute("user");
        %>
        <nav class="navbar navbar-expand-lg navbar-dark bg-black fixed-top">
            <div class="container">
                <a class="navbar-brand" href="http://localhost:8080/RIPClientMaven/EditorLandingPage.jsp">
                    <img src="book.svg" alt="Book Icon" class="me-2" width="24" height="24" style="filter: invert(1)">
                    READERS ARE INNOVATORS
                </a>
            </div>
        </nav>

        <%
            String message = (String) request.getAttribute("message");
            List<String> chartIds = (List<String>) request.getAttribute("chartIds");
            List<String> chartTitles = (List<String>) request.getAttribute("chartTitles");
            List<String> chartDataValuesAxisNames = (List<String>) request.getAttribute("chartDataValuesAxisNames");
            List<String> chartDataLabelsAxisNames = (List<String>) request.getAttribute("chartDataLabelsAxisNames");
            List<List<String>> chartDataLabels = (List<List<String>>) request.getAttribute("chartDataLabels");
            List<List<String>> chartDataValues = (List<List<String>>) request.getAttribute("chartDataValues");
            List<Table> tables = new ArrayList<>();
        %>
        <%
            if (message == null) {
        %>
        <%
            if (user != null && (user.getUserType().equals("E") || user.getUserType().equals("A"))) {
        %>
        
        
        <div class="other-space"></div>
        <div class="container mt-5">

            <h3>Data Report Charts</h3>

            <%
                for (int i = 0; i < chartIds.size(); i++) {
            %>

            <h4><%= chartTitles.get(i)%></h4>
            <canvas class="canvas" id="<%= chartIds.get(i)%>"></canvas>

            <%
                }
            %>

            <script>
                function generateChart(chartId, dataLabels, dataValues, dataLabelString, valueLabelString, chartTitle) {
                    console.log(chartId);
                    console.log(dataLabels);
                    console.log(dataValues);
                    console.log(dataLabelString);
                    console.log(valueLabelString);
                    console.log(chartTitle);

                    var canvas = document.getElementById(chartId);
                    var ctx = canvas.getContext("2d");

                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: dataLabels,
                            datasets: [{
                                    label: valueLabelString,
                                    data: dataValues,
                                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                                    borderColor: 'rgba(75, 192, 192, 1)',
                                    borderWidth: 2
                                }]
                        },
                        options: {
                            animation: {
                                onComplete: () => {
                                    delayed = true;
                                },
                                delay: (context) => {
                                    let delay = 0;
                                    if (context.type === 'data' && context.mode === 'default' && !delayed) {
                                        delay = context.dataIndex * 200;
                                    }
                                    return delay;
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    title: {
                                        display: true,
                                        text: valueLabelString
                                    }
                                },
                                x: {
                                    title: {
                                        display: true,
                                        text: dataLabelString
                                    }
                                }
                            },
                            plugins: {
                                legend: {
                                    display: false
                                },
                                title: {
                                    display: true,
                                    text: chartTitle,
                                    position: 'top',
                                    font: {
                                        size: 16,
                                        weight: 'bold',
                                        align: 'center'
                                    }
                                }
                            }
                        }
                    });
                }

                function downloadTables() {
                    var tables = document.getElementById("tablesContainer");
                    var printWindow = window.open('', '', 'left=0, top=0, width=800, height=500, toolbar=0, scrollbars=0, status=0');
                    printWindow.document.head.innerHTML = document.head.innerHTML;
                    printWindow.document.body.innerHTML = tables.innerHTML;
                    printWindow.document.close();
                    printWindow.focus();
                    printWindow.print();
                }
                <%
                    for (int i = 0; i < chartIds.size(); i++) {
                %>
                var dataLabels = <%= new JSONArray(chartDataLabels.get(i))%>;
                var dataValues = <%= new JSONArray(chartDataValues.get(i))%>;
                var dataLabelString = '<%=(String) chartDataLabelsAxisNames.get(i)%>';
                var valueLabelString = '<%=(String) chartDataValuesAxisNames.get(i)%>';
                var chartTitle = '<%= chartTitles.get(i)%>';
                var chartId = '<%= chartIds.get(i)%>';
                generateChart(chartId, dataLabels, dataValues, dataLabelString, valueLabelString, chartTitle);
                <%
                        //create the tables here:
                        Table table = new Table();
                        //Populate Table Title
                        table.setTableName(chartTitles.get(i));
                        //Populate Table Columns
                        table.setColumns(List.of(chartDataLabelsAxisNames.get(i), chartDataValuesAxisNames.get(i)));
                        //Populate Table Rows
                        table.setData(List.of(chartDataLabels.get(i), chartDataValues.get(i)));
                        table.setNumberOfRows(chartDataLabels.get(i).size());
                        tables.add(table);
                    }
                %>
            </script>
        </div>
        <div class="container mt-5" id="tablesContainer">
            <h3>Data Report Tables</h3>
            <%
                for (Table table : tables) {
            %>
            <h4><%= table.getTableName()%></h4>
            <table class="table mt-3 mb-3" id="<%= table.getTableName()%>">
                <thead class="table-dark">
                    <tr>
                        <th>#</th>
                            <%
                                for (String column : table.getColumns()) {
                            %>
                        <th><%= column%></th>
                            <%
                                }
                            %>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (int i = 0; i < table.getNumberOfRows(); i++) {


                    %>
                    <tr>
                        <td><%=(i + 1)%></td>
                        <%
                            for (List<String> columnData : table.getData()) {
                        %>
                        <td><%= columnData.get(i)%></td>
                        <%
                            }
                        %>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                }
            %>
        </div>
        <div class="mb-3 mt-4 text-center">
            <button type="button" id="printTables" class="btn btn-primary" onclick="downloadTables()">Download PDF</button>
        </div>

        <%
        } else {
        %>
        <div class="alert alert-primary mx-auto my-auto" role="alert">
            <h4 class="alert-heading">You are not currently logged in.</h4>
        </div> 
        <script>
            window.location.replace("http://localhost:8080/RIPClientMaven/");
        </script>
        <%
            }
        %>
        <%
            } else {
        %>
        <div class="other-space">
        </div>
        <div class="alert alert-primary mt-5" role="alert">
            <h4 class="alert-heading"><%=message%></h4>
        </div>
        <%
            }
        %>
    </body>
</html>
