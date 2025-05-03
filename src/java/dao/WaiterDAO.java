package dao;

import model.Waiter;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
/**
 *
 * @author RasinduPerera
 */
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
}
