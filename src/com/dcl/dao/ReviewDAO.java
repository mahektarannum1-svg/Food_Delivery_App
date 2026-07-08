package com.dcl.dao;

import java.util.List;
import com.dcl.model.Review;

public interface ReviewDAO {
    void addReview(Review r);
    void deleteReview(int id);
    Review getReview(int id);
    List<Review> getReviewsByRestaurant(int restaurantId);
    List<Review> getReviewsByUser(int userId);
    double getAverageRating(int restaurantId);
}
