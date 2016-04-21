package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING THOSE STUDY MATERIAL WHICH ARE RETURNED BY THE POSTAL DEPARTMENT.THIS SERVLET DELETES THE ENTRY FROM THE STUDENT DESPATCH TABLE,INSERT THE ENTRY INTO THE STUDENT RECEIVE TABLE AND ALSO UPDATES THE MATERIAL INVENTORY TABLE.
CALLED JSP:-From_post1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;  
import javax.servlet.*;
import javax.servlet.http.*;
 
public class POSTRETURNSUBMIT extends HttpServlet 
{
	String current_session="";
public void init(ServletConfig config) throws ServletException 
{
  super.init(config);  
  System.out.println("POSTRETURNSUBMIT SERVLET STARTED.....");
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
		String pg_flag					=	request.getParameter("pg_flag").toUpperCase();
		String course_flag				=	request.getParameter("course_flag").toUpperCase();
		String enrno					=	request.getParameter("text_enr").toUpperCase();
		String name						=	request.getParameter("text_name").toUpperCase();
		String prg_code					=	request.getParameter("text_prg_code").toUpperCase();
		String current_session			= 	request.getParameter("txt_session").toLowerCase();
		String date						=	request.getParameter("txt_date").toUpperCase();
		String receive_remarks			=	request.getParameter("txt_reason").toUpperCase();		
		String receive_source			=	"BY POST";		
		String[] course					=	new String[0];
		if(course_flag.equals("YES"))
		{
			course					=	request.getParameterValues("crs_code");//all the course codes from the jsp page
		}
		String msg						=	"";	
		String express_no				=	null;	
		String dispatch_date			=	null;		
		String medium					=	null;		
		System.out.println("All the Parameters Received Successfully");
		int block_count					=	0;//int variable for number of blocks available with the course
		int count						=	0;//int variable for multiple use
		String[] temp					=	new String[0];//array of String for multiple use
		int crs_select=0;//variable used to store number of courses selected to be dispatched
		int index						=		0;
		String pg_value=null;
		/*logic for getting the number of total courses selected by user*/
		System.out.println("Value of course_flag is "+course_flag);
		if(course_flag.equals("YES"))
		{
			for(index=0;index<course.length;index++)
			{
				temp		=	 request.getParameterValues(course[index]);
				if(temp!=null)
				{ 
					crs_select++;
					block_count=block_count+temp.length;
				}
			}//end of loop for int c
		}//END OF if(course_flag=="YES")
		/*logic ends here*/
					
char year;
String dispatch_mode=null;
int result=0,result1=0,result2=0;
int pg_result=0,pg_result1=0,pg_result2=0;

	String rc_code=(String)session.getAttribute("rc");
			response.setContentType("text/html");
			ResultSet rs=null;
	String actual_prg_code="(crs_code='"+prg_code+"'";
try
	{
		Connection con=connections.ConnectionProvider.conn();
		Statement stmt=con.createStatement();
/*LOGIC FOR GETTING THE ACTUAL PROGRAMME CODE OF THE IGNOU DATABASE IF THIS IS NOT THE ACTUAL CODE*/		
	rs	=	stmt.executeQuery("select * from program where prg_code='"+prg_code+"'");
	if(!rs.next())
	{
		rs	=	stmt.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
		if(rs.next())
		actual_prg_code=actual_prg_code+" or crs_code='"+rs.getString(1)+"'";
	}
	actual_prg_code=actual_prg_code+")";
	System.out.println("value of actual_prg_code is "+actual_prg_code);
/*LOGIC ENDS FRO GETTING THE ACTUAL PROGRAMME CODE*/
/*LOGIC FOR SUBMITTING THE ENTRY OF PROGRAMME GUIDE*/		
	if(pg_flag.equals("YES"))
	pg_value=request.getParameter("pg_checkbox");
	if(pg_flag.equals("YES") && pg_value!=null )
	{
		String pg_express=request.getParameter("pg_express").toUpperCase();
		String pg_date=request.getParameter("pg_date").toUpperCase();
		String pg_medium=request.getParameter("pg_medium").toUpperCase();
	
		pg_result=stmt.executeUpdate("insert into student_receive_"+current_session+"_"+rc_code+" values('"+enrno+"','"+prg_code+"','"+prg_code+"','PG',1,'"+pg_medium+"','"+date+"','"+receive_source+"','"+receive_remarks+"','"+pg_express+"','"+pg_date+"')");   
		pg_result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty+1 where "+actual_prg_code+" and block='PG' and medium='"+pg_medium+"'");
		pg_result2=stmt.executeUpdate("delete from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and "+actual_prg_code+" and block='PG' and dispatch_source='BY POST' and express_no='"+pg_express+"'");
			if(pg_result>0 && pg_result1>0 && pg_result2>0)
			{
				msg="Material of Programme Guide Updated successfully Returned from Post for "+prg_code+ " <br/> Roll No."+enrno+"<br/>Name. "+name+"<br/>";
			}
			else
			{
				msg="Failed to perform Update the PG.<br/>Please Check on the Server Console or Database";
			}
	}//end of if(pg_flag.equals("YES") && pg_value!=null )	
/*LOGIC ENDS HERE FOR PORGRAMME GUIDE*/				
		if (course.length>0)//course != null )
		{
			System.out.println(course.length +" Courses Selected By the Student");
					/*logic for getting all the courses selected by the user*/
			if (block_count != 0) 
			{
			for(index=0;index<course.length;index++)
			{
				String[] course_block=	 request.getParameterValues(course[index]);
				if(course_block!=null)
				{
					int len=course[index].length();
					for(int e=0;e<course_block.length;e++)
					{
						express_no=request.getParameter(course_block[e]);
						dispatch_date=request.getParameter(course_block[e]+"D");
						medium=request.getParameter(course_block[e]+"M");
						String course_check=course_block[e].substring(0,len);
						String block_check=course_block[e].substring(len);
						String initial=block_check.substring(0,1);
						if(course[index].trim().equals(course_check))
						{
							if(initial.trim().equals("B"))
							{
								result+=stmt.executeUpdate("insert into student_receive_"+current_session+"_"+rc_code+" values('"+enrno+"','"+prg_code+"','"+course[index]+"','"+block_check+"',1,'"+medium+"','"+date+"','"+receive_source+"','"+receive_remarks+"','"+express_no+"','"+dispatch_date+"')");   
								result1+=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty+1 where crs_code='"+course[index]+"' and block='"+block_check+"' and medium='"+medium+"'");
								result2+=stmt.executeUpdate("delete from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and crs_code='"+course[index]+"' and block='"+block_check+"' and dispatch_source='BY POST' and medium='"+medium+"' and express_no='"+express_no+"'");
							}//end of if(initial.trim().equals("B"))
						}//end of if(course[index].trim().equals(course_check))
					}//end of for loop of e
				}//end of if(course_block!=null)
			}//end of for loop 
			}//end of if (block_count != 0) 
	/*logic ends here*/
			if(result==block_count && result1==block_count && result2==block_count)
			{
				msg=msg+"Material Updated Successfully Returned from Post for "+block_count+" Blocks <br/> Roll No."+enrno+"<br/>Name. "+name+"<br/>";
			}
			else
			{
				msg=msg+"Failed to Perform Update Command for Blocks.<br/>Please Check on the Server Console or Database";
			}
			request.setAttribute("msg",msg);			
			request.getRequestDispatcher("jsp/From_post.jsp").forward(request,response);					
		}//end of if (course != null) 
		else if(pg_flag.equals("YES") && pg_value!=null )
		{
			request.setAttribute("msg",msg);			
			request.getRequestDispatcher("jsp/From_post.jsp").forward(request,response);			
		}//end of else if
		else
		{
			System.out.println("Please Select Course code to be Received First");
			msg="Please Select Course Code For Receive First";
			request.setAttribute("alternate_msg",msg);
			request.getRequestDispatcher("POSTRETURNSEARCH?txt_enr="+enrno+"").forward(request,response);
		}//end of else
	}//end of try blocks
	catch(Exception ex)
	{
		System.out.println("exception mila rey from From_post.jsp "+ex);
		msg="Some Serious Exception Hitted the page. Please check on Server Console for Details";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_post.jsp").forward(request,response);
	}
	finally{}//end of finally blocks
}//end of else of session checking
}//end of method doGet()
public void destroy() {}
}//end of class POSTRETURNSUBMIT