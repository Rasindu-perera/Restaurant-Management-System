package dao;

import model.MenuItem;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author RasinduPerera
 */
public class MenuDAO {

    public List<MenuItem> getItemsByCategory(String category) {
        List<MenuItem> items = new ArrayList<>();
        String sql = "SELECT * FROM menu_items WHERE category_id = (SELECT category_id FROM categories WHERE name = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setCategory(category);
                item.setImageUrl(rs.getString("image_url")); // NEW
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public MenuItem getMenuItemById(int itemId) {
        String sql = "SELECT m.*, c.name AS category FROM menu_items m " +
                     "JOIN categories c ON m.category_id = c.category_id WHERE item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                MenuItem item = new MenuItem();
                item.setId(rs.getInt("item_id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setCategory(rs.getString("category"));
                item.setImageUrl(rs.getString("image_url")); // NEW
                return item;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<MenuItem> getAllMenuItems() {
    List<MenuItem> items = new ArrayList<>();
    String sql = "SELECT m.*, c.name AS category FROM menu_items m JOIN categories c ON m.category_id = c.category_id";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            MenuItem item = new MenuItem();
            item.setId(rs.getInt("item_id"));
            item.setName(rs.getString("name"));
            item.setPrice(rs.getDouble("price"));
            item.setCategory(rs.getString("category"));
            item.setImageUrl(rs.getString("image_url"));

            items.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return items;
}

}
