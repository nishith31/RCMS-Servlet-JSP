package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING MATERIAL FROM MPDD COMPLETELY.
 * IF USER WANTS TO RECEIVE MATERIALS PARTIALLY THEN THIS SERVLET WILL REDIRECTS THE PAGE TO FROM_MPDD1.JSP AND 
 * THERE WE RECEIVE PARTIALLY .THIS SERVLET TAKES THE COURSE CODE,DATE,MEDIUM AS INPUT AND DISPLAY THE RESULT INTO NEXT PAGE
CALLED JSP:-From_mpdd.jsp*/
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
        if(session==null) {
            String msg = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", msg);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
    
            /*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/    
            String  courseCode                =    request.getParameter("mnu_crs_code").toUpperCase();
            String  courseCode2               =    request.getParameter("mnu_crs_code2").toUpperCase();
            String  courseCode3               =    request.getParameter("mnu_crs_code3").toUpperCase();
            String  courseCode4               =    request.getParameter("mnu_crs_code4").toUpperCase();
            String  courseCode5               =    request.getParameter("mnu_crs_code5").toUpperCase();
            String  courseCode6               =    request.getParameter("mnu_crs_code6").toUpperCase();
            String  courseCode7               =    request.getParameter("mnu_crs_code7").toUpperCase();       
            String  courseCode8               =    request.getParameter("mnu_crs_code8").toUpperCase();
            String  courseCode9               =    request.getParameter("mnu_crs_code9").toUpperCase();
            String  courseCode10              =    request.getParameter("mnu_crs_code10").toUpperCase();      
            /*in case of partial despatch these need not be got*/
            int        quantity                  =    Integer.parseInt(request.getParameter("txt_no_of_set"));   
            int        quantity2                 =    Integer.parseInt(request.getParameter("txt_no_of_set2"));      
            int        quantity3                 =    Integer.parseInt(request.getParameter("txt_no_of_set3"));  
            int        quantity4                 =    Integer.parseInt(request.getParameter("txt_no_of_set4"));  
            int        qty5                 =    Integer.parseInt(request.getParameter("txt_no_of_set5"));  
            int        qty6                 =    Integer.parseInt(request.getParameter("txt_no_of_set6"));  
            int        qty7                 =    Integer.parseInt(request.getParameter("txt_no_of_set7"));  
            int        qty8                 =    Integer.parseInt(request.getParameter("txt_no_of_set8"));  
            int        qty9                 =    Integer.parseInt(request.getParameter("txt_no_of_set9"));  
            int       qty10                 =    Integer.parseInt(request.getParameter("txt_no_of_set10"));         
            
            String  medium                  =    request.getParameter("txt_medium").toUpperCase();
            String  date                    =    request.getParameter("txt_date").toUpperCase();
            String currentSession          =    request.getParameter("txt_session").toLowerCase();
            String receiptType             =    request.getParameter("receipt_type");
            /*LOGIC ENDS FOR GETTING THE PARAMETERS FROM THE REQUEST*/  
            String regionalCenterCode          =   (String)session.getAttribute("rc");
            System.out.println("fields from mpdd receive medium is " + medium);
            String message = null;    
            int index = 0;
            int actualQuantity = 0;//VARIABLE FOR STORING THE ACTUAL NUMBER OF BOOKS ON THE STORE FROM THE MATERIAL TABLE
            int flagForReturn = 0;
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
            String courses[]        =   new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
            int qtys[]              =   new int[index];//INTEGER ARRAY FOR HOLDING ALL THE QUANTITIES ENTERED BY USER           
            int insert              =   0;
            if(!courseCode.equals(Constants.NONE)) {
                courses[insert] = courseCode;
                qtys[insert] = quantity;
                insert++;
            }
            if(!courseCode2.equals(Constants.NONE)) {
                courses[insert] = courseCode2;
                qtys[insert] = quantity2;
                insert++;
            }
            if(!courseCode3.equals(Constants.NONE)) {
                courses[insert] = courseCode3;
                qtys[insert] = quantity3;
                insert++;
            }
            if(!courseCode4.equals(Constants.NONE))   
            {
                courses[insert] = courseCode4;
                qtys[insert] = quantity4;
                insert++;
            }
            if(!courseCode5.equals(Constants.NONE))   
            {
                courses[insert] = courseCode5;
                qtys[insert] = qty5;              
                insert++;
            }
            if(!courseCode6.equals(Constants.NONE))   
            {
                courses[insert] = courseCode6;
                qtys[insert] = qty6;              
                insert++;
            }
            if(!courseCode7.equals(Constants.NONE))   
            {
                courses[insert] = courseCode7;
                qtys[insert] = qty7;              
                insert++;
            }
            if(!courseCode8.equals(Constants.NONE))   
            {
                courses[insert] = courseCode8;
                qtys[insert] = qty8;              
                insert++;
            }
            if(!courseCode9.equals(Constants.NONE))   
            {
                courses[insert] = courseCode9;
                qtys[insert] = qty9;              
                insert++;
            }
            if(!courseCode10.equals(Constants.NONE))  
            {
                courses[insert] = courseCode10;
                qtys[insert] = qty10;             
                insert++;
            }
            /*LOGIC ENDS OF GETTING THE SELECTED COURSES AND QUANTITES AND STORE THEM IN THE CORRESPONDING ARRAY*/  
            int flag = 0; 
            int resultMaterial  =  0;
            int resultReceive = 0;
            int[] numberOfBlocks = new int[index];
            int blockCount = 0;
            ResultSet first = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
            ResultSet block = null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection con = connections.ConnectionProvider.conn();
                Statement stmt = con.createStatement();
                //logic for receiving materials according to the receipt_type selected i.e. either complete or partial
                if(receiptType.equals("complete")) {
                    int result = 5,result1 = 5;
                    /*LOGIC FOR CHECKING THE EXISTING OF THE SAME ENTRY REQUESTED BY USER IN THE DATABASE AND PREPARING APPROPRIATE MESSAGE*/
                    message = "Entry Already Exist for Course: <br/>";
                    String[] blocks = new String[0];
                    for(int i = 0;i<courses.length;i++) {
                        block = stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                        blocks = new String[blockCount];
                        int count = 0;
                        for(int j = 0;j<blockCount;j++) {
                            count = j+1;
                            blocks[j] = "B"+count;
                            first = stmt.executeQuery("select * from mpdd_receive_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+courses[i]+"' and block='"+blocks[j]+"' and medium='"+medium+"' and date='"+date+"'");
                            if(first.next()) {
                                flag = 1;
                                message = message+courses[i]+" Block "+blocks[j]+" for date "+date+" in medium "+medium+"<br/>";
                            }
                        }
                    }    
                    /*LOGIC ENDS OF CHECKING EXISTENCE*/
                    if(flag==0) {
                        //IF FLAG=0 MEANS CAN ENTER THE DETAILS IN THE DATABASE OTHERWISE ELSE WILL WORK
                        message = "Received Successfully from MPDD Course <br/>";
                        for(int i = 0;i<courses.length;i++) {
                            int count = 0;
                            for(int j = 0;j<numberOfBlocks[i];j++) {
                                count = j+1;
                                blocks = new String[numberOfBlocks[i]];
                                blocks[j] = "B"+count;
                                resultReceive = stmt.executeUpdate("insert into mpdd_receive_"+currentSession+"_"+regionalCenterCode+"(crs_code,block,qty,date,medium) values('"+courses[i]+"','"+blocks[j]+"',"+qtys[i]+",'"+date+"','"+medium+"')");
                                resultMaterial = stmt.executeUpdate("update material_"+currentSession+"_"+regionalCenterCode+" set qty=qty+"+qtys[i]+" where crs_code='"+courses[i]+"' and block='"+blocks[j]+"' and medium='"+medium+"'");
                                message = message+courses[i]+" Block "+blocks[j]+" for date "+date+" in medium "+medium+"<br/>";
                            }
                        }
                        System.out.println("Received Succesfully from MPDD Course code "+courseCode+"");
                        request.setAttribute("msg",message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request,response);  
                    } else {
                        //IF ENTRIES ALREADY FOUND THEN THIS ELSE WILL WORK AND GIVE MESSAGE TO THE BROWSER
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
                    }
                }
                if(receiptType.equals("partial")) {
                    String  programmeCode                =    request.getParameter("mnu_prg_code").toUpperCase();
                    for(int i=0;i<courses.length;i++) {
                        block = stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
                        while(block.next()) {
                            blockCount = block.getInt(1);
                        }
                        numberOfBlocks[i] = blockCount;
                    }
                    request.setAttribute("prg_code",programmeCode);
                    request.setAttribute("courses",courses);
                    request.setAttribute("qtys",qtys);//sending the quantities entered by the user to the browser       
                    request.setAttribute("no_of_blocks",numberOfBlocks);
                    request.setAttribute("current_session",currentSession);
                    request.setAttribute("medium",medium);
                    request.setAttribute("date",date);
                    request.setAttribute("msg",message);
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