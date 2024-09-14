import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {

    // Method to establish and return a connection to the database
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/javaquizapp"; // Your database URL
        String username = "root"; // Database username
        String password = ""; // Database password
        return DriverManager.getConnection(url, username, password);
    }

    // Method to close a PreparedStatement
    public static void close(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to close a Connection
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to close a ResultSet
    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to retrieve the generated key after an insert (auto-incremented values)
    public static int getGeneratedKey(PreparedStatement ps) throws SQLException {
        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1); // Return the first column as the generated key
        }
        return -1; // Return -1 if no key is generated
    }
}
