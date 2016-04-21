package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR UPDATING THE EXPRESS PARCEL NUMBER OF THE COURSES DESPATCHED BY POST FOR THE STUDENTS.
THIS SERVLET TAKES THE DETAILS OF THE DESPATCHED COURSES FROM THE BROWSER AND THEN UPDATE THE NEW EXPRESS PARCEL NUMBER FOR
THE SELECTED COURSES.
CALLED JSP:-Lot_Update.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class LOTUPDATESEARCH extends HttpServlet 
{
public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("LOTUPDATESEARCH SERVLET STARTED TO EXECUTE");
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
/*LOGIC FOR GETTING THE PARAMETERS FROM THE BROWSER LIKE NAME ROLL NO*/
	String msg="";
	String button_value				=	 request.getParameter("enter").toUpperCase();			
		button_value				=	 button_value.trim();			
			System.out.println("Value of Button: "+button_value);	
if(button_value.equals("REFRESH"))
{
System.out.println("Entered into REFRESH block");
request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
}
else
{		
try
{
	String lots[]			=	 request.getParameterValues("lot_name");//all the lot name from the jsp page
	int index=0,len=0;
	int pg_result=0,pg_result1=0,pg_result2=0;
		if(lots==null )
		{
			msg="Please Select Any One Lot Name to Update.<br/>";
			request.setAttribute("msg",msg);			
			request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
		}//end of if
		else
		{
			msg=lots.length+" Lots Selected For Updation.<br/>";
			request.setAttribute("lots",lots);
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/Lot_Update1.jsp").forward(request,response);
		}//end of else
	}//end of try blocks
	catch(Exception ex)
	{
		msg="Some Serious Exception Hitted the page. Please check on Server Console for Details";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
	}//end of catch blocks
	finally{}//end of finally blocks
	}//END OF ELSE OF BUTTON_VALUE
}//end of else of session checking
}//end of method
}//end of class LOTUPDATESEARCH