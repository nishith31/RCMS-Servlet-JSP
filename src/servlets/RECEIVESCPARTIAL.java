package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING STUDY MATERAILS FROM STUDY CENTRES ON PARTIAL MODE MEANS DIFFERENT QUANTITIES FOR 
THE DIFFERENT BLOCKS OF THE COURSES.BEFORE INSERTING DATA TO SC RECEIVE TABLE AND UPDATING INVENTORY IN MATERIAL TABLE OF RC
THIS SERVLET CHECKS THE PRIMARY KEY VIOLATION CONDITION FIRST AND IF NO VIOLATION OF PRIMARY KEY FOUND THEN ALLOW TO INSERT
AND UPDATE DATA TO THE REQUIRED TABLES.TAKES SC CODE,PROGRAMME CODE,COURSE CODE,QUANTITIES,MEDIUM AND DATE AS INPUT AND
SENDS APPROPRIATE OUTPUT TO THE RESULTANT PAGE.
CALLED JSP:-From_sc1.jsp*/
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
public class RECEIVESCPARTIAL extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYHANDFIRSTSUBMIT SERVLET STARTED TO EXECUTE");
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
    String currentSession  =    request.getParameter("txt_session").toLowerCase();//getting the value of current session
    String studyCenterCode          =    request.getParameter("mnu_sc_code").toUpperCase();//gettting the prgram code
    String programmeCode         =    request.getParameter("mnu_prg_code").toUpperCase();//gettting the prgram code
    String[] course         =    request.getParameterValues("crs_code");//all the course codes from the jsp page
    int block_count         =    0;//int variable for number of blocks available with the course
    int count               =    0;//int variable for multiple use
    String[] temp           =    new String[0];//array of String for multiple use
    int crs_select=0;//variable used to store number of courses selected to be dispatched
    int index               =       0;
    /*logic for getting the number of total courses selected by user*/
    for(index=0;index<course.length;index++)
    {
        temp        =    request.getParameterValues(course[index]);
        if(temp!=null)
        {
            crs_select++;
            block_count=block_count+temp.length;
        }
    }//end of loop for int c
    /*logic ends here*/
    String[] course_dispatch    =    new String[block_count];//array for holding the blocks to be receieved
    String[] blk_qty            =    new String[block_count];//array for holding the quantity of the blocks to be received
    /*logic for getting all the courses selected by the user*/
    for(index=0;index<course.length;index++)
    {
        String[] course_block=   request.getParameterValues(course[index]);
        if(course_block!=null)
        {
            int len=course_block.length;
            for(int e=0;e<len;e++)
            {
                course_dispatch[count]=course_block[e];
                blk_qty[count]=request.getParameter(course_block[e]);
                count++;
            }//end of for loop of e
        }//end of if(course_block!=null)
    }//end of for loop of index
    /*logic ends here*/
    
    String medium           =    request.getParameter("txt_medium").toUpperCase();//getting the medium selected by the user
    String date             =    request.getParameter("txt_date").toUpperCase();//date from the jsp page date field
    int qty=0,actual_qty=0,flag_for_return=0;
    ResultSet rs            =   null;
    System.out.println("All the Parameters received");
    request.setAttribute("current_session",currentSession);//setting the value of current session to the request
    String msg="";  
    String rc_code=(String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
    response.setContentType("text/html");
try
{
    Connection con=connections.ConnectionProvider.conn();//creating the connection object for the database
    Statement stmt=con.createStatement();//fetching the refernce of the statement from the connection object.
    int result=5,result1=5;
    if (block_count != 0) 
    {
        qty=block_count;
        msg="Entry Already Exist for Course: <br/>";
        for(int z=0;z<course.length;z++)
        {
            int len=course[z].length();
            for(int y=0;y<course_dispatch.length;y++)
            {
                String course_check =course_dispatch[y].substring(0,len);
                String block_check  =course_dispatch[y].substring(len);
                String initial      =block_check.substring(0,1);
                if(course[z].equals(course_check))
                {
                    if(initial.equals("B"))
                    {
                        rs=stmt.executeQuery("select * from sc_receive_"+currentSession+"_"+rc_code+" where sc_code='"+studyCenterCode+"' and crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"' and date='"+date+"'");
                        if(rs.next())
                        {
                            msg=msg+course[z]+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
                            flag_for_return=1;
                        }//end of if
                    }//end of if(initial.equals("B"))
                }//end of if(course[z].equals(course_check))
            }//end of for loop of y
        }//end of for loop z
/*LOGIC FOR RECEIVING OF MATERIAL IF SELECTED COURSE AND QUANTITY DOESN'T CONFLICT WITH THE PRIMARY KEY*/       
        if(flag_for_return==0)
        {
            msg="Received Successfully from SC Course <br/>";
            int inc=0;
            for(int z=0;z<course.length;z++)
            {
                int len=course[z].length();
                for(int y=0;y<course_dispatch.length;y++)
                {
                    String course_check=course_dispatch[y].substring(0,len);
                    String block_check=course_dispatch[y].substring(len);
                    String initial=block_check.substring(0,1);
                    if(course[z].equals(course_check))
                    {
                        if(initial.equals("B"))
                        {
                            result=stmt.executeUpdate("insert into sc_receive_"+currentSession+"_"+rc_code+"(sc_code,crs_code,block,qty,medium,date)values('"+studyCenterCode+"','"+course[z]+"','"+block_check+"',"+blk_qty[inc]+",'"+medium+"','"+date+"')");   
                            result1=stmt.executeUpdate("update material_"+currentSession+"_"+rc_code+" set qty=qty+"+blk_qty[inc]+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
                            msg=msg+course[z]+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
                            inc++;
                        }//end of if(initial.equals("B"))
                    }//end of if(course[z].equals(course_check))
                }//end of for loop of y
            }//end of for loop z    
        if(result==1 && result1==1)
        {   
            System.out.println("Materials for "+course.length+" courses received from SC");   
        }
        else if(result==1 && result1 !=1)
        {
            System.out.println("Receive table hitted but material table not affected..!!!!!");   
        }
        else
        {
            System.out.println("NO operation performed.!!!!!");   
        }
        request.setAttribute("msg",msg);//SENDING MESSAGE VARIABLE TO THE RESULTANT PAGE
        request.getRequestDispatcher("jsp/From_sc.jsp").forward(request,response);          
    }//end of if(flag_for_return=0)
    else//if material is out of stock then this section will work and give message to the user
    {
        request.setAttribute("msg",msg);
        request.getRequestDispatcher("jsp/From_sc.jsp").forward(request,response);
    }//end of else of if(flag_for_return==0)
    }//end of if(block_count!=null)
    else//if no course selected by the user found then this section will work
    {
        System.out.println("Sorry !!Not any courses Selected...");
        msg="Sorry!! Not any courses selected..";
        request.setAttribute("alternate_msg",msg);
        request.getRequestDispatcher("jsp/From_sc.jsp").forward(request,response);
    }//end of else of if(block_count!=null)
}//end of try blocks
catch(Exception exe)
{
    System.out.println("exception mila rey from RECEIVERCPARTIAL.java and exception is "+exe);
    msg="Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
    request.setAttribute("msg",msg);
    request.getRequestDispatcher("jsp/From_sc.jsp").forward(request,response);
}//end of catch blocks
finally{} //end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class RECEIVEMPDDPARTIAL