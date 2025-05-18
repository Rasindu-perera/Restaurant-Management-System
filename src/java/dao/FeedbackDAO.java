package dao;

import model.Feedback;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FeedbackDAO {
    
    public boolean saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (table_id, order_id, waiter_id, rating, comment) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, feedback.getTableId());
            stmt.setInt(2, feedback.getOrderId());
            stmt.setInt(3, feedback.getWaiterId());
            stmt.setInt(4, feedback.getRating());
            stmt.setString(5, feedback.getComment());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setTableId(rs.getInt("table_id"));
                feedback.setOrderId(rs.getInt("order_id"));
                feedback.setWaiterId(rs.getInt("waiter_id"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setComment(rs.getString("comment"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));
                
                feedbackList.add(feedback);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbackList;
    }
    
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) as average FROM feedback";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getDouble("average");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    public Map<Integer, Integer> getRatingDistribution() {
        Map<Integer, Integer> distribution = new HashMap<>();
        String sql = "SELECT rating, COUNT(*) as count FROM feedback GROUP BY rating ORDER BY rating";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                distribution.put(rs.getInt("rating"), rs.getInt("count"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return distribution;
    }
    
    public Map<Integer, Double> getWaiterRatings() {
        Map<Integer, Double> waiterRatings = new HashMap<>();
        String sql = "SELECT waiter_id, AVG(rating) as avg_rating FROM feedback GROUP BY waiter_id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                waiterRatings.put(rs.getInt("waiter_id"), rs.getDouble("avg_rating"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return waiterRatings;
    }
}
