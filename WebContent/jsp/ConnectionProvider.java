package conn;
import java.sql.*;
public class ConnectionProvider
{
static Connection con = null;
public static Connection conn()
{
try 
{
Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
con=DriverManager.getConnection("jdbc:odbc:mdu_rc_block_dsn","sa","sqlserver");
}
catch(Exception e)
{
e.printStackTrace();
}
return con;
}
}

