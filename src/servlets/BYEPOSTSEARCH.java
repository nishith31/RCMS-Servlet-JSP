package servlets;

/*THIS SERVLET IS RESPONSIBLE FOR FETCHING THE DETAILS OF THE STUDENT ENTERED BY  THE USER FROM THE STUDENT TABLE OF THE CONCERNED REGIONAL 
CENTRE DATABASE AND  
 * ALSO CHECKING THE NUMBER OF COURSES AND DETAILS OF COURSES THOSE HAVE BEEN ALREADY DESPATCHED VIA ANY OTHER DESPATCH MODE OR BY POST MADE.
 * IF ANY COURSE FOUND DESPATCHED THEN DATA OF THOSE COURSES WILL BE SHOWN IN DISABLED FORM IN THE BROWSER
CALLED JSP:-By_post.jsp*/
import static utility.CommonUtility.isNull;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.CommonUtility;
import utility.Constants;
 
public class BYEPOSTSEARCH extends HttpServlet {
    private static final long serialVersionUID = 1L;
    String currentSession="";//variable for holding the value of the current session of the regional centre logged in.
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    @SuppressWarnings({ "unused", "resource" })
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String enrollmentNumber = request.getParameter("txt_enr");//getting the Enrollment Number of the student from the browser
            String message = "";//message for sending message to the browser for printing purpose
            String programme = null;//variable for holding and sending the program code of the student
            String name = null;//variable for holding the name of the student
            char year;//variable for holding the year or semester number of the student.
            String medium = null; //variable for holding the medium of program opted by the student
            String date = null;//variable for holding the date    
            String dispatchMode = null;//variable for holding the mode of despatch_mode
            try {
                message = (String)request.getAttribute("alternate_msg");
            } catch(Exception exception) {
                message = null;
            }//retrieving message from msg variable if this is not coming directly the first page means coming from any other servlet.
            if(message == null) {
                message = Constants.SPACE;
            }

            int length = 0, index = 0;
            int courseNumber = 0;
            String tempVariable = "";

            String regionalCenterCode = (String)session.getAttribute("rc");//getting the code of logged rc in the system from the session object.
            response.setContentType(Constants.HEADER_TYPE_HTML);
            PrintWriter out = response.getWriter();
            int availableProgrammeGuide = 0;
            String programmeGuideFlag = null, programmeGuideDate = null;

            try {
                Connection connection = connections.ConnectionProvider.conn();//creating the connection to the database and getting the reference
                Connection connection1 = connections.ConnectionProvider.conn();//creating the connection to the database and getting the reference
                Statement statement = connection.createStatement();//creating the statement object and getting the reference from the connection object
                Statement statement1 = connection1.createStatement();//creating the statement object and getting the reference from the connection object
                ResultSet rs;
                currentSession = CommonUtility.getCurrentSessionName(regionalCenterCode);
    
                request.setAttribute("current_session", currentSession);
                /*Logic for fetching all details of the student from the student database of the RC logged in*/
                rs = statement.executeQuery("select * from student_" + currentSession + "_" + regionalCenterCode + " where enrno='" + enrollmentNumber + "'");
                if(rs.next()) {
                    programme = rs.getString(2);//getting the complete program code from the student table           
                    char pr[] = programme.toCharArray();//converting the program code to character array for fetching the program code only
                    for(index = 0; index < pr.length; index++) {//logic for checking the actual length of prg_code field of student table
                        if(pr[index] != ' ') {
                            length++;
                        }
                    }
                    /*Logic for getting the program code and semester/year code. If last digit of program code is in between 1 to 6 then took the last digit as semester/year code and rest as program code otherwise the semester/year code will be considered one and the whole word of prg_code is treated as complete program code*/
                    if(pr[length - 1] == '1' || pr[length - 1] == '2' || pr[length - 1] == '3' || 
                            pr[length - 1] == '4' || pr[length - 1] == '5' || pr[length - 1] == '6') {
                        programme = programme.substring(0, length - 1);
                        year = pr[length - 1];
                    } else {
                        year = '1';
                    }      
                    name = rs.getString(5);//getting the name of the student from the student database
                    medium = rs.getString(7);//getting the medium of the program of the student from student database

                    /*Logic for getting the total number of courses for creating the array of course and then storing courses on that.In 2005 the empty courses came blank with only spaces so need to convert them in character array first and then checking the length and if length is avaialble more than 0 then increase the course count but in sql2008 the blank courses came null so checking null is ok in 2008.*/
                    for(int i = 17; i < 35; i = i + 2) {
                        pr = rs.getString(i).toCharArray();
                        length = 0;
                        for(index = 0; index < pr.length; index++) {
                            if(pr[index] != ' ') {
                                length++;
                            }
                        }
                        if(length > 0) {
                            courseNumber++;
                        }
                    }
 
                    rs = statement.executeQuery("select * from student_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where enrno='" + enrollmentNumber + "'");
                    /*Creating the array of courses, number of blocks for each course and the serial number associated with the course*/
                    String course[] = new String[courseNumber];
                    int blocks[] = new int[courseNumber];
                    int blocksShadow[] = new int[courseNumber];     
                    String serialNumber[] = new String[courseNumber];
                    int i = 17, j = 18;
                    int totalLength = 0, count = 0;
                    ResultSet rs1 = null;
                    ResultSet rs2 = null;
                    String relativeCourse = null;
                    /*Logic for storing the courses and serial numbers and no of blocks to their corresponding array*/
                    while(rs.next()) {
                        for(int m = 0; m < courseNumber; m++) {
                            course[m] = rs.getString(i).trim();
                            serialNumber[m] = rs.getString(j);
                            rs1 = statement1.executeQuery("Select * from course where crs_code='" + course[m] + "'");
                            if(rs1.next()) {
                                System.out.println("course found in course table");
                                rs1 = statement1 .executeQuery("Select no_of_blocks from course where crs_code='" + course[m] + "'");
                                while(rs1.next()) {
                                    blocks[m] = rs1.getInt(1);
                                }
                                i = i + 2;
                                j = j + 2;
                            } else {
                                rs1 = statement1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + course[m] + 
                                        "' and rc_code='" + regionalCenterCode + "' ");
                                while(rs1.next()) {
                                    relativeCourse = rs1.getString(1);
                                }
                                rs1 = statement1 .executeQuery("Select no_of_blocks from course where crs_code='" + relativeCourse + "'");
                                while(rs1.next()) {
                                    blocks[m] = rs1.getInt(1);
                                }
                                i = i + 2;
                                j = j + 2;
                            }
                        }
                    }
                    for(index = 0; index < course.length; index++) {
                        totalLength = totalLength + blocks[index];//finding the total legth for store the course as blockwise.
                    }
        
                    int[] stock = new int[totalLength];//int array for stock of each course blockwise
                    String courseBlock[] = new String[totalLength];//String array for course name block wise like MCS51B2
                    /*logic for creating array of course_block & stock availability*/
                    String blockName = null;
                    for(int a = 0; a < course.length; a++) {
                        for(index = 1; index <= blocks[a]; index++) {
                            courseBlock[count] = course[a] + "B" + index;

                            rs1 = statement1.executeQuery("Select * from course where crs_code='" + course[a] + "'");//checking the course in course table
                            if(rs1.next()) {
                                relativeCourse = course[a];
                            } else {
                                rs1 = statement1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + course[a] + 
                                        "' and rc_code='" + regionalCenterCode + "'");
                                while(rs1.next()) {
                                    relativeCourse = rs1.getString(1);
                                }
                            }
                            blockName = "B" + index;
                            rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " where crs_code='" + relativeCourse + "' and block='" + blockName + "' and medium='" + medium + "'");
                            while(rs.next()) {
                                stock[count] = rs.getInt(1);
                            }
                            System.out.println(courseBlock[count] + " " + stock[count]);
                            count++;
                        }
                    }
                    /*Setting all the arrays to the request for sending them to the browser*/
                    request.setAttribute("course", course);
                    request.setAttribute("serial_number", serialNumber);
                    request.setAttribute("course_block", courseBlock);
                    request.setAttribute("blocks", blocks);
                    request.setAttribute("stock", stock);
                    /*logic of getting the ABSOLUTE PROGRAMME CODE*/
                    String[] relativeProgrammeCode = new String[0];
                    rs = statement.executeQuery("select count(*) from program_program where relative_prg_code='" + programme 
                            + "' and rc_code='" + regionalCenterCode + "'");
                    if(rs.next()) {
                        relativeProgrammeCode = new String[rs.getInt(1)];
                    }
        
                    index = 0;
                    rs = statement.executeQuery("select absolute_prg_code from program_program where relative_prg_code='" + programme + 
                            "' and rc_code='" + regionalCenterCode + "'");
                    while(rs.next()) {
                        relativeProgrammeCode[index] = rs.getString(1);
                        index++;
                    }
                    String searchCourseCode = "(crs_code='" + programme + "'";
                    for(index = 0; index < relativeProgrammeCode.length; index++) {
                        searchCourseCode = searchCourseCode + " or crs_code='" + relativeProgrammeCode[index] + "'";
                    }
                    searchCourseCode = searchCourseCode + ")";
                    System.out.println("value of search_crs_code " + searchCourseCode);
                    /*Logic for checking the Despatch of Program guide for the student entered into the system*/
                    rs = statement.executeQuery("select * from student_dispatch_" + currentSession + "_" + regionalCenterCode + 
                                " where enrno='" + enrollmentNumber + "' and " + searchCourseCode + " and block='PG' and reentry='NO'");
                    if(rs.next()) {
                        programmeGuideFlag = Constants.YES;//if entered already then flag will be yes
                        programmeGuideDate = rs.getDate(6).toString();
                    } else {
                        programmeGuideFlag = Constants.NO;//if not entered earlier then flag will be no
                        programmeGuideDate = "XX/XX/XXXX";
                    }
                    /*Logic for getting the available sets of the Programme guide of the program opted by the student*/     
                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE+ regionalCenterCode + 
                            " where " + searchCourseCode + " and block='PG' and medium='" + medium + "'");
                    while(rs.next()) {
                        availableProgrammeGuide = rs.getInt(1);
                    }
        
                    System.out.println("Available sets of Program guide of " + programme + " is " + availableProgrammeGuide);
                    request.setAttribute("pg_flag", programmeGuideFlag);//sending the pg_flag means despatched or not
                    request.setAttribute("pg_date", programmeGuideDate);//sending the pg_flag means despatched or not
                    int dispatchCourseCount = 0;//variable for counting the number of courses despatched to the selected roll number
                    rs = statement.executeQuery("select count(*) from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                            regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
                    while(rs.next()) {
                        dispatchCourseCount = rs.getInt(1);
                    }
                    /*If Not any course opted by student has been dispatched then this logic will create empty Despatch course and date array*/

                    if(dispatchCourseCount == 0) {
                        String dispatch[] = new String[dispatchCourseCount];//array for despatched courses 
                        String dispatchDate[] = new String[dispatchCourseCount];//array for dispatch date of despatched courses
                        message = message + "Welcome to the By Post Entry for " + name + " First Time.";
                        /*Sending the Despatch courses and dates empty array with the msg variable with appropriate msg to the Browser*/        
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post1.jsp?enrno=" + enrollmentNumber + "&prog=" + programme + "&year=" + year + "&name=" + name + "&medium=" 
                        + medium + "&available_pg=" + availableProgrammeGuide).forward(request, response); 
                    } else if(dispatchCourseCount < courseBlock.length) {
                        /*If some courses partially dispatched then this logic will create the dispatched courses and dates array and sent to client*/
                        String checking = null;
                        int m = 0, lll = 0, counter = 0;
                        length = 0;
                        rs = statement.executeQuery("select count(*) from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
                        while(rs.next()) {
                            length = rs.getInt(1);
                        }
    
                        String dispatch[] = new String[length];//initializing the array of despatched courses
                        String dispatchDate[] = new String[length];//initializing the array of despatched dates

                        rs = statement.executeQuery("select * from student_dispatch_"+currentSession + Constants.UNDERSCORE + 
                                regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
            
                        while(rs.next()) {
                            checking = rs.getString(3).trim();
                            for(index = 0; index < course.length; index++) {
                                if(checking.equals(course[index]))
                                    blocksShadow[index]++;
                            }

                            dispatch[m] = checking + rs.getString(4).trim();//rs.getString(3).trim()+rs.getString(4).trim();//creating the course block wise
                            dispatchDate[m] = rs.getDate(6).toString();//getting the date of despatch
                            m++;
                        }
                        m = 0;
                        message = message + "Partially Despatched Courese of " + name + " are ";
                        for(int k = 0; k < dispatch.length; k++) {
                            message = " " + message + " " + dispatch[k];
                        }
                        /*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/  
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post1.jsp?enrno=" + enrollmentNumber + "&prog=" + programme + "&year=" + year + "&name=" + 
                        name + "&medium=" + medium + "&available_pg=" + availableProgrammeGuide).forward(request, response);
                    } else if(dispatchCourseCount == courseBlock.length && programmeGuideFlag.equals(Constants.NO)) {
                        
                        /*Intermediate Logic for sending only the program guide is not despatched and all the courses have been despatched.*/
                        /*If some courses partially dispatched then this logic will create the dispatched courses and dates array and sent to client*/

                        String checking = null;
                        int m = 0, lll = 0, counter = 0;
                        length = 0;
                        rs = statement.executeQuery("select count(*) from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
                        while(rs.next()) {
                            length = rs.getInt(1);
                        }
    
                        String dispatch[] = new String[length];//initializing the array of despatched courses
                        String dispatchDate[] = new String[length];//initializing the array of despatched dates

                        rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode +
                                " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
            
                        while(rs.next()) {
                            checking = rs.getString(3).trim();
                            for(index = 0; index < course.length; index++) {
                                if(checking.equals(course[index])) {
                                    blocksShadow[index]++;
                                }
                            }

                            dispatch[m] = checking + rs.getString(4).trim();//creating the course block wise
                            dispatchDate[m] = rs.getDate(6).toString();//getting the date of despatch
                            m++;
                        }
                        m = 0;
                        message = message + "Partially Despatched Courese of " + name + " are ";
                        for(int k = 0; k < dispatch.length; k++) {
                            message = " " + message + " " + dispatch[k];
                        }
                        /*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/  
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post1.jsp?enrno=" + enrollmentNumber + "&prog=" + programme + "&year=" + year + 
                                "&name=" + name + "&medium=" + medium + "&available_pg=" + availableProgrammeGuide).forward(request, response);
                    } else {

                        /*LOGIC IF ALL THE COURSES AND THE PROGRAM GUIDE HAS BEEN DESPATCHED SUCCESSFULLY THEN THIS SECTION WILL WORK*/
                        
                        int m = 0, lengthOfDispatchCourses = 0;
                        rs = statement.executeQuery("select count(*) from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                                regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
                        while(rs.next()) {
                            lengthOfDispatchCourses = rs.getInt(1);
                        }
    
                        System.out.println("length of length_of_despatch_courses " + lengthOfDispatchCourses);
                        String dispatch[] = new String[lengthOfDispatchCourses];
                        String dispatchDate[] = new String[lengthOfDispatchCourses];
                        rs = statement.executeQuery("select * from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + enrollmentNumber + "'and block<>'PG' and reentry='NO'");
                        
                        while(rs.next()) {
                            dispatch[m] = rs.getString(3).trim() + rs.getString(4).trim();
                            dispatchDate[m] = rs.getDate(6).toString();
                            dispatchMode = rs.getString(7);
                            m++;
                        }

                        request.setAttribute("dispatch", dispatch);//sending the array of Despatch courses block wise to the browser
                        request.setAttribute("dispatch_date", dispatchDate);//sending the array of Despatch dates to the browser        
                        System.out.println("Sorry books have been Despatched...");
                        message = message + "Sorry!! Books have been Dispatched for<br/>" + name + ".";
                        request.setAttribute("msg", message);//sending the message to the browser

                        request.getRequestDispatcher("jsp/By_post.jsp?enrno=" + enrollmentNumber + "&prog=" + programme + 
                                "&year=" + year + "&name=" + name + "&medium=" + medium + "&date=" + date + "&dispatch_mode=" 
                                + dispatchMode + "&available_pg=" + availableProgrammeGuide).forward(request, response);
                    }
                } else {
                    System.out.println("Sorry!! Roll No not found please contact to Registration Department..Thank you..");
                    message = "Sorry!! Roll Number not found please contact to Admission Department. Thank You..";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/By_post.jsp").forward(request, response); 
                }
            } catch(Exception exception) {
                System.out.println("Exception Raised from BYEPOSTSEARCH SERVLET AND EXCEPTION IS " + exception);
                message = "Some Serious Exception Hitted the page. Please check on Server Console for Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_post.jsp").forward(request, response);
            }
        }
    }
}