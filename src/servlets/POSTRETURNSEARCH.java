package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE PERSONAL DETAILS AND DESPATCH DETAILS OF THE STUDENT WHOSE ROLL NO HAS BEEN ENTERED IN THE BROWSER,
 * IF NO DESPATCH DETAILS FOUND THEN REDIRECTS TO THE SAME PAGE AND IF DETAILS FOUND THEN REDIRECTS TO THE FROM_POST1.JSP FROM WHERE RECEVING WILL BE STARTED.
CALLED JPS:-From_post.jsp*/
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
 
public class POSTRETURNSEARCH extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    String currentSession="";
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("POSTRETURNSEARCH SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session=request.getSession(false);//getting and checking the availability of session of java
    if(session==null) {
        String msg="Please Login to Access MDU System";
        request.setAttribute("msg",msg);
        request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
    } else {
        String enrno    =    request.getParameter("txt_enr");//getting the enrolment number of the student from the browser
        String msg=null;    
        String prog=null;
        String name=null;
        char year;
        String medium=null; 
        String date=null;   
        String dispatchMode = null;
        int index=0;
        String      pg_flag=null,pg_date=null,pg_madhyam=null,pg_challan_number=null,pg_packet_type=null,pg_parcel_number=null;
        String      course_flag=null;
        
        String rc_code=(String)session.getAttribute("rc");
        response.setContentType(Constants.HEADER_TYPE_HTML);
        try {
            Connection con=connections.ConnectionProvider.conn();
            Statement stmt=con.createStatement();
            /*logic for getting the value of the current session of the RC*/
            ResultSet rs=stmt.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
            while(rs.next())
            currentSession = rs.getString(1).toLowerCase();
            request.setAttribute("current_session",currentSession);        
            /*logic ends here for getting the value of the current session*/
            /*LOGIC FOR CHECKING THE DESPATCH OF PROGRAMME GUIDE TO THE STUDENT*/
            rs=stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block='PG' and dispatch_source='BY POST'");
            if(rs.next()) {
                pg_flag             =   Constants.YES;
                pg_date             =   rs.getDate(6).toString();
                pg_madhyam          =   rs.getString(8);
                pg_challan_number   =   rs.getString(9);
                pg_packet_type      =   rs.getString(11);
                pg_parcel_number    =   rs.getString(14).trim();                
                    request.setAttribute("pg_date",pg_date);        
                request.setAttribute("pg_madhyam",pg_madhyam);      
                request.setAttribute("pg_challan_number",pg_challan_number);        
                request.setAttribute("pg_packet_type",pg_packet_type);      
                request.setAttribute("pg_parcel_number",pg_parcel_number);          
            } else {
                pg_flag = Constants.NO;
            }
            request.setAttribute("pg_flag",pg_flag);        
            /*LOGIC ENDS HERE FOR CHECKING THE DESPATCH OF PROGRAMME GUIDE*/
            rs=stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and dispatch_source='BY POST'");
            int len=0;
            if(rs.next()) {
                course_flag="YES";
                request.setAttribute("course_flag",course_flag);        
                rs=stmt.executeQuery("select * from student_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"'");
                while(rs.next()) {   
                    prog = rs.getString(2);         
                    char pr[]=prog.toCharArray();
                        for(int ii=0;ii<pr.length;ii++)
                        {
                            if(pr[ii]!=' ')
                            len++;
                        }//end of for loop
                if(pr[len-1]=='1' || pr[len-1]=='2'|| pr[len-1]=='3'|| pr[len-1]=='4'|| pr[len-1]=='5'|| pr[len-1]=='6') 
                {
                    prog=prog.substring(0,len-1);
                    year=pr[len-1];
                }//end of if    
                else
                {
                    year='1';
                    prog=prog;
                }//end of else      
                name=rs.getString(5);
                medium=rs.getString(7);
                int course_number=0;
            }//end of while loop
                int dispatch_course_count=0;
                rs=stmt.executeQuery("select count(distinct(crs_code)) from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and dispatch_source='BY POST'");
                while(rs.next())
                {
                    dispatch_course_count=rs.getInt(1);
                }
            String course_dispatch[]        =   new String[dispatch_course_count];
            rs=stmt.executeQuery("select distinct(crs_code) from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and dispatch_source='BY POST'");
            index=0;
            while(rs.next())
            {
                course_dispatch[index]      =   rs.getString(1);
                index++;
            }
            index=0;
            rs=stmt.executeQuery("select count(*) from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and dispatch_source='BY POST'");
                while(rs.next())
                {
                    index=rs.getInt(1);
                }//index++;
            String[] course_block       =   new String[index];
            String date_dispatch[]      =   new String[index];
            String madhyam[]            =   new String[index];
            String challan_number[]     =   new String[index];
            String packet_type[]        =   new String[index];
            String parcel_number[]      =   new String[index];                      
            rs=stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and dispatch_source='BY POST'");
            index=0;
            while(rs.next())
            {
                course_block[index]         =   rs.getString(3).trim()+rs.getString(4).trim();
                date_dispatch[index]        =   rs.getDate(6).toString();
                madhyam[index]              =   rs.getString(8);
                challan_number[index]       =   rs.getString(9);
                packet_type[index]          =   rs.getString(11);
                parcel_number[index]        =   rs.getString(14).trim();                
                index++;            
            }//end of while loop
            try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
            if(msg==null)
            msg=" ";
                msg=msg+"<br/>Found "+dispatch_course_count+" Course for <br/>Roll No: "+enrno+"<br/>Name: "+name+".";
            request.setAttribute("msg",msg);
            request.setAttribute("course_dispatch",course_dispatch);
            request.setAttribute("course_block",course_block);
            request.setAttribute("date_dispatch",date_dispatch);
            request.setAttribute("medium",madhyam);
            request.setAttribute("challan_number",challan_number);
            request.setAttribute("packet_type",packet_type);
            request.setAttribute("parcel_number",parcel_number);
            request.getRequestDispatcher("jsp/From_post1.jsp?name="+name+"&enrno="+enrno+"&prg_code="+prog+"&medium="+medium+"").forward(request,response); 
        }//end of if    
        else if(pg_flag=="YES")
        {
            course_flag="NO";       
            request.setAttribute("course_flag",course_flag);
            rs=stmt.executeQuery("select * from student_"+currentSession+"_"+rc_code+" where enrno='"+enrno+"'");
            while(rs.next())
            {   prog = rs.getString(2);         
                char pr[]=prog.toCharArray();
                        for(int ii=0;ii<pr.length;ii++)
                        {
                            if(pr[ii]!=' ')
                            len++;
                        }//end of for loop
                if(pr[len-1]=='1' || pr[len-1]=='2'|| pr[len-1]=='3'|| pr[len-1]=='4'|| pr[len-1]=='5'|| pr[len-1]=='6') 
                {
                    prog=prog.substring(0,len-1);
                    year=pr[len-1];
                }//end of if    
                else
                {
                    year='1';
                    prog=prog;
                }//end of else      
                name=rs.getString(5);
                medium=rs.getString(7);
                System.out.println(name+" "+prog+" "+len);
                int course_number=0;
            }//end of while loop
            System.out.println("Sorry!! ONLY PROGRAMME GUIDE FOUND DESPATCHED VIA POST.");
            msg="Despatch of Programme Guide Found for the Roll no..";
            request.setAttribute("msg",msg);
            request.getRequestDispatcher("jsp/From_post1.jsp?name="+name+"&enrno="+enrno+"&prg_code="+prog+"&medium="+medium+"").forward(request,response); 
        }//end of else if()
        else
        {
            System.out.println("Sorry!! Roll No not found please contact to registration department..Thank you.");
            msg="Sorry!! Roll Number not Found.<br/>Please check Details in the Despatch<br/> Database. Thank You..";
            request.setAttribute("msg",msg);
            request.getRequestDispatcher("jsp/From_post.jsp").forward(request,response); 
        }//end of else of first if

    }//end of try blocks
    catch(Exception ex)
    {
        System.out.println("exception mila rey from From_post.jsp "+ex);
        msg="Some Serious Exception Hitted the page.<br/> Please check on Server Console for Details";
        request.setAttribute("msg",msg);
        request.getRequestDispatcher("jsp/From_post.jsp").forward(request,response);
    }//end of catch blocks
    finally{}//end of finally blocks
}//end of else of session checking
}//end of method doGet()
public void destroy() {}
}//end of class POSTRETURNSEARCH