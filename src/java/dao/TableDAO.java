package dao;

import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Table;

public class TableDAO {

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

    public boolean releaseTable(int tableId) {
        String checkSql = "SELECT status FROM tables WHERE table_id = ?";
        String updateSql = "UPDATE tables SET status = 'available', reserved_by = NULL WHERE table_id = ? AND status != 'available'";
        
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, tableId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (!rs.next()) {
                    System.out.println("Table " + tableId + " does not exist");
                    return false;
                }
                
                String currentStatus = rs.getString("status");
                if ("available".equalsIgnoreCase(currentStatus)) {
                    System.out.println("Table " + tableId + " is already available");
                    return true;
                }
            }
            
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setInt(1, tableId);
                int rowsAffected = updateStmt.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error releasing table " + tableId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Completely releases a table: sets status to Available, and resets reserved_by and created_at to NULL
     * @param tableId The ID of the table to release
     * @return true if successful, false otherwise
     */
    public boolean releaseTableCompletely(int tableId) {
        String sql = "UPDATE tables SET status = 'Available', reserved_by = NULL, created_at = NULL WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void deleteTable(int tableId) {
        String sql = "DELETE FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tableId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Table> getAllTables() {
        List<Table> tableList = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM tables");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setStatus(rs.getString("status"));
                table.setWaiterId(rs.getInt("reserved_by"));
                table.setCreatedAt(rs.getTimestamp("created_at"));
                tableList.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tableList;
    }

    public void addTable(Table table) {
        String sql = "INSERT INTO tables (table_id, status) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, table.getTableId());
            stmt.setString(2, table.getStatus());
            int rowsInserted = stmt.executeUpdate();
            System.out.println("Rows inserted: " + rowsInserted);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Table getTableById(int tableId) {
        String sql = "SELECT * FROM tables WHERE table_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, tableId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setStatus(rs.getString("status"));
                table.setWaiterId(rs.getInt("reserved_by"));
                table.setCreatedAt(rs.getTimestamp("created_at"));
                return table;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Table> getTablesByStatus(String status) {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT * FROM tables WHERE status = ? ORDER BY table_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Table table = new Table();
                table.setTableId(rs.getInt("table_id"));
                table.setStatus(rs.getString("status"));
                table.setWaiterId(rs.getInt("reserved_by"));
                table.setCreatedAt(rs.getTimestamp("created_at"));
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }

    public boolean updateTableStatus(int tableId, String status) {
        String sql = "UPDATE tables SET status = ? WHERE table_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, tableId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}



