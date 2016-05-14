package utility;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CommonUtility {

    public static boolean isNull(Object obj) {
        if(obj == null) {
            return true;
        } else {
            return false;
        }
    }
    /*function to get the current session name bases on the regional center*/
    public static String getCurrentSessionName(String regionalCenterCode) {
        Connection connection = connections.ConnectionProvider.conn();
        Statement statement;
        String currentSession = null;
        try {
            statement = connection.createStatement();
            /*Logic for getting the current session name from the sessions table of the regional centre logged in and send to the browser*/ 
            ResultSet rs = statement.executeQuery("select session_name from sessions_" + regionalCenterCode + " order by id DESC LIMIT 1");
            while(rs.next()) {
                currentSession = rs.getString(1).toLowerCase();
            }
        } catch (Exception exception) {
            System.out.println("getCurrentSessionName() execution error : " + exception);
        }
      
        return currentSession;
    }
}
