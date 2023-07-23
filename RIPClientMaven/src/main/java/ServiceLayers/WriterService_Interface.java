/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.Writer;
import java.util.List;

/**
 *
 * @author Jarrod
 */
public interface WriterService_Interface {
    public List<Writer> getWriters(Integer numberOfWriters, Integer pageNumber);
    public List<Writer> searchForWriters(String searchValue, Integer numberOfWriters, Integer pageNumber);
    public Writer getWriter(Integer writerId);
    public Writer getWriter(String email);
    public String updateWriter(Writer writer);
    public String blockWriters(List<Integer> writerIds);
    public String addWriters(List<Integer> writerIds);
    public String addWriter(Integer readerId);
}
