package servlets;
/*This Servlet is Responsible for inserting data to student Despatch table and updating material table.It also checks the violation of primary key means duplicate data can not be enter in the student Despatch table.This servlet gets all the required fields from the browser and after checking all the constraints insert and update the corresponding tables*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYHANDFIRSTSUBMIT extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("BYHANDFIRSTSUBMIT SERVLET STARTED TO EXECUTE");
} 
 
public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
	HttpSession session=request.getSession(false);//getting the reference of the session of the system to the session variable
	if(session==null)
	{
		String msg="Please Login to Access MDU System";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
	}
	else
	{
	String enrno			=	 request.getParameter("text_enr").toUpperCase();//getting the enrolment number of student
	String name				=	 request.getParameter("text_name").toUpperCase();//getting the name of the student
	String current_session	=	 request.getParameter("text_session").toLowerCase();//getting the value of current session
	String prg_code			= 	 request.getParameter("text_prog_code").toUpperCase();//gettting the prgram code
	String year				=	 request.getParameter("text_year");//getting the year or semester code
	String[] course			=	 request.getParameterValues("crs_code");//all the course codes from the jsp page
	int block_count			=	 0;//int variable for number of blocks available with the course
	int count				=	 0;//int variable for multiple use
	String[] temp			=	 new String[0];//array of String for multiple use
	int crs_select=0;//variable used to store number of courses selected to be Despatched
	int index				=		0;
	/*logic for getting the number of total courses selected by user*/
	for(index=0;index<course.length;index++)
	{
		temp		=	 request.getParameterValues(course[index]);
		if(temp!=null)
		{
			crs_select++;
			block_count=block_count+temp.length;
		}
	}//end of loop for int c
	/*logic ends here*/
	String[] course_dispatch	=	 new String[block_count];//array for holding the courses to be Despatched
	/*logic for getting all the courses selected by the user*/
	for(index=0;index<course.length;index++)
	{
		String[] course_block=	 request.getParameterValues(course[index]);
		if(course_block!=null)
		{
			int len=course_block.length;
			for(int e=0;e<len;e++)
			{
				course_dispatch[count]=course_block[e];
				count++;
			}
		}
	}
	/*logic ends here*/
	String pg_flag			=	 request.getParameter("pg_flag");//getting the year or semester code	
	String pg_value			=	null;
	if(pg_flag.equals("NO"))
	pg_value=request.getParameter("program_guide");
	String medium			= 	 request.getParameter("text_medium").toUpperCase();
	String date				= 	 request.getParameter("text_date").toUpperCase();//date from the jsp page date field
	String remarks			= 	 request.getParameter("text_remarks").toUpperCase();//remarks from the jsp page remarks field
	String dispatch_source	=	"BY HAND";//for the Despatch source field of the student_Despatch table for post it is BY POST AND BY SC for study centre Despatch moce
	String reentry_msg		=	"NO";
	int qty					=		0;
	int actual_qty			=		0;
	int flag_for_pg			= 		0;
	int flag_for_return		=		0;
	String relative_course	=	null;
	ResultSet rs			=	null;
	ResultSet rs1			=	null;
	System.out.println("All the Parameters received");
		request.setAttribute("current_session",current_session);//setting the value of current session to the request
	String msg="";	

	String rc_code=(String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system

		response.setContentType("tex-t/html");
		PrintWriter out=response.getWriter();
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the connection object for the database
	Statement stmt=con.createStatement();//fetching the refernce of the statement from the connection object.
	int result=5,result1=5;
/*logic of getting the ABSOLUTE PROGRAMME CODE*/
	String[] relative_prg_code=new String[0];
	rs	=	stmt.executeQuery("select count(*) from program_program where relative_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
		if(rs.next())
		relative_prg_code=new String[rs.getInt(1)];
	index=0;
	rs	=	stmt.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
	while(rs.next())
	{
		relative_prg_code[index]=rs.getString(1);
		index++;
	}
	String search_crs_code="(crs_code='"+prg_code+"'";		
		for(index=0;index<relative_prg_code.length;index++)
			search_crs_code=search_crs_code+" or crs_code='"+relative_prg_code[index].trim()+"'";
		search_crs_code=search_crs_code+")";		
	System.out.println("value of search_crs_code "+search_crs_code);

	if(pg_flag.equals("NO") && pg_value!=null )
	{
		int o=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno+"','"+prg_code+"','"+prg_code+"','PG',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+reentry_msg+"')");   
		int p=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-1 where "+search_crs_code+" and block='PG' and medium='"+medium+"'");
		flag_for_pg=1;
	}//end of if(pg_flag.equals("NO") && pg_value!=null)					
	if (block_count != 0) 
	{
		//qty=course.length;
		qty=block_count;
		for(int z=0;z<course.length;z++)
		{
			int len=course[z].length();
			for(int y=0;y<course_dispatch.length;y++)
			{
				rs1		=	stmt .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
				if(rs1.next())
					relative_course=course[z];
				else
				{
					rs1	=	stmt.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
					while(rs1.next()) 
					relative_course=rs1.getString(1);
				}
				//System.out.println("relative Course:"+relative_course);
				String course_check	=course_dispatch[y].substring(0,len);
				String block_check	=course_dispatch[y].substring(len);
				String initial		=block_check.substring(0,1);
				if(course[z].equals(course_check))
				{
					if(initial.equals("B"))
					{
						rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+relative_course+"' and block='"+block_check+"' and medium='"+medium+"'");
						while(rs.next())
						actual_qty=rs.getInt(1);
			
						if(actual_qty<1)//if stock of any block found less than one then it increase the value of flag
						{
							flag_for_return++;
							msg=msg+" 1 set of Block "+block_check.substring(1)+" of "+course[z]+" Course.<br/>";
						}//end of if
					}//end of if(initial.equals("B"))
				}//end of if(course[z].equals(course_check))
			}//end of for loop of y
		}//end of for loop z
		if(flag_for_return==0)
		{
			for(int z=0;z<course.length;z++)
			{
				int len=course[z].length();
				for(int y=0;y<course_dispatch.length;y++)
				{
					rs1		=	stmt .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
					if(rs1.next())
					relative_course=course[z];
					else
					{
						rs1	=	stmt.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
						while(rs1.next()) 
						relative_course=rs1.getString(1);
					}
					String course_check=course_dispatch[y].substring(0,len);
					String block_check=course_dispatch[y].substring(len);
					String initial=block_check.substring(0,1);
					if(course[z].equals(course_check))
					{
						if(initial.equals("B"))
						{
							result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno+"','"+prg_code+"','"+course[z]+"','"+block_check+"',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+reentry_msg+"')");   
							result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-1 where crs_code='"+relative_course+"' and block='"+block_check+"' and medium='"+medium+"'");
						}//end of if(initial.equals("B"))
					}//end of if(course[z].equals(course_check))
				}//end of for loop of y
			}//end of for loop z	
		if(result==1 && result1==1)
		{	
			System.out.println("Materials for "+course.length+" courses given to "+name+"");   
			msg=""+course_dispatch.length+" Books Despatched to "+name+".";
		}
		else if(result==1 && result1 !=1)
		{
			System.out.println("Despatch table hitted but material table not affected..!!!!!");   
			msg="Despatch table Hitted but material Table not Affected!!!";
		}
		else
		{
			System.out.println("NO operation performed.!!!!!");   			
			msg="No Operation Performed..!!";
		}
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);						
	}//end of if(flag_for_return=0)
	else//if material is out of stock then this section will work and give message to the user
	{
		System.out.println("Sorry Material out of stock for "+flag_for_return+" Courses.");
		String supplementary_msg="Sorry Can not Despatch<br/>";
		msg=supplementary_msg+msg+"As Not Available in Stock.";//message for the browser
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYE?txt_enr="+enrno+"").forward(request,response);//redirecting to the BYE servlet again
	}//end of else of if(flag_for_return==0)
	}//end of if(block_count!=null)
	else if (block_count == 0 && flag_for_pg == 1)
	{
		System.out.println("Program guide successfully despatched...");
		msg="Program guide successfully despatched to "+enrno+"";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);			
	}//end of else of if(block_count!=null)
	else 
	{
		System.out.println("Sorry !!Not any courses Selected...");
		msg="Sorry!! Not any courses selected..";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYE?txt_enr="+enrno+"").forward(request,response);
	}//end of else of if(block_count!=null)
}//end of try blocks
catch(Exception exe)
{	
	System.out.println("exception mila rey from BYHANDFIRSTSUBMIT.java and exception is "+exe);
	msg="Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);
}//end of catch blocks
finally
{
} //end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class BYHANDFIRSTSUBMIT