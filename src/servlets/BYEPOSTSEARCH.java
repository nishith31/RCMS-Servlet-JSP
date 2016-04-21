package servlets;

/*THIS SERVLET IS RESPONSIBLE FOR FETCHING THE DETAILS OF THE STUDENT ENTERED BY THE USER FROM THE STUDENT TABLE OF THE CONCERNED REGIONAL CENTRE DATABASE AND ALSO CHECKING THE
NUMBER OF COURSES AND DETAILS OF COURSES THOSE HAVE BEEN ALREADY DESPATCHED VIA ANY OTHER DESPATCH MODE OR BY POST MADE.IF ANY COURSE FOUND DESPATCHED THEN DATA OF THOSE COURSES
WILL BE SHOWN IN DISABLED FORM IN THE BROWSER
CALLED JSP:-By_post.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYEPOSTSEARCH extends HttpServlet {
    String current_session="";//variable for holding the value of the current session of the regional centre logged in.
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYEPOSTSEARCH SERVLET STARTED TO EXECUTE");	
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
	String enrno	=	 request.getParameter("txt_enr");//getting the Enrolment Number of the student from the browser
	String msg="";//message for sending message to the browser for printing purpose
	String prog=null;//variable for holding and sending the program code of the student
	String name=null;//variable for holding the name of the student
	char year;//variable for holding the year or semester number of the student.
	String medium=null;	//variable for holding the medium of program opted by the student
	String date=null;//variable for holding the date 	
	String dispatch_mode=null;//variable for holding the mode of despatch_mode
	try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}//retrieving message from msg variable if this is not coming directly the first page means coming from any other servlet.
	if(msg==null)
	msg=" ";
	int length=0,index=0;
	int course_number=0;
		String khushi="";

	String rc_code=(String)session.getAttribute("rc");//getting the code of logged rc in the system from the session object.
			response.setContentType("text/html");
			PrintWriter out=response.getWriter();
			int available_pg=0;
			String pg_flag=null,pg_date=null;
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the connection to the database and getting the reference
	Connection con1=connections.ConnectionProvider.conn();//creating the connection to the database and getting the reference
	Statement stmt=con.createStatement();//creating the statement object and getting the reference from the connection object
	Statement stmt1=con1.createStatement();//creating the statement object and getting the reference from the connection object
	ResultSet rs=stmt.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");//getting the value of current session of the rc that is logged in the system.
	/*Logic for fetching the value of current session from the ResultSet variable and setting it to own variable*/
	while(rs.next())
	current_session=rs.getString(1).toLowerCase();
	request.setAttribute("current_session",current_session);		
	/*Logic ends for fetching the value of current session from the ResultSet variable*/
	/*Logic for fetcing all details of the student from the student database of the RC logged in*/
	rs=stmt.executeQuery("select * from student_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'");
	if(rs.next()) 
	{
		prog = rs.getString(2);//getting the complete program code from the student table			
		char pr[]=prog.toCharArray();//converting the program code to character array for fetching the program code only
		for(index=0;index<pr.length;index++)//logic for checking the actual length of prg_code field of student table
		{
			if(pr[index]!=' ')
			length++;
		}//end of for loop
		/*Logic for getting the program code and semester/year code. If last digit of program code is in between 1 to 6 then took the last digit as semester/year code and rest as program code otherwise the semester/year code will be considered one and the whole word of prg_code is treated as complete program code*/
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
		/*logic ends here of program code separationg*/
		name=rs.getString(5);//getting the name of the student from the student database
		medium=rs.getString(7);//getting the medium of the program of the student from student database
		
	/*Logic for getting the total number of courses for creating the array of course and then storing courses on that.In 2005 the empty courses came blank with only spaces so need to convert them in character array first and then checking the length and if length is avaialble more than 0 then increase the course count but in sql2008 the blank courses came null so checking null is ok in 2008.*/
		for(int i=17;i<35;i=i+2)
		{
			/*khushi=rs.getString(i);//logic for system of khushi where fields are not null
			if(khushi!=null){course_number++;}*/
			pr=rs.getString(i).toCharArray();
			length=0;
			for(index=0;index<pr.length;index++)
			{
				if(pr[index]!=' ')
				length++;
			}//end of for loop
			if(length>0)
			course_number++;
		}//end of for loop
 
		rs=stmt.executeQuery("select * from student_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'");
		/*Creating the array of courses, number of blocks for each course and the serial number associated with the course*/
		String course[]			=	new String[course_number];
		int blocks[]			=	new int[course_number];
		int blocks_shadow[]		=	new int[course_number];		
		String serial_number[]	=	new String[course_number];
		int i=17,j=18;
		int total_length=0,count=0;
		ResultSet rs1=null;
		ResultSet rs2=null;
		String relative_course=null;
		/*Logic for storing the courses and serial numbers and no of blocks to their corresponding array*/
		while(rs.next())
		{
			for(int m=0;m<course_number;m++)
			{
				course[m]			=	rs.getString(i).trim();
				serial_number[m]	=	rs.getString(j);
				rs1		=	stmt1.executeQuery("Select * from course where crs_code='"+course[m]+"'");
				if(rs1.next())
				{System.out.println("course found in course table");
					rs1		=	stmt1 .executeQuery("Select no_of_blocks from course where crs_code='"+course[m]+"'");
					while(rs1.next())
					blocks[m]			=	rs1.getInt(1);
					i=i+2;
					j=j+2;
				}//end of if(rs1.next())
				else
				{	
					rs1	=	stmt1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[m]+"' and rc_code='"+rc_code+"' ");
					while(rs1.next())
					relative_course=rs1.getString(1);
					rs1		=	stmt1 .executeQuery("Select no_of_blocks from course where crs_code='"+relative_course+"'");
					while(rs1.next())
					blocks[m]			=	rs1.getInt(1);
					i=i+2;
					j=j+2;
				}//end of else of if(rs1.next())
			}//end of for loop
		}//end of while loop
		for(index=0;index<course.length;index++)
		{
			total_length=total_length+blocks[index];//finding the total legth for store the course as blockwise.
		}
		
		int[] stock				=	new int[total_length];//int array for stock of each course blockwise
		String course_block[]	=	new String[total_length];//String array for course name block wise like MCS51B2
		/*logic for creating array of course_block & stock availability*/
		String block_name=null;
		for(int a=0;a<course.length;a++)
		{
			for(index=1;index<=blocks[a];index++)
			{
				course_block[count]=course[a]+"B"+index;
				
				rs1		=	stmt1 .executeQuery("Select * from course where crs_code='"+course[a]+"'");//checking the course in course table
				if(rs1.next())
					relative_course=course[a];
				else
				{
					rs1	=	stmt1.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[a]+"' and rc_code='"+rc_code+"'");
					while(rs1.next()) 
					relative_course=rs1.getString(1);
				}
				block_name="B"+index;
				rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+relative_course+"' and block='"+block_name+"' and medium='"+medium+"'");
				while(rs.next())
				stock[count]=rs.getInt(1);
				System.out.println(course_block[count]+" "+stock[count]);
				count++;
			}//end of for loop b
		}//end of for loop a
		/*Setting all the arrays to the request for sending them to the browser*/
		request.setAttribute("course",course);
			request.setAttribute("serial_number",serial_number);
				request.setAttribute("course_block",course_block);
			request.setAttribute("blocks",blocks);
		request.setAttribute("stock",stock);
/*logic of getting the ABSOLUTE PROGRAMME CODE*/
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
			search_crs_code=search_crs_code+" or crs_code='"+relative_prg_code[index]+"'";
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
		
		System.out.println("Available sets of Program guide of "+prog+" is "+available_pg);
		request.setAttribute("pg_flag",pg_flag);//sending the pg_flag means despatched or not
		request.setAttribute("pg_date",pg_date);//sending the pg_flag means despatched or not
		int dispatch_course_count=0;//variable for counting the number of courses despatched to the selected roll number
	rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
		while(rs.next())
		{
			dispatch_course_count=rs.getInt(1);
		}
/*If Not any course opted by student has been dispatched then this logic will create empty Despatch course and date array*/

		if(dispatch_course_count==0)
		{
			String dispatch[]				=	new String[dispatch_course_count];//array for despatched courses 
			String dispatch_date[]			=	new String[dispatch_course_count];//array for despatce date of despatched courses
			msg=msg+"Welcome to the By Post Entry for "+name+" First Time.";
/*Sending the Despatch courses and dates empty array with the msg variable with appropriate msg to the Browser*/		
			request.setAttribute("dispatch",dispatch);
			request.setAttribute("dispatch_date",dispatch_date);
			request.setAttribute("blocks_shadow",blocks_shadow);										
			request.setAttribute("msg",msg);
request.getRequestDispatcher("jsp/By_post1.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+available_pg+"").forward(request,response); 
		}//end of if(dispatch_course_count==0)
/*If some courses partially dispatched then this logic will create the dispatched courses and dates array and sent to client*/

		else if(dispatch_course_count<course_block.length)
		{
			String checking=null;
			System.out.println("else if entered");
			int m=0,lll=0,counter=0;
			length=0;
			rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
			while(rs.next())
			{
				length=rs.getInt(1);
			}//end of while loop
	
			String dispatch[]			=	new String[length];//initializing the array of despatched courses
			String dispatch_date[]		=	new String[length];//initializing the array of despatched dates
						
rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
			
			while(rs.next())
			{		
				checking=rs.getString(3).trim();
				for(index=0;index<course.length;index++)
				{
					if(checking.equals(course[index]))
					blocks_shadow[index]++;
				}

				dispatch[m]				=	checking+rs.getString(4).trim();//rs.getString(3).trim()+rs.getString(4).trim();//creating the course block wise
				dispatch_date[m]		=	rs.getDate(6).toString();//getting the date of despatch
				m++;
			}//end of while loop
			m=0;
			msg=msg+"Partially Despatched Courese of "+name+" are ";
			for(int k=0;k<dispatch.length;k++)
			{
				msg=" "+msg+" "+dispatch[k];
			}
			/*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/	
			request.setAttribute("dispatch",dispatch);
			request.setAttribute("dispatch_date",dispatch_date);
			request.setAttribute("blocks_shadow",blocks_shadow);						
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post1.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+available_pg+"").forward(request,response);
		}//end of else if
/*Intermediate Logic for sending only the program guide is not despatched and all the courses have been despatched.*/
/*If some courses partially dispatched then this logic will create the dispatched courses and dates array and sent to client*/

		else if(dispatch_course_count==course_block.length && pg_flag.equals("NO"))
		{
			String checking=null;
			int m=0,lll=0,counter=0;
			length=0;
			rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
			while(rs.next())
			{
				length=rs.getInt(1);
			}//end of while loop
	
			String dispatch[]			=	new String[length];//initializing the array of despatched courses
			String dispatch_date[]		=	new String[length];//initializing the array of despatched dates
						
rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
			
			while(rs.next())
			{		
				checking=rs.getString(3).trim();
				for(index=0;index<course.length;index++)
				{
					if(checking.equals(course[index]))
					blocks_shadow[index]++;
				}

				dispatch[m]				=	checking+rs.getString(4).trim();//creating the course block wise
				dispatch_date[m]		=	rs.getDate(6).toString();//getting the date of despatch
				m++;
			}//end of while loop
			m=0;
			msg=msg+"Partially Despatched Courese of "+name+" are ";
			for(int k=0;k<dispatch.length;k++)
			{
				msg=" "+msg+" "+dispatch[k];
			}
			/*Sending the Despatch courses and dates array with the msg variable with appropriate msg to the Browser*/	
			request.setAttribute("dispatch",dispatch);
			request.setAttribute("dispatch_date",dispatch_date);
			request.setAttribute("blocks_shadow",blocks_shadow);						
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post1.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&available_pg="+available_pg+"").forward(request,response);
		}//end of else if

/*LOGIC IF ALL THE COURSES AND THE PROGRAM GUIDE HAS BEEN DESPATCHED SUCCESSFULLY THEN THIS SECTION WILL WORK*/
		else
		{
			int m=0,length_of_dispatch_courses=0;
			rs=stmt.executeQuery("select count(*) from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"' and block<>'PG' and reentry='NO'");
			while(rs.next())
			{
				length_of_dispatch_courses=rs.getInt(1);
			}//end of while loop
	
			System.out.println("length of length_of_despatch_courses "+length_of_dispatch_courses);
			String dispatch[]			=	new String[length_of_dispatch_courses];
			String dispatch_date[]		=	new String[length_of_dispatch_courses];
			//String dispatch_mode		=	null;
			rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+enrno+"'and block<>'PG' and reentry='NO'");
			
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
			msg=msg+"Sorry!! Books have been Dispatched for<br/>"+name+".";
			request.setAttribute("msg",msg);//sending the message to the browser
			request.getRequestDispatcher("jsp/By_post.jsp?enrno="+enrno+"&prog="+prog+"&year="+year+"&name="+name+"&medium="+medium+"&date="+date+"&dispatch_mode="+dispatch_mode+"&available_pg="+available_pg+"").forward(request,response);
		}//end of else
	}//end of first if(rs.next())
	else
	{
		System.out.println("Sorry!! Roll No not found please contact to Registration Department..Thank you..");
		msg="Sorry!! Roll Number not found please contact to Admission Department. Thank You..";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_post.jsp").forward(request,response); 
	}//end of else of first if(rs.next())
}//end of try block
catch(Exception ex)
{
	System.out.println("exception mila rey from BYEPOSTSEARCH SERVLET AND EXCEPTION IS "+ex);
	msg="Some Serious Exception Hitted the page. Please check on Server Console for Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_post.jsp").forward(request,response);
}//end of catch blocks
finally
{}//end of finally blocks 
}//end of else of session checking
}//end of method doGet()
public void destroy() {}
}//end of class BYEPOSTSEARCH