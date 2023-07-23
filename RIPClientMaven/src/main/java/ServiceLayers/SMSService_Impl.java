/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Utils.GetProperties;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

/**
 *
 * @author Kylynn van der Merwe
 */
public class SMSService_Impl implements SMSService_Interface{
    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;
    
    public SMSService_Impl(){
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("smsUri");
    }

    @Override
    public String sendSMS(String phoneNumber, String message) {
        String sendSMSUri = uri + "sendsms/{phoneNumber}/{message}";
        webTarget = client.target(sendSMSUri);
        response = webTarget.request(MediaType.APPLICATION_XML).get();
        
        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to send SMS. Response status: " + response.getStatus());
                return "Failed to send SMS";
            }
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
