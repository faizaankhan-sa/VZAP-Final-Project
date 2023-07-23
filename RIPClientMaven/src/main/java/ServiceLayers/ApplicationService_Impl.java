/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Application;
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
 * @author Jarrod
 */
public class ApplicationService_Impl implements ApplicationService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public ApplicationService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("applicationsUri");
    }
    
    
    @Override
    public List<Application> getApplications() {
        List<Application> applications = null;
        try {
            String getApplicationsUri = uri + "getApplications";
            webTarget = client.target(getApplicationsUri);
            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get applications. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                applications = mapper.readValue(responseStr, new TypeReference<List<Application>>(){});
            }
             return applications;
        } catch (IOException ex) {
            Logger.getLogger(ApplicationService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            closeResponse();
        }
    }

    @Override
    public String addApplication(Application application) {
        try {
            String addApplicationUri = uri + "addApplication";
            webTarget = client.target(addApplicationUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(application)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to add application. Response status: " + response.getStatus());                
                 return "System failed to add application";
            }
        } catch (IOException ex) {
            Logger.getLogger(ApplicationService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "An error occured while adding an application. IOException was thrown";
        } finally {
            closeResponse();
        }
    }

    @Override
    public String deleteApplication(Integer accountId) {
        try {
            String deleteApplicationUri = uri + "deleteApplication/{readerId}";
            webTarget = client.target(deleteApplicationUri).resolveTemplate("readerId", accountId);
            response = webTarget.request().get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to delete application. Response status: " + response.getStatus());
                return "Failed to delete application";
            }
        } catch (Exception ex) {
            Logger.getLogger(ApplicationService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "An error occurred while deleting the application.";
        } finally {
            closeResponse();
        }
    }
    
    @Override
    public String deleteApplications(List<Integer> accountIds) {
        try {
            String deleteApplicationsUri = uri + "deleteApplications";
            webTarget = client.target(deleteApplicationsUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(accountIds)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to delete applications. Response status: " + response.getStatus());
                return "Failed to delete application";
            }
        } catch (IOException ex) {
            Logger.getLogger(ApplicationService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
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
