package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE TOTAL NUMBER OF STUDENTS WITH THE COURSE SELECTED BY THE USER IN THE FIRST PAGE WHERE USER SELECT THE STUDY CENTRE CODE,PROGRAM CODE,SEMESTER OR YEAR NUMBER AND THE COURSE CODE.AS A RESULT THIS PAGE SENDS THE TOTAL LIST OF STUDENTS TO SECOND PAGE WITH THE FACILITY OF DISABLED STUDENTS MEANS THOSE DATA WILL BE DISABLED WHICH WERE ALREADY DESPATCHED.
CALLED JSP:-To_sc_office_pg.jsp*/
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
 
public class BYSCPRIVATE_PG_STOCK extends HttpServlet {

    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    } 

    @SuppressWarnings("unused")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String studyCenterCode = request.getParameter("mnu_sc_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
            String medium = request.getParameter("text_medium").toUpperCase();//FIELD FOR GETTING THE MEDIUM OPTED BY THE STUDENT
            String currentSession = request.getParameter("text_session").toLowerCase();//FIELD FOR GETTING THE  SESSION NAME
            String message = "";            //VARIABLE FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
            String studyCenterName = "";
            int result = 5, result1 = 5;
            ResultSet rs = null;  
            String regionalCenterCode = (String)session.getAttribute("rc");
            response.setContentType(Constants.HEADER_TYPE_HTML);
            request.setAttribute("current_session", currentSession);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                /*Logic for creating int variable of available sets of the blocks of the course selected*/
                int availableQuantity = 0;
                int index = 0;
                rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" + 
                        programmeCode + "' and block='PG' and medium='" + medium + "'");
                while(rs.next()) {
                    availableQuantity = rs.getInt(1);
                }

                message = message + "Available Stock Status:" + availableQuantity + "</br> PROGRAMME GUIDE of " + programmeCode + ".</br>";
                request.setAttribute("available_qty", availableQuantity);
                rs = statement.executeQuery("select sc_name from study_centre where sc_code='" + studyCenterCode + "'");
                while(rs.next()) {
                    studyCenterName = rs.getString(1);//getting the sc_name from database
                }

                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_sc_office_pg1.jsp?sc_code=" + studyCenterCode + "&sc_name=" + studyCenterName + "&prg_code=" + programmeCode
                            + "&medium=" + medium).forward(request, response); 

            } catch(Exception exception) {
                System.out.println("Exception raised from BYSCPRIVATE_PG_STOCK.java and exception is " + exception);
                message = "Some Serious Exception came.Please check on the Server Console for more Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
            }
        }
    }
}