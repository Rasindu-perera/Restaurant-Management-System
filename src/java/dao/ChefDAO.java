package dao;

import model.Chef;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ChefDAO {
    
    public Chef getChefById(int chefId) {
        Chef chef = null;
        String sql = "SELECT * FROM chefs WHERE chef_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, chefId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    chef = new Chef();
                    chef.setChefId(rs.getInt("chef_id"));
                    chef.setName(rs.getString("name"));
                    // Set other chef properties if they exist in your Chef model and DB table
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
        return chef; // Returns null if chef is not found or an error occurs
    }

    public List<Chef> getAllChefs() {
        List<Chef> chefs = new ArrayList<>();
        String sql = "SELECT * FROM chefs";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Chef chef = new Chef();
                chef.setChefId(rs.getInt("chef_id"));
                chef.setName(rs.getString("name"));
                // Set other chef properties if they exist
                chefs.add(chef);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logger
        }
        return chefs;
    }

    public void addChef(Chef chef) {
        String sql = "INSERT INTO chefs (chef_id, name) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, chef.getChefId());
            stmt.setString(2, chef.getName());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteChef(int chefId) {
        String sql = "DELETE FROM chefs WHERE chef_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, chefId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}