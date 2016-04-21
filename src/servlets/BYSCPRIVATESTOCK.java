package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE TOTAL NUMBER OF STUDENTS WITH THE COURSE SELECTED BY THE USER IN THE FIRST 
PAGE WHERE USER SELECT THE STUDY CENTRE CODE,PROGRAM CODE,SEMESTER OR YEAR NUMBER AND THE COURSE CODE.AS A RESULT THIS PAGE 
SENDS THE TOTAL LIST OF STUDENTS TO SECOND PAGE WITH THE FACILITY OF DISABLED STUDENTS MEANS THOSE DATA WILL BE DISABLED WHICH
 WERE ALREADY DESPATCHED.
CALLED JSP:-To_sc_office.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYSCPRIVATESTOCK extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYSCPRIVATESTOCK SERVLET STARTED TO EXECUTE");
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
	String sc_code				=	 request.getParameter("mnu_sc_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
	String prg_code				=	 request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
	String crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();//FIELD FOR GETTING THE COURSE CODE
	String medium				= 	 request.getParameter("text_medium").toUpperCase();//FIELD FOR GETTING THE MEDIUM OPTED BY THE STUDENT
	String current_session		=	 request.getParameter("text_session").toLowerCase();//FIELD FOR GETTING THE  SESSION NAME
	String msg					=	 "";			//VARIABLE FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
	String sc_name				=	"";
	int result=5,result1=5;
	ResultSet rs=null;	
	String rc_code=(String)session.getAttribute("rc");
	response.setContentType("text/html");
		request.setAttribute("current_session",current_session);
try
{
	int blocks=0;
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	/*logic for fetching the number of blocks of the course selected by the user to Despatch*/
	rs=stmt.executeQuery("select no_of_blocks from course where crs_code='"+crs_code+"'");
	while(rs.next())
	blocks=rs.getInt(1);
	/*logic ends here*/
	/*Logic for creating int variable of available sets of the blocks of the course selected*/
	int available_qty[]=new int[blocks];
	String block[]=new String[blocks];
	int index=0;
	for(int j=0;j<blocks;j++)
	{
		index=j+1;
		block[j]="B"+index;
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block[j]+"' and medium='"+medium+"'");
		while(rs.next())
		available_qty[j]=rs.getInt(1);
		msg=msg+"Available Stock Status:"+available_qty[j]+" Sets of "+crs_code+" Block "+block[j]+"</br>";
	}
	request.setAttribute("block",block);
	request.setAttribute("available_qty",available_qty);
	rs=stmt.executeQuery("select sc_name from study_centre where sc_code='"+sc_code+"'");
	while(rs.next())
	sc_name=rs.getString(1);//getting the sc_name from database
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_sc_office1.jsp?sc_code="+sc_code+"&sc_name="+sc_name+"&prg_code="+prg_code+"&crs_code="+crs_code+"&medium="+medium+"").forward(request,response);	
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYSCPRIVATESTOCK.java "+exe);
	msg="Some Serious Exception came.Please check on the Server Console for more Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);		
}//end of catch
finally{}//end of finally blocks
}//end of else of session checking
}//end of method
 
}//end of class BYSCPRIVATESUBMIT