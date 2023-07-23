/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.StoriesHolder;
import Models.Story;
import Utils.GetProperties;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
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

/**
 *
 * @author Jarrod
 */
public class StoryService_Impl implements StoryService_Interface {

    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public StoryService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("storiesUri");
    }

    @Override
    public Story getStory(Integer storyId) {
        String getStoryUri = uri + "getStory/{storyId}";
        webTarget = client.target(getStoryUri).resolveTemplate("storyId", storyId);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Story.class);
            } else {
                // Handle error response
                System.err.println("Failed to get story. Response status: " + response.getStatus());
                return null;

            }
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public List<Story> getAllStories() {
        List<Story> stories = null;
        try {
            String getAllStoriesUri = uri + "getAllStories";
            webTarget = client.target(getAllStoriesUri);
            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get all stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                stories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return stories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }



    @Override
    public List<Story> getStoriesInGenre(Integer genreId, Integer numberOfStories, Integer currentId, Boolean next) {
        List<Story> stories = null;
        try {
            String getStoriesInGenrePath = uri + "getStoriesInGenre";
            // Build the query parameters
            URI getStoriesInGenreUri = UriBuilder.fromPath(getStoriesInGenrePath)
                .queryParam("genreId", genreId)
                .queryParam("numberOfStories", numberOfStories)
                .queryParam("currentId", currentId)
                .queryParam("next", String.valueOf(next))
                .build();
            webTarget = client.target(getStoriesInGenreUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get stories in genre. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                stories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return stories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public String updateStory(Story story) {
        try {
            String updateStoryUri = uri + "updateStory";
            webTarget = client.target(updateStoryUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(story)));

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                // Handle error response
                System.err.println("Failed to update story. Response status: " + response.getStatus());
                return "Something went wrong updating the story on the system.";
            } else {
             return response.readEntity(String.class);

            }
            
        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong updating the story on the system.";
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public String deleteStory(Integer storyId) {
        String deleteStoryUri = uri + "deleteStory/{storyId}";
    try {
        webTarget = client.target(deleteStoryUri).resolveTemplate("storyId", storyId);
        response = webTarget.request().get();
        
        if (response.getStatus() == Response.Status.OK.getStatusCode()) {
            return response.readEntity(String.class);

            
        }else{
            System.err.println("Failed to delete story. Response status: " + response.getStatus());
            return "Failed to delete story.";
        }
    } finally {
        if (response != null) {
                response.close();
            }
    }
    }

    @Override
    public String addStory(Story story) {
        try {
            String addStoryUri = uri + "addStory";
            webTarget = client.target(addStoryUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(story)));
            return response.readEntity(String.class);

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong adding a story to the system.";
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Story> getTopPicks() {
        List<Story> stories = null;
        try {
            String getTopPicksUri = uri + "getTopPicks";
            webTarget = client.target(getTopPicksUri);
            response = webTarget.request().get();
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get top picks. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                stories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return stories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
         } finally {
            if (response != null) {
                response.close();
            }
        }
    }
    
    @Override
    public List<Story> getSubmittedStories(Integer numberOfStories, Integer offset) {
        List<Story> submittedStories = null;
        try {
            String getSubmittedStoriesUri = uri + "getSubmittedStories/{numberOfStories}/{offset}";
            HashMap<String, Object> params = new HashMap<>();
            params.put("numberOfStories", numberOfStories);
            params.put("offset", offset);
            webTarget = client.target(getSubmittedStoriesUri).resolveTemplates(params);
            response = webTarget.request().get();
            
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get submitted stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                submittedStories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return submittedStories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.ALL, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
    
    @Override
    public List<Story> searchForStories(String searchValue, Integer numberOfStories, Integer currentId, Boolean next) {
        List<Story> stories = null;
        try {
            String searchForStoriesPath = uri + "searchForStories";// Build the query parameters
            URI searchForStoriesUri = UriBuilder.fromPath(searchForStoriesPath)
                    .queryParam("searchValue", searchValue)
                    .queryParam("numberOfStories", numberOfStories)
                    .queryParam("currentId", currentId)
                    .queryParam("next", String.valueOf(next))
                    .build();
            webTarget = client.target(searchForStoriesUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).get();
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to search for stories. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                stories = mapper.readValue(responseStr, new TypeReference<List<Story>>(){});
            }
            return stories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
    
    @Override
    public List<Story> getRecommendations(List<Integer> genreIds) {
        List<Story> recommendedStories = null;
        try {
            String loginReaderUri = uri + "getRecommendations";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(genreIds)));
            recommendedStories = response.readEntity(StoriesHolder.class).getStories();
            return recommendedStories;
        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Story> getWritersSubmittedStories(List<Integer> storyIds, Integer writerId) {
        List<Story> submittedStories = null;
        try {
            StoriesHolder storiesHolder = new StoriesHolder();
            storiesHolder.setId(writerId);
            storiesHolder.setStoryIds(storyIds);
            String loginReaderUri = uri + "getWritersSubmittedStories";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(storiesHolder)));
            submittedStories = response.readEntity(StoriesHolder.class).getStories();
            return submittedStories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

    @Override
    public List<Story> getWritersDraftedStories(List<Integer> storyIds, Integer writerId) {
        List<Story> draftedStories = null;
        try {
            StoriesHolder storiesHolder = new StoriesHolder();
            storiesHolder.setId(writerId);
            storiesHolder.setStoryIds(storyIds);
            String loginReaderUri = uri + "getWritersDraftedStories";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(storiesHolder)));
            draftedStories = response.readEntity(StoriesHolder.class).getStories();
            return draftedStories;

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
    
    private String toJsonString(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }

    @Override
    public String updateStories(List<Story> stories) {
        try {
            String updateStoriesUri = uri + "updateStories";
            webTarget = client.target(updateStoriesUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(stories)));
            return response.readEntity(String.class);

        } catch (IOException ex) {
            Logger.getLogger(StoryService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong updating the selected stories.";
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
}
