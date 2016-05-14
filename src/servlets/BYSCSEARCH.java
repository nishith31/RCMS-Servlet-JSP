package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE STUDENTS OF THE STUDY CENTRE SELECTED FOR THE COURSE 
AND PROGRAMME CODE SELECTED AND AMONG THOSE STUDENTS ALSO CHECKS THE STUDENTS TO WHOM MATERIALS HAVE BEEN ALREADY 
SENT,THIS SERVLET TAKES SC CODE,PROGRAMME CODE,SEMESTER,COURSE CODE FROM THE BROWSER AND SENDS APPROPORIATE RESULTS IN THE NEXT PAGE.
CALLED JSP:-To_sc_students.jsp*/
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
 
public class BYSCSEARCH extends HttpServlet {

    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    } 
 
    @SuppressWarnings("unused")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String message = null;
            String studyCenterCode = request.getParameter("mnu_sc_code").toUpperCase();//variable for holding the study center code from the browser
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//variable for holding the program code from the browser
            String courseCode = request.getParameter("mnu_crs_code").toUpperCase();//variable for holding the course code from the browser
            String year = request.getParameter("textyear").toUpperCase();//variable for holding the year from the browser
            String medium = request.getParameter("textmedium").toUpperCase();//variable for holding the medium of student from the browser
            String programmeCode2 = null;//variable for extracting the program code from the combined program code of the database
            String firstTimer = request.getParameter("first_timer").toUpperCase();
            String currentSession = request.getParameter("textsession").toLowerCase();//variable for holding the name of the current
            int dispatchStudentCount = 0, index = 0, availableQuantity = 0, temp = 0, temp1 = 0, length = 0, i = 0;
            try {
                temp = (Integer)request.getAttribute("initial_block");
                temp1 = (Integer)request.getAttribute("number_of_blocks");
                request.setAttribute("initial_block", temp);
                request.setAttribute("initial_block", temp);
            } catch(Exception exception) {
                temp = 0;
            }
            int numberOfBlocks = 0;
            String regionalCenterCode = (String)session.getAttribute("rc");
            String blockName = "B1"; 
            if(year.equals("NA") || year.equals("1")) {
                programmeCode2 = programmeCode;
            } else {
                programmeCode2 = programmeCode + year;
            }

            response.setContentType(Constants.HEADER_TYPE_HTML);
            String relativeCourse;
            ResultSet rs = null, block = null;
            request.setAttribute("semester", year);
            request.setAttribute("current_session", currentSession);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                /*LOGIC FOR GETTING THE TOTAL NUMBER OF BLOCKS OF THE COURSE SELECTED BY THE USER IN THE SELECTION SCREEN*/ 
                block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courseCode + "'");
                while(block.next()) {
                    numberOfBlocks = block.getInt(1);
                }

                /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/  
                String[] relativeCourseCode = new String[0];
                rs = statement.executeQuery("select count(*) from course_course where absolute_crs_code='" + courseCode + "' and rc_code='" + regionalCenterCode + "'");
                if(rs.next()) {
                    relativeCourseCode = new String[rs.getInt(1)];
                }

                index = 0;
                rs = statement.executeQuery("select relative_crs_code from course_course where absolute_crs_code='" + courseCode + "' and rc_code='" + regionalCenterCode + "'");
                while(rs.next()) {
                    relativeCourseCode[index] = rs.getString(1);
                    index++;
                }
                /*LOGIC FOR CREATING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
                String dispatchCourseCode = "(crs_code='" + courseCode + "'";
                for(index = 0; index < relativeCourseCode.length; index++) {
                    dispatchCourseCode = dispatchCourseCode + " or crs_code='" + relativeCourseCode[index] + "'";
                }
                dispatchCourseCode = dispatchCourseCode + ")";
                /*LOGIC FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL PROGRAMME CODE*/
                String[] relativeProgrammeCode = new String[0];   
                rs = statement.executeQuery("select count(*) from program_program where absolute_prg_code='" + programmeCode + "' and rc_code='" + regionalCenterCode + "'");
                if(rs.next()) {
                    relativeProgrammeCode = new String[rs.getInt(1)];
                }

                index = 0;
                rs = statement.executeQuery("select relative_prg_code from program_program where absolute_prg_code='" + programmeCode + "' and rc_code='" + regionalCenterCode + "'");

                while(rs.next()) {
                    relativeProgrammeCode[index] = rs.getString(1);
                    index++;
                }

                String searchProgrammeCode = null;
                if(year.equals("NA") || year.equals("1")) {
                    searchProgrammeCode = "(prg_code='" + programmeCode + "'";
                } else {
                    searchProgrammeCode = "(prg_code='" + programmeCode + year + "'";
                }
    
                for(index = 0; index < relativeProgrammeCode.length; index++) {
                    if(year.equals("NA") || year.equals("1")) {
                        searchProgrammeCode = searchProgrammeCode + " or prg_code='" + relativeProgrammeCode[index] + "'";
                    } else {
                        searchProgrammeCode = searchProgrammeCode + " or prg_code='" + relativeProgrammeCode[index] + year + "'";
                    }
                }
                searchProgrammeCode = searchProgrammeCode + ")";    //creation of prg_code complete like prg_code=this or prg_code=that
    
                /*  block=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
                while(block.next())
                relative_course=block.getString(1);*/
                request.setAttribute("number_of_blocks", numberOfBlocks);
                request.setAttribute("first_timer", firstTimer);
                int result = 5, result1 = 5;
                rs = statement.executeQuery("select *  from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where sc_code='" 
                        + studyCenterCode + "' and " + searchProgrammeCode + "");

                String check = null;
                int ll = 1;
                if(rs.next()) {
                    rs = statement.executeQuery("select *  from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where sc_code='" + 
                            studyCenterCode + "' and " + searchProgrammeCode);
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
                    ll = 1;
                    String student[] = new String[length];
                    String name[] = new String[length];
                    String hiddenCourse[] = new String[length];
                    rs = statement.executeQuery("select *  from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where sc_code='" + 
                            studyCenterCode + "' and " + searchProgrammeCode);
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
                                hiddenCourse[i] = courseCode;
                                i++;
                            } else {
                                for(index = 0; index < relativeCourseCode.length; index++) {
                                    if(check.equals(relativeCourseCode[index])) {
                                        student[i] = roll;
                                        name[i] = naam;
                                        hiddenCourse[i] = relativeCourseCode[index];
                                        i++;
                                    }
                                }
                            }
                            
                        }  
                    }    

                    request.setAttribute("student", student);
                    request.setAttribute("name", name);
                    request.setAttribute("hidden_course", hiddenCourse);
                    for(index = 0; index < student.length; index++) {
                        rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + student[index] + "' and " + dispatchCourseCode + " and block='" + blockName + "' and reentry='NO'");

                        if(rs.next()) {
                            dispatchStudentCount++;
                        }
                    }
                    String[] dispatchStudent = new String[dispatchStudentCount];
                    String[] dispatchName = new String[dispatchStudentCount];
                    String[] dispatchDate = new String[dispatchStudentCount];
                    String[] dispatchMode = new String[dispatchStudentCount];
                    index = 0;
                    int insertIndex = 0;
                    /*Inserting the Roll Numbers of the Despatched Students of the Study Centres*/      
                    for(index = 0; index < student.length; index++) {
                        rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + student[index] + "' and " + dispatchCourseCode + " and block='" + blockName + "' and reentry='NO'");
                        if(rs.next()) {
                            rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " where enrno='" + student[index] + "' and " + dispatchCourseCode + " and block='" + blockName + "' and reentry='NO'");

                            while(rs.next()) {
                                dispatchStudent[insertIndex] = rs.getString(1);
                                dispatchDate[insertIndex] = rs.getDate(6).toString();
                                dispatchMode[insertIndex] = rs.getString(7);
                            }
                            insertIndex++;
                        }
                    }
                    /*CREATING ARRAY OF DESPATCHED NAMES FROM THE ARRAY OF ALL STUDENTS EARLIER CREATED IN THE SERVLET*/            
                    for(index = 0; index < dispatchStudent.length; index++) {
                        for(int z = 0; z < student.length; z++) {
                            if(dispatchStudent[index].equals(student[z])) {
                                dispatchName[index] = name[z];
                            }
                        }
                    }

                    /*Logic for creating int variable of available sets of the course selected*/
                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                            " where crs_code='" + courseCode + "' and block='" + blockName + "' and medium='" + medium + "'");

                    while(rs.next()) {
                        availableQuantity = rs.getInt(1);
                    }
                    request.setAttribute("available_qty", availableQuantity);
                    request.setAttribute("dispatch_student", dispatchStudent);
                    request.setAttribute("dispatch_date", dispatchDate);
                    request.setAttribute("dispatch_mode", dispatchMode);
                    request.setAttribute("dispatch_name", dispatchName);
    
                    try {
                        message = (String)request.getAttribute("alternate_msg");
                    } catch(Exception ees) {
                        message = null;
                    }
                    if(message == null) {
                        message="";
                    }

                    message = message + student.length + " Students Found For the Study Center Selected";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code=" + studyCenterCode + "&prg_code=" + programmeCode + "&crs_code=" + 
                            courseCode + "&year=" + year + "&medium=" + medium + "&sets=" + student.length).forward(request, response);
                } else {
                    message = "No Students for Study Centre " + studyCenterCode + "<br/>  Of Program " + programmeCode + " <br/> Of Course" + courseCode;
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request, response);
                    System.out.println("No Student for Study Centre " + studyCenterCode + " for program " + programmeCode + " Course " + courseCode);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from BYSCSEARCH.java" + exception);
                message = "Some Serious exception hitted the page.Please check on the server console for more details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request, response);
            }
        }
    } 
}