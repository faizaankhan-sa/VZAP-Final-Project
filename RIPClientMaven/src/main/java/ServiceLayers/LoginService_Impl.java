/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Editor;
import Models.Reader;
import Models.Writer;
import Utils.GetProperties;
import Utils.PasswordEncryptor;
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
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author jarro
 */
public class LoginService_Impl implements LoginService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public LoginService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("loginUri");
    }
    
    @Override
    public HashMap getUserSalt(String email) {
        HashMap<String, String> details = null;
        String getUserSaltUri = uri + "getUserSalt/{email}";

        try {
            webTarget = client.target(getUserSaltUri).resolveTemplate("email", email);
            response = webTarget.request(MediaType.APPLICATION_JSON).get();

            if (response.getStatus() != Response.Status.OK.getStatusCode()) {
                System.err.println("Failed to get users salt. Response status: " + response.getStatus());
                return null;
            }
            
            String responseStr = response.readEntity(String.class);            
            if (!responseStr.isEmpty()) {
                details = mapper.readValue(responseStr, new TypeReference<HashMap<String, String>>(){});
            }
            return details;

        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }
   
    @Override
    public Reader loginReader(Reader reader) {
        try {
            reader.setPasswordHash(PasswordEncryptor.hashPassword(reader.getPasswordHash(), reader.getSalt()));
            String loginReaderUri = uri + "getUser";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(reader)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Reader.class);
            } else {
                // Handle error response
                System.err.println("Failed to login reader. Response status: " + response.getStatus());
                return null;

            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public Writer loginWriter(Writer writer) {
        try {
            writer.setPasswordHash(PasswordEncryptor.hashPassword(writer.getPasswordHash(), writer.getSalt()));
            String loginReaderUri = uri + "getUser";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(writer)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Writer.class);
            } else {
                // Handle error response
                System.err.println("Failed to login writer. Response status: " + response.getStatus());
                return null;

            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public Editor loginEditor(Editor editor) {
        try {
            editor.setPasswordHash(PasswordEncryptor.hashPassword(editor.getPasswordHash(), editor.getSalt()));
            String loginReaderUri = uri + "getUser";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(editor)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(Editor.class);
            } else {
                // Handle error response
                System.err.println("Failed to login editor. Response status: " + response.getStatus());
                return null;

            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        } finally {
            if (response != null) {
                response.close();
            }
        }

    }


    @Override
    public String register(Reader reader) {
        try {
            String loginReaderUri = uri + "register";
            webTarget = client.target(loginReaderUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(reader)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                // Handle error response
                System.err.println("Failed to register reader. Response status: " + response.getStatus());
                return null;

            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Failed to register reader";
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
