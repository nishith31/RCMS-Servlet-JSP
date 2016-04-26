package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABILITY OF THE COURSE CODE SELECTED BY THE USER FOR DESPATCHING TO THE RC ,
THIS SERVLET TAKES THE PROGRAMME CODE,COURSE CODE,RC NAME,MEDIUM AS INPUT FROM THE DATA AND DISPLAYS THE RESULT IN THE NEXT PAGE WITH APPROPRIATE MESSAGE.
CALLED JSP:-To_rc.jsp*/
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
public class BYRCAVAILABLESTOCK extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        System.out.println("BYRCAVAILABLESTOCK SERVLET STARTED FROM INIT METHOD");
        super.init(config);
    }
    
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(session == null) {
            String message="Please Login to Access MDU System";
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
        } else {
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/
            String reg_code         =    request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
            String prg_code         =    request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE    
            String  courseCode                =    request.getParameter("mnu_crs_code").toUpperCase();
            String  courseCode2               =    request.getParameter("mnu_crs_code2").toUpperCase();
            String  courseCode3               =    request.getParameter("mnu_crs_code3").toUpperCase();
            String  courseCode4               =    request.getParameter("mnu_crs_code4").toUpperCase();
            String  courseCode5               =    request.getParameter("mnu_crs_code5").toUpperCase();
            String medium           =    request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
            String currentSession  =    request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
            request.setAttribute("current_session", currentSession);
            String regionalCenterCode          =   (String)session.getAttribute("rc");
            String reg_name = null;
            int index = 0, insert = 0;
            String message = "";
            ResultSet rs = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
            response.setContentType(Constants.HEADER_TYPE_HTML);
            /*LOGIC FOR CHECKING THE SELECTED COURSES AND CREATING THEIR ARRAY OF STRING*/
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
            if(!courseCode5.equals(Constants.NONE)) {
                index++;
            }
            String courses[]        =   new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
            int blocks[]            =   new int[index];//INT ARRAY FOR HOLDING NUMBER OF BLOCKS FOR EACH COURSE SELECTED
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
                courses[insert] = courseCode4;
                insert++;
            }
            if(!courseCode5.equals(Constants.NONE)) {
                courses[insert] = courseCode5;
                insert++;
            }
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                int totalLength = 0, count = 0;
                /*Logic for creating int variable of blocks of the courses selected*/
                for(int m=0;m<index;m++) {
                    rs      =   statement.executeQuery("Select no_of_blocks from course where crs_code='"+courses[m]+"'");
                    while(rs.next()) {
                        blocks[m]           =   rs.getInt(1);
                    }
                
                }
                /*Logic for counting the total number of courses with block like MCS51B1*/
                for(int i = 0; i < courses.length; i++) {
                    totalLength = totalLength + blocks[i];
                }
                int[] stock             =   new int[totalLength];//int array for holding the stock available for all courses blockwise
                String courseBlock[]   =   new String[totalLength];//array for holding all the courses block wise
                /*logic for creating array of course_block & stock availability*/
                String boro = null;
                for(int a=0;a<courses.length;a++) {
                    for(int b=1;b<=blocks[a];b++) {
                        courseBlock[count]=courses[a]+"B"+b;
                        boro = "B" + b;
                        rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" 
                        + courses[a] + "' and block='" + boro + "' and medium='"+medium+"'");
                        while(rs.next()) {
                            stock[count]=rs.getInt(1);
                        }
                        count++;
                    }
                }
                /*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
                request.setAttribute("courses", courses);
                request.setAttribute("course_block", courseBlock);
                request.setAttribute("blocks", blocks);
                request.setAttribute("stock", stock);
                /*Logic for creating reg_name variable of the name of the rc selected rc code*/ 
                rs = statement.executeQuery("select reg_name from regional_centre where reg_code='" + reg_code + "'");
                while(rs.next()) {
                    reg_name = rs.getString(1);
                }
            
                message = "Available Stock Status:<br/>";
                count = 0;
                for(int i=0;i<courses.length;i++) {
                    message = message + courses[i] + "<br/>";
                    for(int j=1;j<=blocks[i];j++) {
                        message = message + stock[count]+" Sets of B"+j+"<br/>";
                        count++;
                    }
                }
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_rc1.jsp?reg_code=" + reg_code + "&reg_name=" + reg_name + "&prg_code=" + prg_code + "&medium="+medium+"").forward(request, response);       
            } catch(Exception exception) {
                System.out.println("Exception raised from BYRCSUBMIT.java and is " + exception);
                message = "Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_rc.jsp").forward(request, response);
            }
        }
    }
}