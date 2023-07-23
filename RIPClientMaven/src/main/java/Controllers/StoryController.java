package Controllers;

import Models.*;
import ServiceLayers.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import org.apache.commons.lang3.ArrayUtils;

/**
 *
 * @author Jarrod
 */
@WebServlet(name = "StoryController", urlPatterns = {"/StoryController"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class StoryController extends HttpServlet {

    private Reader reader;
    private Writer writer;
    private Editor editor;
    private Account user;
    private StoryService_Interface storyService;
    private GenreService_Interface genreService;
    private CommentService_Interface commentService;
    private LikeService_Interface likeService;
    private RatingService_Interface ratingService;
    private ViewService_Interface viewService;
    private MailService_Interface mailService;
    private EditorService_Interface editorService;
    private DataReportService_Interface dataReportService;
    private DateTimeFormatter outputFormatter;
    private String message;
    private Integer storyId;

    public StoryController() {
        this.storyService = new StoryService_Impl();
        this.genreService = new GenreService_Impl();
        this.commentService = new CommentService_Impl();
        this.likeService = new LikeService_Impl();
        this.ratingService = new RatingService_Impl();
        this.viewService = new ViewService_Impl();
        this.mailService = new MailService_Impl();
        this.editorService = new EditorService_Impl();
        this.dataReportService = new DataReportService_Impl();
        this.outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        this.reader = null;
        this.writer = null;
        this.editor = null;
        this.message = null;
        this.storyId = null;
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("user") != null) {
            user = ((Account) request.getSession(false).getAttribute("user"));
            switch (user.getUserType()) {
                case "R":
                    reader = (Reader) user;
                    break;
                case "W":
                    writer = (Writer) user;
                    reader = writer;
                    break;
                case "E":
                    editor = (Editor) user;
                    break;
                case "A":
                    editor = (Editor) user;
                    break;
                default:
                    throw new AssertionError();
            }
        } else {
//            request.setAttribute("message", "You are currently not logged in.");
//            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        switch (request.getParameter("submit")) {
            case "viewStory":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                if (reader != null) {
                    request.setAttribute("userRating", ratingService.getRating(reader.getId(), storyId));
                    request.setAttribute("userViewedStory", viewService.viewExists(reader.getId(), storyId));;
                }
                request.setAttribute("story", storyService.getStory(storyId));
                request.setAttribute("comments", commentService.getAllCommentForStory(storyId));
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);
                break;

            case "readStory":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                View view = new View();
                view.setReaderId(reader.getId());
                view.setStoryId(storyId);
                viewService.addView(view);
                request.setAttribute("story", storyService.getStory(storyId));
                request.getRequestDispatcher("ReadStory.jsp").forward(request, response);
                break;

            case "likeStory":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                Integer readerId = ((Reader) user).getId();
                Like like = new Like();
                like.setReaderId(readerId);
                like.setStoryId(storyId);
                reader.getFavouriteStoryIds().add(storyId);
                
                request.setAttribute("userViewedStory", true);
                request.setAttribute("userRating", ratingService.getRating(reader.getId(), storyId));
                request.setAttribute("message", likeService.addLike(like));
                request.setAttribute("story", storyService.getStory(storyId));
                request.setAttribute("comments", commentService.getAllCommentForStory(storyId));
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);

                break;
            case "unlikeStory":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                readerId = reader.getId();
                like = new Like();
                like.setReaderId(readerId);
                like.setStoryId(storyId);
                reader.getFavouriteStoryIds().remove(storyId);

                request.setAttribute("userViewedStory", true);
                request.setAttribute("userRating", ratingService.getRating(reader.getId(), storyId));
                request.setAttribute("message", likeService.deleteLike(like));
                request.setAttribute("story", storyService.getStory(storyId));
                request.setAttribute("comments", commentService.getAllCommentForStory(storyId));
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);

                break;
            case "rateStory":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                readerId = reader.getId();
                Rating rating = new Rating();
                rating.setReaderId(readerId);
                rating.setStoryId(storyId);
                rating.setValue(Integer.valueOf(request.getParameter("rate")));
                if (Boolean.parseBoolean(request.getParameter("isAdding"))) {
                    request.setAttribute("message", ratingService.addRating(rating));
                } else {
                    request.setAttribute("message", ratingService.updateRatingValue(rating));
                }

                request.setAttribute("userViewedStory", true);
                request.setAttribute("userRating", ratingService.getRating(readerId, storyId));
                request.setAttribute("story", storyService.getStory(storyId));
                request.setAttribute("comments", commentService.getAllCommentForStory(storyId));
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);
                break;

            case "commentStory":
                readerId = reader.getId();
                storyId = Integer.valueOf(request.getParameter("storyId"));
                String commentMessage = request.getParameter("comment");
                Comment comment = new Comment();
                comment.setMessage(commentMessage);
                comment.setName(request.getParameter("name"));
                comment.setSurname(request.getParameter("surname"));
                comment.setReaderId(readerId);
                comment.setStoryId(storyId);

                request.setAttribute("userViewedStory", true);
                request.setAttribute("message", commentService.addComment(comment));
                request.setAttribute("userRating", ratingService.getRating(readerId, storyId));
                request.setAttribute("story", storyService.getStory(storyId));
                request.setAttribute("comments", commentService.getAllCommentForStory(storyId));
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);
                break;

            case "viewAllStoriesInGenre":
                Integer genreId = Integer.valueOf(request.getParameter("genreId"));
                String genreName = request.getParameter("genreName");
                request.setAttribute("storiesInGenre", storyService.getStoriesInGenre(genreId, 20, 0, true));
                request.setAttribute("genreName", genreName);
                request.setAttribute("genreId", genreId);
                request.setAttribute("pageNumber", 0);
                request.getRequestDispatcher("ViewStoriesInGenre.jsp").forward(request, response);
                break;
            case "nextPageOfStoriesInGenre":
                Boolean nextValues = Boolean.valueOf(request.getParameter("next"));
                genreId = Integer.valueOf(request.getParameter("genreId"));
                genreName = request.getParameter("genreName");
                Integer pageNumber = Integer.valueOf(request.getParameter("pageNumber"));
                Integer currentId = Integer.valueOf(request.getParameter("currentId"));
                request.setAttribute("storiesInGenre", storyService.getStoriesInGenre(genreId, 20, currentId, nextValues));
                request.setAttribute("genreName", genreName);
                request.setAttribute("genreId", genreId);
                request.setAttribute("pageNumber", pageNumber);
                request.getRequestDispatcher("ViewStoriesInGenre.jsp").forward(request, response);
                break;
            case "nextPageOfStorySearchResults":
                nextValues = Boolean.valueOf(request.getParameter("next"));
                String searchValue = request.getParameter("searchValue");
                pageNumber = Integer.valueOf(request.getParameter("pageNumber"));
                currentId = Integer.valueOf(request.getParameter("currentId"));
                request.setAttribute("storiesFromSearch", storyService.searchForStories(searchValue, 20, currentId, nextValues));
                request.setAttribute("searchValue", searchValue);
                request.setAttribute("pageNumber", pageNumber);
                request.getRequestDispatcher("SearchResultsPage.jsp").forward(request, response);
                break;
            case "searchForGenreAndStories":
                searchValue = request.getParameter("searchValue");
                if (isAlphaAndNumericOnly(searchValue)) {
                    request.setAttribute("storiesFromSearch", storyService.searchForStories(searchValue, 20, 0, true));
                    request.setAttribute("genresFromSearch", genreService.searchForGenres(searchValue));
                }
                request.setAttribute("pageNumber", 0);
                request.setAttribute("searchValue", searchValue);
                request.getRequestDispatcher("SearchResultsPage.jsp").forward(request, response);
                break;

            case "goToSelectStoriesToEdit":
                request.setAttribute("submittedStories", storyService.getSubmittedStories(20, 0));
                request.getRequestDispatcher("SelectStoryToEdit.jsp").forward(request, response);
                break;

            case "approveEditedStoryFromEditor":
                editor.setApprovalCount(editor.getApprovalCount() + 1);
                message = editorService.updateEditor(editor);
                Story story = new Story();
                story.setApproved(Boolean.TRUE);
                story.setSubmitted(Boolean.TRUE);
                if (request.getParameter("commentsEnabled") != null) {
                    story.setCommentsEnabled(Boolean.TRUE);
                } else {
                    story.setCommentsEnabled(Boolean.FALSE);
                }
                System.out.println("Updating a story.");
                Integer authorId = Integer.valueOf(request.getParameter("authorId"));
                storyId = Integer.valueOf(request.getParameter("storyId"));
                story.setId(storyId);
                story.setAuthorId(authorId);
                message += mailService.notifyWriterOfStorySubmission(authorId, Boolean.TRUE);
                Part filePart = request.getPart("image");
                if (filePart.getSize() > 0) {
                    try (InputStream fis = filePart.getInputStream()) {
                        String fileName = filePart.getSubmittedFileName();
                        byte[] imageData = new byte[(int) filePart.getSize()];
                        fis.read(imageData);
                        Byte[] image = ArrayUtils.toObject(imageData);
                        story.setImage(image);
                        story.setImageName(fileName.substring(fileName.indexOf(".")));
                    }
                } else {
                    story.setImage(ArrayUtils.toObject(Base64.getDecoder().decode(request.getParameter("encodedImage"))));
                    System.out.println("Used original image for story.");
                }
                story.setTitle(request.getParameter("title"));
                story.setContent(request.getParameter("story"));
                story.setBlurb(request.getParameter("summary"));
                List<Genre> genres = genreService.getAllGenres();
                List<Integer> genreIds = new ArrayList<>();
                for (Genre genre : genres) {
                    if (request.getParameter(String.valueOf(genre.getId())) != null) {
                        genreIds.add(genre.getId());
                    }
                }
                story.setGenreIds(genreIds);
                if (genreIds.isEmpty()) {
                    message += "<br>Failed to update story: Please select genres for this story.";
                } else if (validateWordCount(1000, story.getContent()) || validateWordCount(250, story.getBlurb())) {
                    message += "<br>Failed to update story: Max number of words exceeded";
                } else {
                    message += "<br>" + storyService.updateStory(story);
                    System.out.println("Updated story.");
                }
                request.setAttribute("message", message);
                request.setAttribute("submittedStories", storyService.getSubmittedStories(20, 0));
                request.getRequestDispatcher("SelectStoryToEdit.jsp").forward(request, response);
                break;

            case "submitStoryFromSelectStoryToEditPage":

                storyId = Integer.valueOf(request.getParameter("storyId"));
                story = storyService.getStory(storyId);
                if (validateWordCount(1000, story.getContent()) || validateWordCount(250, story.getBlurb())) {
                    message = "Failed to create story: Max number of words for story is 1000 and 250 for your summary.";
                } else {
                    editor.setApprovalCount(editor.getApprovalCount() + 1);
                    message = editorService.updateEditor(editor);
                    story.setApproved(Boolean.TRUE);
                    story.setRejected(Boolean.FALSE);
                    message += mailService.notifyWriterOfStorySubmission(story.getAuthorId(), Boolean.TRUE) + "<br>" + storyService.updateStory(story);

                }
                request.setAttribute("message", message);
                request.setAttribute("submittedStories", storyService.getSubmittedStories(20, 0));
                request.getRequestDispatcher("SelectStoryToEdit.jsp").forward(request, response);
                break;

            case "rejectStoryFromEditor":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                story = storyService.getStory(storyId);
                story.setRejected(Boolean.TRUE);
                message = mailService.notifyWriterOfStorySubmission(story.getAuthorId(), Boolean.FALSE);
                request.setAttribute("message", message + "<br>" + storyService.updateStory(story));
                request.setAttribute("submittedStories", storyService.getSubmittedStories(20, 0));
                request.getRequestDispatcher("SelectStoryToEdit.jsp").forward(request, response);
                break;

            case "goToEditStoryPage":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                story = storyService.getStory(storyId);
                request.setAttribute("story", story);
                request.getRequestDispatcher("EditStoryPage.jsp").forward(request, response);
                break;

            case "getStoriesForLandingPage":
                List<Genre> topGenres = dataReportService.getTopGenres(LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter), 10);
                if (topGenres != null) {
                    request.setAttribute("genre1", topGenres.get(0));
                    request.setAttribute("genre2", topGenres.get(1));
                    request.setAttribute("genre3", topGenres.get(2));
                    request.setAttribute("genre1Stories", storyService.getStoriesInGenre(topGenres.get(0).getId(), 10, 0, true));
                    request.setAttribute("genre2Stories", storyService.getStoriesInGenre(topGenres.get(1).getId(), 10, 0, true));
                    request.setAttribute("genre3Stories", storyService.getStoriesInGenre(topGenres.get(2).getId(), 10, 0, true));
                }
                request.setAttribute("getStoriesCalled", true);
                request.setAttribute("highestRated", dataReportService.getTopHighestRatedStoriesInTimePeriod(LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter), 10));
                request.setAttribute("mostViewed", dataReportService.getMostViewedStoriesInATimePeriod(10, LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter)));
                request.setAttribute("topPicks", dataReportService.getMostLikedStories(10, LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter)));
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;

            case "getStoriesForReaderLandingPage":
                request.setAttribute("getStoriesForReaderLandingPageCalled", Boolean.TRUE);
                if (reader != null) {
                    List<Story> favouriteStories = new ArrayList<>();
                    for (Integer favStoryId : reader.getFavouriteStoryIds()) {
                        favouriteStories.add(storyService.getStory(favStoryId));
                    }
                    request.setAttribute("favouriteStories", favouriteStories);
                }
                topGenres = dataReportService.getTopGenres(LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter), 10);
                if (topGenres != null) {
                    request.setAttribute("genre1", topGenres.get(0));
                    request.setAttribute("genre2", topGenres.get(1));
                    request.setAttribute("genre3", topGenres.get(2));
                    request.setAttribute("genre1Stories", storyService.getStoriesInGenre(topGenres.get(0).getId(), 10, 0, true));
                    request.setAttribute("genre2Stories", storyService.getStoriesInGenre(topGenres.get(1).getId(), 10, 0, true));
                    request.setAttribute("genre3Stories", storyService.getStoriesInGenre(topGenres.get(2).getId(), 10, 0, true));
                }
                request.setAttribute("highestRated", dataReportService.getTopHighestRatedStoriesInTimePeriod(LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter), 10));
                request.setAttribute("mostViewed", dataReportService.getMostViewedStoriesInATimePeriod(10, LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter)));
                request.setAttribute("topPicks", dataReportService.getMostLikedStories(10, LocalDate.now().minusMonths(1).atStartOfDay().format(outputFormatter), LocalDate.now().atStartOfDay().format(outputFormatter)));
                if (reader != null) {
                    request.setAttribute("recommendedStories", storyService.getRecommendations(reader.getFavouriteGenreIds()));
                    request.getRequestDispatcher("ReaderLandingPage.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                }
                break;

            case "manageStories":
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;
            case "addStory":
                story = new Story();
                if (request.getParameter("submitStory").equals("Save To Drafts")) {
                    story.setSubmitted(false);
                } else {
                    story.setSubmitted(true);
                }
                System.out.println("Adding a story.");
                if (writer != null) {
                    story.setAuthorId(writer.getId());
                } else {
                    System.out.println("Author was null.");
                }
                if (request.getParameter("commentsEnabled") != null) {
                    story.setCommentsEnabled(Boolean.TRUE);
                }
                filePart = request.getPart("image");
                if (filePart.getSize() > 0) {
                    try (InputStream fis = filePart.getInputStream()) {

                        byte[] imageData = new byte[(int) filePart.getSize()];
                        fis.read(imageData);
                        Byte[] image = ArrayUtils.toObject(imageData);
                        story.setImage(image);
                        String fileName = filePart.getSubmittedFileName();
                        story.setImageName(fileName.substring(fileName.indexOf(".")));
                    }
                } else {
                    System.out.println("Image was null.");
                }
                story.setTitle(request.getParameter("title"));
                story.setContent(request.getParameter("story"));
                story.setBlurb(request.getParameter("summary"));
                genres = genreService.getAllGenres();
                genreIds = new ArrayList<>();
                for (Genre genre : genres) {
                    if (request.getParameter(String.valueOf(genre.getId())) != null) {
                        genreIds.add(genre.getId());
                    }
                }
                story.setGenreIds(genreIds);
                if (genreIds.isEmpty()) {
                    message = "Failed to create story: Please select genres for your story.";
                } else if (validateWordCount(1000, story.getContent()) || validateWordCount(250, story.getBlurb())) {
                    message = "Failed to create story: Max number of words for story is 1000 and 250 for your summary.";
                } else {
                    message = storyService.addStory(story);
                }

                System.out.println("Finished adding a story.");
                request.setAttribute("message", message);
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;
            case "deleteStoryFromManageStoryPage":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                request.setAttribute("message", storyService.deleteStory(storyId));
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;
            case "updateEditedStoryFromWriter":
                String submitStory = request.getParameter("submitStory");
                System.out.println("Updating a story.");
                storyId = Integer.valueOf(request.getParameter("storyId"));
                story = storyService.getStory(storyId);
                if (submitStory.equals("Submit")) {
                    story.setSubmitted(Boolean.TRUE);
                } else {
                    story.setSubmitted(Boolean.FALSE);
                }
                if (request.getParameter("commentsEnabled") != null) {
                    story.setCommentsEnabled(Boolean.TRUE);
                } else {
                    story.setCommentsEnabled(Boolean.FALSE);
                }
                filePart = request.getPart("image");
                if (filePart.getSize() > 0) {
                    try (InputStream fis = filePart.getInputStream()) {
                        String fileName = filePart.getSubmittedFileName();
                        byte[] imageData = new byte[(int) filePart.getSize()];
                        fis.read(imageData);
                        Byte[] image = ArrayUtils.toObject(imageData);
                        story.setImage(image);
                        story.setImageName(fileName.substring(fileName.indexOf(".")));
                    }
                } else {
                    System.out.println("Used original image for story.");
                }
                story.setTitle(request.getParameter("title"));
                story.setContent(request.getParameter("story"));
                story.setBlurb(request.getParameter("summary"));
                genres = genreService.getAllGenres();
                genreIds = new ArrayList<>();
                for (Genre genre : genres) {
                    if (request.getParameter(String.valueOf(genre.getId())) != null) {
                        genreIds.add(genre.getId());
                    }
                }
                story.setGenreIds(genreIds);
                if (genreIds.isEmpty()) {
                    message = "Failed to update story: Please select genres for your story.";
                } else if (validateWordCount(1000, story.getContent()) || validateWordCount(250, story.getBlurb())) {
                    message = "Failed to update story: Max number of words for story is 1000 and 250 for your summary.";
                } else {
                    message = storyService.updateStory(story);
                    System.out.println("Updated story.");
                }
                request.setAttribute("message", message);
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;

            case "submitStoryFromWriter":
                storyId = Integer.valueOf(request.getParameter("storyId"));
                story = storyService.getStory(storyId);
                story.setSubmitted(Boolean.TRUE);
                request.setAttribute("message", storyService.updateStory(story));
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;

            case "moveStoriesToDrafts":
                List<Story> writerSubmittedStories = storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId());
                for (Story stry : writerSubmittedStories) {
                    if (request.getParameter(String.valueOf(stry.getId())) != null) {
                        stry.setSubmitted(false);
                        stry.setRejected(false);
                        stry.setApproved(false);
                    }
                }
                request.setAttribute("message", storyService.updateStories(writerSubmittedStories));
                request.setAttribute("submittedStories", storyService.getWritersSubmittedStories(writer.getSubmittedStoryIds(), writer.getId()));
                request.setAttribute("draftedStories", storyService.getWritersDraftedStories(writer.getDraftedStoryIds(), writer.getId()));
                request.getRequestDispatcher("ManageStory.jsp").forward(request, response);
                break;

            case "storyOfTheDay":
                request.setAttribute("readerName", request.getParameter("readerName"));
                Story storyOfTheDay = dataReportService.getMostViewedStoriesInATimePeriod(1, LocalDate.now().minusDays(1).atStartOfDay().format(outputFormatter), LocalDateTime.now().format(outputFormatter)).get(0);
                request.setAttribute("story", storyOfTheDay);
                request.getRequestDispatcher("DetailsPage.jsp").forward(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    public Boolean isAlphaAndNumericOnly(String searchValue) {
        Boolean alphaNumericOnly = true;
        for (int i = 0; i < searchValue.length(); i++) {
            if (!Character.isAlphabetic(searchValue.charAt(i)) && !Character.isDigit(searchValue.charAt(i)) && !Character.isWhitespace(searchValue.charAt(i))) {
                alphaNumericOnly = false;
            }
        }
        return alphaNumericOnly;
    }

    public Boolean validateWordCount(Integer maxNumberOfWords, String content) {
        return content.stripTrailing().stripLeading().split(" ").length > maxNumberOfWords;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
