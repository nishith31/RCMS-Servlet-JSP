package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR UPDATING THE EXPRESS PARCEL NUMBER OF THE COURSES DESPATCHED BY POST FOR THE STUDENTS.
THIS SERVLET TAKES THE DETAILS OF THE DESPATCHED COURSES FROM THE BROWSER AND THEN UPDATE THE NEW EXPRESS PARCEL NUMBER FOR
THE SELECTED COURSES.
CALLED JSP:-Lot_Update1.jsp*/
import static utility.CommonUtility.isNull;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.Constants;
 
public class LOTUPDATE extends HttpServlet {

    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("LOTUPDATE SERVLET STARTED TO EXECUTE");
    } 

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java

        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {   
            String regionalCenterCode = (String)session.getAttribute("rc");
            /*LOGIC FOR GETTING THE PARAMETERS FROM THE BROWSER LIKE NAME ROLL NO*/
            String message = "";
            String currentSession = null;
            try {
                String lots[] = request.getParameterValues("lot_name");//all the lot name from the jsp page
                String lotsName[] = new String[lots.length];

                int index = 0;
                for(index = 0; index < lots.length; index++) {
                    lotsName[index] = request.getParameter(lots[index]);
                }

                int programmeGuideResult = 0;
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                ResultSet rs = null;
                /*Logic for getting the current session name from the sessions table of the regional centre logged in and send to the browser*/ 
                rs = statement.executeQuery("select TOP 1 session_name from sessions_" + regionalCenterCode + " order by id DESC");
                while(rs.next()) {
                    currentSession = rs.getString(1).toLowerCase();
                }

                for(index = 0; index < lots.length; index++) {
                    programmeGuideResult += statement.executeUpdate("update student_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " set lot='" + lotsName[index] + "' where lot_name='" + lots[index] + "'");        
                }

                if(programmeGuideResult > 0) {
                    message = "Successfully Updates " + lots.length + " Lots Name.<br/>Total Updated Student are : " + programmeGuideResult + ".<br/>";
                } else {
                    message = "Failed to update";
                }

                request.setAttribute("lots", lots);
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request, response);
            } catch(Exception exception) {
                message = "Some Serious Exception Hitted the page. Please check on Server Console for Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request, response);
            }
        }
    }
}