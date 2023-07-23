/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Rating;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author 27713
 */
public interface RatingService_Interface {
    public String addRating(Rating rating);
    public List<Integer> getTopHighestRatedStoriesInTimePeriod(Timestamp startDate, Timestamp endDate, Integer numberOfEntries);
    public String updateRatingValue(Rating rating);
    public Boolean checkRatingExists(Rating rating);
    public Rating getRating(Integer accountId, Integer storyId);
}
