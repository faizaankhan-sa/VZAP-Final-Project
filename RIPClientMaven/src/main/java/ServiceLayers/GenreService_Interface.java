/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Genre;
import java.util.List;

/**
 *
 * @author jarro
 */
public interface GenreService_Interface {
    public Genre getGenre(Integer id);
    public List<Genre> getAllGenres();
    public List<Genre> searchForGenres(String searchValue);
    public String deleteGenre(Integer id);
    public String addGenre(Genre genre);
}
