package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING DATA INTO STUDENT DESPATCH TABLE SECOND TIME MEANS IF ANY STUDENT HAVE NOT RECEIVED THE 
 * MATERIALS SENT BY POST THEN WE CAN GIVE HIM/HER AGAIN THE MATERIALS AND MARKED AS REENTRY, AND UPDATING THE MATERIAL TABLE.AFTER RECEIVING
 *  DATA SUCCESSFULLY FROM THE BROWSER IT CHECKS FOR PRIMARY KEY VIOLATION AND IF EVERYTHING IS OK THEN IT SAVES ALL THE DATA TO CORESSPONDING TABLES.   
CALLED JSP:- By_hand3.jsp*/
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
 
public class BYHANDREENTRYSUBMIT extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    } 

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            /*Logic for getting all the parameters from the browser*/
            String enrollmentNumber =    request.getParameter("text_enr").toUpperCase();//enrolment number of the student
            String name = request.getParameter("text_name").toUpperCase();//name of the student
            String currentSession = request.getParameter("text_session").toLowerCase();//value of the current session of the rc
            String programmeCode = request.getParameter("text_prog_code").toUpperCase();//program code of the student
            request.getParameter("text_year");
            String[] course = request.getParameterValues("crs_code");//all the course codes from the jsp page
            String reentryMessage = request.getParameter("mnuremarks").toUpperCase();//reentry message of for the transaction
            int blockCount = 0;
            int count = 0;
            String[] temporaryVar = new String[0];
            /*logic for getting the number of total courses selected by user*/
            for(int c = 0; c < course.length; c++) {
                temporaryVar = request.getParameterValues(course[c]);
                if(temporaryVar != null) {
                    blockCount = blockCount + temporaryVar.length;
                }
            }
            String[] courseDispatch = new String[blockCount];//array for holding the courses to be Despatched
            /*logic for getting all the courses selected by the user*/
            for(int d = 0; d < course.length; d++) {
                String[] courseBlock = request.getParameterValues(course[d]);
                if(courseBlock != null) {
                    int len = courseBlock.length;
                    for(int e = 0; e < len; e++) {
                        courseDispatch[count] = courseBlock[e];
                        count++;
                    }
                }
            }
            String programmeGuideFlag = request.getParameter("pg_flag");//getting the year or semester code    
            String programmeGuideValue = null;
            if(programmeGuideFlag.equals("NO")) {
                programmeGuideValue = request.getParameter("program_guide");
            }
            String medium = request.getParameter("text_medium").toUpperCase();
            String date = request.getParameter("text_date").toUpperCase();//date from the jsp page date field
            String disptachSource = "BY HAND";//for the Despatch source field of the student_Despatch table for post it is BY POST AND BY SC for study centre Despatch moce
            String reentry = "YES";
            int actualQuantity = 0;
            String relativeCourse = null;
            int flagForProgrammeGuide = 0;
            int flagForReturn = 0;
            int index = 0;
            ResultSet rs;
            ResultSet rs1;
            request.setAttribute("current_session", currentSession);
            String message = "";

            String regionalCenterCode = (String)session.getAttribute("rc");

            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();//creating connection object for the Database
                Statement statement = connection.createStatement();//creating object of Statement and getting the reference of the statement
                int result = 5,result1 = 5;
                /*Logic for checking the availability of Program Guide in the Material Database,if Not available then increase flag_for_return*/    
                /*  if(pg_flag.equals("NO") && pg_value!=null )
                {
                    rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
                    while(rs.next())
                    actual_qty=rs.getInt(1);
                    if(actual_qty<1)
                    {
                        flag_for_return++;
                        msg=msg+" Program Guide of  "+prg_code+".<br/>";
                    }//end of if
        
                }//end of if(pg_flag.equals("NO") && pg_value!=null )*/
                /*logic of getting the ABSOLUTE PROGRAMME CODE*/
                String[] relativeProgrammeCode = new String[0];
                rs = statement.executeQuery("select count(*) from program_program where relative_prg_code='" + 
                                        programmeCode + "' and rc_code='" + regionalCenterCode + "'");
                if(rs.next()) {
                    relativeProgrammeCode = new String[rs.getInt(1)];
                }
                index = 0;
                rs = statement.executeQuery("select absolute_prg_code from program_program where relative_prg_code='" + programmeCode + "' and rc_code='"
                        + regionalCenterCode + "'");
                while(rs.next()) {
                    relativeProgrammeCode[index] = rs.getString(1);
                    index++;
                }
                String searchCourseCode = "(crs_code='" + programmeCode + "'";
                for(index = 0; index < relativeProgrammeCode.length;index++) {
                    searchCourseCode = searchCourseCode + " or crs_code='" + relativeProgrammeCode[index].trim() + "'";
                }
                searchCourseCode = searchCourseCode + ")";
                System.out.println("value of search_crs_code " + searchCourseCode);


                if(programmeGuideFlag.equals("NO") && programmeGuideValue != null ) {
                    statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry,reentry_msg)values('" + 
                            enrollmentNumber + "','" + programmeCode + "','" + programmeCode + "','PG',1,'" + date + "','" + disptachSource + "','" + 
                            medium + "','" + reentry + "','" + reentryMessage + "')");

                    statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                            " set qty=qty-1 where " + searchCourseCode + " and block='PG' and medium='" + medium + "'");

                    flagForProgrammeGuide = 1;
                }
    
                if (blockCount != 0) {
                    for(int z = 0; z < course.length; z++) {
                        int len = course[z].length();
                        for(int y = 0; y < courseDispatch.length; y++) {
                            rs1 = statement.executeQuery("Select * from course where crs_code='" + course[z] + "'");//checking the course in course table
                            if(rs1.next()) {
                                relativeCourse = course[z];
                            } else {
                                rs1 =   statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + course[z] + 
                                        "' and rc_code='" + regionalCenterCode + "'");
                                while(rs1.next()) { 
                                    relativeCourse = rs1.getString(1);
                                }
                            }
                            String courseCheck = courseDispatch[y].substring(0, len);
                            String blockCheck = courseDispatch[y].substring(len);
                            String initial = blockCheck.substring(0,1);
                            if(course[z].equals(courseCheck)) {
                                if(initial.equals("B")) {
                                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                            " where crs_code='" + relativeCourse + "' and block='" + blockCheck + "' and medium='" + medium + "'");
                                    while(rs.next()) {
                                        actualQuantity = rs.getInt(1);
                                    }
                                    if(actualQuantity < 1) {
                                        flagForReturn++;
                                        message = message + " 1 set of Block " + blockCheck.substring(1) + " of " + course[z] + "  Course.<br/>";
                                    }
                                }
                            }
                        }
                    }

                    if(flagForReturn == 0) {
                        for(int z = 0; z < course.length; z++) {
                            int len = course[z].length();
                            for(int y = 0; y < courseDispatch.length; y++) {
                                rs1 = statement .executeQuery("Select * from course where crs_code='" + course[z] + "'");
                                if(rs1.next()) {
                                    relativeCourse = course[z];
                                } else {
                                    rs1 =   statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + 
                                            course[z] + "' and rc_code='" + regionalCenterCode + "'");
                                    while(rs1.next()) { 
                                        relativeCourse = rs1.getString(1);
                                    }
                                }
                                String courseCheck = courseDispatch[y].substring(0, len);
                                String blockCheck = courseDispatch[y].substring(len);
                                String initial = blockCheck.substring(0,1);
                                if(course[z].equals(courseCheck)) {
                                    if(initial.equals("B")) {
                                        result = statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                                                regionalCenterCode + "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry,reentry_msg)values('" + 
                                                enrollmentNumber + "','" + programmeCode + "','" + course[z] + "','" + blockCheck + "',1,'" + date + "','" + 
                                                disptachSource + "','" + medium + "','" + reentry + "','" + reentryMessage + "')");

                                        result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                                " set qty=qty-1 where crs_code='" + relativeCourse + "' and block='" + blockCheck + "' and medium='" + medium + "'");
                                    }
                                }
                            }
                        }    

                        if(result == 1 && result1 == 1) {
                            message = courseDispatch.length + " Books Despatched to " + name + " Second Time.";
                        } else if(result == 1 && result1 != 1) {
                            message = "Despatch Table Hitted But Material Table Not Affected!!!";
                        } else {
                            message = "No Operation Performed..!!";
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response);
            
                    } else {
                        String supplementaryMessage = "Sorry Can not Despatch<br/>";
                        message = supplementaryMessage + message + "As Not Available in Stock.";
                        request.setAttribute("alternate_msg", message);
                        request.getRequestDispatcher("BYHANDREENTRYSEARCH?text_enr="+enrollmentNumber+"").forward(request, response);
                    }
                } else if (blockCount == 0 && flagForProgrammeGuide == 1) {
                    message = "Program Guide Successfully Despatched to " + enrollmentNumber + "";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response);
                } else {
                    System.out.println("Sorry !!Not any courses Selected...");
                    message = "Sorry!! Any Course not Selected..";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("BYE?txt_enr="+enrollmentNumber+"").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from By_hand1.jsp" + exception);
                message = "Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response);
            }
        }
    } 
}