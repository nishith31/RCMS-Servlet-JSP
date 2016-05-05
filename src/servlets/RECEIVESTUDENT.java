package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING MATERIAL FROM STUDENT COMPLETELY OR IF USER WANTS TO PARTIALLY SUBMIT MEANS
BLOCKWISE THEN THIS SERVLET SENDS THE REQUESTED DETAILS TO THE NEXT PAGE FOR THE PARTIAL RECEIPT OF THE COURSE.THIS SERVLET
TAKES THE ENROLMENT NO,NAME,PROGRAMME CODE,COURSE CODES,QUANTITIES,DATE,MEDIUM AND CURRENT SESSION AND SENDS THE APPROPRIATE
MESSAGE TO THE BROWSER
CALLED JSP:-From_student.jsp*/
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
 
public class RECEIVESTUDENT extends HttpServlet {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVESTUDENT SERVLET STARTED.....");
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String enrollmentNumber = request.getParameter("txt_enr").toUpperCase();//String variable for holding the roll number inpur on the browser
            String name = request.getParameter("txt_name").toUpperCase();//String variable for holding the name of the student input on the browser
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
            String courseCode = request.getParameter("mnu_crs_code").toUpperCase();
            String courseCode2 = request.getParameter("mnu_crs_code2").toUpperCase();
            String courseCode3 = request.getParameter("mnu_crs_code3").toUpperCase();
            String courseCode4 = request.getParameter("mnu_crs_code4").toUpperCase();
            String courseCode5 = request.getParameter("mnu_crs_code5").toUpperCase();
            String courseCode6 = request.getParameter("mnu_crs_code6").toUpperCase();
            String courseCode7 = request.getParameter("mnu_crs_code7").toUpperCase();
            String courseCode8 = request.getParameter("mnu_crs_code8").toUpperCase();
            String courseCode9 = request.getParameter("mnu_crs_code9").toUpperCase();
            String courseCode10 = request.getParameter("mnu_crs_code10").toUpperCase();

            int quantity = Integer.parseInt(request.getParameter("txt_no_of_set"));
            int quantity2 = Integer.parseInt(request.getParameter("txt_no_of_set2"));
            int quantity3 = Integer.parseInt(request.getParameter("txt_no_of_set3"));
            int quantity4 = Integer.parseInt(request.getParameter("txt_no_of_set4"));  
            int quantity5 = Integer.parseInt(request.getParameter("txt_no_of_set5"));  
            int quantity6 = Integer.parseInt(request.getParameter("txt_no_of_set6"));  
            int quantity7 = Integer.parseInt(request.getParameter("txt_no_of_set7"));  
            int quantity8 = Integer.parseInt(request.getParameter("txt_no_of_set8"));  
            int quantity9 = Integer.parseInt(request.getParameter("txt_no_of_set9"));  
            int quantity10 = Integer.parseInt(request.getParameter("txt_no_of_set10"));         

            String medium              =    request.getParameter("txt_medium").toUpperCase();
            String  date                =    request.getParameter("txt_date").toUpperCase();
            String currentSession      =    request.getParameter("txt_session").toLowerCase();
            String receiptType             =    request.getParameter("receipt_type");
            System.out.println("fields from From_student.jsp received Successfully");
            String message = null;    
            String regionalCenterCode = (String)session.getAttribute("rc");
            int index = 0, flag = 0;
            if(!courseCode.equals("NONE")) {
                index++;
            }
        
            if(!courseCode2.equals("NONE")) {
                index++; 
            }
            
            if(!courseCode3.equals("NONE")) {
                index++;
            }
            if(!courseCode4.equals("NONE")) {
                index++;
            }
        
            if(!courseCode5.equals("NONE")) {
                index++;
            }
            
            if(!courseCode6.equals("NONE")) {
                index++;
            }
            
            if(!courseCode7.equals("NONE")) {
                index++;
            }
            
            if(!courseCode8.equals("NONE")) {
                index++;
            }
            
            if(!courseCode9.equals("NONE")) {
                index++;
            }
            if(!courseCode10.equals("NONE")) {
                index++;
            }
            String courses[] = new String[index];
            int qtys[] = new int[index];
            int insert = 0;
            if(!courseCode.equals("NONE")) {
                courses[insert] = courseCode;
                qtys[insert] = quantity;
                insert++;
            }

            if(!courseCode2.equals("NONE")) {
                courses[insert] = courseCode2;
                qtys[insert] = quantity2;
                insert++;
            }
            
            if(!courseCode3.equals("NONE")) {
                courses[insert] = courseCode3;
                qtys[insert] = quantity3;
                insert++;
            }
            
            if(!courseCode4.equals("NONE")) {
                courses[insert] = courseCode4;
                qtys[insert] = quantity4;
                insert++;
            }
            
            if(!courseCode5.equals("NONE")) {
                courses[insert] = courseCode5;
                qtys[insert] = quantity5;              
                insert++;
            }

            if(!courseCode6.equals("NONE")) {
                courses[insert]=courseCode6;
                qtys[insert]=quantity6;              
                insert++;
            }

            if(!courseCode7.equals("NONE")) {
                courses[insert] = courseCode7;
                qtys[insert] = quantity7;
                insert++;
            }    

            if(!courseCode8.equals("NONE")) {
                courses[insert] = courseCode8;
                qtys[insert] = quantity8;
                insert++;
            }
            
            if(!courseCode9.equals("NONE")) {
                courses[insert] = courseCode9;
                qtys[insert] = quantity9;
                insert++;
            }

            if(!courseCode10.equals("NONE")) {
                courses[insert] = courseCode10;
                qtys[insert] = quantity10;
                insert++;
            }

            int[] numberOfBlocks = new int[index];
            int blockCount = 0;
            ResultSet firstResultSet = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            ResultSet block = null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                if(receiptType.equals("complete")) {
                    /*checking*/
                    message = "Entry Already Exist for Enrollment No " + enrollmentNumber + " for Course: <br/>";
                    String[] blocks = new String[0];
                    for(int i = 0;i < courses.length; i++) {
                        block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courses[i] + "'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                        blocks = new String[blockCount];
                        int count = 0;
                        for(int j = 0; j < blockCount; j++) {
                            count = j + 1;
                            blocks[j] = "B" + count;
                            firstResultSet = statement.executeQuery("select * from student_receive_" + currentSession + Constants.UNDERSCORE + 
                                    regionalCenterCode + " where enrno='" + enrollmentNumber + "' and crs_code='" + courses[i] + "' and block='" + blocks[j] + "'");
            
                            if(firstResultSet.next()) {
                                flag = 1;
                                message = message + courses[i] + " Block " + blocks[j] + "<br/>";
                            }
                        }
                    }    

                    /*LOGIC FOR INSERTING THE MATERIAL INTO RECEIVE DATABASE IF FLAG==0 MEANS DUPLICATE ENTRY NOT FOUND ALREADY*/
                    if(flag==0) {
                        message = "Received Successfully from STUDENT Course<br/>";
                        for(int i = 0; i < courses.length; i++) {
                            int count = 0;
                            for(int j = 0; j < numberOfBlocks[i]; j++) {
                                count = j + 1;
                                blocks = new String[numberOfBlocks[i]];
                                blocks[j] = "B" + count;
                                message = message + courses[i] + " Block " + blocks[j] + " for date " + date + " in medium " + medium + "<br/>";
                            }
                            System.out.println("Received Succesfully from STUDENT: " + enrollmentNumber + " Course code " + courses[i]);
                        }

                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_student.jsp").forward(request, response);
                    } else {
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_student.jsp").forward(request, response);
                    }
                }
                /*IF PARTIAL RECEIPT OF MATERIAL DEMANDED BY THE CLIENT THEN THIS SECTION WILL WORK*/
                if(receiptType.equals("partial")) {
                    message = " Welcome to The Partial Receipt of Materials from " + name + ".<br/>";
                    for(int i=0;i<courses.length;i++) {
                        block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courses[i] + "'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                    }
                    request.setAttribute("enrno",enrollmentNumber);//sending the enrolment no of the student entered by the user
                    request.setAttribute("name",name);//sending the name of the student entered by the user
                    request.setAttribute("prg_code",programmeCode);//sending the programme code selected by the user
                    request.setAttribute("courses",courses);//sending the courses selected by the user
                    request.setAttribute("qtys",qtys);//sending the no of sets selected for the courses in the first page to the next page
                    request.setAttribute("no_of_blocks",numberOfBlocks);//sending no of blocks of courses selected by the user
                    request.setAttribute("current_session",currentSession);//sending the value of the current session of the RC
                    request.setAttribute("medium",medium);//sending the value of the medium selected by the user
                    request.setAttribute("date",date);//sending the value of the date selected by the user
                    request.setAttribute("msg",message);//sending the output message to the browser
                    request.getRequestDispatcher("jsp/From_student1.jsp").forward(request,response);        
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from From_student page" + exception);
                message = "Some Serious Exception Came.Please check on the Server Console for more details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_student.jsp").forward(request, response); 
            }
        }
    } 
}