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
            String  enrno               =    request.getParameter("txt_enr").toUpperCase();//String variable for holding the roll number inpur on the browser
            String  name                =    request.getParameter("txt_name").toUpperCase();//String variable for holding the name of the student input on the browser
            String  prg_code                =    request.getParameter("mnu_prg_code").toUpperCase();
            String  crs_code                =    request.getParameter("mnu_crs_code").toUpperCase();
            String  crs_code2               =    request.getParameter("mnu_crs_code2").toUpperCase();
            String  crs_code3               =    request.getParameter("mnu_crs_code3").toUpperCase();
            String  crs_code4               =    request.getParameter("mnu_crs_code4").toUpperCase();
            String  crs_code5               =    request.getParameter("mnu_crs_code5").toUpperCase();
            String  crs_code6               =    request.getParameter("mnu_crs_code6").toUpperCase();
            String  crs_code7               =    request.getParameter("mnu_crs_code7").toUpperCase();       
            String  crs_code8               =    request.getParameter("mnu_crs_code8").toUpperCase();
            String  crs_code9               =    request.getParameter("mnu_crs_code9").toUpperCase();
            String  crs_code10              =    request.getParameter("mnu_crs_code10").toUpperCase();      

            int        qty                  =    Integer.parseInt(request.getParameter("txt_no_of_set"));   
            int        qty2                 =    Integer.parseInt(request.getParameter("txt_no_of_set2"));      
            int        qty3                 =    Integer.parseInt(request.getParameter("txt_no_of_set3"));  
            int        qty4                 =    Integer.parseInt(request.getParameter("txt_no_of_set4"));  
            int        qty5                 =    Integer.parseInt(request.getParameter("txt_no_of_set5"));  
            int        qty6                 =    Integer.parseInt(request.getParameter("txt_no_of_set6"));  
            int        qty7                 =    Integer.parseInt(request.getParameter("txt_no_of_set7"));  
            int        qty8                 =    Integer.parseInt(request.getParameter("txt_no_of_set8"));  
            int        qty9                 =    Integer.parseInt(request.getParameter("txt_no_of_set9"));  
            int       qty10                 =    Integer.parseInt(request.getParameter("txt_no_of_set10"));         

            String  medium              =    request.getParameter("txt_medium").toUpperCase();
            String  date                =    request.getParameter("txt_date").toUpperCase();
            String currentSession      =    request.getParameter("txt_session").toLowerCase();
            String receiptType             =    request.getParameter("receipt_type");
            System.out.println("fields from From_student.jsp received Successfully");
            String message = null;    
            String regionalCenterCode = (String)session.getAttribute("rc");
            int index = 0, flag = 0;
            if(!crs_code.equals("NONE")) {
                index++;
            }
        
            if(!crs_code2.equals("NONE")) {
                index++; 
            }
            if(!crs_code3.equals("NONE")) {
                index++;
            }
            if(!crs_code4.equals("NONE")) {
                index++;
            }
        
            if(!crs_code5.equals("NONE")) {
                index++;
            }
            if(!crs_code6.equals("NONE")) {
                index++;
            }
            if(!crs_code7.equals("NONE")) {
                index++;
            }
            if(!crs_code8.equals("NONE")) {
                index++;
            }
            if(!crs_code9.equals("NONE")) {
                index++;
            }
            if(!crs_code10.equals("NONE")) {
                index++;
            }
            String courses[]        =   new String[index];
            int qtys[]              =   new int[index];         
            int insert              =   0;
            if(!crs_code.equals("NONE")) {
                courses[insert]=crs_code;
                qtys[insert]=qty;       
                insert++;
            }
            if(!crs_code2.equals("NONE")) {
                courses[insert]=crs_code2;
                qtys[insert]=qty2;              
                insert++;
            }
            if(!crs_code3.equals("NONE")) {
                courses[insert]=crs_code3;
                qtys[insert]=qty3;              
                insert++;
            }
            if(!crs_code4.equals("NONE")) {
                courses[insert]=crs_code4;
                qtys[insert]=qty4;              
                insert++;
            }
            if(!crs_code5.equals("NONE")) {
                courses[insert]=crs_code5;
                qtys[insert]=qty5;              
                insert++;
            }
            if(!crs_code6.equals("NONE")) {
                courses[insert]=crs_code6;
                qtys[insert]=qty6;              
                insert++;
            }
            if(!crs_code7.equals("NONE"))   
    {
        courses[insert]=crs_code7;
        qtys[insert]=qty7;              
        insert++;
    }
    if(!crs_code8.equals("NONE"))   
    {
        courses[insert]=crs_code8;
        qtys[insert]=qty8;              
        insert++;
    }
    if(!crs_code9.equals("NONE"))   
    {
        courses[insert]=crs_code9;
        qtys[insert]=qty9;              
        insert++;
    }
    if(!crs_code10.equals("NONE"))  
    {
        courses[insert]=crs_code10;
        qtys[insert]=qty10;             
        insert++;
    }
    int[] no_of_blocks=new int[index];
    int blk_count=0;
    ResultSet first=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
    ResultSet block=null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
    response.setContentType("text/html");
try
{
    Connection con=connections.ConnectionProvider.conn();
    Statement stmt=con.createStatement();
    if(receiptType.equals("complete"))
    {
    int result=5,result1=5;
    /*checking*/
    message="Entry Already Exist for Enrollment No "+enrno+" for Course: <br/>";
    String[] blocks=new String[0];
    for(int i=0;i<courses.length;i++)
    {
        block=stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
        while(block.next())
        {
            blk_count=block.getInt(1);
        }
        no_of_blocks[i]=blk_count;
        blocks=new String[blk_count];
        int count=0;
        for(int j=0;j<blk_count;j++)
        {
            count=j+1;
            blocks[j]="B"+count;
        first=stmt.executeQuery("select * from student_receive_"+currentSession+"_"+regionalCenterCode+" where enrno='"+enrno+"' and crs_code='"+courses[i]+"' and block='"+blocks[j]+"'");
            if(first.next())
            {   
                flag=1;
//              System.out.println("Entry Already Exist for Course "+courses[i]+" Block "+blocks[j]+" for Enrollment No. "+enrno+"");   
    //          System.out.println(""+courses[i]+" ne wapas bheja");
                message=message+courses[i]+" Block "+blocks[j]+"<br/>";                     
            }//end of if first
        }//end of inner for loop
    }//end of outer for loop    

/*ends checking*/   
String bbb="B";
/*LOGIC FOR INSERTING THE MATERIAL INTO RECEIVE DATABASE IF FLAG==0 MEANS DUPLICATE ENTRY NOT FOUND ALREADY*/
    if(flag==0)
    {
        message="Received Successfully from STUDENT Course<br/>";
        for(int i=0;i<courses.length;i++)
        {
            int count=0;
            for(int j=0;j<no_of_blocks[i];j++)
            {
                count=j+1;
                blocks=new String[no_of_blocks[i]];
                blocks[j]="B"+count;
                message=message+courses[i]+" Block "+blocks[j]+" for date "+date+" in medium "+medium+"<br/>";
            }//end of inner for loop of j
            System.out.println("Received Succesfully from STUDENT: "+enrno+" Course code "+courses[i]+"");
        }//end of outer for loop of i
        
        request.setAttribute("msg",message);
        request.getRequestDispatcher("jsp/From_student.jsp").forward(request,response);  
    }//end of if(flag==0)
    else
    {
        request.setAttribute("msg",message);
        request.getRequestDispatcher("jsp/From_student.jsp").forward(request,response);
    }
    }//end of if(receipt_type==complete)
    /*IF PARTIAL RECEIPT OF MATERIAL DEMANDED BY THE CLIENT THEN THIS SECTION WILL WORK*/
    if(receiptType.equals("partial"))
    {
    message="Welcome to The Partial Receipt of Materials from "+name+".<br/>";
        for(int i=0;i<courses.length;i++)
        {
            block=stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
            while(block.next())
            {
                blk_count=block.getInt(1);
            }
            no_of_blocks[i]=blk_count;
        }//end of for loop of i
        request.setAttribute("enrno",enrno);//sending the enrolment no of the student entered by the user
        request.setAttribute("name",name);//sending the name of the student entered by the user
        request.setAttribute("prg_code",prg_code);//sending the programme code selected by the user
        request.setAttribute("courses",courses);//sending the courses selected by the user
        request.setAttribute("qtys",qtys);//sending the no of sets selected for the courses in the first page to the next page
        request.setAttribute("no_of_blocks",no_of_blocks);//sending no of blocks of courses selected by the user
        request.setAttribute("current_session",currentSession);//sending the value of the current session of the RC
        request.setAttribute("medium",medium);//sending the value of the medium selected by the user
        request.setAttribute("date",date);//sending the value of the date selected by the user
        request.setAttribute("msg",message);//sending the output message to the browser
        request.getRequestDispatcher("jsp/From_student1.jsp").forward(request,response);        
    }//end of if(receipt_type==partial)
}//end of try
catch(Exception ex)
{
        System.out.println("exception mila rey from From_student page"+ex);
        message="Some Serious Exception Came.Please check on the Server Console for more details";
        request.setAttribute("msg",message);
        request.getRequestDispatcher("jsp/From_student.jsp").forward(request,response); 
}//end of catch blocks
finally{}//end of finally blocks
}//end of else of session checking
}//enf of method doGet 
public void destroy() { }
}//end of class RECEIVESTUDENT