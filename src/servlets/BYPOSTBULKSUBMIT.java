package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR DESPATCHING MATERIAL BY POST TO STUDENTS IN BULK MODE,IT TAKES DETAILS OF ALL THE STUDENTS TO WHOM MATERIALS HAS TO BE SENT AND ALSO TAKES THE COURSE CODE AND MEDIUM AND THEN ENTER ALL THE TRANSACTION IN STUDENT DESPATCH TABLE WITH REMARKS BY POST AND IN THE MATERAILA TABLE UPDATE THE INVENTORY WHICH IS NOW LESS FROM THE EARLIER QUANTITY.
CALLED JSP:-By_post_bulk2.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;  
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYPOSTBULKSUBMIT extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
		super.init(config);
		System.out.println("BYPOSTBULKSUBMIT SERVLET STARTED TO EXECUTE");
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
/*Logic for getting all the parameters from the Browser via the request*/
	String prg_code				= 	 request.getParameter("mnu_prg_code").toUpperCase();
				System.out.println("Program code received: "+prg_code);	
	String crs_code				= 	 request.getParameter("mnu_crs_code").toUpperCase();
				System.out.println("Course code received: "+crs_code);	
	String block_name			=	 request.getParameter("block_name").toUpperCase();
				System.out.println("Block Name received: "+block_name);	
	String current_session		=	 request.getParameter("text_session").toLowerCase();
				System.out.println("Current Session received: "+current_session);	
	String medium				= 	 request.getParameter("text_medium").toUpperCase();
				System.out.println("Medium received: "+medium);	
	String lot					= 	 request.getParameter("text_lot").toUpperCase();
				System.out.println("Lot no received: "+lot);	
	String date					= 	 request.getParameter("text_date").toUpperCase();
				System.out.println("Date received: "+date);	
	String pkt_type				=	 request.getParameter("text_pkt_type").toUpperCase();
				System.out.println("Packet Type received: "+pkt_type);	
	String first_timer			=	 request.getParameter("first_timer").toUpperCase();
				System.out.println("first_timer received: "+first_timer);	
	int pkt_weight				=	 Integer.parseInt(request.getParameter("text_pkt_wt"));
				System.out.println("Packet weight received: "+pkt_weight);	
	int initial_block			=	 Integer.parseInt(request.getParameter("initial_block"));
				System.out.println("Initial Block received: "+initial_block);	
	int number_of_blocks		=	 Integer.parseInt(request.getParameter("number_of_blocks"));
		number_of_blocks		=	 number_of_blocks-1;
				System.out.println("Number of Block received: "+number_of_blocks);	
	String challan_no			=	 request.getParameter("text_chln_no").toUpperCase();
				System.out.println("Challan no received: "+challan_no);	
	String button_value				=	 request.getParameter("enter").toUpperCase();			
		button_value				=	 button_value.trim();			
				System.out.println("Value of Button: "+button_value);	
	String[] enrno		=	new String[0];
	int index=0;
if(button_value.equals("SKIP"))
{
System.out.println("Entered into skip block");
}
else
{			enrno				=	 request.getParameterValues("enrno");
			System.out.println("Student selected for despatched are: "+enrno.length);	
}
			String[] student				=	 request.getParameterValues("all_enr");
			System.out.println("Total Number of Students: "+student.length);	
			String[] name				=	 request.getParameterValues("name");
			System.out.println("Total Name of Students: "+name.length);	
			String[] serial_number			=	 request.getParameterValues("serial");
			System.out.println("Total Number of Serial Numbers: "+serial_number.length);	
			String[] hidden_course			=	 request.getParameterValues("hide_course");
			System.out.println("Total Number of hidden course : "+hidden_course.length);	
	
	int qty						=	0;
	int actual_qty				=	0;
	int remain_qty				=	0;
	String dispatch_source		= 	 "BY POST";
	int start					=	 Integer.parseInt(request.getParameter("text_start"));
	int end						=	 Integer.parseInt(request.getParameter("text_end"));
	int final_length			=	student.length;
		String msg=null;	
		ResultSet rs=null;//ResultSet variable for  fetching the data from the statement
			String rc_code=(String)session.getAttribute("rc");
			request.setAttribute("first_timer",			first_timer);		
			request.setAttribute("number_of_blocks",	number_of_blocks);		
			request.setAttribute("initial_block",		initial_block);
			request.setAttribute("student",				student);
			request.setAttribute("name",				name);
			request.setAttribute("serial_number",		serial_number);
			request.setAttribute("hidden_course",		hidden_course);
			request.setAttribute("start",				start);
			request.setAttribute("end",					end);

			request.setAttribute("date",				date);
			request.setAttribute("packet_type",			pkt_type);
			request.setAttribute("packet_weight",		pkt_weight);
			request.setAttribute("challan_no",			challan_no);
			request.setAttribute("current_session",		current_session);					
			System.out.println("Attributes settled in request");
			response.setContentType("text/html");
try
{
	Connection con=connections.ConnectionProvider.conn();//connection object for connecting with the database
	Statement stmt=con.createStatement();//Statement object and fetching the reference from the conneciton object
	int result=0,result1=0,result2=5,blocks=0;
	/*logic for fetching the number of blocks of the course selected by the user to Despatch*/
	/*logic ends here*/
if(button_value.equals("SKIP"))
{
	int[] dispatch_index;				
		if(number_of_blocks>0)
		{
			/*logic for checking the students filtered above in the Despatch table*/
			int j=0;
			j=initial_block-number_of_blocks;
			String block="B"+j;
			int sam=0;
			for(int i=0;i<final_length;i++)
			{
				try
				{
					rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"'");
					if(rs.next())
					{sam++;}
				}catch(Exception ecc){System.out.print("nahi hai "+student[i]+" "+ecc);}
			}//end of for loop
			dispatch_index=new int[sam];
			sam=0;
			for(int i=0;i<final_length;i++)
			{
			try
			{
				rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"'");
					if(rs.next())
					{	
						dispatch_index[sam]=i;
						sam++;
					}//end of if
			}catch(Exception jd){System.out.print("nahi hai "+jd);}
			}//end of for loop
			int available_qty=0;
			j=j-1;
			msg="You have Skipped the despatch of Block "+j+".";
			/*Logic for creating int variable of available sets of the course selected*/
			rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"'");
			while(rs.next())
			available_qty=rs.getInt(1);
			request.setAttribute("available_qty",available_qty);
			
				request.setAttribute("dispatch_index",dispatch_index);
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code="+prg_code+"&crs_code="+crs_code+"&medium="+medium+"&lot="+lot+"&start="+start+"&end="+end+"&length="+final_length+"").forward(request,response);
			}//end of if(number_of_blocks>0)
			else
			{
				msg="Complete despatch";
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
			}//end of else of if(number_of_blocks>0)
}//end of if(button_value.equals("SKIP")
else
{
	if (enrno != null)//checking that any student has been selected or not if not then redirect to the browser
	{
		String hii[]=new String[enrno.length];
		for(index=0;index<enrno.length;index++)
		{
			for(int k=0;k<student.length;k++)
			{
				if(enrno[index].equals(student[k]))
				hii[index]=hidden_course[k];
			}//end of for loop of k
		}//end of for loop of index
	
		qty=enrno.length;//getting the total number of student selected by the user
		rs=stmt.executeQuery("select TOP 1 qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block_name+"' and medium='"+medium+"' ");
		while(rs.next())
		actual_qty=rs.getInt(1);
		if(actual_qty-qty>-1)//checking that stock available or not for course selected if not then else parr will work
		{
			if(prg_code.equals("ALL"))
			{
				for(int i=0;i<enrno.length;i++) 
				{
					result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry)values('"+enrno[i]+"','"+hii[i]+"','"+block_name+"',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+challan_no+"',"+pkt_weight+",'"+pkt_type+"','NO')");
				}//end of for loop i
			}//end of second if(prg_code.equals("ALL")
			else
			{
				for(int i=0;i<enrno.length;i++) 
				{
						result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry)values('"+enrno[i]+"','"+prg_code+"','"+hii[i]+"','"+block_name+"',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+challan_no+"',"+pkt_weight+",'"+pkt_type+"','NO')");
				}//end of for loop i
			}//end of else
			/*Logic for updating the material table after inserting the records into the student Despatch table*/
				result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty+" where crs_code='"+crs_code+"' and block='"+block_name+"' and medium='"+medium+"'");
				System.out.println(result1);
			/*Logic ends here for  updating the material table*/
				if(result==1 && result1==1)
				{	
					System.out.println("Material of "+crs_code+" of "+block_name+" despatched to "+qty+" students of Study By Post");
					msg="Material of "+crs_code+" of "+block_name+" Despatched to "+qty+" students By Post";
				}
				else if(result==1 && result1 !=1)
				{	
					System.out.println("Despatch table hitted but material table not affected..!!!!!!");   
					msg="Despatch Table Hitted but material table Not Affected..";
				}
				else if(result!=1 && result1==1)
				{
					System.out.println("Material table affected..but despatch table not..!!!!!!");   
					msg="Material Table Affected ,but Despatch table not affected..";
				}	
				else
				{
					System.out.println("NO operation performed.!!!!!!");   
					msg="No Operation Performed";
				}
				//request.setAttribute("dispatch_index",dispatch_index);
				
				int[] dispatch_index;				
			if(number_of_blocks>0)
			{
				/*logic for checking the students filtered above in the Despatch table*/
				int j=0;
				j=initial_block-number_of_blocks;
				String block="B"+j;
				System.out.println("Created Block name is: "+block);
				int sam=0;
				for(int i=0;i<final_length;i++)
				{
					try
					{
						rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and crs_code='"+hidden_course[i]+"' and block='"+block+"' and medium='"+medium+"'");
						if(rs.next())
						{System.out.println("student found in Despatch table is: "+rs.getString(1));
						sam++;}
					}catch(Exception ecc){System.out.print("nahi hai "+student[i]+" "+ecc);}
				}//end of for loop
				System.out.println("length of Despatch students "+sam);
				dispatch_index=new int[sam];
				sam=0;
				for(int i=0;i<final_length;i++)
				{
				try
				{
					rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and crs_code='"+hidden_course[i]+"' and block='"+block+"' and medium='"+medium+"'");
						if(rs.next())
						{	
							dispatch_index[sam]=i;
							sam++;
						}//end of if
				}catch(Exception jd){System.out.print("nahi hai "+jd);}
				}//end of for loop
				int available_qty=0;
				/*Logic for creating int variable of available sets of the course selected*/
				rs=stmt.executeQuery("select TOP 1 qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"' order by qty");
				while(rs.next())
				available_qty=rs.getInt(1);
				request.setAttribute("available_qty",available_qty);
					request.setAttribute("dispatch_index",dispatch_index);
					request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code="+prg_code+"&crs_code="+crs_code+"&medium="+medium+"&lot="+lot+"&start="+start+"&end="+end+"&length="+final_length+"").forward(request,response);
			}
			else
			{
				msg="Complete Despatch of Course "+crs_code;
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
			}//end of else blocks
		}//end of if(actual_qty-qty>-1)
		else
		{
			System.out.println("Sorry...Materials out of stock for "+crs_code+".As only "+actual_qty+" Sets are in Stock");
			msg="Can not Despatch "+qty+" Sets of "+crs_code+"<br/> As in Stock Only "+actual_qty+" Sets";
			request.setAttribute("alternate_msg",msg);
			request.getRequestDispatcher("BYPOSTBULKSEARCH?mnu_prg_code="+prg_code+"&mnu_crs_code="+crs_code+"&mnu_medium="+medium+"&text_lot="+lot+"&text_start="+start+"&text_end="+end+"&").forward(request,response);
		}//end of else of if(actual_qty-qty>-1)
	}//end of if (enrno != null) 	
	else 
	{
		System.out.println("NO roll no selected..please select any roll no first..sending to servlet again");
		msg="No Roll Number Selected<br/>";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYPOSTBULKSEARCH?mnu_prg_code="+prg_code+"&mnu_crs_code="+crs_code+"&mnu_medium="+medium+"&text_lot="+lot+"&text_start="+start+"&text_end="+end+"&").forward(request,response);
	
	}//end of else of if (enrno != null)
}//end of else of if(button_value.equals("SKIP")
}//end of try blocks
catch(Exception exe)
{
	System.out.println("EXCEPTION ON THE BYPOSTBULKSUBMIT SERLVET AND EXCEPTION IS "+exe);   
	msg="Some Serious exception come on the page.Please check on the Server Console for More Details.";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
	}//end of catch blocks
	finally
	{} //end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class BYPOSTBULKSUBMIT