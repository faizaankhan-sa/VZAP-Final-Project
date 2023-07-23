/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Comment;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Kylynn van der Merwe
 */
public class CommentService_Impl implements CommentService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;
    
    public CommentService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("commentUri");
    }
    
    @Override
    public List<Comment> getAllCommentForStory(Integer storyId) {
        List<Comment> allComments = null;
        try {            
            String getCommentsForStoryUri = uri + "getAllComments/{storyId}";
            webTarget = client.target(getCommentsForStoryUri).resolveTemplate("storyId",storyId);
            response = webTarget.request(MediaType.APPLICATION_JSON).get();
            
            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get all comments. Response status: " + response.getStatus());
             }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                allComments = mapper.readValue(responseStr, new TypeReference<List<Comment>>(){});
            }            
           return allComments;
        } catch (IOException ex) {
            Logger.getLogger(CommentService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }finally{
            closeResponse();
        }
    }

    @Override
    public String addComment(Comment comment) {        
        try {
            String addCommentUri = uri + "addComment";
            webTarget = client.target(addCommentUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(comment)));
            
            if (response.getStatus() == Response.Status.OK.getStatusCode()){
                return response.readEntity(String.class);
            }else {
                System.err.println("Failed to add comment. Response status: " + response.getStatus());
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(CommentService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "An error occured while adding a comment. JsonProcessingException was thrown";
        }finally{
            closeResponse();
        }
        return "System failed to add comment";
    }
    
    private String toJsonString(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }
    
    private void closeResponse(){
        if (response != null) {
            response.close();
        }
    }
}
