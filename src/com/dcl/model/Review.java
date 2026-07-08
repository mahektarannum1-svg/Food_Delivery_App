package com.dcl.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int userId;
    private int restaurantId;
    private int rating;
    private String comment;
    private Timestamp createdDate;

    public Review() {}

    public Review(int userId, int restaurantId, int rating, String comment) {
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.rating = rating;
        this.comment = comment;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    @Override
    public String toString() {
        return "Review{" + "reviewId=" + reviewId + ", rating=" + rating + 
               ", comment='" + comment + '\'' + '}';
    }
}
