package dao;

import model.Waiter;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WaiterDAO {

    public Waiter getWaiterById(int waiterId) {
        String sql = "SELECT * FROM waiters WHERE waiter_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, waiterId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Waiter waiter = new Waiter();
                waiter.setWaiterId(rs.getInt("waiter_id"));
                waiter.setName(rs.getString("name"));
                return waiter;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteWaiter(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM waiters WHERE waiter_id = ?")) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Waiter> getAllWaiters() {
        List<Waiter> waiters = new ArrayList<>();
        String sql = "SELECT * FROM waiters";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Waiter waiter = new Waiter();
                waiter.setWaiterId(rs.getInt("waiter_id"));
                waiter.setName(rs.getString("name"));
                waiters.add(waiter);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return waiters;
    }

    public void addWaiter(Waiter waiter) {
        String sql = "INSERT INTO waiters (waiter_id, name) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, waiter.getWaiterId());
            stmt.setString(2, waiter.getName());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
