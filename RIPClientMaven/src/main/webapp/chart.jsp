<%@ page import="java.util.List" %>
<%@ page import="org.json.JSONArray" %>

<%


    if ((Integer) request.getAttribute("chartNumber") != null && (List<String>) request.getAttribute("dataLabels") != null && (List<Number>) request.getAttribute("dataValues") != null && (String) request.getAttribute("dataLabelString") != null && (String) request.getAttribute("valueLabelString") != null) {
        JSONArray dataLabelsJsonArray = new JSONArray((List<String>) request.getAttribute("dataLabels"));
        JSONArray dataValuesJsonArray = new JSONArray((List<Number>) request.getAttribute("dataValues"));
        
    if ((Integer) request.getAttribute("chartNumber") == null) {
            dataLabelsJsonArray = null;
            dataValuesJsonArray = null;
        }
%>
<canvas id="dataChart<%= (int) request.getAttribute("chartNumber") %>"></canvas>
<script>
    var dataLabels<%= (int) request.getAttribute("chartNumber") %> = <%= dataLabelsJsonArray %>;
    var dataValues<%= (int) request.getAttribute("chartNumber") %> = <%= dataValuesJsonArray %>;

    var ctx<%= (int) request.getAttribute("chartNumber") %> = document.getElementById('dataChart<%= (int) request.getAttribute("chartNumber") %>').getContext('2d');
    var chart<%= (int) request.getAttribute("chartNumber") %> = new Chart(ctx<%= (int) request.getAttribute("chartNumber") %>, {
        type: 'bar',
        data: {
            labels: dataLabels<%= (int) request.getAttribute("chartNumber") %>,
            datasets: [{
                label: '<%= (String) request.getAttribute("valueLabelString")%>',
                data: dataValues<%= (int) request.getAttribute("chartNumber") %>,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '<%= (String) request.getAttribute("valueLabelString") %>'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: '<%= (String) request.getAttribute("dataLabelString") %>'
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                title: {
                    display: true,
                    text: '<%= (String) request.getAttribute("charttitle") %>',
                    position: 'top',
                    font: {
                        size: 16,
                        weight: 'bold'
                    }
                }
            }
        }
    });
</script>
<%
    } else {
%>
<p>No data to display</p>
<% } %>
