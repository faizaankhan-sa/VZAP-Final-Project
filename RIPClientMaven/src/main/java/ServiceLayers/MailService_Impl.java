package ServiceLayers;

import Models.Reader;
import Utils.GetProperties;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.WebTarget;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MailService_Impl implements MailService_Interface {

    private final Client client;
    private WebTarget webTarget;
    private final ObjectMapper mapper;
    private Response response;
    private final GetProperties properties;
    private final String uri;

    public MailService_Impl() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
        properties = new GetProperties("config.properties");
        uri = properties.get("serverUri")+properties.get("mailUri");
    }

    @Override
    public String sendMail(String recipientEmail, String emailContent, String subject) {
        HashMap<String, String> emailDetails = new HashMap<>();
        try {            
            emailDetails.put("recipient", recipientEmail);
            emailDetails.put("content", emailContent);
            emailDetails.put("subject", subject);
            String sendMailUri = uri + "sendMail";
            webTarget = client.target(sendMailUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(emailDetails)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to send email. Response status: " + response.getStatus());
                return "Failed to send email";
            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }
    

    @Override
    public String sendVerficationEmail(Reader reader) {
        try {
            String sendVerificationEmailUri = uri + "sendVerificationEmail";
            webTarget = client.target(sendVerificationEmailUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(reader)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to send verification email. Response status: " + response.getStatus());
                return "Failed to send verification email";
            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }

    private String toJsonString(Object obj) throws JsonProcessingException {
        return mapper.writeValueAsString(obj);
    }

    @Override
    public String sendReferralEmail(String recipientEmail, String recipientName, String phoneNumber) {
        String sendReferralEmailUri = uri + "sendReferralEmail/{recipientEmail}/{recipientName}/{recipientPhoneNumber}";
        HashMap<String, Object> referralDetails = new HashMap<>();
        referralDetails.put("recipientEmail", recipientEmail);
        referralDetails.put("recipientName", recipientName);
        referralDetails.put("recipientPhoneNumber", phoneNumber);
        webTarget = client.target(sendReferralEmailUri).resolveTemplates(referralDetails);
        response = webTarget.request().get();

        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to send referral email. Response status: " + response.getStatus());
                return "Failed to send referral email";
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public String notifyApprovedWriters(List<Integer> accountIds, Boolean approved) {
        try {
            String notifyWritersUri = uri;
            if (approved) {
                notifyWritersUri += "notifyApprovedWriters";
            } else {
                notifyWritersUri += "notifyRejectedWriters";
            }
            webTarget = client.target(notifyWritersUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(accountIds)));

            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to notify writers. Response status: " + response.getStatus());
                return "Failed to notify approved writer";
            }
        }catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }

    @Override
    public String notifyWriterOfStorySubmission(Integer writerId, Boolean approved) {
        String notifyUri = uri + "notifyWriterOfStorySubmission/{writerId}/{approved}";
        HashMap<String, Object> notifDetails = new HashMap<>();
        notifDetails.put("writerId", writerId);
        notifDetails.put("approved", approved);
        webTarget = client.target(notifyUri).resolveTemplates(notifDetails);
        response = webTarget.request().get();
        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to notify writer of story submission. Response status: " + response.getStatus());
                return "Failed to notify writer of story submission";
            }
        } finally {
            closeResponse();
        }
    }

    @Override
    public String notifyBlockedWriters(List<Integer> accountIds) {
        try {
            String notifyBlockedWritersUri = uri + "notifyBlockedWriters";
            webTarget = client.target(notifyBlockedWritersUri);
            response = webTarget.request(MediaType.APPLICATION_JSON).post(Entity.json(toJsonString(accountIds)));
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to notify blocked writers. Response status: " + response.getStatus());
                return "Failed to notify blocked writer";
            }
        } catch (IOException ex) {
            Logger.getLogger(LoginService_Impl.class.getName()).log(Level.SEVERE, null, ex);
            return "Something went wrong connecting to the server.";
        } finally {
            closeResponse();
        }
    }
    
    private void closeResponse(){
        if (response != null) {
            response.close();
        }
    }

    @Override
    public String sendChangePasswordEmail(String email) {
        String notifyUri = uri + "sendChangePasswordEmail/{accountEmail}";
        webTarget = client.target(notifyUri).resolveTemplate("accountEmail", email);
        response = webTarget.request().get();
        try {
            if (response.getStatus() == Response.Status.OK.getStatusCode()) {
                return response.readEntity(String.class);
            } else {
                System.err.println("Failed to send email to change password. Response status: " + response.getStatus());
                return "Failed to send email to change password.";
            }
        } finally {
            closeResponse();
        }
    }
}
