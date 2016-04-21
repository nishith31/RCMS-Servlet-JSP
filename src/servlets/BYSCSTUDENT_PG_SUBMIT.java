package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO STUDENT DESPATCH AND SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE MAINLY.BY THIS
SERVLET SYSTEM SAVE THE DATA OF THOSE STUDENTS TO WHOM MATERIALS ARE DISTRIBUTED BY THE STUDY CENTRE DIRECTLY.THIS SERVLET ALSO CHECKS
FOR THE PRIMARY KEY VOILATION IN THE TWO DESPATCH TABLES, IF NO VIOALTION FOUND THEN SAVES THE DATA TO THE CORRESPONDING TABLES
AND GENERATE APPROPRIATE MSGS.
CALLED JSP:-To_sc_students_pg1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*;
 
public class BYSCSTUDENT_PG_SUBMIT extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYSCSTUDENT_PG_SUBMIT SERVLET STARTED TO EXECUTE");
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
		String button_value				=	 request.getParameter("enter").toUpperCase();			
		button_value				=	 button_value.trim();			
/*LOGIC FOR CHECKING THAT IF USER HAS CLICKED ON BACK BUTTON IF THERE IS NO WAY TO DESPATCH THEN*/	
	if(button_value.equals("BACK"))
	{
			String msg="Welcome Back to the Searching Page";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);			
	}
/*LOGIC ENDS HERE FOR CHECKING THE BACK BUTTON*/	
/*LOGIC FOR DESPATCH THE MATERIALS IF USER HAS CLICKED ON THE DESPATCH BUTTON*/
	else
	{
		String sc_code				=	 request.getParameter("txt_sc_code").toUpperCase();//FIELD FOR STORING THE STUDY CENTRE CODE OF THE STUDENT
		String prg_code				= 	 request.getParameter("txt_prog_code").toUpperCase();//FIELD FOR STORING THE PROGRAM CODE OF THE STUDENT
		String crs_code				= 	 request.getParameter("txt_crs_code").toUpperCase();//FIELD FOR STORING THE COURSE CODE OF THE STUDENTS
		String year					= 	 request.getParameter("txt_year").toUpperCase();//FIELD FOR STORING THE YEAR OR SEMESTER DETAILS OF THE STUDENT
		String medium				= 	 request.getParameter("txt_medium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM OPTED BY THE STUDENT
		String date					= 	 request.getParameter("txt_date").toUpperCase();//FIELD FOR HOLDING THE DATE OF Despatch OF MATERIALS
		String current_session		=	 request.getParameter("txt_session").toLowerCase();//FIELD FOR STORING THE NAME OF THE CURRENT SESSION MEANS CURRENTLY USED SESSION
		String[] student			=	 request.getParameterValues("all_enr");
		String[] name				=	 request.getParameterValues("name");

		int dispatch_student_count=0,index=0;
		int qty						=	 0;//FIELD FOR HOLDING THE NUMBER OF MATERIALS TO BE DISPATCHED TO THE STUDENTS
		String remarks				= 	 "FOR STUDENTS";//FIELD FOR THE REMARKS IN THE SC_DISPATCH TABLE BECAUSE THIS CONTAIN TWO TYPE OF ENTRY ON FOR STUDENT AND OTHER FOR SC OFFICE USE
		String dispatch_source		= 	 "BY SC";//FOR THE DISPATCH_MODE FIELD OF STUDENT_DISPATCH TABLE BECAUSE HERE INFORMATION IS STORED OF MODE OF Despatch TO STUDENTS
		String[] enrno				=	request.getParameterValues("enrno");//ARRAY VARIABLE FOR GETTING ALL THE SELECTED ROLL NUMBERS ON THE BROWSER BY THE CLIENT
		String msg=null;//FIELD FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
		String relative_course=null;
		int actual_qty=0;//FIELD FOR CHECKING THE AVAILABLE QUANTITY OF THE STUDY MATERIAL OF SELECTED COURSE BY THE CLIENT

		String rc_code=(String)session.getAttribute("rc");
		System.out.println("All Parameters received from JSP");	
		int available_qty			=	0;		
			response.setContentType("text/html");
			ResultSet rs=null,blk=null;
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the object of Connection with the database
	Statement stmt=con.createStatement();//creating the object of Statement and getting the reference of Statement object into it from the Connection Object
	int result=5,result1=5,result2=5,blocks=0;
/*	blk=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
	while(blk.next())
	relative_course=blk.getString(1);*/
	if (enrno != null)//if atleast one student has been selected by the user then this section will work and if not selected any student by the user then else section will work.
	{
		qty=enrno.length;//number of sets to be despatched according to the number of checkboxes checked.
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
		while(rs.next())
		actual_qty=rs.getInt(1);
		if(actual_qty-qty>-1)//if stock available then this section will work or else section will work.
		{
			qty=enrno.length;
			for(int i=0;i<enrno.length;i++) 
			{
				result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno[i]+"','"+prg_code+"','"+prg_code+"','PG',1,'"+date+"','"+dispatch_source+"','"+medium+"','NO')");   
			}//end of for loop  
			result2=stmt.executeUpdate("insert into sc_dispatch_"+current_session+"_"+rc_code+" values('"+sc_code+"','"+prg_code+"','PG',"+qty+",'"+medium+"','"+date+"','"+remarks+"')");			
			result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
			if(result==1 && result1==1 && result2==1)
			{
				System.out.println("PRGRAMME GUIDE OF "+prg_code+" dispatched to "+qty+" students of Study centre "+sc_code+"");   
				msg="PROGRAMME GUIDE Of "+prg_code+"<br/> Despatched to "+qty+" Students of Study Centre "+sc_code+"";
			}//end of if
			else if(result==1 && result1 ==1 && result2!=1)
			{
				msg="Despatch and Material Table Hitted but SC despatch Table Not Affected...";
			}//end of else if
			else if(result==1 && result2 ==1 && result1!=1)
			{
				msg="Despatch and SC Despatch table Hitted but Material Table Not affected...";
			}//end of else if
			else
			{
				msg="No Operation Performed.Please Try Again";
			}//end of else
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);			
		}//end of if(actual_qty-qty>1)
		else//if out of stock material then this else section will work
		{
			msg="Can not Despatch "+qty+" PROGRAMME GUIDE OF "+prg_code+" .<br/> As in Stock "+actual_qty+" Sets Only";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);			
		}//end of else of if(actual_qty-qty>1)
	}//end of if (enrno != null) 
	else//if no student has been selected by the user then this else section will work
	{
		System.out.println("No Student Selected ..please select Student");
		msg="Please Select Student Before Submitting";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYSC_PG_SEARCH?mnu_sc_code="+sc_code+"&mnu_prg_code="+prg_code+"&mnu_crs_code="+crs_code+"&textyear="+year+"&textmedium="+medium+"&textsession="+current_session+"").forward(request,response);	
	}//end of else of if (enrno != null) 
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYSCSTUDENT_PG_SUBMIT.java and exception is "+exe);
	msg="Some Serious Exception Hitted the page.Please check on the Server Console for Further Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
}//end of catch blocks
finally
{} //end of finally blocks
}//end of else of if(button_value.equals("BACK"))
}//end of else of session checking
}//end of method doPost()
}//end of class BYSCSTUDENT_PG_SUBMIT