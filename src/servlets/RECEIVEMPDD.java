package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR RECEIVING MATERIAL FROM MPDD COMPLETELY.IF USER WANTS TO RECEIVE MATERIALS PARTIALLY THEN THIS SERVLET WILL REDIRECTS THE PAGE TO FROM_MPDD1.JSP AND THERE WE RECEIVE PARTIALLY .THIS SERVLET TAKES THE COURSE CODE,DATE,MEDIUM AS INPUT AND DISPLAY THE RESULT INTO NEXT PAGE
CALLED JSP:-From_mpdd.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class RECEIVEMPDD extends HttpServlet {

public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("RECEIVEMPDD SERVLET STARTED TO EXECUTE");
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
	String  crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();
		String  crs_code2				=	 request.getParameter("mnu_crs_code2").toUpperCase();
			String  crs_code3				=	 request.getParameter("mnu_crs_code3").toUpperCase();
				String  crs_code4				=	 request.getParameter("mnu_crs_code4").toUpperCase();
					String  crs_code5				=	 request.getParameter("mnu_crs_code5").toUpperCase();
					String  crs_code6				=	 request.getParameter("mnu_crs_code6").toUpperCase();
				String  crs_code7				=	 request.getParameter("mnu_crs_code7").toUpperCase();		
			String  crs_code8				=	 request.getParameter("mnu_crs_code8").toUpperCase();
		String  crs_code9				=	 request.getParameter("mnu_crs_code9").toUpperCase();
	String  crs_code10				=	 request.getParameter("mnu_crs_code10").toUpperCase();		
	/*in case of partial despatch these need not be got*/
	int        qty					=	 Integer.parseInt(request.getParameter("txt_no_of_set"));	
		int        qty2					=	 Integer.parseInt(request.getParameter("txt_no_of_set2"));		
			int        qty3					=	 Integer.parseInt(request.getParameter("txt_no_of_set3"));	
				int        qty4					=	 Integer.parseInt(request.getParameter("txt_no_of_set4"));	
					int        qty5					=	 Integer.parseInt(request.getParameter("txt_no_of_set5"));	
					int        qty6					=	 Integer.parseInt(request.getParameter("txt_no_of_set6"));	
				int        qty7					=	 Integer.parseInt(request.getParameter("txt_no_of_set7"));	
			int        qty8					=	 Integer.parseInt(request.getParameter("txt_no_of_set8"));	
		int        qty9					=	 Integer.parseInt(request.getParameter("txt_no_of_set9"));	
	int       qty10					=	 Integer.parseInt(request.getParameter("txt_no_of_set10"));			
	
	String  medium					=	 request.getParameter("txt_medium").toUpperCase();
	String  date					=	 request.getParameter("txt_date").toUpperCase();
	String current_session			=	 request.getParameter("txt_session").toLowerCase();
	String receipt_type				=	 request.getParameter("receipt_type");
/*LOGIC ENDS FOR GETTING THE PARAMETERS FROM THE REQUEST*/	
	String rc_code			=	(String)session.getAttribute("rc");
	System.out.println("fields from mpdd receive"+"medium is "+medium);
	String msg=null;	
int index=0;
int actual_qty=0;//VARIABLE FOR STORING THE ACTUAL NUMBER OF BOOKS ON THE STORE FROM THE MATERIAL TABLE
int flag_for_return=0;
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
						if(!crs_code6.equals("NONE"))	
						index++;
					if(!crs_code7.equals("NONE"))	
					index++;
				if(!crs_code8.equals("NONE"))	
				index++;
			if(!crs_code9.equals("NONE"))	
			index++;
		if(!crs_code10.equals("NONE"))	
		index++;
			String courses[]		=	new String[index];//STRING ARRAY FOR HOLDING ALL THE SELECTED COURSE CODES
			int qtys[]				=	new int[index];//INTEGER ARRAY FOR HOLDING ALL THE QUANTITIES ENTERED BY USER			
			int insert				=	0;
	if(!crs_code.equals("NONE"))	
	{
		courses[insert]=crs_code;
		qtys[insert]=qty;		
		insert++;
	}
	if(!crs_code2.equals("NONE"))	
	{
		courses[insert]=crs_code2;
		qtys[insert]=qty2;				
		insert++;
	}
	if(!crs_code3.equals("NONE"))	
	{
		courses[insert]=crs_code3;
		qtys[insert]=qty3;				
		insert++;
	}
	if(!crs_code4.equals("NONE"))	
	{
		courses[insert]=crs_code4;
		qtys[insert]=qty4;				
		insert++;
	}
	if(!crs_code5.equals("NONE"))	
	{
		courses[insert]=crs_code5;
		qtys[insert]=qty5;				
		insert++;
	}
	if(!crs_code6.equals("NONE"))	
	{
		courses[insert]=crs_code6;
		qtys[insert]=qty6;				
		insert++;
	}
	if(!crs_code7.equals("NONE"))	
	{
		courses[insert]=crs_code7;
		qtys[insert]=qty7;				
		insert++;
	}
	if(!crs_code8.equals("NONE"))	
	{
		courses[insert]=crs_code8;
		qtys[insert]=qty8;				
		insert++;
	}
	if(!crs_code9.equals("NONE"))	
	{
		courses[insert]=crs_code9;
		qtys[insert]=qty9;				
		insert++;
	}
	if(!crs_code10.equals("NONE"))	
	{
		courses[insert]=crs_code10;
		qtys[insert]=qty10;				
		insert++;
	}
/*LOGIC ENDS OF GETTING THE SELECTED COURSES AND QUANTITES AND STORE THEM IN THE CORRESPONDING ARRAY*/	
int flag=0;	
int result_material=0;
int result_receive=0;
int[] no_of_blocks=new int[index];
int blk_count=0;
ResultSet first=null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE DATABASE
ResultSet block=null;//RESULTSET VARIABLE FOR FETCHING NUMBER OF BLOCKS FROM THE DATABASE
	response.setContentType("text/html");
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	//logic for receiving materials according to the receipt_type selected i.e. either complete or partial
	if(receipt_type.equals("complete"))
	{
	int result=5,result1=5;
/*LOGIC FOR CHECKING THE EXISTING OF THE SAME ENTRY REQUESTED BY USER IN THE DATABASE AND PREPARING APPROPRIATE MESSAGE*/
	msg="Entry Already Exist for Course: <br/>";
	String[] blocks=new String[0];
	for(int i=0;i<courses.length;i++)
	{
		block=stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
		while(block.next())
		{
			blk_count=block.getInt(1);
		}
		no_of_blocks[i]=blk_count;
		blocks=new String[blk_count];
		int count=0;
		for(int j=0;j<blk_count;j++)
		{
			count=j+1;
			blocks[j]="B"+count;
			first=stmt.executeQuery("select * from mpdd_receive_"+current_session+"_"+rc_code+" where crs_code='"+courses[i]+"' and block='"+blocks[j]+"' and medium='"+medium+"' and date='"+date+"'");
			if(first.next())
			{
				flag=1;
				msg=msg+courses[i]+" Block "+blocks[j]+" for date "+date+" in medium "+medium+"<br/>";
			}//end of if first
		}//end of inner for loop
	}//end of outer for loop	
/*LOGIC ENDS OF CHECKING EXISTENCE*/
	if(flag==0)//IF FLAG=0 MEANS CAN ENTER THE DETAILS IN THE DATABASE OTHERWISE ELSE WILL WORK
	{
		msg="Received Successfully from MPDD Course <br/>";
		for(int i=0;i<courses.length;i++)
		{
			int count=0;
			for(int j=0;j<no_of_blocks[i];j++)
			{
				count=j+1;
				blocks=new String[no_of_blocks[i]];
				blocks[j]="B"+count;
				result_receive=stmt.executeUpdate("insert into mpdd_receive_"+current_session+"_"+rc_code+"(crs_code,block,qty,date,medium) values('"+courses[i]+"','"+blocks[j]+"',"+qtys[i]+",'"+date+"','"+medium+"')");
				result_material=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty+"+qtys[i]+" where crs_code='"+courses[i]+"' and block='"+blocks[j]+"' and medium='"+medium+"'");
				msg=msg+courses[i]+" Block "+blocks[j]+" for date "+date+" in medium "+medium+"<br/>";
			}//end of inner for loop
		}//end of outer for loop
		System.out.println("Received Succesfully from MPDD Course code "+crs_code+"");
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request,response);  
	}//end of if(flag==0)
	else//IF ENTRIES ALREADY FOUND THEN THIS ELSE WILL WORK AND GIVE MESSAGE TO THE BROWSER
	{
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request,response);
	}
	}//end of if(receipt_type==complete)
	if(receipt_type.equals("partial"))
	{
		String  prg_code				=	 request.getParameter("mnu_prg_code").toUpperCase();
		for(int i=0;i<courses.length;i++)
		{
			block=stmt.executeQuery("select no_of_blocks from course where crs_code='"+courses[i]+"'");
			while(block.next())
			{
				blk_count=block.getInt(1);
			}
			no_of_blocks[i]=blk_count;
		}
		request.setAttribute("prg_code",prg_code);
		request.setAttribute("courses",courses);
		request.setAttribute("qtys",qtys);//sending the quantities entered by the user to the browser		
		request.setAttribute("no_of_blocks",no_of_blocks);
		request.setAttribute("current_session",current_session);
		request.setAttribute("medium",medium);
		request.setAttribute("date",date);
		request.setAttribute("msg",msg);
		System.out.println("All attributes set for partial receipt in From_mpdd");
		request.getRequestDispatcher("jsp/From_mpdd1.jsp").forward(request,response);		
	}//end of if(receipt_type==partial)
}//end of try
catch(Exception ex)
{
	System.out.println("exception mila rey from From_mpdd page"+ex);
	msg="Some Serious Exception came at the page. Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request,response);
}//end of catch blocks
finally{}//end of finally blocks
}//end of else of session checking
}//end of method 
public void destroy() {	}
}//end of class RECEIVEMPDD