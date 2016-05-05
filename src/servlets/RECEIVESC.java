package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING MATERIAL FROM STUDY CENTRE IN COMPLETE MODEA AND IF USER WANTS TO RECEIVE PARTIALLY 
THEN PARTIALLY LOGIC WILL SENDS ALL THE SELECTED COURSES AND OTHER SELECTIONS LIKE SC CODE,PROGRAMME CODE TO THE NEXT PAGE
IN READ ONLY MODE WITH APPROPRIATE MESSAGE.
CALLED JSP:-From_sc.jsp*/
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
 
public class RECEIVESC extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVESC SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String  studyCenterCode = request.getParameter("mnu_sc_code").toUpperCase();
            String  courseCode = request.getParameter("mnu_crs_code").toUpperCase();
            String  courseCode2 = request.getParameter("mnu_crs_code2").toUpperCase();
            String  courseCode3 = request.getParameter("mnu_crs_code3").toUpperCase();
            String  courseCode4 = request.getParameter("mnu_crs_code4").toUpperCase();
            String  courseCode5 = request.getParameter("mnu_crs_code5").toUpperCase();
            String  courseCode6 = request.getParameter("mnu_crs_code6").toUpperCase();
            String  courseCode7 = request.getParameter("mnu_crs_code7").toUpperCase();       
            String  courseCode8 = request.getParameter("mnu_crs_code8").toUpperCase();
            String  courseCode9 = request.getParameter("mnu_crs_code9").toUpperCase();
            String  courseCode10 = request.getParameter("mnu_crs_code10").toUpperCase();      

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

            String medium = request.getParameter("txt_medium").toUpperCase();
            String date = request.getParameter("txt_date").toUpperCase();
            String currentSession = request.getParameter("txt_session").toLowerCase();
            String receiptType = request.getParameter("receipt_type");
            System.out.println("fields from From_SC.jsp received");
            String regionalCenterCode = (String)session.getAttribute("rc");
            String message = null;
            int index = 0, flag = 0;
        
            if(!courseCode.equals(Constants.NONE)) {
                index++;
            }
        
            if(!courseCode2.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode3.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode4.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode5.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode6.equals(Constants.NONE)) {
                index++;
            }
                    
            if(!courseCode7.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode8.equals(Constants.NONE)) {
                index++;
            }

            if(!courseCode9.equals(Constants.NONE)) {
                index++;
            }
            
            if(!courseCode10.equals(Constants.NONE)) {
                index++;
            }

            String courses[] = new String[index];
            int quantities[] = new int[index];
            int insert = 0;
            if(!courseCode.equals(Constants.NONE)) {
                courses[insert] = courseCode;
                quantities[insert] = quantity;
                insert++;
            }
            
            if(!courseCode2.equals(Constants.NONE)) {
                courses[insert] = courseCode2;
                quantities[insert] = quantity2;
                insert++;
            }
            
            if(!courseCode3.equals(Constants.NONE)) {
                courses[insert] = courseCode3;
                quantities[insert] = quantity3;
                insert++;
            }

            if(!courseCode4.equals(Constants.NONE)) {
                courses[insert] = courseCode4;
                quantities[insert] = quantity4;
                insert++;
            }

            if(!courseCode5.equals(Constants.NONE)) {
                courses[insert] = courseCode5;
                quantities[insert] = quantity5;
                insert++;
            }
    
            if(!courseCode6.equals(Constants.NONE)) {
                courses[insert] = courseCode6;
                quantities[insert] = quantity6;
                insert++;
            }
    
            if(!courseCode7.equals(Constants.NONE)) {
                courses[insert] = courseCode7;
                quantities[insert] = quantity7;
                insert++;
            }

            if(!courseCode8.equals(Constants.NONE)) {
                courses[insert] = courseCode8;
                quantities[insert] = quantity8;
                insert++;
            }
    
            if(!courseCode9.equals(Constants.NONE)) {
                courses[insert] = courseCode9;
                quantities[insert] = quantity9;
                insert++;
            }

            if(!courseCode10.equals(Constants.NONE)) {
                courses[insert] = courseCode10;
                quantities[insert] = quantity10;
                insert++;
            }

            int[] numberOfBlocks = new int[index];
            int blockCount = 0;
            ResultSet firstResultSet = null;// RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            ResultSet block = null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                /*IF USER WANTS TO RECEIVE ALL THE MATERIALS FROM THE SC IN COMPLETE MODE THAN THIS SECTION WILL WORK*/ 
                if(receiptType.equals("complete")) {
                    message = "Entry Already Exist for Course: <br/>";
                    String[] blocks = new String[0];
                    for(int i=0;i<courses.length;i++) {
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
                            firstResultSet = statement.executeQuery("select * from sc_receive_" + currentSession + Constants.UNDERSCORE+ regionalCenterCode
                                    + " where sc_code='" + studyCenterCode + "' and crs_code='" + courses[i] + "' and block='" + blocks[j] + "' and medium='" + medium
                                    + "' and date='" + date + "'");
            
                            if(firstResultSet.next()) {
                                flag = 1;
                                message = message + courses[i] + " Block " + blocks[j] + " for Date " + date + " in Medium " + medium + "<br/>";
                            }
                        }
                    }
                    if(flag == 0) {
                        message = "Received Successfully from SC Course <br/>";
                        for(int i = 0; i < courses.length; i++) {
                            int count = 0;
                            for(int j = 0; j < numberOfBlocks[i]; j++) {
                                count = j + 1;
                                blocks = new String[numberOfBlocks[i]];
                                blocks[j] = "B" + count;//creating the block names of the courses
                                message = message + courses[i] + " Block " + blocks[j] + " for date " + date + " in medium " + medium + "<br/>";
                            }
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_sc.jsp").forward(request, response);  
                    } else {
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_sc.jsp").forward(request, response);  
                    }
                }
                /*IF USER WANTS TO RECEIVE MATERIAL PARTIALLY MEANS BLOCK WISE THEN THIS SECTION WILL WORK*/    
                if(receiptType.equals("partial")) {
                    String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
                    for(int i = 0; i < courses.length; i++) {
                        block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courses[i] + "'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                    }
                    request.setAttribute("sc_code", studyCenterCode);//sending the sc code to the browser
                    request.setAttribute("prg_code", programmeCode);//sending the programme code to the browser
                    request.setAttribute("courses", courses);//sending the courses selected by user to the browser
                    request.setAttribute("qtys", quantities);//sending the quantities entered by the user to the browser
                    request.setAttribute("no_of_blocks", numberOfBlocks);//sending the no of blocks of the courses selected by user to the browser
                    request.setAttribute("current_session", currentSession);//sending the value of the current session of the RC
                    request.setAttribute("medium", medium);//sending the medium selected by the user to the browser
                    request.setAttribute("date", date);//sending the date selected by the user to the browser
                    request.setAttribute("msg", message);//sending the appropriate message to the browser
                    System.out.println("All attributes set for partial receipt in From_rc");
                    request.getRequestDispatcher("jsp/From_sc1.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from RECEIVESC.JAVA page" + exception);
                message = "Some Serious Exception came at the page. Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_sc.jsp").forward(request, response);
            }
        }
    } 
}