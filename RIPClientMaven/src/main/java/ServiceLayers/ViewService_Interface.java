/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServiceLayers;

import Models.View;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author 27713
 */
public interface ViewService_Interface {    
    
    public String addView(View view);
    public List<Integer> getMostViewedStoriesInATimePeriod(Integer numberOfEntries, Timestamp startDate, Timestamp endDate);
    public Integer getTheViewsOnAStoryInATimePeriod(Integer storyId, Timestamp startDate, Timestamp endDate);
    public Boolean isViewAlreadyAdded(View view);
    public Boolean viewExists(Integer readerId, Integer storyId);
}
