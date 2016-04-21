package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING DATA TO OTHERS RECEIVE TABLE AND UPDATING MATERIAL TABLE.IT ALSO CHECKS THE VIOLATION OF PRIMARY KEY MEANS DUPLICATE DATA CAN NOT
BE ENTER IN THE OTHERS RECEIVE TABLE.THIS SERVLET GETS ALL THE REQUIRED FIELDS FROM THE BROWSER AND AFTER CHECKING ALL THE CONSTRAINTS INSERT AND UPDATE THE CORRESPONDING TABLES
CALLED JSP:-From_others1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class RECEIVEOTHERSPARTIAL extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("RECEIVEOTHERSPARTIAL SERVLET STARTED TO EXECUTE");
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
	String current_session	=	 request.getParameter("txt_session").toLowerCase();//getting the value of current session
	String crs_code			= 	 request.getParameter("mnu_crs_code").toUpperCase();//gettting the course code
	int block_count			=	 0;//int variable for number of blocks available with the course
	String[] temp			=	 new String[0];//array of String for multiple use
	int crs_select=0;//variable used to store number of courses selected to be dispatched
	int index				=		0;
	/*logic for getting the number of total courses selected by user*/
	temp		=	 request.getParameterValues(crs_code);
	if(temp!=null)
	{
		block_count=block_count+temp.length;
	}
	/*logic ends here*/
	String[] course_dispatch	=	 new String[block_count];//array for holding the blocks to be receieved
	String[] blk_qty			=	 new String[block_count];//array for holding the quantity of the blocks to be received
	/*logic for getting all the courses selected by the user*/
	String[] course_block=	 request.getParameterValues(crs_code);
	if(course_block!=null)
	{
		int len_despatch=course_block.length;
		for(int e=0;e<len_despatch;e++)
		{
			course_dispatch[e]=course_block[e];
			System.out.println("block:"+course_dispatch[e]);
			blk_qty[e]=request.getParameter(course_block[e]);
		}//end of for loop of e
	}//end of if(course_block!=null)
	/*logic ends here*/	
	String medium			= 	 request.getParameter("mnu_medium").toUpperCase();
	String date				= 	 request.getParameter("text_date").toUpperCase();//date from the jsp page date field
	String receive_from		= 	 request.getParameter("receive_from").toUpperCase();//receive_from from the jsp page receive_from field
	int qty					=		0;
	int actual_qty			=		0;
	int flag_for_return		=		0;
	ResultSet rs			=	null;
	System.out.println("All the Parameters received");
	request.setAttribute("current_session",current_session);//setting the value of current session to the request
	String msg="";	
	String rc_code=(String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
		response.setContentType("text/html");
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the connection object for the database
	Statement stmt=con.createStatement();//fetching the refernce of the statement from the connection object.
	int result=5,result1=5;
	if (block_count != 0) 
	{
		msg="Entry Already Exist for Course: "+crs_code+" <br/>";
		int len=crs_code.length();
		for(int y=0;y<course_dispatch.length;y++)
		{
			String course_check		=	course_dispatch[y].substring(0,len);
			String block_check		=	course_dispatch[y].substring(len);
			String initial			=	block_check.substring(0,1);
			if(crs_code.equals(course_check))
			{
				if(initial.equals("B"))
				{
					rs=stmt.executeQuery("select * from others_receive_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block_check+"' and medium='"+medium+"' and date='"+date+"'");
					if(rs.next())
					{
						msg=msg+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
						flag_for_return=1;
					}//end of if
				}//end of if(initial.equals("B"))
			}//end of if(crs_code.equals(course_check))
		}//end of for loop of y
		if(flag_for_return==0)
		{
			msg="Received Successfully from Others Course "+crs_code+" <br/>";
			int inc=0;
			for(int y=0;y<course_dispatch.length;y++)
			{
				String course_check=course_dispatch[y].substring(0,len);
				String block_check=course_dispatch[y].substring(len);
				String initial=block_check.substring(0,1);
				if(crs_code.equals(course_check))
				{
					if(initial.equals("B"))
					{
						result=stmt.executeUpdate("insert into others_receive_"+current_session+"_"+rc_code+"(crs_code,block,qty,medium,date,receive_from)values('"+crs_code+"','"+block_check+"',"+blk_qty[y]+",'"+medium+"','"+date+"','"+receive_from+"')");   
						result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty+"+blk_qty[y]+" where crs_code='"+crs_code+"' and block='"+block_check+"' and medium='"+medium+"'");
						msg=msg+" Block "+block_check+" for date "+date+" in medium "+medium+"<br/>";
					}//end of if(initial.equals("B"))
				}//end of if(course[z].equals(course_check))
			}//end of for loop of y
		if(result==1 && result1==1)
		{	
			System.out.println("Materials for "+course_dispatch.length+" courses received from Others");   
		}
		else if(result==1 && result1 !=1)
		{
			System.out.println("Receive table hitted but material table not affected..!!!!!");   
		}
		else
		{
			System.out.println("NO operation performed.!!!!!");   
		}
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);			
			
	}//end of if(flag_for_return=0)
	else//if material is out of stock then this section will work and give message to the user
	{
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
	}//end of else of if(flag_for_return==0)
	}//end of if(block_count!=null)
	else
	{
		System.out.println("Sorry !!Not any courses Selected...");
		msg="Sorry!! Not any courses selected..";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
	}//end of else of if(block_count!=null)
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from RECEIVEOTHERSPARTIAL.java and exception is "+exe);
	msg="Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/From_others.jsp").forward(request,response);
}//end of catch blocks
finally{} //end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class RECEIVEOTHERSPARTIAL