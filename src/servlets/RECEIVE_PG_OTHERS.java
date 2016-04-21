package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING PROGRAMME GUIDE FROM OTHERS,MEANS PROGRAMME GUIDE RECEIVED FROM ANY OTHER SOURCE EXCEPT THE REGULAR SOURCE AND THE TRANSACTION RECORDED INTO OTHERS RECEIVE TABLE AND MATERIAL TABLE IS ALSO UPDATED ON SUCCESSUFUL TRANSACTION.
CALLED JSP:-From_others_pg.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;  
import javax.servlet.*;
import javax.servlet.http.*;
 
public class RECEIVE_PG_OTHERS extends HttpServlet {

public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("RECEIVE_PG_OTHERS SERVLET STARTED TO EXECUTE");
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
/*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE REQUEST AND STORING THEM IN THE VARIABLES*/
	String  prg_code				=	 request.getParameter("mnu_prg_code").toUpperCase();
		String  prg_code2				=	 request.getParameter("mnu_prg_code2").toUpperCase();


	String  medium				=	 request.getParameter("txt_medium").toUpperCase();
		String  medium2				=	 request.getParameter("txt_medium2").toUpperCase();


	String  date				=	 request.getParameter("txt_date").toUpperCase();
	String current_session		=	 request.getParameter("txt_session").toLowerCase();
	String receive_from			=	 request.getParameter("receive_from").toLowerCase();
	String rc_code=(String)session.getAttribute("rc");
	
/*LOGIC ENDS HERE FOR GETTING THE PARAMETERS FORM THE REQUEST*/	
	System.out.println("fields from From_mpdd_pg.jsp received Successfully");	
	String msg=null;	
		int index=0,flag=0,result_material=0,result_receive=0;		
		int actual_qty=0;//VARIABLE FOR STORING THE ACTUAL NUMBER OF BOOKS ON THE STORE FROM THE MATERIAL TABLE
/*LOGIC FOR CHECKING THE SELECTED COURSE AND STORING THEM IN STRING ARRAY AND QUANTITIES IN INTEGER ARRAY*/		
		if(!prg_code.equals("NONE"))	
		index++;
			if(!prg_code2.equals("NONE"))	
			index++;

			
			String courses[]		=	new String[index];
			String mediums[]		=	new String[index];
			int qtys[]				=	new int[index];			
			int insert				=	0;
	if(!prg_code.equals("NONE"))	
	{
		courses[insert]=prg_code;
		mediums[insert]=medium;
		qtys[insert]=Integer.parseInt(request.getParameter("text_qty"));
		insert++;
	}
	if(!prg_code2.equals("NONE"))	
	{
		courses[insert]=prg_code2;
		mediums[insert]=medium2;		
		qtys[insert]=Integer.parseInt(request.getParameter("text_qty2"));
		insert++;
	}
/*LOGIC ENDS HERE FOR GETTING THE SELECTED COURSE AND QUANTITY IN THE CORRESPONDING ARRAY*/	
	int result=5,result1=5;
	ResultSet first=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
	ResultSet block=null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
	response.setContentType("text/html");
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
/*LOGIC FOR CHECKING THE EXISTENCE OF THE ENTRIES TO BE MADE IN DATABSE ALREADY*/	
	msg="Entry Already Exist for PROGRAMME GUIDE OF: <br/>";

	for(int i=0;i<courses.length;i++)
	{
		first=stmt.executeQuery("select * from others_receive_"+current_session+"_"+rc_code+" where crs_code='"+courses[i]+"' and block='PG' and date='"+date+"'");
		if(first.next())
		{
			flag=1;
			msg=msg+courses[i]+"  for Date "+date+" <br/>";
		}//end of if first
	}//end of outer for loop
/*LOGIC ENDS HERE FOR CHEKING THE EXISTENCE OF THE ENTRIES TO BE MADE*/
	if(flag==0)
	{
		msg="Received Successfully PROGRAMME GUIDES OF <br/>";
		for(int i=0;i<courses.length;i++)
		{
			result_receive=stmt.executeUpdate("insert into others_receive_"+current_session+"_"+rc_code+"(crs_code,block,qty,medium,date,receive_from) values('"+courses[i]+"','PG',"+qtys[i]+",'"+mediums[i]+"','"+date+"','"+receive_from+"')");
			result_material=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty+"+qtys[i]+" where crs_code='"+courses[i]+"' and block='PG' and medium='"+mediums[i]+"'");
			msg=msg+courses[i]+"  For Date "+date+" in Medium "+mediums[i]+"<br/>";
		}//end of outer for loop
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request,response);  
	}//end of if(flag==0)
	else//IF THIS ELSE WILL WORK MEANS ENTRIES ALREADY EXIST AND CAN NOT ENTER AGAIN.....
	{
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request,response);
	}//end of else of if(flag==0)
}//end of try
catch(Exception ex)
{
	System.out.println("exception mila rey from RECEIVE_PG_OTHERS.JAVA page and exception is "+ex);
	msg="Some Serious Exception came at the page. Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/From_others_pg.jsp").forward(request,response);
}//end of catch blocks
finally{}//end of finally blocks
}//end of else of session checking
}//end of method doPost
public void destroy() {	}
}//end of class RECEIVE_PG_OTHERS