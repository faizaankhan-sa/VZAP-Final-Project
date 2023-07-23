/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Genre;
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
 * @author jarro
 */
public class GenreService_Impl implements GenreService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public GenreService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("genreUri");
    }
    
    @Override
    public Genre getGenre(Integer id) {
        String getGenreUri = uri + "getGenre/{genreId}";
        webTarget = client.target(getGenreUri).resolveTemplate("genreId", id);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Genre.class);
            } else {
                System.err.println("Failed to retrieve the genre. Response status: " + response.getStatus());
                return null; // or throw an exception
            }
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public List<Genre> getAllGenres() {
        List<Genre> genres = null;
        try {
            String getAllGenresUri = uri + "getAllGenres";
            webTarget = client.target(getAllGenresUri);
            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get all genres. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                genres = mapper.readValue(responseStr, new TypeReference<List<Genre>>(){});
            }
            return genres;

        } catch (IOException ex) {
            Logger.getLogger(GenreService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public String deleteGenre(Integer id) {
        String deleteGenreUri = uri + "deleteGenre/{genreId}";
        webTarget = client.target(deleteGenreUri).resolveTemplate("genreId", id);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to delete the genre. Response status: " + response.getStatus());
                return null; 
            }
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }


    @Override
    public String addGenre(Genre genre) {
        try {
            String addGenreUri = uri + "addGenre";
            webTarget = client.target(addGenreUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(genre)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to add the genre. Response status: " + response.getStatus());
                return null;
            }
        } catch (IOException ex) {
            Logger.getLogger(GenreService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null; 
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
    
    @Override
    public List<Genre> searchForGenres(String searchValue) {
        List<Genre> genres = null;
        try {
            String searchForGenresUri = uri + "searchForGenres/{searchValue}";
            webTarget = client.target(searchForGenresUri).resolveTemplate("searchValue", searchValue);
            response = webTarget.request().get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to search for genres. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                genres = mapper.readValue(responseStr, new TypeReference<List<Genre>>(){});
            }
            return genres;

        } catch (IOException ex) {
            Logger.getLogger(GenreService_Impl.class.getName()).log(Level.SEVERE, null, ex);
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
