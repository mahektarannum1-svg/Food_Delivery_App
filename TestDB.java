import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) throws ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        System.out.println("Testing instant_food:");
        try {
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/instant_food", "root", "admin");
            System.out.println("SUCCESS: instant_food exists.");
            c.close();
        } catch(SQLException e) {
            System.out.println("FAIL: " + e.getMessage());
        }
        
        System.out.println("Testing InstantFood:");
        try {
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/InstantFood", "root", "admin");
            System.out.println("SUCCESS: InstantFood exists.");
            c.close();
        } catch(SQLException e) {
            System.out.println("FAIL: " + e.getMessage());
        }
    }
}
