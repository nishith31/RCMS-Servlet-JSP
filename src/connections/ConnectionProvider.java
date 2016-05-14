package connections;
import java.sql.*;
public class ConnectionProvider {
    static Connection con = null;
    public static Connection conn() {
        try {
            /*Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
            con = DriverManager.getConnection("jdbc:odbc:mdu_rc_block_dsn", "sa", "sqlserver");*/
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/mdu_rc_blockwise_mode", "root", "root");
        } catch(Exception exception) {
            System.out.println(exception);
        }
        return con;
    }
}

