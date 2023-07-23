/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Writer;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Jarrod
 */
public class WriterService_Impl implements WriterService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public WriterService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("writerUri");
    }
    
    @Override
    public String addWriter(Integer readerId) {
        String addWriterUri = uri + "addWriter/{readerId}";
        webTarget = client.target(addWriterUri).resolveTemplate("readerId", readerId);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to add writer. Response status: " + response.getStatus());
                return "Failed to add writer";
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public List<Writer> getWriters(Integer numberOfWriters, Integer pageNumber) {
        List<Writer> writers = null;
        String getwriterPath = uri + "getWriters";
        try {
            // Build the query parameters
            URI getwriterUri = UriBuilder.fromPath(getwriterPath)
                .queryParam("pageNumber", pageNumber)
                .queryParam("numberOfWriters", numberOfWriters)
                .build();
            webTarget = client.target(getwriterUri);
            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get writers. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                writers = mapper.readValue(responseStr, new TypeReference<List<Writer>>(){});
            }
            return writers;

        } catch (IOException ex) {
            Logger.getLogger(WriterService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            closeResponse();
        }
    }

    @Override
    public Writer getWriter(Integer writerId) {
        String getWriterByIdUri = uri + "getWriterById/{writerId}";
        webTarget = client.target(getWriterByIdUri).resolveTemplate("writerId", writerId);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Writer.class);
            } else {
                System.err.println("Failed to retrieve writer by ID. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public Writer getWriter(String email) {
        String getWriterByEmailUri = uri + "getWriterByEmail/{email}";
        webTarget = client.target(getWriterByEmailUri).resolveTemplate("email", email);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Writer.class);
            } else {
                System.err.println("Failed to retrieve writer by email. Response status: " + response.getStatus());
                return null;
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public String updateWriter(Writer writer) {
        try {
            String updateWriterUri = uri + "updateWriter";
            webTarget = client.target(updateWriterUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(writer)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to update writer. Response status: " + response.getStatus());
                return "Failed to update writer";
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(WriterService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }

    @Override
    public String blockWriters(List<Integer> writerIds) {
        try {
            String blockWritersUri = uri + "blockWriters";
            webTarget = client.target(blockWritersUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(writerIds)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to block writers. Response status: " + response.getStatus());
                return "Failed to block writers";
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(WriterService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }
    
    @Override
    public String addWriters(List<Integer> writerIds) {
        try {
            String addWritersUri = uri + "addWriters";
            webTarget = client.target(addWritersUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(writerIds)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to add writers. Response status: " + response.getStatus());
                return null;
            }
        } catch (JsonProcessingException ex) {
            Logger.getLogger(WriterService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }
    
    private String toJsonString(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }

    @Override
    public List<Writer> searchForWriters(String searchValue, Integer numberOfWriters, Integer pageNumber) {
        List<Writer> writers = null;
        String searchForWritersPath = uri + "searchForWriters";
        try {
            // Build the query parameters
            URI searchForWritersUri = UriBuilder.fromPath(searchForWritersPath)
                .queryParam("searchValue", searchValue)
                .queryParam("numberOfWriters", numberOfWriters)
                .queryParam("pageNumber", pageNumber)
                .build();
            webTarget = client.target(searchForWritersUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                String responseStr = response.readEntity(String.class);
                if (responseStr != null && !responseStr.isEmpty()) {
                    writers = mapper.readValue(responseStr, new TypeReference<List<Writer>>(){});
                }
            } else {
                System.err.println("Failed to search for writers. Response status: " + response.getStatus());
            }
           return writers;

        } catch (IOException ex) {
            Logger.getLogger(WriterService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            closeResponse();
        }
    }
    
    private void closeResponse(){
        if (response != null) {
            response.close();
        }
    }
}
