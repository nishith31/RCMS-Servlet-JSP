package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE PERSONAL DETAILS AND DESPATCH DETAILS OF THE STUDENT WHOSE ROLL NO HAS BEEN ENTERED IN THE BROWSER,
 * IF NO DESPATCH DETAILS FOUND THEN REDIRECTS TO THE SAME PAGE AND IF DETAILS FOUND THEN REDIRECTS TO THE FROM_POST1.JSP FROM WHERE RECEVING WILL BE STARTED.
CALLED JPS:-From_post.jsp*/
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
 
public class POSTRETURNSEARCH extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    String currentSession = "";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("POSTRETURNSEARCH SERVLET STARTED TO EXECUTE");
    } 
    @SuppressWarnings("resource")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String enrollmentNumber = request.getParameter("txt_enr");//getting the enrollment number of the student from the browser
            String message = null;
            String programme = null;
            String name = null;
            String medium = null; 
            int index = 0;
            String programmeGuideFlag = null, programmeGuideDate = null, programmeGuideMedium = null,
            programmeGuideChallanNumber = null, programmeGuidePacketType = null, programmeGuideParcelNumber = null;
            String courseFlag = null;
            
            String regionalCenterCode = (String)session.getAttribute("rc");
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                /*logic for getting the value of the current session of the RC*/
                ResultSet rs = statement.executeQuery("select TOP 1 session_name from sessions_" + regionalCenterCode + " order by id DESC");
                while(rs.next()) {
                    currentSession = rs.getString(1).toLowerCase();
                }
                
                request.setAttribute("current_session", currentSession);
                /*LOGIC FOR CHECKING THE DESPATCH OF PROGRAMME GUIDE TO THE STUDENT*/
                rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode +
                        " where enrno='" + enrollmentNumber + "' and block='PG' and dispatch_source='BY POST'");
                if(rs.next()) {
                    programmeGuideFlag = Constants.YES;
                    programmeGuideDate = rs.getDate(6).toString();
                    programmeGuideMedium = rs.getString(8);
                    programmeGuideChallanNumber = rs.getString(9);
                    programmeGuidePacketType = rs.getString(11);
                    programmeGuideParcelNumber = rs.getString(14).trim();
                    request.setAttribute("pg_date", programmeGuideDate);
                    request.setAttribute("pg_madhyam", programmeGuideMedium);      
                    request.setAttribute("pg_challan_number", programmeGuideChallanNumber);        
                    request.setAttribute("pg_packet_type", programmeGuidePacketType);      
                    request.setAttribute("pg_parcel_number", programmeGuideParcelNumber);          
                } else {
                    programmeGuideFlag = Constants.NO;
                }
                request.setAttribute("pg_flag", programmeGuideFlag);
                rs = statement.executeQuery("select * from student_dispatch_"+currentSession + Constants.UNDERSCORE + regionalCenterCode
                        + " where enrno='" + enrollmentNumber + "' and block<>'PG' and dispatch_source='BY POST'");
                int len = 0;
                if(rs.next()) {
                    courseFlag = "YES";
                    request.setAttribute("course_flag", courseFlag);
                    rs = statement.executeQuery("select * from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode 
                            + " where enrno='" + enrollmentNumber + "'");
                    while(rs.next()) {   
                        programme = rs.getString(2);         
                        char pr[] = programme.toCharArray();
                        for(int ii = 0; ii < pr.length; ii++) {
                            if(pr[ii] != ' ') {
                                len++;
                            }
                        }
                        if(pr[len - 1] == '1' || pr[len - 1] == '2' || pr[len - 1] == '3' || 
                                pr[len - 1] == '4'|| pr[len - 1] == '5' || pr[len - 1] == '6') {
                            programme = programme.substring(0, len - 1);
                        } 
                        name = rs.getString(5);
                        medium = rs.getString(7);
                    }
                    int dispatchCourseCount = 0;
                    rs = statement.executeQuery("select count(distinct(crs_code)) from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and dispatch_source='BY POST'");

                    while(rs.next()) {
                        dispatchCourseCount = rs.getInt(1);
                    }
                    String courseDispatch[] = new String[dispatchCourseCount];
                    rs = statement.executeQuery("select distinct(crs_code) from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                            + " where enrno='" + enrollmentNumber + "' and block<>'PG' and dispatch_source='BY POST'");
                    index = 0;
                    while(rs.next()) {
                        courseDispatch[index] = rs.getString(1);
                        index++;
                    }
                    index = 0;
                    rs = statement.executeQuery("select count(*) from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                            " where enrno='" + enrollmentNumber + "' and block<>'PG' and dispatch_source='BY POST'");
                    while(rs.next()) {
                        index = rs.getInt(1);
                    }
                    String[] courseBlock = new String[index];
                    String dateDispatch[] = new String[index];
                    String mediums[] = new String[index];
                    String challanNumber[] = new String[index];
                    String packetType[] = new String[index];
                    String parcelNumber[] = new String[index];
                    rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and dispatch_source='BY POST'");
                    index = 0;
                    while(rs.next()) {
                        courseBlock[index] = rs.getString(3).trim() + rs.getString(4).trim();
                        dateDispatch[index] = rs.getDate(6).toString();
                        mediums[index] = rs.getString(8);
                        challanNumber[index] = rs.getString(9);
                        packetType[index] = rs.getString(11);
                        parcelNumber[index] =  rs.getString(14).trim();
                        index++;
                    }
                    try {
                        message = (String)request.getAttribute("alternate_msg");
                    } catch(Exception exception) {
                        message = null;
                    }
                    if(message == null) {
                        message = " ";
                    }
                
                    message = message + "<br/>Found " + dispatchCourseCount +" Course for <br/>Roll No: " + enrollmentNumber
                            + "<br/>Name: " + name + ".";
                    request.setAttribute("msg", message);
                    request.setAttribute("course_dispatch", courseDispatch);
                    request.setAttribute("course_block", courseBlock);
                    request.setAttribute("date_dispatch", dateDispatch);
                    request.setAttribute("medium", mediums);
                    request.setAttribute("challan_number", challanNumber);
                    request.setAttribute("packet_type", packetType);
                    request.setAttribute("parcel_number", parcelNumber);
                    request.getRequestDispatcher("jsp/From_post1.jsp?name=" + name + "&enrno=" + enrollmentNumber +
                            "&prg_code=" + programme + "&medium=" + medium).forward(request, response); 
                } else if(programmeGuideFlag == "YES") {
                    courseFlag = "NO";
                    request.setAttribute("course_flag", courseFlag);
                    rs = statement.executeQuery("select * from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode 
                            + " where enrno='" + enrollmentNumber + "'");
                    while(rs.next()) {   
                        programme = rs.getString(2);         
                        char pr[] = programme.toCharArray();
                        for(int ii = 0; ii < pr.length; ii++) {
                                if(pr[ii] != ' ') {
                                    len++;
                                }
                        }
                        if(pr[len - 1] == '1' || pr[len - 1] == '2' || pr[len - 1] == '3' 
                            || pr[len - 1] == '4' || pr[len - 1] == '5'|| pr[len - 1] == '6') {
                            programme = programme.substring(0, len - 1);
                        } 
                        name = rs.getString(5);
                        medium = rs.getString(7);
                        System.out.println( name + " " + programme + " " + len);
                    }
                    System.out.println("Sorry!! ONLY PROGRAMME GUIDE FOUND DESPATCHED VIA POST.");
                    message = "Despatch of Programme Guide Found for the Roll no..";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_post1.jsp?name=" + name + "&enrno=" + enrollmentNumber + "&prg_code=" + programme + "&medium=" + medium).forward(request, response); 
                } else {
                    System.out.println("Sorry!! Roll No not found please contact to registration department..Thank you.");
                    message = "Sorry!! Roll Number not Found.<br/>Please check Details in the Despatch<br/> Database. Thank You..";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/From_post.jsp").forward(request, response); 
                }
    
            } catch(Exception exception) {
                System.out.println("Exception raised from From_post.jsp " + exception);
                message = "Some Serious Exception Hitted the page.<br/> Please check on Server Console for Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_post.jsp").forward(request, response);
            }
        }
    }
}