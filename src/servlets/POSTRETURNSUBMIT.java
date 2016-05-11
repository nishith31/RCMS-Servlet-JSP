package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING THOSE STUDY MATERIAL WHICH ARE RETURNED BY THE POSTAL DEPARTMENT. 
THIS SERVLET DELETES THE ENTRY FROM THE STUDENT DESPATCH TABLE,INSERT THE ENTRY INTO THE STUDENT RECEIVE TABLE AND ALSO UPDATES THE MATERIAL INVENTORY TABLE.
CALLED JSP:-From_post1.jsp*/
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
 
public class POSTRETURNSUBMIT extends HttpServlet {

    private static final long serialVersionUID = 1L;
    String current_session = "";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);  
        System.out.println("POSTRETURNSUBMIT SERVLET STARTED.....");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String programmeGuideFlag = request.getParameter("pg_flag").toUpperCase();
            String courseFlag = request.getParameter("course_flag").toUpperCase();
            String enrollmentNumber = request.getParameter("text_enr").toUpperCase();
            String name = request.getParameter("text_name").toUpperCase();
            String programmeCode = request.getParameter("text_prg_code").toUpperCase();
            String currentSession = request.getParameter("txt_session").toLowerCase();
            String date = request.getParameter("txt_date").toUpperCase();
            String receiveRemarks = request.getParameter("txt_reason").toUpperCase();
            String receiveSource = "BY POST";
            String[] course = new String[0];
            if(courseFlag.equals(Constants.YES)) {
                course = request.getParameterValues("crs_code");//all the course codes from the jsp page
            }

            String message =  ""; 
            String expressNumber = null;
            String dispatchDate = null; 
            String medium = null;
            int blockCount = 0;//int variable for number of blocks available with the course
            String[] temp = new String[0];//array of String for multiple use
            int index = 0;
            String programmeGuideValue = null;
            /*logic for getting the number of total courses selected by user*/
            if(courseFlag.equals(Constants.YES)) {
                for(index = 0; index < course.length; index++) {
                    temp = request.getParameterValues(course[index]);
                    if(!isNull(temp)) { 
                        blockCount = blockCount + temp.length;
                    }
                }
            }

            int result = 0, result1 = 0, result2 = 0;
            int programmeGuideResult = 0, programmeGuideResult1 = 0, programmeGuideResult2 = 0;

            String regionalCenterCode = (String)session.getAttribute("rc");
            response.setContentType(Constants.HEADER_TYPE_HTML);
            ResultSet rs = null;
            String actualProgrammeCode = "(crs_code='" + programmeCode + "'";

            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement stmt=connection.createStatement();
                /*LOGIC FOR GETTING THE ACTUAL PROGRAMME CODE OF THE IGNOU DATABASE IF THIS IS NOT THE ACTUAL CODE*/        
                rs = stmt.executeQuery("select * from program where prg_code='" + programmeCode + "'");
                if(!rs.next()) {
                    rs = stmt.executeQuery("select absolute_prg_code from program_program where relative_prg_code='" + programmeCode +
                            "' and rc_code='" + regionalCenterCode + "'");

                    if(rs.next()) {
                        actualProgrammeCode = actualProgrammeCode + " or crs_code='" + rs.getString(1) + "'";
                    }
                }
                actualProgrammeCode = actualProgrammeCode  + ")";
                /*LOGIC FOR SUBMITTING THE ENTRY OF PROGRAMME GUIDE*/       
                if(programmeGuideFlag.equals(Constants.YES)) {
                    programmeGuideValue = request.getParameter("pg_checkbox");
                }

                if(programmeGuideFlag.equals(Constants.YES) && programmeGuideValue != null ) {
                    String programmeGuideExpress = request.getParameter("pg_express").toUpperCase();
                    String programmeGuideDate = request.getParameter("pg_date").toUpperCase();
                    String programmeGuideMedium = request.getParameter("pg_medium").toUpperCase();

                    programmeGuideResult = stmt.executeUpdate("insert into student_receive_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " values('" + enrollmentNumber + "','" + programmeCode + "','" + programmeCode + "','PG',1,'" + programmeGuideMedium 
                            + "','" + date + "','" + receiveSource + "','" + receiveRemarks + "','" + programmeGuideExpress + "','" + programmeGuideDate + "')");

                    programmeGuideResult1 = stmt.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " set qty=qty+1 where " + actualProgrammeCode + " and block='PG' and medium='" + programmeGuideMedium + "'");

                    programmeGuideResult2 = stmt.executeUpdate("delete from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where enrno='" + enrollmentNumber + "' and " + actualProgrammeCode + 
                            " and block='PG' and dispatch_source='BY POST' and express_no='" + programmeGuideExpress + "'");

                    if(programmeGuideResult > 0 && programmeGuideResult1 > 0 && programmeGuideResult2 > 0) {
                        message = "Material of Programme Guide Updated successfully Returned from Post for " + programmeCode + 
                                " <br/> Roll No." + enrollmentNumber + "<br/>Name. " + name + "<br/>";
                    } else {
                        message = "Failed to perform Update the PG.<br/>Please Check on the Server Console or Database";
                    }
                }  

                if (course.length > 0) {
                    System.out.println(course.length +" Courses Selected By the Student");
                    /*logic for getting all the courses selected by the user*/
                    if (blockCount != 0) {
                        for(index = 0; index < course.length; index++) {
                            String[] courseBlock = request.getParameterValues(course[index]);
                            if(!isNull(courseBlock)) {
                                int len = course[index].length();
                                for(int e = 0; e < courseBlock.length; e++) {
                                    expressNumber = request.getParameter(courseBlock[e]);
                                    dispatchDate = request.getParameter(courseBlock[e] + "D");
                                    medium = request.getParameter(courseBlock[e] + "M");
                                    String courseCheck = courseBlock[e].substring(0, len);
                                    String blockCheck = courseBlock[e].substring(len);
                                    String initial = blockCheck.substring(0, 1);
                                    if(course[index].trim().equals(courseCheck)) {
                                        if(initial.trim().equals("B")) {
                                            result += stmt.executeUpdate("insert into student_receive_" + currentSession + Constants.UNDERSCORE +
                                                    regionalCenterCode + " values('" + enrollmentNumber + "','" + programmeCode + "','" + course[index] + "','"
                                                    + blockCheck + "',1,'" + medium + "','" + date + "','" + receiveSource + "','" +
                                                    receiveRemarks + "','" + expressNumber + "','" + dispatchDate + "')");

                                            result1 += stmt.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + 
                                                    regionalCenterCode + " set qty=qty+1 where crs_code='" + course[index] + "' and block='" + blockCheck
                                                    + "' and medium='" + medium + "'");

                                            result2 += stmt.executeUpdate("delete from student_dispatch_" + currentSession + Constants.UNDERSCORE +
                                                    regionalCenterCode + " where enrno='" + enrollmentNumber + "' and crs_code='" + course[index] + "' and block='"
                                                    + blockCheck + "' and dispatch_source='BY POST' and medium='" + medium + "' and express_no='" + expressNumber + "'");
                                        }
                                    }
                                }
                            }
                        } 
                    } 

                    if(result == blockCount && result1 == blockCount && result2 == blockCount) {
                        message = message + "Material Updated Successfully Returned from Post for " + blockCount + 
                                " Blocks <br/> Roll No." + enrollmentNumber + "<br/>Name. " + name+"<br/>";
                    } else {
                        message = message + "Failed to Perform Update Command for Blocks.<br/>Please Check on the Server Console or Database";
                    }
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_post.jsp").forward(request, response);

                } else if(programmeGuideFlag.equals(Constants.YES) && programmeGuideValue != null ) {
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_post.jsp").forward(request, response);
                } else {
                    System.out.println("Please Select Course code to be Received First");
                    message = "Please Select Course Code For Receive First";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("POSTRETURNSEARCH?txt_enr=" + enrollmentNumber + "").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from From_post.jsp " + exception);
                message = "Some Serious Exception Hitted the page. Please check on Server Console for Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_post.jsp").forward(request, response);
            }
        }
    }
}