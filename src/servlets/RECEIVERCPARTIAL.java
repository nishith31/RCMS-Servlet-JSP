package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING DATA TO RC RECEIVE TABLE AND UPDATING MATERIAL TABLE. 
IT ALSO CHECKS THE VIOLATION OF PRIMARY KEY MEANS DUPLICATE DATA CAN NOT BE ENTER IN THE RC RECEIVE TABLE.
THIS SERVLET GETS ALL THE REQUIRED FIELDS FROM THE BROWSER AND AFTER CHECKING ALL THE CONSTRAINTS INSERT AND UPDATE THE CORRESPONDING TABLES.
CALLED JSP:-From_rc1.jsp*/
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
 
public class RECEIVERCPARTIAL extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVERCPARTIAL SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession(false);
        if(session == null) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg",message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
        } else {

            String currentSession = request.getParameter("txt_session").toLowerCase();//getting the value of current session
            String reg_code = request.getParameter("mnu_reg_code").toUpperCase();//gettting the prgram code
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//gettting the prgram code
            String[] course = request.getParameterValues("crs_code");//all the course codes from the jsp page
            int blockCount = 0;//int variable for number of blocks available with the course
            int count = 0;//int variable for multiple use
            String[] temporary = new String[0];//array of String for multiple use
            int crs_select=0;//variable used to store number of courses selected to be dispatched
            int index = 0;
            /*logic for getting the number of total courses selected by user*/
            for(index = 0; index < course.length; index++) {
                temporary = request.getParameterValues(course[index]);
                if(temporary != null) {
                    crs_select++;
                    blockCount = blockCount + temporary.length;
                }
            }
            /*logic ends here*/
            String[] course_dispatch    =    new String[blockCount];//array for holding the blocks to be receieved
            String[] blockQuantity            =    new String[blockCount];//array for holding the quantity of the blocks to be received
            /*logic for getting all the courses selected by the user*/
            for(index = 0; index < course.length; index++) {
                String[] course_block = request.getParameterValues(course[index]);
                if(course_block != null) {
                    int len=course_block.length;
                    for(int e = 0; e < len; e++) {
                        course_dispatch[count] = course_block[e];
                        blockQuantity[count]=request.getParameter(course_block[e]);
                        count++;
                    }
                }
            }
            /*logic ends here*/ 
            String medium           =    request.getParameter("txt_medium").toUpperCase();
            String date             =    request.getParameter("txt_date").toUpperCase();//date from the jsp page date field
            int quantity = 0;
            int actualQuantity = 0;
            int flagForReturn = 0;
    
            ResultSet rs            =   null;
            System.out.println("All the Parameters received");
            request.setAttribute("current_session",currentSession);//setting the value of current session to the request
            String message="";  
            String rc_code=(String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
            response.setContentType("tex-t/html");
            try {
                Connection con=connections.ConnectionProvider.conn();//creating the connection object for the database
                Statement stmt=con.createStatement();//fetching the refernce of the statement from the connection object.
                int result=5,result1=5;
                if (blockCount != 0) {
                    quantity = blockCount;
                    message="Entry Already Exist for Course: <br/>";
                    for(int z = 0; z < course.length; z++) {
                    int len=course[z].length();
                    for(int y=0;y<course_dispatch.length;y++) {
                        String course_check = course_dispatch[y].substring(0,len);
                        String block_check  =course_dispatch[y].substring(len);
                        String initial      =block_check.substring(0,1);
                        if(course[z].equals(course_check)) {
                            if(initial.equals("B")) {
                                rs=stmt.executeQuery("select * from rc_receive_"+currentSession+"_"+rc_code+" where reg_code='"+reg_code+"' and crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"' and date='"+date+"'");
                                if(rs.next()) {
                                    message=message+course[z]+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
                                    flagForReturn=1;
                                }
                            }
                        }
                    }
                }
                if(flagForReturn==0) {
                    message = "Received Successfully from RC Course <br/>";
                    int inc=0;
                    for(int z=0;z<course.length;z++) {
                    int len=course[z].length();
                    for(int y=0;y<course_dispatch.length;y++) {
                        String course_check=course_dispatch[y].substring(0,len);
                        String block_check=course_dispatch[y].substring(len);
                        String initial=block_check.substring(0,1);
                        if(course[z].equals(course_check)) {
                            if(initial.equals("B")) {
                                result=stmt.executeUpdate("insert into rc_receive_"+currentSession+"_"+rc_code+"(reg_code,crs_code,block,qty,medium,date)values('"+reg_code+"','"+course[z]+"','"+block_check+"',"+blockQuantity[inc]+",'"+medium+"','"+date+"')");   
                                result1=stmt.executeUpdate("update material_"+currentSession+"_"+rc_code+" set qty=qty+"+blockQuantity[inc]+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
                                message=message+course[z]+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
                                inc++;
                            }
                        }
                    }
                }    
                    if(result==1 && result1==1) {   
                        System.out.println("Materials for "+course.length+" courses received from RC");   
                    } else if(result==1 && result1 !=1) {
                        System.out.println("Receive table hitted but material table not affected..!!!!!");   
                    } else {
                        System.out.println("NO operation performed.!!!!!");   
                    }
                    request.setAttribute("msg",message);
                    request.getRequestDispatcher("jsp/From_rc.jsp").forward(request,response);                      
                } else { //if material is out of stock then this section will work and give message to the user
                    request.setAttribute("msg",message);
                    request.getRequestDispatcher("jsp/From_rc.jsp").forward(request,response);
                }
            } else {
                System.out.println("Sorry !!Not any courses Selected...");
                message="Sorry!! Not any courses selected..";
                request.setAttribute("alternate_msg",message);
                request.getRequestDispatcher("jsp/From_rc.jsp").forward(request,response);
            }
        } catch(Exception exception) {
            System.out.println("Exception raised from RECEIVERCPARTIAL.java and exception is: " + exception);
            message="Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/From_rc.jsp").forward(request,response);
        }
    }
    } 
}