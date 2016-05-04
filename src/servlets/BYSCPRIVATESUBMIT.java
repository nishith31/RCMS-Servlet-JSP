package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING THE DATA INTO SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE OF RC LOGGED IN.HERE WE GET THE NUMBER OF SETS OF SELECTED COURSE AND THE NAME OF THE COURSE TO BE DESPATCHED TO THE THE STUDY CENTRES AND WITH THE REASON OF DESPATCH MEANS PURPOSE OF DESPATCH OF MATERIAL.
CALLED JSP:-To_sc_office1.jsp*/
import static utility.CommonUtility.isNull;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.Constants;
public class BYSCPRIVATESUBMIT extends HttpServlet {
/**
     * 
     */
    private static final long serialVersionUID = 1L;
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYSCPRIVATESUBMIT SERVLET STARTED TO EXECUTE");
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
	String sc_code				=	 request.getParameter("mnu_sc_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
	String crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();//FIELD FOR GETTING THE COURSE CODE
	String[] blocks				=	 request.getParameterValues(crs_code);//FIELD FOR GETTING THE COURSES CODES FROM THE BROWSER
	int        qty				=	 Integer.parseInt(request.getParameter("text_no_of_set"));//FIELD FOR GETTING THE QUANTITY OF STUDY MATERIALS
	String medium				= 	 request.getParameter("text_medium").toUpperCase();//FIELD FOR GETTING THE MEDIUM OPTED BY THE STUDENT
	String date					= 	 request.getParameter("text_date").toUpperCase();//FIELD FOR GETTING THE DATE ENTERED IN THE BROWSER
	String remarks				= 	 request.getParameter("mnu_remarks").toUpperCase();//FIELD FOR GETTING THE REMARKS
	String current_session		=	 request.getParameter("text_session").toLowerCase();//FIELD FOR GETTING THE  SESSION NAME
	String msg					=	 "";//VARIABLE FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
	int remain_qty				=	 0;//VARIABLE FOR HOLDING THE REMAINING QUANTITY OF MATERIALS AFTER SUCCESSFUL Despatch OF MATERIALS
	int result=5,result1=5;
	String rc_code=(String)session.getAttribute("rc");//getting the code of thr rc which is logged in to the system
		response.setContentType("text/html");
			ResultSet rs=null;
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the connection object with the database
	Statement stmt=con.createStatement();//creating the statement object and getting the reference from the connection
	/*Logic for checking the primary key violation of the transaction*/
	rs=stmt.executeQuery("select * from sc_dispatch_"+current_session+"_"+rc_code+" where sc_code='"+sc_code+"' and crs_code='"+crs_code+"' and date='"+date+"' and remarks='"+remarks+"'");
	if(!rs.next())//this means no duplicate records found in the database and can enter the received details
	{
		int[] actual_qty=new int[blocks.length];//variable for holding the actual quantity of the blocks of the course to Despatch
		int success=0;
		/*logic for getting actual quantity of each block and inserting into sc_dispatch table and updating material table*/
		for(int i=0;i<blocks.length;i++)
		{	
			rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+blocks[i]+"' and medium='"+medium+"'");
			while(rs.next())
			actual_qty[i]=rs.getInt(1);
			if(actual_qty[i]-qty>-1)//IF MATERIAL IS AVAILABLE FOR Despatch THEN THIS SECTION WILL WORK OTHERWISE ELSE BLOCK WILL WORK
			{
				result=stmt.executeUpdate("insert into sc_dispatch_"+current_session+"_"+rc_code+" values('"+sc_code+"','"+crs_code+"','"+blocks[i]+"',"+qty+",'"+medium+"','"+date+"','"+remarks+"')");   
				result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty+" where crs_code='"+crs_code+"' and block='"+blocks[i]+"' and medium='"+medium+"'");
				rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+blocks[i]+"' and medium='"+medium+"'");
				while(rs.next())
				remain_qty=rs.getInt(1);
				if(result==1 && result1==1)
				{
					System.out.println("Successfully despatched to SC "+sc_code+" course code "+crs_code+" sets= "+qty+"");
					msg=msg+crs_code+"&nbsp;&nbsp;&nbsp;&nbsp;"+blocks[i]+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+qty+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+remain_qty+"</br>";
					success++;
				}
				if(result==1 && result1 !=1)
				{
					msg="SC Despatch Table Hitted but Material Table Not Affected...";
					request.setAttribute("msg",msg);
					request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);
				}//end of if
				else if(result!=1 && result1==1)
				{
					msg="No Operation Performed";
					request.setAttribute("msg",msg);
					request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);
				}//end of else if
			}//end of if(actual_qty-qty>1)
			else
			{
				System.out.println("Materials Not Available for Course : "+crs_code);
				msg="Sorry..<br/>Can not Despatch "+qty+" sets of "+blocks[i]+" of "+crs_code+"<br/> As Total sets in stock is "+actual_qty;
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);	
			}//end of else of if(actual_qty-qty------)))
		}/*logic ends here*/
		if(success==blocks.length)
		{
			msg="Successfully dispatched to SC "+sc_code+" "+remarks+"<br/>Course Block Quantity Current stock</br>"+msg+""; 
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);
		}
	}//end of main if(!rs.next())
	else
	{	
		System.out.println("Sorry..Primary key violation..can not enter these details in the System...");
		msg="You Cannot enter these details as they already Exists.<br/>Please Change One or More thing from the Combination of<br/> Study Centre= "+sc_code+"<br/>Course = "+crs_code+"<br/>Date = "+date+"<br/> Remarks= "+remarks;
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);
	}//end of else blocks
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYSCPRIVATESUBMIT.java "+exe);
	msg="Some Serious Exception came.Please check on the Server Console for more Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_sc_office.jsp").forward(request,response);	
}//end of catch
finally	{}//end of finally blocks
}//end of else of session checking
}//end of method
}//end of class BYSCPRIVATESUBMIT