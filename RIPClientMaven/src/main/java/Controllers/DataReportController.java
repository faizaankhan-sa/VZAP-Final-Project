package Controllers;

import Models.Editor;
import Models.Genre;
import Models.Story;
import Models.Writer;
import ServiceLayers.DataReportService_Impl;
import ServiceLayers.DataReportService_Interface;
import ServiceLayers.EditorService_Impl;
import ServiceLayers.EditorService_Interface;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DataReportController", urlPatterns = {
    "/DataReportController"
})
public class DataReportController extends HttpServlet {

    private DataReportService_Interface dataReportService;
    private EditorService_Interface editorService;

    public DataReportController() {
        this.dataReportService = new DataReportService_Impl();
        this.editorService = new EditorService_Impl();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String submitAction = request.getParameter("submit");
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String message = "";
        if (submitAction == null) {
            request.getRequestDispatcher("datareport.jsp").forward(request, response);
        } else {
            switch (submitAction) {
                case "showcharts":
                    LocalDate startDate;
                    LocalDate endDate;
                    LocalDateTime startDateTime;
                    LocalDateTime endDateTime;
                    List<String> chartIds = new ArrayList<>();
                    List<String> chartTitles = new ArrayList<>();
                    List<String> chartDataValuesAxisNames = new ArrayList<>();
                    List<String> chartDataLabelsAxisNames = new ArrayList<>();
                    List<List<String>> chartDataLabels = new ArrayList<>();
                    List<List<String>> chartDataValues = new ArrayList<>();

                    String[] reportSelectionArray = request.getParameterValues("reportOptions");
                    List<String> reportSelection = new ArrayList<>();
                    if (reportSelectionArray!=null) {
                        reportSelection = Arrays.asList(reportSelectionArray);
                    }

                    System.out.println("Report Selection: " + reportSelection);

                    // Getting the editors with the most approvals
                    if (reportSelection.contains("topEditors")) {
                        chartIds.add("topEditorsChart");
                        chartDataLabelsAxisNames.add("Name of editor");
                        chartDataValuesAxisNames.add("Number of approvals");
                        chartTitles.add("The editors with the most approvals");

                        Integer numberOfEditors = 3;
                        List<Editor> listOfEditors = dataReportService.getTopEditors(numberOfEditors);

                        List<String> editorNames = new ArrayList<>();
                        List<String> topEditorApprovalCounts = new ArrayList<>();

                        if (listOfEditors == null) {
                            listOfEditors = new ArrayList<>();
                        }

                        for (Editor topEditor : listOfEditors) {
                            editorNames.add(topEditor.getName());
                            topEditorApprovalCounts.add(String.valueOf(topEditor.getApprovalCount()));
                        }
                        chartDataLabels.add(editorNames);
                        chartDataValues.add(topEditorApprovalCounts);
                    }

                    // Getting the stories with the most likes
                    if (reportSelection.contains("mostLikedStories") && request.getParameter("monthOfMostLikedStories") != null) {
                        //get the month selected
                        Integer monthSelected = Integer.valueOf(request.getParameter("monthOfMostLikedStories"));

                        //get the appropriate start and end date of that month
                        startDate = LocalDate.of(LocalDate.now().getYear(), monthSelected, 1);
                        endDate = LocalDate.of(LocalDate.now().getYear(), monthSelected, LocalDate.now().withMonth(monthSelected).lengthOfMonth());

                        startDateTime = startDate.atTime(0, 0, 0);
                        endDateTime = endDate.atTime(23, 59, 59);
                        Integer numberOfStories = 20;

                        //
                        chartIds.add("mostLikedStoriesChart");
                        chartDataLabelsAxisNames.add("Story");
                        chartDataValuesAxisNames.add("Number of likes");
                        chartTitles.add("The most liked stories");

                        List<Story> listOfStories;
                        List<String> storyTitles;
                        List<String> listOfNumberOfStoryLikes;

                        listOfStories = dataReportService.getMostLikedStories(numberOfStories, startDateTime.format(outputFormatter), endDateTime.format(outputFormatter));

                        if (listOfStories == null) {
                            listOfStories = new ArrayList<>();
                        }

                        storyTitles = new ArrayList<>();
                        listOfNumberOfStoryLikes = new ArrayList<>();

                        for (Story topStory : listOfStories) {
                            storyTitles.add(topStory.getTitle());
                            listOfNumberOfStoryLikes.add(String.valueOf(dataReportService.getStoryLikesByDate(topStory.getId(),
                                    startDateTime.format(outputFormatter), endDateTime.format(outputFormatter))));
                        }

                        chartDataLabels.add(storyTitles);
                        chartDataValues.add(listOfNumberOfStoryLikes);
                    }

                    //Getting the top rated stories
                    if (reportSelection.contains("mostRatedStories")) {
                        Integer numberOfTopRatedStories = 20;

                        chartIds.add("mostRatedStoriesChart");
                        chartDataLabelsAxisNames.add("Story");
                        chartDataValuesAxisNames.add("Average rating");
                        chartTitles.add("Top rated stories");

                        List<Story> listOfTopRatedStories;
                        List<String> topRatedStoryTitles = new ArrayList<>();
                        List<String> listOfAverageRatings = new ArrayList<>();

                        startDate = LocalDate.now().withDayOfMonth(1);
                        endDate = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());

                        startDateTime = startDate.atStartOfDay();
                        endDateTime = endDate.atTime(23, 59, 59);

                        listOfTopRatedStories = dataReportService.getTopHighestRatedStoriesInTimePeriod(startDateTime.format(outputFormatter), endDateTime.format(outputFormatter), numberOfTopRatedStories);

                        if (listOfTopRatedStories == null) {
                            listOfTopRatedStories = new ArrayList<>();
                        }

                        for (Story topRatedStory : listOfTopRatedStories) {
                            topRatedStoryTitles.add(topRatedStory.getTitle());
                            listOfAverageRatings.add(String.valueOf(dataReportService.getAverageRatingOfAStoryInATimePeriod(topRatedStory.getId(), startDateTime.format(outputFormatter), endDateTime.format(outputFormatter))));

                        }

                        chartDataLabels.add(topRatedStoryTitles);
                        chartDataValues.add(listOfAverageRatings);
                    }

                    //Getting the top writers
                    if (reportSelection.contains("topWriters")) {
                        Integer numberOfTopWriters = 30;
                        chartIds.add("topWritersChart");
                        chartDataLabelsAxisNames.add("Writer");
                        chartDataValuesAxisNames.add("Number of views");
                        chartTitles.add("The top writers");

                        List< Writer> listOfTopWriters = dataReportService.getTopWriters(numberOfTopWriters);

                        if (listOfTopWriters == null) {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "No writers found");
                            return;
                        }

                        List<String> writerNames = new ArrayList<>();
                        List<String> listOfNumberOfStories = new ArrayList<>();

                        for (Writer topWriter : listOfTopWriters) {
                            writerNames.add(topWriter.getName());
                            listOfNumberOfStories.add(String.valueOf(dataReportService.getTotalViewsByWriterId(topWriter.getId())));
                        }

                        chartDataLabels.add(writerNames);
                        chartDataValues.add(listOfNumberOfStories);
                    }

                    //Getting the top genres
                    if (reportSelection.contains("topGenres")) {
                        Integer numberOfTopGenres = 3;

                        chartIds.add("topGenresChart");
                        chartDataLabelsAxisNames.add("Genre");
                        chartDataValuesAxisNames.add("Number of views");
                        chartTitles.add("The top genres");

                        List<Genre> listOfTopGenres;
                        List<String> genreNames;
                        List<String> listOfNumberOfGenreViews;

                        startDate = LocalDate.now().withDayOfMonth(1);
                        endDate = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth());

                        startDateTime = startDate.atStartOfDay();
                        endDateTime = endDate.atTime(23, 59, 59);

                        listOfTopGenres = dataReportService.getTopGenres(startDateTime.format(outputFormatter), endDateTime.format(outputFormatter), numberOfTopGenres);

                        if (listOfTopGenres == null) {
                            listOfTopGenres = new ArrayList<>();
                        }

                        genreNames = new ArrayList<>();
                        listOfNumberOfGenreViews = new ArrayList<>();

                        for (Genre topGenre : listOfTopGenres) {
                            genreNames.add(topGenre.getName());
                            listOfNumberOfGenreViews.add(String.valueOf(dataReportService.getGenreViewsByDate(startDateTime.format(outputFormatter), endDateTime.format(outputFormatter), topGenre.getId())));
                        }

                        chartDataLabels.add(genreNames);
                        chartDataValues.add(listOfNumberOfGenreViews);
                    }

                    if (reportSelection.contains("mostViewedStories")) {
                        //Getting the most viewed stories
                        Integer numberOfStoriess = 10;
                        String startDateString = request.getParameter("startDate");
                        String endDateString = request.getParameter("endDate");

                        startDate = null;
                        endDate = null;

                        try {
                            startDate = LocalDate.parse(startDateString);
                            endDate = LocalDate.parse(endDateString);
                        } catch (DateTimeParseException e) {
                            Logger.getLogger(DataReportController.class.getName()).log(Level.SEVERE, "Error occurred while checking if the view is already added", e);
                            return;
                        }

                        startDateTime = startDate.atStartOfDay();
                        endDateTime = endDate.atTime(23, 59, 59);
                        if (startDateTime.isBefore(endDateTime)) {
                            chartIds.add("mostViewedStoriesChart");
                            chartDataLabelsAxisNames.add("Story");
                            chartDataValuesAxisNames.add("Number of views");
                            chartTitles.add("The most viewed stories");

                            List<Story> listOfStories = dataReportService.getMostViewedStoriesInATimePeriod(numberOfStoriess, startDateTime.format(outputFormatter), endDateTime.format(outputFormatter));
                            List<String> storyTitless;
                            List<String> listOfNumberOfStoryViews;

                            if (listOfStories == null) {
                                listOfStories = new ArrayList<>();
                            }

                            storyTitless = new ArrayList<>();
                            listOfNumberOfStoryViews = new ArrayList<>();

                            for (Story topStory : listOfStories) {
                                storyTitless.add(topStory.getTitle());
                                listOfNumberOfStoryViews.add(String.valueOf(dataReportService.getTheViewsOnAStoryInATimePeriod(topStory.getId(), startDateTime.format(outputFormatter), endDateTime.format(outputFormatter))));
                            }

                            chartDataLabels.add(storyTitless);
                            chartDataValues.add(listOfNumberOfStoryViews);
                        } else {
                            message += "Start date selected for most viewed stories cannot be after end date.<br>";
                        }
                    }

                    System.out.println(chartIds);
                    System.out.println(chartTitles);
                    System.out.println(chartDataValuesAxisNames);
                    System.out.println(chartDataLabelsAxisNames);
                    System.out.println(chartDataLabels);
                    System.out.println(chartDataValues);

                    if (!message.isEmpty()) {
                        request.setAttribute("message", message);
                    }
                    request.setAttribute("chartIds", chartIds);
                    request.setAttribute("chartTitles", chartTitles);
                    request.setAttribute("chartDataValuesAxisNames", chartDataValuesAxisNames);
                    request.setAttribute("chartDataLabelsAxisNames", chartDataLabelsAxisNames);
                    request.setAttribute("chartDataLabels", chartDataLabels);
                    request.setAttribute("chartDataValues", chartDataValues);
                    request.getRequestDispatcher("datareport.jsp").forward(request, response);
                    break;
                case "goToDataReportTables":

                    break;
                default:
                    request.getRequestDispatcher("datareport.jsp").forward(request, response);
            }
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
