package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABLE STOCK OF THE PROGRAMME GUIDE OF PROGRAMME SELECTED BY THE USER AND SENDS THE INFORMATION TO THE BROWSER ABOUT THE AVAILABILITY AND IT ALSO SENDS THE RC NAME OF THE SELECTED RC WITH ITS NECESSARY DETAILS OF THE RC.S
CALLED JSP:-To_rc_pg.jsp*/
import static utility.CommonUtility.isNull;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 

import javax.servlet.*;
import javax.servlet.http.*; 

import utility.Constants;
public class BYRCAVAILABLE_PG_STOCK extends HttpServlet
 {
	public void init(ServletConfig config) throws ServletException 
	{
		System.out.println("BYRCAVAILABLE_PG_STOCK SERVLET STARTED FROM INIT METHOD");
		super.init(config);
	}  
public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
	HttpSession session=request.getSession(false);//getting and checking the availability of session of java
	if(isNull(session)) {
		String message = Constants.LOGIN_ACCESS_MESSAGE;
		request.setAttribute("msg", message);
		request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
	}
	else
	{
	/*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST SELECTED BY THE CLIENT*/
	String reg_code			=	 request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String prg_code			=	 request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE	
	String medium			= 	 request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
	String current_session	=	 request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
	request.setAttribute("current_session",current_session);
	String rc_code			=	(String)session.getAttribute("rc");
	System.out.println(rc_code);
	String reg_name			=	null;
	int index=0,insert=0;
	String msg="";
	ResultSet rs=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
	response.setContentType("text/html");
	/*LOGIC FOR CHECKING THE SELECTED COURSES AND CREATING THEIR ARRAY OF STRING*/
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	int total_length=0,count=0;
	int stock				=	0;//int array for holding the stock available for all courses blockwise
	/*logic for creating array of course_block & stock availability*/
	String boro=null;
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
			while(rs.next())
			stock=rs.getInt(1);
		request.setAttribute("stock",stock);
/*Logic for creating reg_name variable of the name of the rc selected rc code*/	
	rs=stmt.executeQuery("select reg_name from regional_centre where reg_code='"+reg_code+"'");
	while(rs.next())
	reg_name=rs.getString(1);
	msg="Available Stock OF PROGRAMME GUIDE OF :"+prg_code+"<br/> are "+stock+".";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/To_rc_pg1.jsp?reg_code="+reg_code+"&reg_name="+reg_name+"&prg_code="+prg_code+"&medium="+medium+"").forward(request,response);	
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYRCAVAILABLE_PG_STOCK.java and is "+exe);
	msg="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request,response);
}//end of catch blocks
finally		
{} //END OF FINALLY BLOCKS
}//end of else of session checking
}//end of method
 
}//end of class BYRCAVAILABLE_PG_STOCK