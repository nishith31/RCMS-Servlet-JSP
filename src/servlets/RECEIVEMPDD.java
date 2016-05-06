package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING MATERIAL FROM MPDD COMPLETELY.
 * IF USER WANTS TO RECEIVE MATERIALS PARTIALLY THEN THIS SERVLET WILL REDIRECTS THE PAGE TO FROM_MPDD1.JSP AND 
 * THERE WE RECEIVE PARTIALLY .THIS SERVLET TAKES THE COURSE CODE,DATE,MEDIUM AS INPUT AND DISPLAY THE RESULT INTO NEXT PAGE
CALLED JSP:-From_mpdd.jsp*/
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
 
public class RECEIVEMPDD extends HttpServlet { 
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("RECEIVEMPDD SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
    
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/    
            String courseCode                =    request.getParameter("mnu_crs_code").toUpperCase();
            String courseCode2               =    request.getParameter("mnu_crs_code2").toUpperCase();
            String courseCode3               =    request.getParameter("mnu_crs_code3").toUpperCase();
            String courseCode4               =    request.getParameter("mnu_crs_code4").toUpperCase();
            String courseCode5               =    request.getParameter("mnu_crs_code5").toUpperCase();
            String courseCode6               =    request.getParameter("mnu_crs_code6").toUpperCase();
            String courseCode7               =    request.getParameter("mnu_crs_code7").toUpperCase();       
            String courseCode8               =    request.getParameter("mnu_crs_code8").toUpperCase();
            String courseCode9               =    request.getParameter("mnu_crs_code9").toUpperCase();
            String courseCode10              =    request.getParameter("mnu_crs_code10").toUpperCase();      
            /*in case of partial despatch these need not be got*/
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
            String regionalCenterCode = (String)session.getAttribute("rc");
            System.out.println("fields from mpdd receive medium is " + medium);
            String message = null;    
            int index = 0;
            /*LOGIC FOR CHECKING THE SELECTED COURSES AND CREATING THEIR ARRAY OF STRING*/
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
            String courses[] = new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
            int quantities[] = new int[index];//INTEGER ARRAY FOR HOLDING ALL THE QUANTITIES ENTERED BY USER           
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
            int flag = 0; 
            int[] numberOfBlocks = new int[index];
            int blockCount = 0;
            ResultSet first = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            ResultSet block = null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                //logic for receiving materials according to the receipt_type selected i.e. either complete or partial
                if(receiptType.equals("complete")) {
                    /*LOGIC FOR CHECKING THE EXISTING OF THE SAME ENTRY REQUESTED BY USER IN THE DATABASE AND PREPARING APPROPRIATE MESSAGE*/
                    message = "Entry Already Exist for Course: <br/>";
                    String[] blocks = new String[0];
                    for(int i = 0; i < courses.length; i++) {
                        block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courses[i] + "'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                        blocks = new String[blockCount];
                        int count = 0;
                        for(int j = 0;j<blockCount;j++) {
                            count = j+1;
                            blocks[j] = "B"+count;
                            first = statement.executeQuery("select * from mpdd_receive_"+currentSession + Constants.UNDERSCORE + 
                                    regionalCenterCode + " where crs_code='" + courses[i] + "' and block='" + blocks[j] + "' and medium='" 
                                    + medium + "' and date='" + date + "'");
                            if(first.next()) {
                                flag = 1;
                                message = message + courses[i] + " Block " + blocks[j] + " for date " + date + " in medium " + medium + "<br/>";
                            }
                        }
                    }    
                    if(flag == 0) {
                        //IF FLAG=0 MEANS CAN ENTER THE DETAILS IN THE DATABASE OTHERWISE ELSE WILL WORK
                        message = "Received Successfully from MPDD Course <br/>";
                        for(int i = 0; i < courses.length; i++) {
                            int count = 0;
                            for(int j = 0; j < numberOfBlocks[i]; j++) {
                                count = j + 1;
                                blocks = new String[numberOfBlocks[i]];
                                blocks[j] = "B" + count;
                                statement.executeUpdate("insert into mpdd_receive_" + currentSession+ Constants.UNDERSCORE + 
                                        regionalCenterCode+"(crs_code,block,qty,date,medium) values('" + courses[i] + "','" + blocks[j] + "',"
                                        + quantities[i] + ",'" + date + "','" + medium + "')");
                                
                                statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + 
                                        regionalCenterCode + " set qty=qty+" + quantities[i] + " where crs_code='" + courses[i] + "' and block='" + 
                                        blocks[j] + "' and medium='" + medium + "'");

                                message = message + courses[i] + " Block " + blocks[j] + " for date " + date + " in medium " + medium + "<br/>";
                            }
                        }
                        System.out.println("Received Succesfully from MPDD Course code " + courseCode);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);  
                    } else {
                        //IF ENTRIES ALREADY FOUND THEN THIS ELSE WILL WORK AND GIVE MESSAGE TO THE BROWSER
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
                    }
                }
                if(receiptType.equals("partial")) {
                    String  programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
                    for(int i = 0; i < courses.length; i++) {
                        block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courses[i] + "'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                    }
                    request.setAttribute("prg_code", programmeCode);
                    request.setAttribute("courses", courses);
                    request.setAttribute("qtys", quantities);//sending the quantities entered by the user to the browser       
                    request.setAttribute("no_of_blocks", numberOfBlocks);
                    request.setAttribute("current_session", currentSession);
                    request.setAttribute("medium", medium);
                    request.setAttribute("date", date);
                    request.setAttribute("msg", message);
                    System.out.println("All attributes set for partial receipt in From_mpdd");
                    request.getRequestDispatcher("jsp/From_mpdd1.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from From_mpdd page " + exception);
                message  =  "Some Serious Exception came at the page. Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
            }
        }
    } 
}