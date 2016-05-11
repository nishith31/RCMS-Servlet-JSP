package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE STUDENTS FOR THE COURSE CODE,PROGRAMME CODE,MEDIUM AND LOT NUMBER PROVIDED BY THE USER ON THE BROWSER AND IN THAT RANGE OF STUDENTS ALSO CHECKS THE STUDENTS TO WHOM MATERIALS HAS BEEN ALREADY SENT AND SENDS THOSE STUDENTS AS DISABLED FOR DESPATCHING,IT ALSO CHECKS AND DISPLAY THE AVAILABLE QUANTITY OF THE STUDY MATERIAL SELECETED FOR DESPATCHING.
CALLED JSP;-By_post_bulk1.jsp*/
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
 
public class BYPOSTBULKSEARCH extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYPOSTBULKSEARCH SERVLET STARTED TO EXECUTE");
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE BROWSER*/   
            String firstTimer = request.getParameter("first_timer").toUpperCase();
            System.out.println("value of first_timer is " + firstTimer);

            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
            String courseCode = request.getParameter("mnu_crs_code").toUpperCase();
            String medium = request.getParameter("mnu_medium").toUpperCase();
            String lot = request.getParameter("text_lot").toUpperCase();
            int start = Integer.parseInt(request.getParameter("text_start"));
            int end = Integer.parseInt(request.getParameter("text_end"));

            String regionalCenterCode = (String)session.getAttribute("rc");
            System.out.println("course code " + courseCode);
            String message = null;
            String query = null;
            String check = null;
            int numberOfBlocks = 0, index = 0, length = 0, i = 0, availableQuantity = 0;//Field for storing the available sets of the selected course and send to browser
            String currentSession = null;
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                message = (String)request.getAttribute("alternate_msg");
            } catch (Exception exception) {
                message = null;
            }
            if(message == null) {
                message = "";
            }
            ResultSet rs = null;
            ResultSet block = null;
            request.setAttribute("start", start);
            request.setAttribute("end", end);

            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courseCode + "'");

                while(block.next()) {
                    numberOfBlocks=block.getInt(1);
                }

                request.setAttribute("number_of_blocks", numberOfBlocks);
                request.setAttribute("first_timer", firstTimer);
                /*request.setAttribute("date",date);        
                request.setAttribute("packet_type",packet_type);        */
                request.setAttribute("start", start);
                request.setAttribute("end", end);
                rs = statement.executeQuery("select TOP 1 session_name from sessions_" + regionalCenterCode + " order by id DESC");
                while(rs.next()) {
                    currentSession=rs.getString(1).toLowerCase();
                }
                request.setAttribute("current_session", currentSession);
                /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/  
                String[] relativeCourseCode = new String[0];
                rs = statement.executeQuery("select count(*) from course_course where absolute_crs_code='" + courseCode + "' and rc_code='" + regionalCenterCode + "'");

                if(rs.next()) {
                    relativeCourseCode=new String[rs.getInt(1)];
                }
                index = 0;
                rs = statement.executeQuery("select relative_crs_code from course_course where absolute_crs_code='" + courseCode + 
                        "' and rc_code='" + regionalCenterCode + "'");

                while(rs.next()) {
                    relativeCourseCode[index] = rs.getString(1);
                    index++;
                }
                String course1 = "(crs1='" + courseCode + "'";
                String course2 = "(crs2='" + courseCode + "'";
                String course3 = "(crs3='" + courseCode + "'";
                String course4 = "(crs4='" + courseCode + "'";
                String course5 = "(crs5='" + courseCode + "'";
                String course6 = "(crs6='" + courseCode + "'";
                String course7 = "(crs7='" + courseCode + "'";
                String course8 = "(crs8='" + courseCode + "'";
                String course9 = "(crs9='" + courseCode + "'";
                String course10 = "(crs10='" + courseCode + "'";
                String course11 = "(crs11='" + courseCode + "'";
                String course12 = "(crs12='" + courseCode + "'";
                String course13 = "(crs13='" + courseCode + "'";
                String course14 = "(crs14='" + courseCode + "'";
                String course15 = "(crs15='" + courseCode + "'";
                String course16 = "(crs16='" + courseCode + "'";
                String course17 = "(crs17='" + courseCode + "'";
                String course18 = "(crs18='" + courseCode + "'";
                String course19 = "(crs19='" + courseCode + "'";
                String course20 = "(crs20='" + courseCode + "'";

                for(index = 0; index < relativeCourseCode.length; index++) {
                    course1 = course1 + " or crs1='"+relativeCourseCode[index]+"'";
                    course2 = course2 + " or crs2='" + relativeCourseCode[index] + "'";
                    course3 = course3 + " or crs3='" + relativeCourseCode[index] + "'";
                    course4 = course4 + " or crs4='" + relativeCourseCode[index] + "'";
                    course5 = course5 + " or crs5='" + relativeCourseCode[index] + "'";
                    course6 = course6 + " or crs6='" + relativeCourseCode[index] + "'";
                    course7 = course7 + " or crs7='" + relativeCourseCode[index] + "'";
                    course8 = course8 + " or crs8='" + relativeCourseCode[index] + "'";
                    course9 = course9 + " or crs9='" + relativeCourseCode[index] + "'";
                    course10 = course10 + " or crs10='" + relativeCourseCode[index] + "'";
                    course11 = course11 + " or crs11='" + relativeCourseCode[index] + "'";
                    course12 = course12 + " or crs12='" + relativeCourseCode[index] + "'";
                    course13 = course13 + " or crs13='" + relativeCourseCode[index] + "'";
                    course14 = course14 + " or crs14='" +relativeCourseCode[index] + "'";
                    course15 = course15 + " or crs15='" + relativeCourseCode[index] + "'";
                    course16 = course16 + " or crs16='" + relativeCourseCode[index] + "'";
                    course17 = course17 + " or crs17='" + relativeCourseCode[index] + "'";
                    course18 = course18 + " or crs18='" + relativeCourseCode[index] + "'";
                    course19 = course19 + " or crs19='" + relativeCourseCode[index] + "'";
                    course20 = course20 + " or crs20='" + relativeCourseCode[index] + "'";
                }

                course1 = course1 + ")";
                course2 = course2 + ")";
                course3 = course3 + ")";
                course4 = course4 + ")";
                course5 = course5 + ")";
                course6 = course6 + ")";
                course7 = course7 + ")";
                course8 = course8 + ")";
                course9 = course9 + ")";
                course10 = course10 + ")";
                course11 = course11 + ")";
                course12 = course12 + ")";
                course13 = course13 + ")";
                course14 = course14 + ")";
                course15 = course15 + ")";
                course16 = course16 + ")";
                course17 = course17 + ")";
                course18 = course18 + ")";
                course19 = course19 + ")";
                course20 = course20 + ")";

                /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
                String dispatchSearchCourseCode = "(crs_code='" + courseCode + "'";
                for(index = 0; index < relativeCourseCode.length; index++) {
                    dispatchSearchCourseCode = dispatchSearchCourseCode + " or crs_code='" + relativeCourseCode[index] + "'";
                }
                dispatchSearchCourseCode = dispatchSearchCourseCode + ")";
                /*LOGIC FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL PROGRAMME CODE*/
                String[] relativeProgrammeCode = new String[0];   
                rs = statement.executeQuery("select count(*) from program_program where absolute_prg_code='" + programmeCode + "' and rc_code='" + regionalCenterCode + "'");
                if(rs.next()) {
                    relativeProgrammeCode = new String[rs.getInt(1)];
                }
                index = 0;
                rs = statement.executeQuery("select relative_prg_code from program_program where absolute_prg_code='"  +programmeCode + "' and rc_code='" +
                                regionalCenterCode + "'");
                while(rs.next()) {
                    relativeProgrammeCode[index] = rs.getString(1);
                    index++;
                }
                String searchProgrammeCode = "(prg_code like '" + programmeCode + "%'";
                for(index = 0; index < relativeProgrammeCode.length; index++) {
                    searchProgrammeCode = searchProgrammeCode + " or prg_code like '" + relativeProgrammeCode[index] + "%'";
                }
                searchProgrammeCode = searchProgrammeCode + ")";
                System.out.println("value of despatch course " + dispatchSearchCourseCode);
                if(programmeCode.equals("ALL")) {
                    //      query="select * from student_"+current_session+"_"+rc_code+" where medium='"+medium+"' and crs1='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs2='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs3='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs4='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs5='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs6='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs7='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs8='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs9='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs10='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs11='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs12='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs13='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs14='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs15='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs16='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs17='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs18='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs19='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs20='"+crs_code+"' and lot='"+lot+"'";
                    query = "select * from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where medium='" + 
                            medium + "' and " + course1 + " and lot='" + lot + "' or medium='" + medium + "' and " + course2 + " and lot='" + lot + 
                            "' or medium='" + medium + "' and " + course3 + " and lot='" + lot + "' or medium='" + medium + "' and " + course4 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course5 + " and lot='" + lot + "' or medium='" + medium + "' and " + course6 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course7 + " and lot='" + lot + "' or medium='" + medium + "' and " + course8 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course9 + " and lot='" + lot + "' or medium='" + medium + "' and " + course10 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course11 + " and lot='" + lot + "' or medium='" + medium + "' and " + course12 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course13 + " and lot='" + lot + "' or medium='" + medium + "' and " + course14 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course15 + " and lot='" + lot + "' or medium='" + medium + "' and " + course16 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course17 + " and lot='" + lot + "' or medium='" + medium + "' and " + course18 + " and lot='" + 
                            lot + "' or medium='" + medium + "' and " + course19 + " and lot='" + lot + "' or medium='" + medium + "' and " + course20 + " and lot='" + lot + "'";
                } else {
                    query = "select * from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where " + searchProgrammeCode + " and medium='" + 
                            medium + "' and " + course1 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course2 + " and lot='" 
                            + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course3 + " and lot='" + lot + "' or " + searchProgrammeCode + 
                            " and medium='" + medium + "' and " + course4 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + 
                            course5 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course6 + " and lot='" + lot + "' or " + 
                            searchProgrammeCode + " and medium='" + medium + "' and " + course7 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + 
                            medium + "' and " + course8 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course9 + " and lot='" + 
                            lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course10 + " and lot='" + lot + "' or " + searchProgrammeCode + 
                            " and medium='" + medium + "' and " + course11 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + 
                            course12 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course13 + " and lot='" + lot + "' or " + 
                            searchProgrammeCode + " and medium='" + medium + "' and " + course14 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium 
                            + "' and " + course15 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course16 + " and lot='" + lot + 
                            "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course17 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" 
                            + medium + "' and " + course18 + " and lot='" + lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course19 + " and lot='" + 
                            lot + "' or " + searchProgrammeCode + " and medium='" + medium + "' and " + course20 + " and lot='" + lot + "'";
                }
                rs = statement.executeQuery(query);
                if(rs.next()) {
                    rs = statement.executeQuery(query);
                    while(rs.next()) {
                        for(int j = 17; j <= 35;) {
                            check = rs.getString(j);
                            check = check.trim();
                            if(check.equals(courseCode)) {
                                length++;
                            } else {
                                for(index = 0; index < relativeCourseCode.length; index++) {
                                    if(check.equals(relativeCourseCode[index])) {
                                        length++;
                                    }

                                }
                            }
                            j = j + 2;
                        }  
                    }
                    String student[] = new String[length];
                    String name[] = new String[length];
                    String serialNumber[] = new String[length];
                    String hiddenCourse[] = new String[length];

                    rs = statement.executeQuery(query);
                    i = 0;
                    String naam = null;
                    String roll = null;
                    while(rs.next()) {
                        roll = rs.getString(1);
                        naam = rs.getString(5);   
                        for(int k = 17; k <= 35; k = k + 2) {
                            check = rs.getString(k);
                            check = check.trim();
                            if(check.equals(courseCode)) {
                                student[i] = roll;
                                name[i] = naam;
                                serialNumber[i] = rs.getString(k+1);
                                hiddenCourse[i] = courseCode;
                                i++;
                            } else {
                                for(index = 0; index < relativeCourseCode.length; index++) {
                                    if(check.equals(relativeCourseCode[index])) {
                                        student[i] = roll;
                                        name[i] = naam;
                                        serialNumber[i] = rs.getString(k+1);
                                        hiddenCourse[i] = relativeCourseCode[index];
                                        i++;
                                    }
                                }
                            }
                        }  
                    }    
                    naam = null;
                    roll = null;
                    String number = null;
                    String hideCourse = null;
                    int first = 0;
                    int second = 0;
                    if(programmeCode.equals("ALL")) {
                    } else {
                    }
                    int finalLength = 0;
                    for(i = 0; i <serialNumber.length; i++) {
                        if(serialNumber[i] != null) {
                            finalLength++;
                        }

                    }
                    System.out.println("final length is " + finalLength);
                    /*LOGIC FOR SORTING THE ARRAY OF SERIAL NUMBER ON THE ASCENDING ORDER*/
                    for(i = 0; i < finalLength; i++) {
                        for(int j = i + 1; j < finalLength; j++) {
                            first = Integer.parseInt(serialNumber[i].trim());
                            second = Integer.parseInt(serialNumber[j].trim());
                            if(first > second) {
                                number = serialNumber[i];
                                serialNumber[i] = serialNumber[j];
                                serialNumber[j] = number;
                                naam = name[i];
                                name[i] = name[j];
                                name[j] = naam;

                                roll  =student[i];
                                student[i] = student[j];
                                student[j] = roll;

                                hideCourse = hiddenCourse[i];
                                hiddenCourse[i] = hiddenCourse[j];
                                hiddenCourse[j] = hideCourse;
                            }
                        }
                    }
                    /*Logic for creating int variable of available sets of the course selected*/
                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" + 
                            courseCode + "' and block='B1' and medium='" + medium + "' ");
                    while(rs.next()) {
                        availableQuantity = rs.getInt(1);
                    }

                    request.setAttribute("available_qty", availableQuantity);

                    /*logic for checking the students filtered above in the Despatch table*/
                    int[] dispatchIndex;
                    int j = 0;
                    for(i = 0; i < finalLength; i++) {
                        try {
                            rs = statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " where enrno='" + student[i] + "' and " + dispatchSearchCourseCode + " and block='B1' and medium='" + medium + "'");
                            if(rs.next()) {
                                j++;
                            }
                        } catch(Exception exception) {
                            System.out.print("nahi hai " + student[i] + ".." + exception);
                        }
                    }
                    System.out.println("length of Despatch students " + j);
                    dispatchIndex = new int[j];
                    j = 0;
                    for(i = 0; i < finalLength; i++) {
                        try {
                            rs = statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " where enrno='" + student[i] + "' and " + dispatchSearchCourseCode + " and block='B1' and medium='" + medium + "'");
                            if(rs.next()) {   
                                dispatchIndex[j] = i;
                                j++;
                            }
                        } catch(Exception exception) {
                            System.out.print("nahi hai " + exception);
                        }
                    }
                    request.setAttribute("student", student);
                    request.setAttribute("name", name);
                    request.setAttribute("serial_number", serialNumber);
                    request.setAttribute("hidden_course", hiddenCourse);
                    request.setAttribute("dispatch_index", dispatchIndex);
                    if(finalLength == 0) {
                        System.out.println("No Student found...");
                        message = message + "No Student Found";
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
                    } else if(end > finalLength) {
                        System.out.println("Your Selection is out of Range:- Total Student " + finalLength + " and Range is " + start + " to " + end);
                        message = message + "Your Selection is out of Range:- Total Student " + finalLength + " and Range is " + start + " to " + end; 
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
                    } else {
                        System.out.println("NO OF STUDENTS ARE " + finalLength);
                        message = message + "No Of Students Are " + finalLength;
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code=" + programmeCode + "&crs_code=" + courseCode + "&medium=" + medium 
                                + "&lot=" + lot + "&start=" + start + "&end=" + end + "&length=" + finalLength).forward(request, response);
                    }  
                } else {
                    System.out.println("No Student found...");
                    message = message + "No Student Found";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from BYPOSTBULKSEARCH.java " + exception);
                message = message + "Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
            }
        }
    } 
}