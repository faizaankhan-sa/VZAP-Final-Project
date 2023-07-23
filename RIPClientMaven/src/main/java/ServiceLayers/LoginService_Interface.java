/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Editor;
import Models.Reader;
import Models.Writer;
import java.util.HashMap;

/**
 *
 * @author jarro
 */
public interface LoginService_Interface {
    public HashMap getUserSalt(String email);
    public Reader loginReader(Reader reader);
    public Writer loginWriter(Writer writer);
    public Editor loginEditor(Editor editor);
    public String register(Reader reader);
}
