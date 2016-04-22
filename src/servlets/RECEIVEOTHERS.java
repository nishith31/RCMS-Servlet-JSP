package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING STUDY MATERIALS FROM OTHERS WHO ARE NOT IN THE REGULAR SOURCES,
IF WE HAVE TO RECEIVE PARTIALLY THEN THIS SERVLET WILL REDIRECTS PAGE TO From_others1.jsp AND THERE IT WILL RECEIVE PARTIALLY.
CALLED JSP:-From_others.jsp*/
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
 
public class RECEIVEOTHERS extends HttpServlet {

public void init(ServletConfig config) throws ServletException 
{
        super.init(config);
        System.out.println("RECEIVEOTHERS SERVLET STARTED TO EXECUTE");
} 
 public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
    HttpSession session=request.getSession(false);//getting and checking the availability of session of java
    if(session==null)
    {
        String msg="Please Login to Access MDU System";
        request.setAttribute("msg",msg);
        request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
    }
    else
    {
/*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/    
    String  flag                =    request.getParameter("flag").toUpperCase();
    String  courseCode            =    request.getParameter("course_code").toUpperCase();
    String  newCourseCode        =    request.getParameter("new_course_code").toUpperCase(); 
    String  newCourseName        =    request.getParameter("new_course_name").toUpperCase(); 
    String currentSession      =    request.getParameter("txt_session").toLowerCase();
    String  medium              =    request.getParameter("mnu_medium").toUpperCase();
    int        qty              =    Integer.parseInt(request.getParameter("text_set"));    
    String  date                =    request.getParameter("text_date").toUpperCase();
    String receiveFrom             =    request.getParameter("receive_from").toLowerCase();
    
/*LOGIC ENDS FOR GETTING THE PARAMETERS FROM THE REQUEST*/  
    String rc_code=(String)session.getAttribute("rc");
    System.out.println("fields from others receive page successfully "+medium);
    String msg=null;    
    String query=null;
    String receipt_type         =null;
    if(flag.equals("OLD"))
    {
        query="select * from others_receive_"+currentSession+"_"+rc_code+" where crs_code='"+courseCode+"' and date='"+date+"'";
        receipt_type            =    request.getParameter("receipt_type");              
    }
    if(flag.equals("NEW"))
    query="select * from others_receive_"+currentSession+"_"+rc_code+" where crs_code='"+newCourseCode+"' and date='"+date+"'";
    
int result_material=0;
int result_receive=0,index=0,blocks=0,no=0;
String block_name="B";
ResultSet first=null,rs1=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
    response.setContentType("text/html");
    PrintWriter out=response.getWriter(); 
    int flag_for_return=0;
try
{
    Connection con=connections.ConnectionProvider.conn();
    Statement stmt=con.createStatement();
    int result=5,result1=5;
    first=stmt.executeQuery(query);
    if(flag.equals("OLD"))
    {
        if(receipt_type.equals("complete"))
        {
            msg="Entry Already Exist for Course: <br/>";
            rs1     =   stmt.executeQuery("select no_of_blocks from course where crs_code='"+courseCode+"'");
            while(rs1.next())
            blocks      =   rs1.getInt(1);
            for(index=0;index<blocks;index++)
            {
                no=index+1;
                block_name="B"+no;
                first=stmt.executeQuery("select * from others_receive_"+currentSession+"_"+rc_code+" where crs_code='"+courseCode+"' and block='"+block_name+"' and date='"+date+"'");
                System.out.println("1");        
                if(first.next())
                {
                    flag_for_return=1;
                    System.out.println("Entry Already Exist for Course "+courseCode+" block: "+block_name+" for date "+date);   
                    msg=msg+courseCode+block_name+" for date "+date+" in medium.<br/>";
                }//end of if first
            }//end of for loop of index
            if(flag_for_return==0)
            {
                msg="Received Successfully  Course <br/>";      
                for(index=0;index<blocks;index++)
                {
                    no=index+1;
                    block_name="B"+no;
                    result_receive=stmt.executeUpdate("insert into others_receive_"+currentSession+"_"+rc_code+" values('"+courseCode+"','"+block_name+"',"+qty+",'"+medium+"','"+date+"','"+receiveFrom+"')");

                    result_material=stmt.executeUpdate("update material_"+currentSession+"_"+rc_code+" set qty=qty+"+qty+" where crs_code='"+courseCode+"' and block='"+block_name+"' and medium='"+medium+"'");     
        
                    msg=msg+courseCode+block_name+" for date "+date+" in medium "+medium+"<br/>";             
                }//end of for loop of index
                request.setAttribute("msg",msg);
                request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);  
            }//end of if(flag_for_return==0)
            else//IF ENTRIES ALREADY FOUND THEN THIS ELSE WILL WORK AND GIVE MESSAGE TO THE BROWSER
            {
                request.setAttribute("msg",msg);
                request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
            }//end of else

        }
        else//redirect to the from_others1.jsp page for partial receipt
        {
            rs1     =   stmt.executeQuery("select no_of_blocks from course where crs_code='"+courseCode+"'");
            while(rs1.next())
            blocks      =   rs1.getInt(1);
            msg="Partial Receipt of Materials of Course "+courseCode;
            request.setAttribute("blocks",blocks);
            request.setAttribute("crs_code",courseCode);
            request.setAttribute("qty",qty);            
            request.setAttribute("current_session",currentSession);
            request.setAttribute("medium",medium);
            request.setAttribute("date",date);
            request.setAttribute("receive_from",receiveFrom);
                request.setAttribute("msg",msg);
                request.getRequestDispatcher("jsp/From_others1.jsp").forward(request,response);         
            //code for partial receipt of the old course materials
        }//end of else
    }//IF QUERY IS FOR OLD COURSE THEN THIS WIIL WORK
        
            
    if(flag.equals("NEW"))
    {
        msg="Entry Already Exist for Course: <br/>";
        first=stmt.executeQuery("select * from others_receive_"+currentSession+"_"+rc_code+" where crs_code='"+newCourseCode+"' and block='BLOCK' and date='"+date+"'");
        if(first.next())
        {
            flag_for_return=1;
            //System.out.println("Entry Already Exist for Course "+crs_code+" block: "+block_name+" for date "+date);   
            msg=msg+newCourseCode+" for date "+date+".<br/>";
        }//end of if first
        if(flag_for_return==0)
        {
            msg="Received Successfully  Course <br/>";      
            result_receive=stmt.executeUpdate("insert into others_receive_"+currentSession+"_"+rc_code+" values('"+newCourseCode+"','BLOCK',"+qty+",'"+medium+"','"+date+"','"+receiveFrom+"')");
            msg="Successfully received "+qty+" Sets of "+newCourseCode+".";
            System.out.println("Successfully receive materials...");
            request.setAttribute("msg",msg);
            request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);          
        }//IF QUERY IS FOR NEW COURSE THEN THIS WILL WORK
        else
        {
            System.out.println("Duplicate Records found please change the date or course code");
            msg="Entry Already exist for Course and date selected.";
            request.setAttribute("msg",msg);
            request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
        }//end of else of if(flag_for_return==0)        
    }//end of if(flag.equals("NEW"))
}//end of try
catch(Exception ex)
{
    System.out.println("exception mila rey from RECEIVEOTHERS page and exception is "+ex);
    msg="Some Serious Exception came at the page. Please check on the Server Console for More Details";
    request.setAttribute("msg",msg);
    request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
}//end of catch blocks
finally{}//end of finally blocks
}//end of else of session checking
}//end of method 
public void destroy() { }
}//end of class RECEIVEOTHERS