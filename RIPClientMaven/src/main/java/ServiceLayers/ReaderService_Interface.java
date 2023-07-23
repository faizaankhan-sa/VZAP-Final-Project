/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Reader;

/**
 *
 * @author jarro
 */
public interface ReaderService_Interface {
    public Boolean userExists(String email);
    public String setVerified(Integer readerId);
    public Boolean isVerified(Integer readerId);
    public String getVerifyToken(Integer readerId);
    public Reader getReader(String accountEmail);
    public String updateReaderDetails(Reader reader);
    public Reader getReaderById(Integer readerId);
}
