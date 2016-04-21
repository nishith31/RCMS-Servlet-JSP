package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE REGISTRATION DETAILS OF THE ROLL NO ENTERED BY THE USER IN THE CLIEN PAGE
AND SENDING THE DETAILS TO THE BROWSER WITH THE COURSES SELECTED BY THE USER AND THE ABAILABLE STOCK OF THOSE COURSES BLOCK
WISE AND ALSO THE STATUS OF DESPATCH OF MATERIAL TO THAT STUDENT FROM ANY OTHER MODE
CALLED JSP:-By_hand.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;  
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYE extends HttpServlet 
{
String current_session="";
public void init(ServletConfig config) throws ServletException 
{
  super.init(config);  
  System.out.println("BYE SERVLET STARTED TO EXECUTE");
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
		String rc_code=(String)session.getAttribute("rc");//getting the rc code of the logged in rc in the system
		String enrno			=	 request.getParameter("txt_enr");//variable for getting the roll no of the student
		String msg				=	"";	
		String prog				=	null;
		String name				=	null;
		char year;
		String medium			=	null;	
		String date				=	null;	
		String dispatch_mode	=	null;
		try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
		if(msg==null)
			msg=" ";
		int length=0,index=0;
			response.setContentType("text/html");
			int available_pg=0;
			String pg_flag=null,pg_date=null;
		try
		{
			Connection con=connections.ConnectionProvider.conn();
			Connection con1=connections.ConnectionProvider.conn();
			Statement stmt=con.createStatement();
			Statement stmt1=con1.createStatement();

	/*Logic for getting the current session name from the sessions table of the regional centre logged in and send to the browser*/	
	ResultSet rs=stmt.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
	while(rs.next())
	current_session=rs.getString(1).toLowerCase();
	request.setAttribute("current_session",current_session);		
/*Logic Ends here for getting the current session value from the sessions table of regional centres*/	
/*Complete Logic for fetching the details of the student from the the student database*/
	rs=stmt.executeQuery("select * from student_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'");
	if(rs.next())//if controls enter in if(rs.next()) means records exist for the roll entered in the browser
	{
		prog 			= rs.getString(2);//getting the prg_code from the table
		char pr[]		=prog.toCharArray();//converting the program to character array
		for(int ii=0;ii<pr.length;ii++)//getting the actual length of the program code fetched from the student table
		{
			if(pr[ii]!=' ')
			length++;
		}//end of for loop
		/*Logic for separating the year or semester number from the program code*/
		if(pr[length-1]=='1' || pr[length-1]=='2'|| pr[length-1]=='3'|| pr[length-1]=='4'|| pr[length-1]=='5'|| pr[length-1]=='6') 
		{
			prog=prog.substring(0,length-1);
			year=pr[length-1];
		}//end of if	
		else
		{
			year='1';
			prog=prog;
		}//end of else		
		/*Logic ends here of separating the year or semester number from program code*/
		name=rs.getString(5);//getting the name of the student from the ResultSet
		medium=rs.getString(7);//getting the medium opted by the student from the student registration table
		int course_number=0;
	/*Logic for checking the total number of courses opted by the student as blank course column contains only spaces*/
		for(int i=17;i<35;i=i+2)
		{
			pr=rs.getString(i).toCharArray();
			length=0;
			for(int k=0;k<pr.length;k++)
			{
				if(pr[k]!=' ')
				length++;
			}//end of for loop
			if(length>0)
			course_number++;
		}//end of for loop
	/*Logic ends here for getting the total number of courses opted byt the student*/
	/*Logic for getting all the courses name, no of blocks of them and the serial number associated with the course*/
		rs=stmt.executeQuery("select * from student_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'");
		String course[]					=	new String[course_number];
		int blocks[]					=	new int[course_number];
		int blocks_shadow[]				=	new int[course_number];
		String serial_number[]			=	new String[course_number];
		int i=17,j=18;
		int total_length=0,count=0;
		ResultSet rs1=null,rs2=null;
		String relative_course=null;
		while(rs.next())
		{
			for(index=0;index<course_number;index++)
			{
				course[index]		=	rs.getString(i).trim();
				serial_number[index]=	rs.getString(j);
				
				rs1		=	stmt1.executeQuery("Select * from course where crs_code='"+course[index]+"'");
				if(rs1.next())
				{	
					rs1		=	stmt1 .executeQuery("Select no_of_blocks from course where crs_code='"+course[index]+"'");
					while(rs1.next())
					blocks[index]			=	rs1.getInt(1);
					i=i+2;
					j=j+2;
				}//end of if(rs1.next())
				else
				{								
					rs1	=	stmt1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[index]+"' and rc_code='"+rc_code+"'");
					while(rs1.next())
					relative_course=rs1.getString(1);
					rs1		=	stmt1 .executeQuery("Select no_of_blocks from course where crs_code='"+relative_course+"'");
					while(rs1.next())
					blocks[index]			=	rs1.getInt(1);
					i=i+2;
					j=j+2;
				}//end of else of if(rs1.next())
			}//end of for loop
		}//end of while loop
	/*Logic end here for getting all the course name,serial numbers and blocks*/
	/*Logic for counting the total number of courses with block like MCSB1*/
		for(index=0;index<course.length;index++)
		{
			total_length=total_length+blocks[index];
		}
	/*Logic ends here for counting the total number of courses with block like MCSB1*/
	
		int[] stock				=	new int[total_length];//int array for holding the stock available for all courses blockwise
		String course_block[]	=	new String[total_length];//array for holding all the courses block wise
		/*logic for creating array of course_block & stock availability*/
		String block_name=null;
		for(index=0;index<course.length;index++)
		{
			for(int b=1;b<=blocks[index];b++)
			{
				course_block[count]=course[index]+"B"+b;
				rs1		=	stmt1 .executeQuery("Select * from course where crs_code='"+course[index]+"'");//checking the course in course table
				if(rs1.next())
					relative_course=course[index];
				else
				{
					rs1	=	stmt1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[index]+"' and rc_code='"+rc_code+"'");
					while(rs1.next()) 
					relative_course=rs1.getString(1);
				}
				block_name="B"+b;
				rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+relative_course+"' and block='"+block_name+"' and medium='"+medium+"'");
				while(rs.next())
				stock[count]=rs.getInt(1);
				count++;
			}//end of for loop b
		}//end of for loop a
	/*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
		request.setAttribute("course",course);
		request.setAttribute("serial_number",serial_number);
		request.setAttribute("course_block",course_block);
		request.setAttribute("blocks",blocks);
		request.setAttribute("stock",stock);
/* logic of getting the ABSOLUTE PROGRAMME CODE*/
	String[] relative_prg_code=new String[0];
	rs	=	stmt.executeQuery("select count(*) from program_program where relative_prg_code='"+prog+"' and rc_code='"+rc_code+"'");
	if(rs.next())
	relative_prg_code=new String[rs.getInt(1)];
	index=0;
	rs	=	stmt.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+prog+"' and rc_code='"+rc_code+"'");
	while(rs.next())
	{
	relative_prg_code[index]=rs.getString(1);
	index++;
	}
String search_crs_code="(crs_code='"+prog+"'";		
for(index=0;index<relative_prg_code.length;index++)
{
	search_crs_code=search_crs_code+" or crs_code='"+relative_prg_code[index]+"'";
}//end of for loop

search_crs_code=search_crs_code+")";		
System.out.println("value of search_crs_code "+search_crs_code);

		
/*Logic for checking the Despatch of Programme guide for the student entered into the system*/		
	rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and "+search_crs_code+" and block='PG' and reentry='NO'");
		if(rs.next())
		{
			pg_flag="YES";//if entered already then flag will be yes
			pg_date=rs.getDate(6).toString();	
		}
		else
		{
			pg_flag="NO";//if not entered earlier then flag will be no
			pg_date="XX/XX/XXXX";
		}
/*Logic for getting the available sets of the Programme guide of the program opted by the student*/		

		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where "+search_crs_code+" and block='PG' and medium='"+medium+"'");
		while(rs.next())
		available_pg=rs.getInt(1);
			request.setAttribute("pg_flag",pg_flag);//sending the pg_flag means despatched or not
			request.setAttribute("pg_date",pg_date);//sending the pg_flag means despatched or not
		int dispatch_course_count=0;//variable for holding the number of courses despatched blockwise now
		rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO' ");
		while(rs.next())
		{
			dispatch_course_count=rs.getInt(1);
		}
		
/*If Not any course opted by student has been Despatched then this logic will create empty Despatch course and date array*/

		if(dispatch_course_count==0)
		{
														//System.out.println("no material Despatch section entered");
			String dispatch[]				=	new String[dispatch_course_count];//create array of Despatch courses
			String dispatch_date[]			=	new String[dispatch_course_count];//create array of Despatch courses date
			msg=msg+"Welcome to the By Hand Entry for "+name+" First Time.";
/*Sending the Despatch courses and dates empty array with the msg variable with appropriate msg to the Browser*/		
			request.setAttribute("dispatch",dispatch);
			request.setAttribute("dispatch_date",dispatch_date);
			request.setAttribute("blocks_shadow",blocks_shadow);						
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_hand1.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+available_pg+"").forward(request,response); 
		}//end of if(dispatch_course_count==0)
/*If some courses partially Despatched then this logic will create the Despatched courses and dates array and sent to client*/

		else if(dispatch_course_count<course_block.length)
		{
			String checking=null;
			int m=0,counter=0;
			dispatch_course_count=0;
			rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and reentry='NO' and block<>'PG'");
			while(rs.next())
			{
				dispatch_course_count=rs.getInt(1);
			}//end of while loop

			String dispatch[]			=	new String[dispatch_course_count];//array for dispatched courses
			String dispatch_date[]		=	new String[dispatch_course_count];//array for date of Despatched courses
						
			rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'  and reentry='NO' and block<>'PG'");
			while(rs.next())
			{
			checking=rs.getString(3).trim();
				for(index=0;index<course.length;index++)
				{
					if(checking.equals(course[index]))
					blocks_shadow[index]++;
				}
				dispatch[m]				=	checking+rs.getString(4).trim();//rs.getString(3).trim()+rs.getString(4).trim();
				dispatch_date[m]		=	rs.getDate(6).toString();
				m++;
			}//end of while loop
			m=0;
			
			msg=msg+"Partially Despatched Courese of "+name+" are ";
			for(index=0;index<dispatch.length;index++)
			{
				msg=" "+msg+" "+dispatch[index];
			}
			/*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/	
			request.setAttribute("dispatch",dispatch);
			request.setAttribute("dispatch_date",dispatch_date);
			request.setAttribute("blocks_shadow",blocks_shadow);			
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_hand1.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+available_pg+"").forward(request,response);
		}//end of else if

		//if all materials Despatched
		else
		{
			int m=0,length_of_dispatch_courses=0;
			rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and reentry='NO' and block<>'PG'");
			while(rs.next())
			{
				length_of_dispatch_courses=rs.getInt(1);
			}//end of while loop
	
			String dispatch[]			=	new String[length_of_dispatch_courses];//array of despatched courses block wise
			String dispatch_date[]		=	new String[length_of_dispatch_courses];//array of Despatch dates of courses despatched
			rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'  and reentry='NO' and block<>'PG'");

			while(rs.next())
			{
				dispatch[m]				=	rs.getString(3).trim()+rs.getString(4).trim();
				dispatch_date[m]		=	rs.getDate(6).toString();
				dispatch_mode			=	rs.getString(7);
				m++;
			}//end of while loop
			request.setAttribute("dispatch",dispatch);//sending the array of Despatch courses block wise to the browser
			request.setAttribute("dispatch_date",dispatch_date);//sending the array of Despatch dates to the browser		
			System.out.println("Sorry books have been Despatched...");
			msg=msg+"Sorry!! Books have been Despatched For <br/>"+name+".";
			request.setAttribute("msg",msg);//Sending the message to the Browser
			request.getRequestDispatcher("jsp/By_hand2_reentry.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&date="+date+"&dispatch_mode="+dispatch_mode+"&available_pg="+available_pg+"").forward(request,response);
		}//end of else
	}//end of first if(rs.next())
	else
	{
		System.out.println("Sorry!! Roll No not found please contact to Registration Department..Thank you..");
		msg="Sorry!! Roll Number not found Please Contact to Admission Department. Thank You..";
		request.setAttribute("msg",msg);//sending the message to the browser
		request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response); 
	}//end of else of first if(rs.next())
}//end of try block
catch(Exception ex)
{
	System.out.println("exception mila rey from By_hand.jsp"+ex);
	msg="Some Serious Exception Hitted the Page. Please Check on Server Console For Details.";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);
}//end of catch blocks
finally
{}//end of finally blocks 
}//end of else of session checking
}//end of get method
public void destroy() {}
}//end of class BYE