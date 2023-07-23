/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Editor;
import Models.Genre;
import Models.Story;
import Models.Writer;
import java.util.List;

/**
 *
 * @author ruthe
 */
public interface DataReportService_Interface {
    public Integer getStoryLikesByDate(Integer storyId, String startDate, String endDate);    
    public List<Story> getMostLikedStories(Integer numberOfStories, String startDate, String endDate);
    public List<Story> getMostViewedStoriesInATimePeriod(Integer numberOfEntries, String startDate, String endDate);
    public Integer getTheViewsOnAStoryInATimePeriod(Integer storyId, String startDate, String endDate);
    public List<Story> getTopHighestRatedStoriesInTimePeriod(String startDate, String endDate, Integer numberOfEntries);
    public List<Writer> getTopWriters(Integer numberOfWriters);
    //public List<Writer> getTopWritersByDate(Integer numberOfWriters, String startDate, String endDate);
    public List<Editor> getTopEditors(Integer numberOfEditors);
    public Integer getTotalViewsByWriterId(Integer writerId);
    public Double getAverageRatingOfAStoryInATimePeriod(Integer storyId, String startDate, String endDate);
    public List<Genre> getTopGenres(String startDate, String endDate, Integer numberOfEntries);
    public Integer getGenreViewsByDate(String startDate, String endDate, Integer genreId);

}
