package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING PROGRAMME GUIDE FROM OTHERS,MEANS PROGRAMME GUIDE RECEIVED FROM ANY OTHER SOURCE EXCEPT 
THE REGULAR SOURCE AND THE TRANSACTION RECORDED INTO OTHERS RECEIVE TABLE AND MATERIAL TABLE IS ALSO UPDATED ON SUCCESSUFUL TRANSACTION.
CALLED JSP:-From_others_pg.jsp*/
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
 
public class RECEIVE_PG_OTHERS extends HttpServlet {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVE_PG_OTHERS SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST AND STORING THEM IN THE VARIABLES*/
            String  programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
            String  programmeCode2 = request.getParameter("mnu_prg_code2").toUpperCase();
    
            String  medium = request.getParameter("txt_medium").toUpperCase();
            String  medium2 = request.getParameter("txt_medium2").toUpperCase();
    
            String  date = request.getParameter("txt_date").toUpperCase();
            String currentSession = request.getParameter("txt_session").toLowerCase();
            String receiveFrom = request.getParameter("receive_from").toLowerCase();
            String regionalCenterCode = (String)session.getAttribute("rc");
        
            /*LOGIC ENDS HERE FOR GETTING THE PARAMETERS FORM THE REQUEST*/ 
            System.out.println("fields from From_mpdd_pg.jsp received Successfully");   
            String message;
            int index = 0, flag = 0;
            /*LOGIC FOR CHECKING THE SELECTED COURSE AND STORING THEM IN STRING ARRAY AND QUANTITIES IN INTEGER ARRAY*/     
            if(!programmeCode.equals(Constants.NONE)) {
                index++;
            }
            
            if(!programmeCode2.equals(Constants.NONE)) {
                index++;
            }

            String courses[] = new String[index];
            String mediums[] = new String[index];
            int quantities[] = new int[index];
            int insert = 0;
            if(!programmeCode.equals(Constants.NONE)) {
                courses[insert] = programmeCode;
                mediums[insert] = medium;
                quantities[insert] = Integer.parseInt(request.getParameter("text_qty"));
                insert++;
            }
    
            if(!programmeCode2.equals(Constants.NONE)) {
                courses[insert] = programmeCode2;
                mediums[insert] = medium2;
                quantities[insert] = Integer.parseInt(request.getParameter("text_qty2"));
                insert++;
            }

            ResultSet first = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                /*LOGIC FOR CHECKING THE EXISTENCE OF THE ENTRIES TO BE MADE IN DATABSE ALREADY*/   
                message = "Entry Already Exist for PROGRAMME GUIDE OF: <br/>";
    
                for(int i = 0; i < courses.length; i++) {
                    first = statement.executeQuery("select * from others_receive_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where crs_code='" + courses[i] + "' and block='PG' and date='" + date + "'");
                    if(first.next()) {
                        flag = 1;
                        message = message + courses[i] + "  for Date " + date + " <br/>";
                    }
                }
                /*LOGIC ENDS HERE FOR CHEKING THE EXISTENCE OF THE ENTRIES TO BE MADE*/
                if(flag == 0) {
                    message = "Received Successfully PROGRAMME GUIDES OF <br/>";
                    for(int i = 0; i < courses.length; i++) {
                        statement.executeUpdate("insert into others_receive_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                "(crs_code,block,qty,medium,date,receive_from) values('" + courses[i] + "','PG'," + quantities[i] + ",'" + mediums[i] + "','"
                                + date+"','" + receiveFrom +"')");

                        statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " set qty=qty+" + 
                                quantities[i] + " where crs_code='" + courses[i] + "' and block='PG' and medium='" + mediums[i] + "'");
                        message = message + courses[i] + "  For Date " + date + " in Medium " + mediums[i] + "<br/>";
                    }
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request, response);  
                } else {
                    //IF THIS ELSE WILL WORK MEANS ENTRIES ALREADY EXIST AND CAN NOT ENTER AGAIN.....
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from RECEIVE_PG_OTHERS.JAVA page and exception is " + exception);
                message = "Some Serious Exception came at the page. Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request, response);
            }
        }
    }
}