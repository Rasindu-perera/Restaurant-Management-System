package dao;

import util.DBConnection;

import java.sql.*;
/**
 *
 * @author RasinduPerera
 */
public class TableDAO {

    /**
     * Gets the current status of a table.
     * 
     * @param tableId The table ID to check
     * @return "available", "Reserved", or null if not found/error
     */
    public String getTableStatus(int tableId) {
        String sql = "SELECT status FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("status");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Reserves a table for a specific waiter.
     * 
     * @param tableId  The table to reserve
     * @param waiterId The waiter ID reserving the table
     */
    public void reserveTable(int tableId, int waiterId) {
        String sql = "UPDATE tables SET status = 'Reserved', reserved_by = ? WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, waiterId);
            stmt.setInt(2, tableId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Checks if a table is reserved by someone else.
     * 
     * @param tableId         The table to check
     * @param currentWaiterId The waiter trying to access it
     * @return true if reserved by another waiter, false otherwise
     */
    public boolean isTableReservedByAnotherWaiter(int tableId, int currentWaiterId) {
        String sql = "SELECT reserved_by FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int reservedBy = rs.getInt("reserved_by");
                return reservedBy != currentWaiterId && reservedBy != 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Releases a table (makes it available again).
     * 
     * @param tableId The table to release
     */
    public void releaseTable(int tableId) {
        String sql = "UPDATE tables SET status = 'available', reserved_by = NULL WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, tableId);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
