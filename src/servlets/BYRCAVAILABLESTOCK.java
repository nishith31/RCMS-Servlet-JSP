package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABILITY OF THE COURSE CODE SELECTED BY THE USER FOR DESPATCHING TO THE RC ,THIS SERVLET TAKES THE PROGRAMME CODE,COURSE CODE,RC NAME,MEDIUM AS INPUT FROM THE DATA AND DISPLAYS THE RESULT IN THE NEXT PAGE WITH APPROPRIATE MESSAGE.
CALLED JSP:-To_rc.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
public class BYRCAVAILABLESTOCK extends HttpServlet
 {
	public void init(ServletConfig config) throws ServletException 
	{
		System.out.println("BYRCAVAILABLESTOCK SERVLET STARTED FROM INIT METHOD");
		super.init(config);
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
	String reg_code			=	 request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String prg_code			=	 request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE	
	String  crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();
		String  crs_code2				=	 request.getParameter("mnu_crs_code2").toUpperCase();
			String  crs_code3				=	 request.getParameter("mnu_crs_code3").toUpperCase();
		String  crs_code4				=	 request.getParameter("mnu_crs_code4").toUpperCase();
	String  crs_code5				=	 request.getParameter("mnu_crs_code5").toUpperCase();
	String medium			= 	 request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
	String current_session	=	 request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
	request.setAttribute("current_session",current_session);
	String rc_code			=	(String)session.getAttribute("rc");
	String reg_name			=	null;
	int index=0,insert=0;
	String msg="";
	ResultSet rs=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
		response.setContentType("text/html");
	/*LOGIC FOR CHECKING THE SELECTED COURSES AND CREATING THEIR ARRAY OF STRING*/
	if(!crs_code.equals("NONE"))	
	index++;
		if(!crs_code2.equals("NONE"))	
		index++;
			if(!crs_code3.equals("NONE"))	
			index++;
		if(!crs_code4.equals("NONE"))	
		index++;
	if(!crs_code5.equals("NONE"))	
	index++;
	String courses[]		=	new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
	int blocks[]			=	new int[index];//INT ARRAY FOR HOLDING NUMBER OF BLOCKS FOR EACH COURSE SELECTED
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
	if(!crs_code5.equals("NONE"))	
	{
		courses[insert]=crs_code5;			
		insert++;
	}
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
			count++;
		}//end of for loop b
	}//end of for loop a
	/*Sending all the arrays of course,serial number,course_block,stocks and blocks to the browser by setting on the request*/
		request.setAttribute("courses",courses);
		request.setAttribute("course_block",course_block);
		request.setAttribute("blocks",blocks);
		request.setAttribute("stock",stock);		
/*Logic for creating reg_name variable of the name of the rc selected rc code*/	
	rs=stmt.executeQuery("select reg_name from regional_centre where reg_code='"+reg_code+"'");
	while(rs.next())
	reg_name=rs.getString(1);
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
	request.getRequestDispatcher("jsp/To_rc1.jsp?reg_code="+reg_code+"&reg_name="+reg_name+"&prg_code="+prg_code+"&medium="+medium+"").forward(request,response);		
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYRCSUBMIT.java and is "+exe);
	msg="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_rc.jsp").forward(request,response);
}//end of catch blocks
finally		
{} //end of finally blocks
}//end of else of session checking
}//end of method
}//end of class BYRCAVAILABLESTOCK