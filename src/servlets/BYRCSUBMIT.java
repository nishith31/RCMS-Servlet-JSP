package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO RC DESPATCH TABLE AND UPDATE INTO MATERIAL TABLE.THIS WILL ALSO CHECK THE VIOLATION OF
THE PRIMARY KEY FIRST IF NO VIOLATION FOUND IN THE RC DESPATCH TABLE THEN WILL SAVE THE REQUESTED DATA TO THE CORRESPONDING
TABLES AND GENERATE APPROPRIATE MESSAGE.
CALLED JSP:-To_rc1.jsp*/
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
public class BYRCSUBMIT extends HttpServlet
 {
	/**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException 
	{
		System.out.println("BYRCSUBMIT SERVLET STARTED FROM INIT METHOD");
		super.init(config);
	} 
public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
	HttpSession session=request.getSession(false);//getting and checking the availability of session of java
	if(isNull(session))	{
		String message = Constants.LOGIN_ACCESS_MESSAGE;
		request.setAttribute("msg", message);
		request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
	}
	else
	{
	String reg_code			=	 	request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String prg_code			=	 request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
	String[] course			=	 request.getParameterValues("crs_code");//all the course codes from the jsp page
	String[] quantity		=	 request.getParameterValues("txt_no_of_set");
	int[] 		 qty		=	 new int[quantity.length];
	int block_count	=0,block=0,count=0;
	String[] temp			=	 new String[0];
	int crs_select			=	 0;//variable used to store number of courses selected to be dispatched
	for(int i=0;i<quantity.length;i++)
	{
		qty[i]					=	 Integer.parseInt(quantity[i]);//FIELD FOR HOLDING THE QUANTITY OF MATERIALS TO BE DESPATCHED
	}
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
	/*logic for getting the number of total courses selected by user*/
	for(int c=0;c<course.length;c++)
	{
		temp		=	 request.getParameterValues(course[c]);
		if(temp!=null)
		{
			crs_select++;
			block_count		=block_count+temp.length;
		}
	}//end of loop for int c
	/*logic ends here*/
	String[] course_dispatch	=	 new String[block_count];//array for holding the courses to be dispatched
	/*logic for getting all the courses selected by the user*/
	for(int d=0;d<course.length;d++)
	{
		String[] course_block=	 request.getParameterValues(course[d]);
		if(course_block!=null)
		{
			int len=course_block.length;
			for(int e=0;e<len;e++)
			{
				course_dispatch[count]=course_block[e];
				count++;
			}
		}
	}
	/*logic ends here*/
	if (block_count != 0) 
	{
		block=block_count;
		for(int z=0;z<course.length;z++)
		{
			int len=course[z].length();
			for(int y=0;y<course_dispatch.length;y++)
			{
				String course_check=course_dispatch[y].substring(0,len);
				String block_check=course_dispatch[y].substring(len);
				String initial=block_check.substring(0,1);
				if(course[z].equals(course_check))
				{
					if(initial.equals("B"))
					{
rs=stmt.executeQuery("select * from rc_dispatch_"+current_session+"_"+rc_code+" where reg_code='"+reg_code+"' and crs_code='"+course[z]+"' and block='"+block_check+"' and date='"+date+"'");
						if(!rs.next())//IF DUPLICATE RECORDS NOT FOUND THEN ENTER ON THIS SECTION FOR FURTHER ACTIONS OTHERWISE TO ELSE BLOCK.
						{
rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
					while(rs.next())
							actual_qty=rs.getInt(1);
							if(actual_qty<1)
							{
								flag_for_return++;
								msg=msg+" 1 set of Block "+block_check.substring(1)+" of "+course[z]+" Course.<br/>";
							}//end of if
						}//end of if(!rs.next)
						else
						{
							flag_for_duplicate=1;
						}//end of else(!rs.next)
					}//end of if(initial.equals("B"))
				}//end of if(course[z].equals(course_check))
			}//end of for loop of y
		}//end of for loop z
		if(flag_for_duplicate==0)
		{
		if(flag_for_return==0)
		{
			for(int z=0;z<course.length;z++)
			{
				int len=course[z].length();
				for(int y=0;y<course_dispatch.length;y++)
				{
					String course_check=course_dispatch[y].substring(0,len);
					String block_check=course_dispatch[y].substring(len);
					String initial=block_check.substring(0,1);
					if(course[z].equals(course_check))
					{
						if(initial.equals("B"))
						{
result=stmt.executeUpdate("insert into rc_dispatch_"+current_session+"_"+rc_code+" values('"+reg_code+"','"+course[z]+"','"+block_check+"',"+qty[z]+",'"+medium+"','"+date+"','"+remarks+"')");   
result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty[z]+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
							while(rs.next())
							{
								remain_qty=rs.getInt(1);
								qty_remain=qty_remain+" set remained of "+block_check+" of "+course[z]+": "+remain_qty+"<br/>";
							}
						}//end of if(initial.equals("B"))
					}//end of if(course[z].equals(course_check))
				}//end of for loop of y
			}//end of for loop z
			if(result==1 && result1==1)
			{	
				msg=""+course_dispatch.length+" books dispatched to "+reg_code+".<br/>"+qty_remain;
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
			request.getRequestDispatcher("jsp/To_rc.jsp").forward(request,response);	
		}//end of if(flag_for_return=0)
		else
		{
			System.out.println("Materials out of Stock,Demanded "+qty+" Sets and in Store "+actual_qty+" Sets");
			msg="Can not Despatch";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_rc.jsp").forward(request,response);	
		}//end of else of if(flag_for_return=0)
		}//end of if(flag_for_duplicate=0)
		else
		{
			System.out.println("Records Already Exists..primary key violation.");
			msg="Can not Enter these Details As they Already Exist.<br/>Change one or more values from the Combination of<br>RC= "+reg_code+"<br/>";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_rc.jsp").forward(request,response);
		}//end of else of if(flag_for_duplicate=0)
	}//end of if(block_count!=null)
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
 
}//end of class BYRCSUBMIT