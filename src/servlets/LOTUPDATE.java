package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR UPDATING THE EXPRESS PARCEL NUMBER OF THE COURSES DESPATCHED BY POST FOR THE STUDENTS.
THIS SERVLET TAKES THE DETAILS OF THE DESPATCHED COURSES FROM THE BROWSER AND THEN UPDATE THE NEW EXPRESS PARCEL NUMBER FOR
THE SELECTED COURSES.
CALLED JSP:-Lot_Update1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class LOTUPDATE extends HttpServlet 
{

public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("LOTUPDATE SERVLET STARTED TO EXECUTE");
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
	else//if session of java exists than this will work
	{	
	String rc_code=(String)session.getAttribute("rc");
/*LOGIC FOR GETTING THE PARAMETERS FROM THE BROWSER LIKE NAME ROLL NO*/
	String msg="";
	String current_session=null;
try
{
	String lots[]			=	 request.getParameterValues("lot_name");//all the lot name from the jsp page
	String lots_name[]			=	new String[lots.length];
	
	int index				=		0;
	for(index=0;index<lots.length;index++)
	{
		lots_name[index]=	 request.getParameter(lots[index]);
	}
	
	int pg_result=0;
		Connection con=connections.ConnectionProvider.conn();
		Statement stmt=con.createStatement();
		ResultSet rs=null;
/*Logic for getting the current session name from the sessions table of the regional centre logged in and send to the browser*/	
	rs=stmt.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
	while(rs.next())
	current_session=rs.getString(1).toLowerCase();
/*Logic ends here*/		
	for(index=0;index<lots.length;index++)
	{
		pg_result+=stmt.executeUpdate("update student_"+current_session+"_"+rc_code+" set lot='"+lots_name[index]+"' where lot_name='"+lots[index]+"'");		
		
	}
		if(pg_result>0)
		msg="Successfully Updates "+lots.length+" Lots Name.<br/>Total Updated Student are :"+pg_result+".<br/>";
		else
		msg="Failed to update";
				request.setAttribute("lots",lots);
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
	}//end of try blocks
	catch(Exception ex)
	{
		msg="Some Serious Exception Hitted the page. Please check on Server Console for Details";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
	}//end of catch blocks
	finally{}//end of finally blocks
}//end of else of session checking
}//end of method
}//end of class LOTUPDATE