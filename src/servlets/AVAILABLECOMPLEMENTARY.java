package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABILITY OF THE COURSE SELECTED BY THE USER FOR THE COMPLEMENTARY DESPATCH.
THIS SERVLET TAKES THE COURSE CODES SELECTED BY THE
USER AS INPUT AND THEN CHECKS THE AVAILABILITY OF THE COURSES IN THE MATERIAL DATABASE,AVAILABILITY OF THE COURSES SENT TO THE BORWSER AS OUTPUT.
CALLED JSP:-Complementary.jsp*/
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
 
public class AVAILABLECOMPLEMENTARY extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("AVAILABLECOMPLEMENTARY SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
        } else {
            String regionalCenterCode = (String)session.getAttribute("rc");
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE BROWSER SELECTED BY THE USER*/
            String programmeCode = request.getParameter("mnu_prg_code").trim();//getting the value of the programme code from the browser
            String courseCode = request.getParameter("mnu_crs_code").trim();//getting the value of the first course code from the browser
            String courseCode2 = request.getParameter("mnu_crs_code2").trim();//getting the value of the second course code from the browser
            String courseCode3 = request.getParameter("mnu_crs_code3").trim();//getting the value of the third course code from the browser
            String courseCode4 =    request.getParameter("mnu_crs_code4").trim();//getting the value of the forth course code from the browser
            String medium               =    request.getParameter("txt_medium").toUpperCase();//gerring the medium  selecte by the user from the browser
            String currentSession =    request.getParameter("txt_session").toLowerCase();//getting the value of the current session from tehe browser
            System.out.println("all parameters received");
            /*LOGIC ENDS FOR GETTING THE PARAMETERS FROM THE BROWSER*/  
            String message = "";
            request.setAttribute("current_session", currentSession);//sending the value of the current session to the browser
            int index = 0;
            if(!courseCode.equals(Constants.NONE)) {
                index++;
            }
            
            if(!courseCode2.equals(Constants.NONE)) {
                index++;
            }
                    
            if(!courseCode3.equals(Constants.NONE)) {   
                index++;
            }
            if(!courseCode4.equals(Constants.NONE)) {
                index++;
            }
            String courses[]        =   new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
            int blocks[]            =   new int[index];//INT ARRAY FOR HOLDING NUMBER OF BLOCKS FOR EACH COURSE SELECTED
    
            int insert              =   0;
            if(!courseCode.equals(Constants.NONE)) {
                courses[insert] = courseCode;
                insert++;
            }
    
            if(!courseCode2.equals(Constants.NONE)) {
                courses[insert] = courseCode2;
                insert++;
            }
    
            if(!courseCode3.equals(Constants.NONE)) {
                courses[insert] = courseCode3;
                insert++;
            }
    
            if(!courseCode4.equals(Constants.NONE)) {
                courses[insert]=courseCode4;
                insert++;
            }
    
            response.setContentType(Constants.HEADER_TYPE_HTML);
            ResultSet rs = null;
            try {
                Connection con = connections.ConnectionProvider.conn();
                Statement stmt = con.createStatement();
                int totalLength = 0, count = 0;
                /*Logic for creating int variable of blocks of the courses selected*/
                for(int m = 0; m < index; m++) {
                    rs      =   stmt.executeQuery("Select no_of_blocks from course where crs_code='"+courses[m]+"'");
                    while(rs.next())
                    blocks[m]           =   rs.getInt(1);
                }//end of for loop
                /*Logic end here for getting all the blocks*/
    
                /*Logic for counting the total number of courses with block like MCS51B1*/
                for(int i = 0; i < courses.length; i++) {
                    totalLength = totalLength+blocks[i];
                }
                /*Logic ends here for counting the total number of courses with block like MCS51B1*/
                int[] stock             =   new int[totalLength];//int array for holding the stock available for all courses blockwise
                String courseBlock[]   =   new String[totalLength];//array for holding all the courses block wise
                /*logic for creating array of course_block & stock availability*/
                String boro=null;
    
                for(int a = 0; a < courses.length; a++) {
                    for(int b = 1; b <= blocks[a]; b++) {
                        courseBlock[count] = courses[a] + "B" + b;
                        boro = "B" + b;
                        rs = stmt.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + 
                                regionalCenterCode + " where crs_code='" + courses[a] + "' and block='" + boro + "' and medium='" + medium + "'");
                        while(rs.next()) {
                            stock[count] = rs.getInt(1);
                        }
            
                        System.out.println(courseBlock[count]+" "+stock[count]);
                        count++;
                        }
                }
                /*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
                request.setAttribute("courses", courses);
                request.setAttribute("course_block", courseBlock);
                request.setAttribute("blocks", blocks);
                request.setAttribute("stock", stock);

                message= " Available Stock Status:<br/>";
                count = 0;
                for(int i=0;i<courses.length;i++) {
                    message = message + courses[i] + "<br/>";
                    for(int j = 1; j <= blocks[i]; j++) {
                        message = message + stock[count] + " Sets of B" + j + "<br/>";
                        count++;
                    }
                }
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/Complementary1.jsp?prg_code=" + programmeCode + "&medium=" + medium).forward(request,response);   
    
            } catch(Exception exception) {
                System.out.println("Exception raised from AVAILABLECOMPLEMENTARY.java and is " + exception);
                message="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg",message);
                request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);
            }
        }
    } 
}