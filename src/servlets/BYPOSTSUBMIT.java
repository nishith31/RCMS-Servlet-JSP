package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR DESPATCHING STUDY MATERIALS TO STUDNETS BY POST IN ONE BY ONE METHOD,IT TAKES THE ENROLLMENT NO,NAME,COURSE CODES,
 * PROGRAMME CODE,MEDIUM AS INPUT FROM THE BROWSER AND BY CHECKING THE AVAILABILITY OF THE MATERIALS COMPLETE THE TRANSACTION,IF MATERIALS ARE OUT OF
 *  STOCK THEN IT SENDS APPROPRIATE MESSAGE TO THE BROWSER AND IF TRANSACTION IS SUCCESSFULLY COMPLETED THEN IT SENDS THE SUCCESS MESSAGE TO THE BROWSER
CALLED JSP:-By_post1.jsp*/
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
 
public class BYPOSTSUBMIT extends HttpServlet {

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
            String enrollmentNumber = request.getParameter("text_enr").toUpperCase();//done
            String name = request.getParameter("text_name").toUpperCase();//done
            String currentSession  = request.getParameter("text_session").toLowerCase();//done
            String programmeCode = request.getParameter("text_prog_code").toUpperCase();//done
            String year = request.getParameter("text_year");//done
            String[] course = request.getParameterValues("crs_code");//all the course codes from the jsp page
            int blockCount = 0;
            int count = 0;
            String[] temp = new String[0];
            int courseSelect = 0;//variable used to store number of courses selected to be Despatched
            String medium = request.getParameter("text_medium").toUpperCase();//done
            String date = request.getParameter("text_date").toUpperCase();//done
            String packetType = request.getParameter("text_pkt_type").toUpperCase();//done
            int packetWeight = Integer.parseInt(request.getParameter("text_pkt_wt"));//done
            String challanNumber = request.getParameter("text_chln_no").toUpperCase();//done
            String  expressNumber = request.getParameter("text_express_number").toUpperCase();//done
            String dispatchSource = "BY POST";
            String relativeCourse = null;
            int quantity = 0;
            int actualQuantity = 0;
            int flagForProgrammeGuide = 0;
            int flagForReturn = 0;
            int index = 0;
            System.out.println("All the Parameters received");
            String message = "";  

            String regionalCenterCode = (String)session.getAttribute("rc");
            /*logic for getting the number of total courses selected by user*/
            for(int c = 0; c <course.length; c++) {
                temp = request.getParameterValues(course[c]);
                if(!isNull(temp)) {
                    courseSelect++;
                    blockCount = blockCount + temp.length;
                }
            }

            String[] courseDispatch = new String[blockCount];//array for holding the courses to be Despatched
            /*logic for getting all the courses selected by the user*/
            for(int d = 0; d < course.length; d++) {
                String[] courseBlock = request.getParameterValues(course[d]);
                if(courseBlock != null) {
                    int length = courseBlock.length;
                    for(int e = 0; e < length; e++) {
                        courseDispatch[count] = courseBlock[e];
                        count++;
                    }
                }
            }

            String programmeGuideFlag = request.getParameter("pg_flag").trim();//
            String programmeGuideValue = null;
            if(programmeGuideFlag.equals("NO")) {
                programmeGuideValue=request.getParameter("program_guide");
            }
            ResultSet rs = null, rs1 = null;
            response.setContentType(Constants.HEADER_TYPE_HTML);
            response.getWriter();

            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                int result = 5, result1 = 5, result2 = 5;
                /*logic of getting the ABSOLUTE PROGRAMME CODE*/
                String[] relativeProgrammecode = new String[0];
                rs = statement.executeQuery("select count(*) from program_program where relative_prg_code='" + programmeCode + "' and rc_code='" + regionalCenterCode + "'");
                if(rs.next()) {
                    relativeProgrammecode = new String[rs.getInt(1)];
                }

                index = 0;
                rs = statement.executeQuery("select absolute_prg_code from program_program where relative_prg_code='" + programmeCode + "' and rc_code='" + regionalCenterCode + "'");

                while(rs.next()) {
                    relativeProgrammecode[index] = rs.getString(1);
                    index++;
                }
                String searchCourseCode = "(crs_code='" + programmeCode + "'";
                for(index = 0; index < relativeProgrammecode.length; index++) {
                    searchCourseCode = searchCourseCode + " or crs_code='" + relativeProgrammecode[index].trim() + "'";
                }

                searchCourseCode = searchCourseCode + ")";

                if(programmeGuideFlag.equals("NO") && programmeGuideValue != null ) {
                    statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                            "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry,express_no)values('" +
                            enrollmentNumber + "','" + programmeCode + "','" + programmeCode + "','PG',1,'" + date + "','" + dispatchSource + "','" + medium + "','"
                            + challanNumber + "'," + packetWeight + ",'" + packetType + "','NO','" + expressNumber + "')");

                    statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " set qty=qty-1 where " + searchCourseCode
                            + " and block='PG' and medium='" + medium + "'");
                    flagForProgrammeGuide = 1;
                }

                if (blockCount != 0) {
                    quantity = blockCount;
                    for(int z = 0; z < course.length; z++) {
                        int len = course[z].length();
                        for(int y = 0; y < courseDispatch.length; y++) {
                            rs1 = statement .executeQuery("Select * from course where crs_code='" + course[z] + "'");//checking the course in course table

                            if(rs1.next()) {
                                relativeCourse = course[z];
                            } else {
                                rs1 = statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + course[z] + "' and rc_code='" +
                                        regionalCenterCode + "'");
                                while(rs1.next()) {
                                    relativeCourse = rs1.getString(1);
                                }

                            }
                            String courseCheck = courseDispatch[y].substring(0, len);
                            String blockCheck = courseDispatch[y].substring(len);
                            String initial=blockCheck.substring(0, 1);
                            if(course[z].equals(courseCheck)) {
                                if(initial.equals("B")) {
                                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                            " where crs_code='" + relativeCourse + "' and block='" + blockCheck + "' and medium='" + medium + "'");

                                    while(rs.next()) {
                                        actualQuantity = rs.getInt(1);
                                    }
                                    if(actualQuantity < 1) {
                                        flagForReturn++;
                                        message = message + " 1 set of Block " + blockCheck.substring(1) + " of " + course[z] + " Course.<br/>";
                                    }
                                }
                            }
                        }
                    }

                    if(flagForReturn == 0) {
                        for(int z = 0; z < course.length; z++) {
                            int length = course[z].length();
                            for(int y = 0; y < courseDispatch.length; y++) {
                                rs1 = statement .executeQuery("Select * from course where crs_code='" + course[z] + "'");//checking the course in course table
                                if(rs1.next()) {
                                    relativeCourse = course[z];
                                } else {
                                    rs1 = statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + course[z] + 
                                            "' and rc_code='" + regionalCenterCode + "'");
                                    while(rs1.next()) {
                                        relativeCourse = rs1.getString(1);
                                    }

                                }
                                String courseCheck = courseDispatch[y].substring(0, length);
                                String blockCheck = courseDispatch[y].substring(length);
                                String initial = blockCheck.substring(0, 1);
                                if(course[z].equals(courseCheck)) {
                                    if(initial.equals("B")) {
                                        result = statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                                + "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry,express_no)values('"
                                                + enrollmentNumber + "','" + programmeCode + "','" + course[z] + "','" + blockCheck + "',1,'" + date + "','" + dispatchSource + 
                                                "','" + medium + "','" + challanNumber + "'," + packetWeight + ",'" + packetType + "','NO','" + expressNumber + "')");

                                        result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                                " set qty=qty-1 where crs_code='" + relativeCourse + "' and block='" + blockCheck + "' and medium='" + medium + "'");
                                    }
                                }
                            }
                        }    

                        if(result == 1 && result1 == 1) {   
                            System.out.println("Materials for " + course.length + " courses given to " + name);   
                            message = "" + courseDispatch.length + " Books Despatched to " + name + ".";
                        } else if(result == 1 && result1 != 1) {
                            System.out.println("Despatch table hitted but material table not affected..!!!!!");   
                            message = "Despatch Table Hitted But Material Table not Affected!!!";
                        } else {
                            System.out.println("NO operation performed.!!!!!");   
                            message = "No Operation Performed..!!";
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post.jsp").forward(request, response);

                    } else {
                        String supplementaryMessage="Sorry Can not Despatch<br/>";
                        message = supplementaryMessage + message + "As Not Available in Stock.";
                        request.setAttribute("alternate_msg", message);
                        request.getRequestDispatcher("BYEPOSTSEARCH?txt_enr=" + enrollmentNumber).forward(request, response);
                    }
                } else if (blockCount == 0 && flagForProgrammeGuide == 1) {
                    System.out.println("Program Guide Successfully Despatched...");
                    message = "Program Guide Successfully Despatched to " + enrollmentNumber;
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/By_post.jsp").forward(request, response);
                } else {
                    System.out.println("Sorry !!Not any courses Selected...");
                    message = "Sorry!! Not any courses selected..";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("BYEPOSTSEARCH?txt_enr=" + enrollmentNumber).forward(request, response);
                }
            } catch(Exception exception) {
                message = "Some Serious Exception found .please check on the Server console for details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_post.jsp").forward(request, response);
                System.out.println("Exception raised from BYPOSTSUBMIT.java" + exception);
            }
        }
    }
}