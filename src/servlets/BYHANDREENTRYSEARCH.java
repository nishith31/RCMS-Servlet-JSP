package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING ALL THE DETAILS OF THE STUDENT FROM THE STUDENT DATABASE AND DISPLAY THEM TO THE NEXT PAGE.
 * IF ANY COURSE HAS NOT BEEN DESPATCHED THEN ALL THE CECKBOXES WILL BE ACTIVE AND IF SOME COURSES ALREADY DESPATCHED THEN THOSE COURSES WILL 
 * BE SHOWN IN DISABLED FORMAT IN THE BROWSER.*/
import static utility.CommonUtility.isNull;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 

import javax.servlet.*;
import javax.servlet.http.*;

import utility.Constants;
 
public class BYHANDREENTRYSEARCH extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    String current_session = "";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYHANDREENTRYSEARCH SERVLET STARTED TO EXECUTE");
    } 
 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String enrollmentNumber                =    request.getParameter("text_enr").toUpperCase();
            String message              =   ""; 
            String programme             =   null;
            String name             =   null;
            char year;
            String medium           =   null;   
            String date             =   null;   
            String dispatchMode    =   null;
            int availableProgrammeGuide = 0;
            String programmeGuideFlat = null, programmeGuideDate = null;
            try {
                message = (String)request.getAttribute("alternate_msg");
            } catch(Exception exception) {
                message = null;
            }
            if(message == null) {
                message = " ";
            }

            String regionalCenterCode = (String)session.getAttribute("rc");
            int length = 0,index = 0;
            response.setContentType(Constants.HEADER_TYPE_HTML);
            ResultSet  rs = null;
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Connection connection1 = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                Statement statement1 = connection1.createStatement();
                /*Logic for getting the current session name from the sessions table of the regional centre logged in and send to the browser*/ 
                rs = statement.executeQuery("select TOP 1 session_name from sessions_" + regionalCenterCode + " order by id DESC");
                while(rs.next()) {
                    current_session = rs.getString(1).toLowerCase();
                }
                
                request.setAttribute("current_session", current_session);
                /*Complete Logic for fetching the details of the student from the the student database*/
                rs = statement.executeQuery("select * from student_" + current_session + Constants.UNDERSCORE + regionalCenterCode + " where enrno='" + enrollmentNumber + "'");
            
                if(rs.next()) {
                    //    if controls enter in if(rs.next()) means records exist for the roll entered in the browser
                    programme = rs.getString(2);//getting the prg_code from the table
                    char pr[] = programme.toCharArray();//converting the program to character array
                    for(int ii = 0; ii < pr.length; ii++) {
                      //getting the actual length of the program code fetched from the student table
                        if(pr[ii] != ' ')
                        length++;
                    }
                    /*Logic for separating the year or semester number from the program code*/
                    if(pr[length-1]=='1' || pr[length-1]=='2'|| pr[length-1]=='3'|| 
                            pr[length-1]=='4'|| pr[length-1]=='5'|| pr[length-1]=='6') {
                        programme = programme.substring(0,length-1);
                        year = pr[length - 1];
                    } else {
                        year = '1';
                        programme = programme;
                    }
                    name = rs.getString(5);//getting the name of the student from the ResultSet
                    medium = rs.getString(7);//getting the medium opted by the student from the student registration table
                    int courseNumber = 0;
                    /*Logic for checking the total number of courses opted by the student as blank course column contains only spaces*/
                    for(int i = 17; i < 35; i = i + 2) {
                        pr = rs.getString(i).toCharArray();
                        length = 0;
                        for(int k=0;k<pr.length;k++) {
                            if(pr[k] != ' ') {
                                length++;
                            }
                        }
                        if(length > 0) {
                            courseNumber++;
                        }
                    }
                    /*Logic for getting all the courses name, no of blocks of them and the serial number associated with the course*/
                    rs = statement.executeQuery("select * from student_" + current_session + Constants.UNDERSCORE + regionalCenterCode + " where enrno='" + enrollmentNumber + "'");
                    String course[] = new String[courseNumber];
                    int blocks[] = new int[courseNumber];
                    int blocksShadow[] = new int[courseNumber];
                    String serialNumber[] = new String[courseNumber];
                    int i = 17, j = 18, totalLength = 0, count = 0;

                    ResultSet rs1 = null, rs2 = null;
                    String relativeCourse = null;
                    while(rs.next()) {
                        for(index = 0; index < courseNumber; index++) {
                            course[index]           =   rs.getString(i).trim();
                            serialNumber[index]    =   rs.getString(j);
                            
                            rs1     =   statement1.executeQuery("Select * from course where crs_code='"+course[index]+"'");
                            if(rs1.next()) {
                                //System.out.println("course found in course table");
                                rs1     =   statement1 .executeQuery("Select no_of_blocks from course where crs_code='"+course[index]+"'");
                                while(rs1.next()) {
                                    blocks[index]           =   rs1.getInt(1);
                                }
                                
                                i = i + 2;
                                j = j + 2;
                            } else {
                                rs1 =   statement1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[index]+"' and rc_code='"+regionalCenterCode+"'");
                                while(rs1.next()) {
                                    relativeCourse=rs1.getString(1);
                                }
                                
                                rs1     =   statement1 .executeQuery("Select no_of_blocks from course where crs_code='"+relativeCourse+"'");
                                while(rs1.next()) {
                                    blocks[index]           =   rs1.getInt(1);    
                                }
                                
                                i = i + 2;
                                j = j + 2;
                            }
                        }
                    }
                    /*Logic for counting the total number of courses with block like MCSB1*/
                    for(index = 0; index < course.length; index++) {
                        totalLength = totalLength + blocks[index];
                    }
                
                    int[] stock =   new int[totalLength];//int array for holding the stock available for all courses blockwise
                    String courseBlock[] = new String[totalLength];//array for holding all the courses block wise
                    /*logic for creating array of course_block & stock availability*/
                    String blockName;
                    for(index = 0; index < course.length; index++) {
                        for(int b = 1; b <= blocks[index]; b++) {
                            courseBlock[count] = course[index] + "B" + b;
                            rs1     =   statement1 .executeQuery("Select * from course where crs_code='" + course[index] + "'");//checking the course in course table                
                            if(rs1.next()) {
                                relativeCourse=course[index];
                            } else {
                                rs1 = statement1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='" + 
                                                        course[index] + "' and rc_code='" + regionalCenterCode + "'");
                                while(rs1.next()) {
                                    relativeCourse = rs1.getString(1);
                                }
                            }
                            
                            blockName = "B" + b;
                            rs = statement.executeQuery("select qty from material_" + current_session + Constants.UNDERSCORE + 
                                    regionalCenterCode + " where crs_code='" + relativeCourse + "' and block='" + blockName + "' and medium='" + medium + "'");
                            while(rs.next()) {
                                stock[count] = rs.getInt(1);
                            }
                            count++;
                        }
                    }
                    /*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
                    request.setAttribute("course", course);
                    request.setAttribute("serial_number", serialNumber);
                    request.setAttribute("course_block", courseBlock);
                    request.setAttribute("blocks", blocks);
                    request.setAttribute("stock", stock);
                    /* logic of getting the ABSOLUTE PROGRAMME CODE*/
                    String[] relativeProgrammeCode = new String[0];
                    rs = statement.executeQuery("select count(*) from program_program where relative_prg_code='" + 
                                    programme + "' and rc_code='" + regionalCenterCode + "'");
                    if(rs.next()) {
                        relativeProgrammeCode = new String[rs.getInt(1)];
                    }
                    
                    index = 0;
                    rs = statement.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+programme+"' and rc_code='"+regionalCenterCode+"'");
                    while(rs.next()) {
                        relativeProgrammeCode[index]=rs.getString(1);
                        index++;
                    }
                    String searchCourseCode = "(crs_code='" + programme + "'";
                    for(index = 0; index < relativeProgrammeCode.length; index++) {
                        searchCourseCode = searchCourseCode + " or crs_code='" + relativeProgrammeCode[index] + "'";
                    }

                    searchCourseCode = searchCourseCode+")";
                System.out.println("value of search_crs_code " + searchCourseCode);
                /*Logic for checking the Despatch of Programme guide for the student entered into the system*/      
                rs=statement.executeQuery("select * from student_dispatch_"+current_session+"_"+regionalCenterCode+" where enrno='"+enrollmentNumber+"' and "+searchCourseCode+" and block='PG' and reentry='YES'");
                if(rs.next()) {
                    programmeGuideFlat = "YES";//if program guide is already despatched then flag will be YES
                    programmeGuideDate = rs.getDate(6).toString();   
                } else {
                    programmeGuideFlat = "NO";//if not entered earlier then flag will be NO
                    programmeGuideDate = "XX/XX/XXXX";
                }
                /*Logic for getting the available sets of the Programme guide of the program opted by the student*/     
                rs=statement.executeQuery("select qty from material_"+current_session+"_"+regionalCenterCode+" where "+searchCourseCode+" and block='PG' and medium='"+medium+"'");
                while(rs.next()) {
                    availableProgrammeGuide=rs.getInt(1);
                }
                    
                request.setAttribute("pg_flag",programmeGuideFlat);//sending the pg_flag means despatched or not
                request.setAttribute("pg_date",programmeGuideDate);//sending the pg_flag means despatched or not
        
                    int dispatchCourseCount=0;//variable for holding the number of courses despatched blockwise now
                    rs=statement.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+regionalCenterCode+" where enrno='"+enrollmentNumber+"' and block<>'PG' and reentry='YES'");
                    while(rs.next()) {
                        dispatchCourseCount=rs.getInt(1);
                    }
                    
                    /*If Not any course opted by student has been Despatched then this logic will create empty Despatch course and date array*/
            
                    if(dispatchCourseCount == 0) {
                        String dispatch[] = new String[dispatchCourseCount];//create array of Despatch courses
                        String dispatchDate[] = new String[dispatchCourseCount];//create array of Despatch courses date
                        message = message + "Welcome to the RE-ENTRY By Hand Entry for " + name + ".<br/>";
                        /*Sending the Despatch courses and dates empty array with the msg variable with appropriate msg to the Browser*/
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_hand3.jsp?enrno="+enrollmentNumber+"&prog="+programme+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+availableProgrammeGuide+"").forward(request, response); 
                    } else if(dispatchCourseCount<courseBlock.length) {
                        /*If some courses partially Despatched then this logic will create the Despatched courses and dates array and sent to client*/
                        String checking = null;
                        int m = 0, counter = 0;
                        dispatchCourseCount = 0;
                        rs=statement.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+regionalCenterCode+" where enrno='"+enrollmentNumber+"' and block<>'PG' and reentry='YES'");
                        while(rs.next()) {
                            dispatchCourseCount = rs.getInt(1);
                        }
            
                        String dispatch[]           =   new String[dispatchCourseCount];//array for Despatched courses
                        String dispatchDate[]      =   new String[dispatchCourseCount];//array for date of Despatched courses
                                    
                        rs = statement.executeQuery("select * from student_dispatch_" + current_session + Constants.UNDERSCORE + 
                                    regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='YES'");
                        while(rs.next()) {
                            checking = rs.getString(3).trim();
                            for(index = 0; index < course.length; index++) {
                                if(checking.equals(course[index])) {
                                    blocksShadow[index]++;
                                }
                            }
                            dispatch[m] = checking+rs.getString(4).trim();
                            dispatchDate[m] =   rs.getDate(6).toString();
                            m++;
                        }
                        m = 0;
                        message = message + "Partially Despatched Courese of " + name + " are ";
                        for(int k = 0; k < dispatch.length; k++) {
                            message = message + " " + dispatch[k];
                        }
                        /*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/  
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_hand3.jsp?enrno="+enrollmentNumber+"&prog="+programme+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+availableProgrammeGuide).forward(request, response);
            
                    } else if(dispatchCourseCount==courseBlock.length && programmeGuideFlat.equals("NO")) {
                        /*intermediate logic for Program Guide*/
                        /*If some courses partially Despatched then this logic will create the Despatched courses and dates array and sent to client*/
                    String checking = null;
                    int m = 0, counter = 0;
                        dispatchCourseCount = 0;
                        rs = statement.executeQuery("select count(*) from student_dispatch_" + current_session + Constants.UNDERSCORE + 
                                regionalCenterCode + " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='YES'");
                        while(rs.next()) {
                            dispatchCourseCount = rs.getInt(1);
                        }
                        String dispatch[] = new String[dispatchCourseCount];//array for dispatched courses
                        String dispatchDate[] = new String[dispatchCourseCount];//array for date of Despatched courses

                        rs=statement.executeQuery("select * from student_dispatch_"+current_session+"_"+regionalCenterCode+" where enrno='"+enrollmentNumber+"' and block<>'PG' and reentry='YES'");
                        while(rs.next()) {
                            checking = rs.getString(3).trim();
                            for(index = 0; index < course.length; index++) {
                                if(checking.equals(course[index])) {
                                    blocksShadow[index]++;
                                }
                            }
                            dispatch[m] = checking+rs.getString(4).trim();
                            dispatchDate[m] = rs.getDate(6).toString();
                            m++;
                        }
                        m = 0;
                        message = message + "Partially Despatched Courses of " + name + " are ";
                        for(int k = 0; k < dispatch.length; k++) {
                            message = message + " " + dispatch[k];
                        }
                        /*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/  
                        request.setAttribute("dispatch", dispatch);
                        request.setAttribute("dispatch_date", dispatchDate);
                        request.setAttribute("blocks_shadow", blocksShadow);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_hand3.jsp?enrno="+enrollmentNumber+"&prog="+programme+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+availableProgrammeGuide+"").forward(request,response);
                    } else {
                        /*If all the Materials has been despatched successfully then this section will work and sends the message to the browser*/
                        int m = 0,lengthOfDispatchCourses = 0;
                        rs = statement.executeQuery("select count(*) from student_dispatch_" + current_session + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='YES'");
                        while(rs.next())
                        {
                            lengthOfDispatchCourses=rs.getInt(1);
                        }//end of while loop
                
                        String dispatch[] = new String[lengthOfDispatchCourses];//array of despatched courses block wise
                        String dispatchDate[] = new String[lengthOfDispatchCourses];//array of Despatch dates of courses despatched
                        rs=statement.executeQuery("select * from student_dispatch_" + current_session + Constants.UNDERSCORE + regionalCenterCode + 
                                " where enrno='" + enrollmentNumber + "' and block<>'PG' and reentry='NO'");
            
                        while(rs.next()) {
                            dispatch[m] = rs.getString(3).trim() + rs.getString(4).trim();
                            dispatchDate[m] = rs.getDate(6).toString();
                            dispatchMode = rs.getString(7);
                            m++;
                        }
                        request.setAttribute("dispatch", dispatch);//sending the array of Despatch courses block wise to the browser
                        request.setAttribute("dispatch_date", dispatchDate);//sending the array of Despatch dates to the browser        
                        System.out.println("Sorry books have been Despatched...");
                        message = message+"Sorry!! Books have been Despatched For<br/>" +name + ".";
                        request.setAttribute("msg", message);//sending the message to the browser
                        request.getRequestDispatcher("jsp/By_hand.jsp?enrno=" +enrollmentNumber+"&prog="+programme+"&year="+year+"&name="+name+"&medium="+medium+"&date="+date+"&available_pg="+availableProgrammeGuide+"&dispatch_mode="+dispatchMode+"").forward(request,response);
                    }
                } else {
                    System.out.println("Sorry!! Roll No not found please contact to registration department..Thank you..");
                    message = "Sorry!! Roll Number not found please contact to Admission Department. Thank You..";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response); 
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from By_hand.jsp" + exception);
                message = "Some Serious Exception Hitted the page. Please check on Server Console for Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response);
            }
        }  
    }
}