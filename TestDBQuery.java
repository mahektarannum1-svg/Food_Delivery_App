import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBQuery {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/instant_food", "root", "admin");
            Statement s = c.createStatement();
            ResultSet rs = s.executeQuery("SELECT restaurant_id, name, image_url FROM restaurant");
            System.out.println("--- Restaurants in instant_food ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("restaurant_id") + 
                                   " | Name: " + rs.getString("name") + 
                                   " | Image URL: '" + rs.getString("image_url") + "'");
            }
            c.close();
        } catch (Exception e) {
            System.out.println("Error (instant_food): " + e.getMessage());
        }

        try {
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/InstantFood", "root", "admin");
            Statement s = c.createStatement();
            ResultSet rs = s.executeQuery("SELECT restaurant_id, name, image_url FROM restaurant");
            System.out.println("--- Restaurants in InstantFood ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("restaurant_id") + 
                                   " | Name: " + rs.getString("name") + 
                                   " | Image URL: '" + rs.getString("image_url") + "'");
            }
            c.close();
        } catch (Exception e) {
            System.out.println("Error (InstantFood): " + e.getMessage());
        }
    }
}
