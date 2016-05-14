package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABLE STOCK OF THE PROGRAMME GUIDE OF PROGRAMME SELECTED BY THE USER AND SENDS THE INFORMATION TO THE BROWSER ABOUT THE AVAILABILITY AND IT ALSO SENDS THE RC NAME OF THE SELECTED RC WITH ITS NECESSARY DETAILS OF THE RC.S
CALLED JSP:-To_rc_pg.jsp*/
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
public class BYRCAVAILABLE_PG_STOCK extends HttpServlet {

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
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/
            String reg_code = request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE    
            String medium = request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
            String currentSession = request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
            request.setAttribute("current_session", currentSession);
            String regionalCenterCode = (String)session.getAttribute("rc");
            String reg_name = null;
            int index = 0, insert = 0;
            String message = "";
            ResultSet rs = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
            response.setContentType(Constants.HEADER_TYPE_HTML);
            /*LOGIC FOR CHECKING THE SELECTED COURSES AND CREATING THEIR ARRAY OF STRING*/

            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                int totalLength = 0, count = 0;
                int stock = 0;//int array for holding the stock available for all courses block wise
                /*logic for creating array of course_block & stock availability*/
                String boro = null;
                rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                        " where crs_code='" + programmeCode + "' and block='PG' and medium='" + medium + "'");

                while(rs.next()) {
                    stock = rs.getInt(1); 
                }
                    
                request.setAttribute("stock", stock);
                /*Logic for creating reg_name variable of the name of the rc selected rc code*/ 
                rs = statement.executeQuery("select reg_name from regional_centre where reg_code='" + reg_code + "'");
                while(rs.next()) {
                    reg_name=rs.getString(1);
                }

                message = "Available Stock OF PROGRAMME GUIDE OF :" + programmeCode + "<br/> are " + stock + ".";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_rc_pg1.jsp?reg_code=" + reg_code + "&reg_name=" + reg_name + "&prg_code=" + programmeCode + "&medium=" + medium).forward(request, response);
            } catch(Exception exception) {
                System.out.println("Exception raised from BYRCAVAILABLE_PG_STOCK.java and is " + exception);
                message = "Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request, response);
            }
        }
    }
}