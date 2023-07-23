/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Like;
import Utils.GetProperties;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.ProcessingException;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author 27713
 */
public class LikeService_Impl implements LikeService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    
    public LikeService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("likeUri");
    }
    
    @Override
    public String addLike(Like like) {
        String addLikeUri = uri + "addLike";
        try {
            webTarget = client.target(addLikeUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(like)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to add the like. Response status: " + response.getStatus());
                return "Like not added";
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Like not added";
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public String deleteLike(Like like) {
        try {
            String deleteLikeUri = uri + "deleteLike";
            webTarget = client.target(deleteLikeUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(like)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to delete the like. Response status: " + response.getStatus());
                return "Like not deleted";
            }

        } catch (JsonProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Like not deleted";
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public List<Like> getLikesByReaderId(Integer accountId) {
        List<Like> likes = null;
        try {
            String likesByReaderUri = uri + "getLikesByReaderId/{accountId}";
            webTarget = client.target(likesByReaderUri).resolveTemplate("accountId", accountId);

            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get likes by reader ID. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                likes = mapper.readValue(responseStr, new TypeReference<List<Like>>(){});
            }

            return likes;
        } catch (IOException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, "Error reading JSON response", ex);
            return null;
        } catch (ProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, "Error processing the request", ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }



    @Override
    public List<Like> getLikesByStory(Integer storyId) {
        List<Like> likes = new ArrayList<>();
        try {
            String likesByStoryUri = uri + "getLikesByStory/{storyId}";
            webTarget = client.target(likesByStoryUri).resolveTemplate("storyId", storyId);

            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to retrieve story's likes. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                likes = mapper.readValue(responseStr, new TypeReference<List<Like>>(){});
            }
            return likes;

        } catch (IOException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public Integer getStoryLikesByDate(Integer storyId, Timestamp startDate, Timestamp endDate) {
        String storyLikesUri = uri + "getStoryLikesByDate/{storyId}/{startDate}/{endDate}";
        HashMap<String, Object> details = new HashMap<>();
        details.put("storyId", storyId);
        details.put("startDate", startDate);
        details.put("endDate", endDate);
        webTarget = client.target(storyLikesUri).resolveTemplates(details);
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
    public List<Integer> getMostLikedBooks(Integer numberOfBooks, Timestamp startDate, Timestamp endDate) {
        List<Integer> bookIds = new ArrayList<>();
        HashMap<String, Object> details = new HashMap<>();
        try {
            String mostLikedBooksUri = uri + "getMostLikedBooks/{numberOfBooks}/{startDate}/{endDate}";
            details.put("numberOfBooks", numberOfBooks);
            details.put("startDate", startDate);
            details.put("endDate", endDate);
            webTarget = client.target(mostLikedBooksUri).resolveTemplates(details);

            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get most liked books. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                bookIds = mapper.readValue(responseStr, new TypeReference<List<Integer>>(){});
            }
            return bookIds;

        } catch (IOException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }

    
    @Override
    public Boolean checkIfLikeExists(Like like) {
        try {
            String checkLikeExistsUri = uri + "checkIfLikeExists";
            webTarget = client.target(checkLikeExistsUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(like)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Boolean.class);
            } else {
                System.err.println("Failed to check if like exists. Response status: " + response.getStatus());
                return null;
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, "Failed to check if like exists: " + ex.getMessage(), ex);
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

}
