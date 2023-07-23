/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Reader;
import Utils.GetProperties;
import Utils.GetProperties;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Jarrod
 */
public class ReaderService_Impl implements ReaderService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public ReaderService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("readersUri");
    }
    
    @Override
    public Boolean userExists(String email) {
        String getUserSaltUri = uri + "userExists/{email}";
        webTarget = client.target(getUserSaltUri).resolveTemplate("email", email);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Boolean.class);
            } else {
                System.err.println("Failed to check if user exists. Response status: " + response.getStatus());
                return false;
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public String setVerified(Integer readerId) {
        String setVerifiedUri = uri + "setVerified/{readerId}";
        webTarget = client.target(setVerifiedUri).resolveTemplate("readerId", readerId);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to set verified. Response status: " + response.getStatus());
                return "Failed to set verified";
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public Boolean isVerified(Integer readerId) {
        String isVerifiedUri = uri + "isVerified/{readerId}";
        webTarget = client.target(isVerifiedUri).resolveTemplate("readerId", readerId);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Boolean.class);
            } else {
                System.err.println("Failed to check if reader is verified. Response status: " + response.getStatus());
                return false;
            }
        } finally {
            closeResponse();
        }
    }
    
    @Override
    public String getVerifyToken(Integer readerId) {
        String getVerifyTokenUri = uri + "getVerifyToken/{readerId}";
        webTarget = client.target(getVerifyTokenUri).resolveTemplate("readerId", readerId);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to get verification token. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            closeResponse();
        }
    }
    
    @Override
    public Reader getReader(String accountEmail) {
        String getReaderUri = uri + "getReader/{accountEmail}";
        webTarget = client.target(getReaderUri).resolveTemplate("accountEmail", accountEmail);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Reader.class);
            } else {
                System.err.println("Failed to retrieve reader. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public Reader getReaderById(Integer readerId){
        String getReaderByIdUri = uri + "getReaderById/{readerId}";
        webTarget = client.target(getReaderByIdUri).resolveTemplate("readerId", readerId);
        response = webTarget.request(MediaType.APPLICATION_JSON).get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Reader.class);
            } else {
                System.err.println("Failed to retrieve reader by ID. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            closeResponse();
        }
    }
    
    @Override
    public String updateReaderDetails(Reader reader) {
        String updateReaderUri = uri + "updateReaderDetails";
        webTarget = client.target(updateReaderUri);

        try {
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(reader)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to update reader details. Response status: " + response.getStatus());
                return null;
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(ReaderService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "System failed to update reader details";
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
