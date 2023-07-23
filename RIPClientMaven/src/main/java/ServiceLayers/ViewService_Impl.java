/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.View;
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
import java.io.IOException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Kylynn van der Merwe
 */
public class ViewService_Impl implements ViewService_Interface {
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;
    
    public ViewService_Impl(){
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("viewUri");
    }
    
    @Override
    public String addView(View view) {        
        try {
            String addViewUri = uri + "addView";
            webTarget = client.target(addViewUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(view)));
            
            if (response.getStatus() == Response.Status.OK.getStatusCode()){
                return response.readEntity(String.class);
            }else {
                System.err.println("Failed to add view. Response status: " + response.getStatus());
                return "System failed to add view";

            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "An error occured while adding a view. JsonProcessingException was thrown";
        }finally{
            closeResponse();
        }
    }

    @Override
    public List<Integer> getMostViewedStoriesInATimePeriod(Integer numberOfEntries, Timestamp startDate, Timestamp endDate) {
        List<Integer> bookIds = null;
        HashMap<String, Object> details = new HashMap<>();
        try {            
            String mostViewedBooksUri = uri + "getMostViewedStories/{numberOfEntries}/{startDate}/{endDate}";
            details.put("numberOfEntries", numberOfEntries);
            details.put("startDate", startDate);
            details.put("endDate", endDate);
            webTarget = client.target(mostViewedBooksUri).resolveTemplates(details);
            response = webTarget.request().get();
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to search for genres. Response status: " + response.getStatus());
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
        }finally{
            closeResponse();
        }
    }

    @Override
    public Integer getTheViewsOnAStoryInATimePeriod(Integer storyId, Timestamp startDate, Timestamp endDate) {
        HashMap<String, Object> details = new HashMap<>();
        String getViewsOnStoryUri = uri + "getTheViewOnAStory/{storyId}/{startDate}/{endDate}";
        details.put("storyId", storyId);
        details.put("startDate", startDate);
        details.put("endDate", endDate);

        try {
            webTarget = client.target(getViewsOnStoryUri).resolveTemplates(details);
            response = webTarget.request().get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Integer.class);
            } else {
                System.err.println("Failed to retrieve the views on a story. Response status: " + response.getStatus());
                return null;
            }
        }finally{
            closeResponse();
        }
    }

    @Override
    public Boolean isViewAlreadyAdded(View view) {
        Boolean viewExists;
        try {
            String isViewAddedUri = uri + "isViewAlreadyAdded";
            webTarget = client.target(isViewAddedUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(view)));
            viewExists = response.readEntity(Boolean.class);
            System.out.println("View Exists: " + viewExists);
            return viewExists;
        } catch (JsonProcessingException ex) {
            Logger.getLogger(LikeService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        } finally {
            closeResponse();
        }
    }
    
    private String toJsonString(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }

    @Override
    public Boolean viewExists(Integer readerId, Integer storyId) {
        View view = new View();
        view.setReaderId(readerId);
        view.setStoryId(storyId);
        return isViewAlreadyAdded(view);
    }
    
    private void closeResponse(){
        if (response != null) {
            response.close();
        }
    }
}
