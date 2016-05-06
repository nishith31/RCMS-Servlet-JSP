package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING STUDY MATERIALS FROM OTHERS WHO ARE NOT IN THE REGULAR SOURCES,
IF WE HAVE TO RECEIVE PARTIALLY THEN THIS SERVLET WILL REDIRECTS PAGE TO From_others1.jsp AND THERE IT WILL RECEIVE PARTIALLY.
CALLED JSP:-From_others.jsp*/
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
 
public class RECEIVEOTHERS extends HttpServlet {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVEOTHERS SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/    
            String flag = request.getParameter("flag").toUpperCase();
            String courseCode = request.getParameter("course_code").toUpperCase();
            String newCourseCode = request.getParameter("new_course_code").toUpperCase(); 
            String currentSession = request.getParameter("txt_session").toLowerCase();
            String medium = request.getParameter("mnu_medium").toUpperCase();
            int quantity = Integer.parseInt(request.getParameter("text_set"));
            String date = request.getParameter("text_date").toUpperCase();
            String receiveFrom = request.getParameter("receive_from").toLowerCase();
    
            String regionalCenterCode = (String)session.getAttribute("rc");
            System.out.println("fields from others receive page successfully " + medium);
            String message = null;
            String query = null;
            String receiptType = null;
            if(flag.equals("OLD")) {
                query = "select * from others_receive_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                        " where crs_code='" + courseCode + "' and date='" + date + "'";
                receiptType = request.getParameter("receipt_type");
            }
            if(flag.equals("NEW")) {
                query = "select * from others_receive_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                        " where crs_code='" + newCourseCode + "' and date='" + date + "'";
            }

            int index = 0, blocks = 0, no = 0;
            String blockName = "B";
            ResultSet first = null, rs1 = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            int flagForReturn = 0;
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                first = statement.executeQuery(query);
                if(flag.equals("OLD")) {
                    if(receiptType.equals("complete")) {
                        message = "Entry Already Exist for Course: <br/>";
                        rs1 = statement.executeQuery("select no_of_blocks from course where crs_code='" + courseCode + "'");
                        while(rs1.next()) {
                            blocks = rs1.getInt(1);
                        }
            
                        for(index = 0; index < blocks; index++) {
                            no = index + 1;
                            blockName = "B" + no;
                            first = statement.executeQuery("select * from others_receive_" + currentSession + Constants.UNDERSCORE + 
                                    regionalCenterCode + " where crs_code='" + courseCode + "' and block='" + blockName + "' and date='" + date + "'");
                            if(first.next()) {
                                flagForReturn = 1;
                                System.out.println("Entry Already Exist for Course " + courseCode + " block: " + blockName + " for date " + date);
                                message = message + courseCode + blockName + " for date " + date + " in medium.<br/>";
                            }
                        }
                        if(flagForReturn==0) {
                            message = "Received Successfully  Course <br/>";
                            for(index = 0; index < blocks; index++) {
                                no = index + 1;
                                blockName =  "B" + no;
                                statement.executeUpdate("insert into others_receive_" + currentSession + Constants.UNDERSCORE + regionalCenterCode+" values('"
                                + courseCode + "','" + blockName + "'," + quantity + ",'" + medium + "','" + date + "','" + receiveFrom + "')");

                                statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                        " set qty=qty+" + quantity + " where crs_code='" + courseCode + "' and block='" + blockName + "' and medium='" + medium + "'");     

                                message = message + courseCode + blockName + " for date " + date + " in medium " + medium + "<br/>";
                            }
                            request.setAttribute("msg", message);
                            request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);  
                        } else {
                            //IF ENTRIES ALREADY FOUND THEN THIS ELSE WILL WORK AND GIVE MESSAGE TO THE BROWSER
                            request.setAttribute("msg", message);
                            request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                        }

                    } else {
                        //redirect to the from_others1.jsp page for partial receipt
                        rs1 = statement.executeQuery("select no_of_blocks from course where crs_code='" + courseCode + "'");
                        while(rs1.next()) {
                            blocks = rs1.getInt(1);
                        }
            
                        message = "Partial Receipt of Materials of Course " + courseCode;
                        request.setAttribute("blocks", blocks);
                        request.setAttribute("crs_code", courseCode);
                        request.setAttribute("qty", quantity);
                        request.setAttribute("current_session", currentSession);
                        request.setAttribute("medium", medium);
                        request.setAttribute("date", date);
                        request.setAttribute("receive_from", receiveFrom);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_others1.jsp").forward(request, response);
                    }
                }

                if(flag.equals("NEW")) {
                    message = "Entry Already Exist for Course: <br/>";
                    first = statement.executeQuery("select * from others_receive_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where crs_code='" + newCourseCode + "' and block='BLOCK' and date='" + date + "'");
                    if(first.next()) {
                        flagForReturn = 1;
                        message = message + newCourseCode + " for date " + date + ".<br/>";
                    }
                    if(flagForReturn==0) {
                        message = "Received Successfully  Course <br/>";
                        statement.executeUpdate("insert into others_receive_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " values('" + newCourseCode
                                + "','BLOCK'," + quantity + ",'" + medium + "','" + date + "','" + receiveFrom + "')");

                        message = "Successfully received " + quantity + " Sets of " + newCourseCode + ".";
                        System.out.println("Successfully receive materials...");
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                    } else {
                        System.out.println("Duplicate Records found please change the date or course code");
                        message = "Entry Already exist for Course and date selected.";
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                    }
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from RECEIVEOTHERS page and exception is " + exception);
                message = "Some Serious Exception came at the page. Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
            }
        }
    } 
}