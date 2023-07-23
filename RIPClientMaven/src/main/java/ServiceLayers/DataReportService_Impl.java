package ServiceLayers;

import Models.Editor;
import Models.Genre;
import Models.Story;
import Models.Writer;
import Utils.GetProperties;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.ProcessingException;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriBuilder;
import java.io.IOException;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DataReportService_Impl implements DataReportService_Interface {

    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;
    private HashMap<String, Object> params;

    public DataReportService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("dataReportUri");
    }

    @Override
    public Integer getStoryLikesByDate(Integer storyId, String startDate, String endDate) {
        String storyLikesPath = uri + "getStoryLikesByDate";

        // Build the query parameters
        URI storyLikesUri = UriBuilder.fromPath(storyLikesPath)
                .queryParam("storyId", storyId)
                .queryParam("startDate", startDate)
                .queryParam("endDate", endDate)
                .build();
        webTarget = client.target(storyLikesUri);
        
        // Perform the HTTP GET request
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Integer.class);
            } else {
                System.err.println("Failed to retrieve story likes by date. Response status: " + response.getStatus());
                return null; // or throw an exception
            }
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public List<Story> getMostLikedStories(Integer numberOfStories, String startDate, String endDate) {
        List<Story> listOfStories = null;
        try {
            String mostLikedStoriesPath = uri + "getMostLikedStories";

            // Build the query parameters
            URI mostLikedStoriesUri = UriBuilder.fromPath(mostLikedStoriesPath)
                    .queryParam("numberOfStories", numberOfStories)
                    .queryParam("startDate", startDate)
                    .queryParam("endDate", endDate)
                    .build();
            webTarget = client.target(mostLikedStoriesUri);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get most liked stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                listOfStories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return listOfStories;

        } catch (ProcessingException | IllegalStateException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Story> getMostViewedStoriesInATimePeriod(Integer numberOfEntries, String startDate, String endDate) {
        List<Story> listOfStories = null;
        try {
            String mostViewedStoriesPath = uri + "getMostViewedStories";

            // Build the query parameters
            URI mostViewedStoriesUri = UriBuilder.fromPath(mostViewedStoriesPath)
                    .queryParam("numberOfEntries", numberOfEntries)
                    .queryParam("startDate", startDate)
                    .queryParam("endDate", endDate)
                    .build();
            webTarget = client.target(mostViewedStoriesUri);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get most viewed stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                listOfStories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return listOfStories;
        } catch (ProcessingException | IllegalStateException ex) {
            // Handle exceptions related to the HTTP request or response processing
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }

    }

    @Override
    public Integer getTheViewsOnAStoryInATimePeriod(Integer storyId, String startDate, String endDate) {
        String storyViewsPath = uri + "getStoryViewsByDate";

        // Build the query parameters
        URI storyViewsUri = UriBuilder.fromPath(storyViewsPath)
                .queryParam("storyId", storyId)
                .queryParam("startDate", startDate)
                .queryParam("endDate", endDate)
                .build();
        webTarget = client.target(storyViewsUri);

        // Perform the HTTP GET request
        response = webTarget.request().get();

        try {
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to retrieve the views on this story in this time period. Response status: " + response.getStatus());
            }

            return response.readEntity(Integer.class);
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public List<Story> getTopHighestRatedStoriesInTimePeriod(String startDate, String endDate, Integer numberOfEntries) {
        List<Story> listOfStories = null;
        try {
            String topRatedStoriesPath = uri + "getTopHighestRatedStories";

            // Build the query parameters
            URI topRatedStoriesUri = UriBuilder.fromPath(topRatedStoriesPath)
                    .queryParam("numberOfEntries", numberOfEntries)
                    .queryParam("startDate", startDate)
                    .queryParam("endDate", endDate)
                    .build();
            webTarget = client.target(topRatedStoriesUri);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to retrieve highest rated stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                listOfStories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return listOfStories;

        } catch (ProcessingException | IllegalStateException ex) {
            // Handle exceptions related to the HTTP request or response processing
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public Double getAverageRatingOfAStoryInATimePeriod(Integer storyId, String startDate, String endDate) {
        String storyRatingPath = uri + "getStoryRatingByDate";

        // Build the query parameters
        URI storyRatingUri = UriBuilder.fromPath(storyRatingPath)
                .queryParam("startDate", startDate)
                .queryParam("endDate", endDate)
                .queryParam("storyId", storyId)
                .build();
        webTarget = client.target(storyRatingUri);

        // Perform the HTTP GET request
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                String responseBody = response.readEntity(String.class);
                try {
                    return Double.parseDouble(responseBody);
                } catch (NumberFormatException ex) {
                    Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Unable to parse the response body as a Double: " + responseBody, ex);
                    return null;
                }
            } else {
                System.err.println("Failed to retrieve the rating. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Writer> getTopWriters(Integer numberOfWriters) {
        List<Writer> topWriters = null;
        try {
            String topWritersUri = uri + "getTopWriters/{numberOfWriters}";
            // Build the query parameters
            webTarget = client.target(topWritersUri).resolveTemplate("numberOfWriters", numberOfWriters);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get top writers. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                topWriters = mapper.readValue(responseStr, new TypeReference<List<Writer>>(){});
            }
            return topWriters;

        } catch (ProcessingException | IllegalStateException ex) {
            // Handle exceptions related to the HTTP request or response processing
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Genre> getTopGenres(String startDate, String endDate, Integer numberOfEntries) {
        List<Genre> listOfTopGenres = null;
        try {
            String topRatedStoriesPath = uri + "getTopGenres";

            //build query
            URI topRatedStoriesUri = UriBuilder.fromPath(topRatedStoriesPath)
                    .queryParam("startDate", startDate)
                    .queryParam("endDate", endDate)
                    .queryParam("numberOfEntries", numberOfEntries)
                    .build();
            webTarget = client.target(topRatedStoriesUri);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();        

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get top genres. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                listOfTopGenres = mapper.readValue(responseStr, new TypeReference<List<Genre>>(){});
            }
            return listOfTopGenres;
        } catch (ProcessingException | IllegalStateException ex) {
            // Handle exceptions related to the HTTP request or response processing
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public Integer getGenreViewsByDate(String startDate, String endDate, Integer genreId) {
        String genresViewsPath = uri + "getGenreViewsByDate";

        // Build the query
        URI genresViewsUri = UriBuilder.fromPath(genresViewsPath)
                .queryParam("startDate", startDate)
                .queryParam("endDate", endDate)
                .queryParam("genreId", genreId)
                .build();
        webTarget = client.target(genresViewsUri);

        // Perform the HTTP GET request
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Integer.class);
            } else {
                System.err.println("Failed to retrieve genre views by date. Response status: " + response.getStatus());
                return null;
            }
        } catch (ProcessingException ex) {
            // Log an error or handle the case when there is an exception during the request
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Exception occurred during the HTTP request: " + ex.getMessage(), ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

@Override
public Integer getTotalViewsByWriterId(Integer writerId) {
    String totalViewsByWriterIdUri = uri + "getTotalViewsByWriterId/{writerId}";

    // Build the query parameters
    webTarget = client.target(totalViewsByWriterIdUri).resolveTemplate("writerId", writerId);

    // Perform the HTTP GET request
    response = webTarget.request().get();

    try {
        if (response.getStatus() == Response.Status.OK.getStatusCode()) {
            return response.readEntity(Integer.class);
        } else {
            System.err.println("Failed to retrieve total views by writer ID. Response status: " + response.getStatus());
            return null;
        }
    } catch (ProcessingException ex) {
        // Log an error or handle the case when there is an exception during the request
        Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);

        return null;
    } finally {
        if (response != null) {
            response.close();
        }
    }
}

    @Override
    public List<Editor> getTopEditors(Integer numberOfEntries) {
        List<Editor> topEditors = null;
        try {
            String topEditorsUri = uri + "getTopEditors/{numberOfEntries}";

            // Build the query parameters
            webTarget = client.target(topEditorsUri).resolveTemplate("numberOfEntries", numberOfEntries);

            // Perform the HTTP GET request
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get top editors. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                topEditors = mapper.readValue(responseStr, new TypeReference<List<Editor>>(){});
            }
             return topEditors;

        } catch (ProcessingException | IllegalStateException ex) {
            // Handle exceptions related to the HTTP request or response processing
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } catch (IOException ex) {
            Logger.getLogger(DataReportService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            // Close the response to release resources
            if (response != null) {
                response.close();
            }
        }
    }
}
