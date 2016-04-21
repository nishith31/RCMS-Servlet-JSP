package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO RC DESPATCH TABLE AND UPDATE INTO MATERIAL TABLE.THIS WILL ALSO CHECK THE VIOLATION OF
THE PRIMARY KEY FIRST IF NO VIOLATION FOUND IN THE RC DESPATCH TABLE THEN WILL SAVE THE REQUESTED DATA TO THE CORRESPONDING
TABLES AND GENERATE APPROPRIATE MESSAGE.
CALLED JSP:-By_rc_pg1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYRC_PG_SUBMIT extends HttpServlet
 {
	public void init(ServletConfig config) throws ServletException 
	{
		System.out.println("BYRC_PG_SUBMIT SERVLET STARTED FROM INIT METHOD");
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
	String reg_code			=	 	request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String reg_name			=	 	request.getParameter("mnu_reg_name").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String prg_code			=	 request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	int qty					=	 Integer.parseInt(request.getParameter("text_qty"));
	String medium			= 	 request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
	String date				= 	 request.getParameter("txtdate");//FIELD FOR HOLDING THE DATE SELECTED BY THE STUDENT
	String remarks			= 	 request.getParameter("txtrsn").toUpperCase();//FIELD FOR HOLDING THE REASON FOR Despatch OF MATERIAL TO REGIONAL CENTRE
	String current_session	=	 request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
	int remain_qty=0;																//FIELD FOR HOLDING THE REMAINING QUANTITY AFTER Despatch
	int actual_qty=0;															//FIELD FOR HOLDING THE AVAILABLE QUANTITY OF MATERIALS BEFORE Despatch IN STOCK
	int result=5,result1=5;
	String msg=null;
	ResultSet rs=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
	String rc_code=(String)session.getAttribute("rc");//getting the rc code of the logged rc from the session
	
		response.setContentType("text/html");
try
{
	Connection con		=	connections.ConnectionProvider.conn();
	Statement stmt		=	con.createStatement();
	int flag_for_return	=	0,	flag_for_duplicate=0;
	String qty_remain=""; 
	
	rs=stmt.executeQuery("select * from rc_dispatch_"+current_session+"_"+rc_code+" where reg_code='"+reg_code+"' and crs_code='"+prg_code+"' and block='PG' and date='"+date+"'");
	if(!rs.next())//IF DUPLICATE RECORDS NOT FOUND THEN ENTER ON THIS SECTION FOR FURTHER ACTIONS OTHERWISE TO ELSE BLOCK.
	{
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
		while(rs.next())
		actual_qty=rs.getInt(1);
		if(actual_qty-qty>-1)
		{
			result=stmt.executeUpdate("insert into rc_dispatch_"+current_session+"_"+rc_code+" values('"+reg_code+"','"+prg_code+"','PG',"+qty+",'"+medium+"','"+date+"','"+remarks+"')");   
			result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
			rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
			while(rs.next())
			{
				remain_qty=rs.getInt(1);
				qty_remain=qty_remain+remain_qty+" set remained of PROGRAMME GUIDE OF "+prg_code+" <br/>";
			}

			if(result==1 && result1==1)
			{	
				msg=""+qty+" PRGRAMME GUIDE OF "+prg_code+" Despatched to "+reg_name+"("+reg_code+").<br/>"+qty_remain;
			}
			else if(result==1 && result1 !=1)
			{
				msg="Despatch table Hitted but material Table not Affected!!!";
			}
			else
			{
				msg="No Operation Performed..!!";
			}
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request,response);	
		}//end of if(actual_qty-qty>-1)
		else
		{
			System.out.println("Materials out of Stock,Demanded "+qty+" Sets and in Store "+actual_qty+" Sets");
			msg="Can not Despatch as material is out of stock.";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request,response);	
		}//end of else of if(actual_qty-qty>-1)
	}//end of if(!rs.next())
	else
	{
		System.out.println("Records Already Exists..primary key violation.");
		msg="Can not Enter these Details As they Already Exist.<br/>Change one or more values from the Combination of<br>RC= "+reg_name+"("+reg_code+")<br/> Programme Code:"+prg_code+"<br/>Date: "+date+"";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request,response);
	}//end of else of if(!rs.next())
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYRC_PG_SUBMIT.java and is "+exe);
	msg="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request,response);
}//end of catch blocks
finally		
{} //END OF FINALLY BLOCKS
}//end of else of session checking
}//end of method
}//end of class BYRC_PG_SUBMIT