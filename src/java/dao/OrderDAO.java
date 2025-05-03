package dao;

import model.CartItem;
import model.Order;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
/**
 *
 * @author RasinduPerera
 */
public class OrderDAO {

    public void saveOrder(int waiterId, int tableId, List<CartItem> cart) {
        String orderSql = "INSERT INTO orders (table_id, waiter_id, status) VALUES (?, ?, 'sent')";
        String itemSql = "INSERT INTO order_items (order_id, item_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // begin transaction

            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, tableId);
            orderStmt.setInt(2, waiterId);
            orderStmt.executeUpdate();

            int orderId = 0;
            var rs = orderStmt.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            for (CartItem item : cart) {
                PreparedStatement itemStmt = conn.prepareStatement(itemSql);
                itemStmt.setInt(1, orderId);
                itemStmt.setInt(2, item.getItem().getId());
                itemStmt.setInt(3, item.getQuantity());
                itemStmt.executeUpdate();
            }

            conn.commit(); // success
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
