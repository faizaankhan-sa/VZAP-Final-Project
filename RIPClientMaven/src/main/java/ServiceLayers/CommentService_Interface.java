/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package ServiceLayers;

import Models.Comment;
import java.util.List;

/**
 *
 * @author Kylynn van der Merwe
 */
public interface CommentService_Interface {
    public List<Comment> getAllCommentForStory(Integer storyId);
    public String addComment(Comment comment);
}
