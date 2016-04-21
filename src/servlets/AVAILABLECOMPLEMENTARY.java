package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABILITY OF THE COURSE SELECTED BY THE USER FOR THE COMPLEMENTARY DESPATCH.THIS SERVLET TAKES THE COURSE CODES SELECTED BY THE
USER AS INPUT AND THEN CHECKS THE AVAILABILITY OF THE COURSES IN THE MATERIAL DATABASE,AVAILABILITY OF THE COURSES SENT TO THE BORWSER AS OUTPUT.
CALLED JSP:-Complementary.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class AVAILABLECOMPLEMENTARY extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("AVAILABLECOMPLEMENTARY SERVLET STARTED TO EXECUTE");
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
		String rc_code=(String)session.getAttribute("rc");
/*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE BROWSER SELECTED BY THE USER*/
	String prg_code				=	 request.getParameter("mnu_prg_code").trim();//getting the value of the programme code from the browser
	String crs_code				=	 request.getParameter("mnu_crs_code").trim();//getting the value of the first course code from the browser
	String crs_code2			=	 request.getParameter("mnu_crs_code2").trim();//getting the value of the second course code from the browser
	String crs_code3			=	 request.getParameter("mnu_crs_code3").trim();//getting the value of the third course code from the browser
	String crs_code4			=	 request.getParameter("mnu_crs_code4").trim();//getting the value of the forth course code from the browser
	String medium				= 	 request.getParameter("txt_medium").toUpperCase();//gerring the medium  selecte by the user from the browser
	String current_session		=	 request.getParameter("txt_session").toLowerCase();//getting the value of the current session from tehe browser
			System.out.println("all parameters received");
	/*LOGIC ENDS FOR GETTING THE PARAMETERS FROM THE BROWSER*/	
	String msg="";
	request.setAttribute("current_session",current_session);//sending the value of the current session to the browser
	int one=0,two=0,three=0,four=0;
	int index=0;
	int actual_qty=0;//VARIABLE FOR STORING THE ACTUAL NUMBER OF BOOKS ON THE STORE FROM THE MATERIAL TABLE
	int flag_for_return=0;

		if(!crs_code.equals("NONE"))	
			index++;
				if(!crs_code2.equals("NONE"))	
					index++;
					if(!crs_code3.equals("NONE"))	
				index++;
			if(!crs_code4.equals("NONE"))	
		index++;
	String courses[]		=	new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
	int blocks[]			=	new int[index];//INT ARRAY FOR HOLDING NUMBER OF BLOCKS FOR EACH COURSE SELECTED
	
			int insert				=	0;
	if(!crs_code.equals("NONE"))	
	{
		courses[insert]=crs_code;
		insert++;
	}
	
	if(!crs_code2.equals("NONE"))	
	{
		courses[insert]=crs_code2;
		insert++;
	}
	
	if(!crs_code3.equals("NONE"))	
	{
		courses[insert]=crs_code3;
		insert++;
	}
	
	if(!crs_code4.equals("NONE"))	
	{
		courses[insert]=crs_code4;
		insert++;
	}
	
			response.setContentType("text/html");
			PrintWriter out=response.getWriter();
			ResultSet first=null,rs=null;
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	int total_length=0,count=0;
	/*Logic for creating int variable of blocks of the courses selected*/
	for(int m=0;m<index;m++)
	{
		rs		=	stmt.executeQuery("Select no_of_blocks from course where crs_code='"+courses[m]+"'");
		while(rs.next())
		blocks[m]			=	rs.getInt(1);
	}//end of for loop
	/*Logic end here for getting all the blocks*/
	
	/*Logic for counting the total number of courses with block like MCS51B1*/
	for(int i=0;i<courses.length;i++)
	{
		total_length=total_length+blocks[i];
	}
	/*Logic ends here for counting the total number of courses with block like MCS51B1*/
	int[] stock				=	new int[total_length];//int array for holding the stock available for all courses blockwise
	String course_block[]	=	new String[total_length];//array for holding all the courses block wise
	/*logic for creating array of course_block & stock availability*/
	String boro=null;
	
	for(int a=0;a<courses.length;a++)
	{
		for(int b=1;b<=blocks[a];b++)
		{
			course_block[count]=courses[a]+"B"+b;
			boro="B"+b;
			rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+courses[a]+"' and block='"+boro+"' and medium='"+medium+"'");
			while(rs.next())
			stock[count]=rs.getInt(1);
			System.out.println(course_block[count]+" "+stock[count]);
			count++;
		}//end of for loop b
	}//end of for loop a
	/*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
		request.setAttribute("courses",courses);
		request.setAttribute("course_block",course_block);
		request.setAttribute("blocks",blocks);
		request.setAttribute("stock",stock);
		
	msg="Available Stock Status:<br/>";
	count=0;
	for(int i=0;i<courses.length;i++)
	{
		msg=msg+courses[i]+"<br/>";
		for(int j=1;j<=blocks[i];j++)
		{
			msg=msg+stock[count]+" Sets of B"+j+"<br/>";
			count++;
		}
	}
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/Complementary1.jsp?prg_code="+prg_code+"&medium="+medium+"").forward(request,response);	
	
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from AVAILABLECOMPLEMENTARY.java and is "+exe);
	msg="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);
}//end of catch blocks
finally		{System.out.println("Finally block of BYRCSUBMIT has been started");} 
}//end of else of session checking
}//end of method 
}//end of class CHECKINGCOMPLEMENTARY