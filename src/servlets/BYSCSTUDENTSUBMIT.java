package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO STUDENT DESPATCH AND SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE MAINLY.BY THIS
SERVLET SYSTEM SAVE THE DATA OF THOSE STUDENTS TO WHOM MATERIALS ARE DISTRIBUTED BY THE STUDY CENTRE DIRECTLY.THIS SERVLET ALSO CHECKS
FOR THE PRIMARY KEY VOILATION IN THE TWO DESPATCH TABLES, IF NO VIOALTION FOUND THEN SAVES THE DATA TO THE CORRESPONDING TABLES
AND GENERATE APPROPRIATE MSGS.
CALLED JSP:-To_sc_students1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.*;
import javax.servlet.http.*; 
public class BYSCSTUDENTSUBMIT extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYSCSTUDENTSUBMIT SERVLET STARTED TO EXECUTE");
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
	String sc_code				=	 request.getParameter("txt_sc_code").toUpperCase();//FIELD FOR STORING THE STUDY CENTRE CODE OF THE STUDENT
		String prg_code				= 	 request.getParameter("txt_prog_code").toUpperCase();//FIELD FOR STORING THE PROGRAM CODE OF THE STUDENT
			String crs_code				= 	 request.getParameter("txt_crs_code").toUpperCase();//FIELD FOR STORING THE COURSE CODE OF THE STUDENTS
				String year					= 	 request.getParameter("txt_year").toUpperCase();//FIELD FOR STORING THE YEAR OR SEMESTER DETAILS OF THE STUDENT
					String medium				= 	 request.getParameter("txt_medium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM OPTED BY THE STUDENT
						String date					= 	 request.getParameter("txt_date").toUpperCase();//FIELD FOR HOLDING THE DATE OF Despatch OF MATERIALS
						String current_session		=	 request.getParameter("txt_session").toLowerCase();//FIELD FOR STORING THE NAME OF THE CURRENT SESSION MEANS CURRENTLY USED SESSION
					String block_name			=	 request.getParameter("block_name").toUpperCase();
				int initial_block			=	 Integer.parseInt(request.getParameter("initial_block"));
			int number_of_blocks		=	 Integer.parseInt(request.getParameter("number_of_blocks"));
			number_of_blocks			=	 number_of_blocks-1;
		String first_timer			=	 request.getParameter("first_timer").toUpperCase();
	String button_value				=	 request.getParameter("enter").toUpperCase();			
	button_value				=	 button_value.trim();			
	
	String[] student				=	 request.getParameterValues("all_enr");
		System.out.println("Total Number of Students: "+student.length);	
	String[] name				=	 request.getParameterValues("name");
			System.out.println("Total Name of Students: "+name.length);	
	String[] hidden_course			=	 request.getParameterValues("hide_course");
		System.out.println("Total Number of hidden course : "+hidden_course.length);	
			
		
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
			request.setAttribute("first_timer",	first_timer);		
				request.setAttribute("number_of_blocks",	number_of_blocks);		
					request.setAttribute("initial_block",		initial_block);
						request.setAttribute("student",				student);
							request.setAttribute("name",				name);
						request.setAttribute("hidden_course",hidden_course);			
					request.setAttribute("semester",		year);
				request.setAttribute("current_session",current_session);		
			request.setAttribute("date",date);		
						
		int available_qty			=	0;		
		response.setContentType("text/html");
		PrintWriter out=response.getWriter();
		ResultSet rs=null,blk=null;
try
{
	Connection con=connections.ConnectionProvider.conn();//creating the object of Connection with the database
	Statement stmt=con.createStatement();//creating the object of Statement and getting the reference of Statement object into it from the Connection Object
	int result=5,result1=5,result2=5,blocks=0;
	blk=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
	while(blk.next())
	relative_course=blk.getString(1);
	
/*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/	
	String[] relative_crs_code=new String[0];
	rs	=	stmt.executeQuery("select count(*) from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
		if(rs.next())
		relative_crs_code=new String[rs.getInt(1)];
	index=0;
	rs	=	stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
	while(rs.next())
	{
		relative_crs_code[index]=rs.getString(1);
		index++;
	}
/*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
	String despatch_crs_code="(crs_code='"+crs_code+"'";		
	for(index=0;index<relative_crs_code.length;index++)
	{
		despatch_crs_code=despatch_crs_code+" or crs_code='"+relative_crs_code[index]+"'";
	}//end of for loop
	despatch_crs_code=despatch_crs_code+")";		
/*LOGIC ENDS HERE OF GETTING RELATIVE COURSE CODE IN DESPATCH DATABASE*/	

if(button_value.equals("SKIP"))
{
			if(number_of_blocks>0)
			{
				int j=0;
				j=initial_block-number_of_blocks;
				String block="B"+j;
				System.out.println("Created Block name is: "+block);
				int sam=0;
				
				for(index=0;index<student.length;index++)
				{
					rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and "+despatch_crs_code+" and block='"+block+"' and reentry='NO'");
					if(rs.next())
					{	
						dispatch_student_count++;
					}//end of if
				}//end of for loop
				String[] dispatch_student		= new String[dispatch_student_count];
				String[] dispatch_name			= new String[dispatch_student_count];
				String[] dispatch_date			= new String[dispatch_student_count];
				String[] dispatch_mode			= new String[dispatch_student_count];
				System.out.println("Array of Student Dispatched Created of length "+dispatch_student_count);
				index=0;
				int insert_index=0;
/*Inserting the Roll Numbers of the Despatched Students of the Study Centres*/		
			for(index=0;index<student.length;index++)
			{
				rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and "+despatch_crs_code+" and block='"+block+"' and reentry='NO'");
				if(rs.next())
				{
						dispatch_student[insert_index]			=	rs.getString(1);
						dispatch_date[insert_index]				=	rs.getDate(6).toString();
						dispatch_mode[insert_index]				=	rs.getString(7);
					insert_index++;
				}//end of if
			}//end of for loop
			System.out.println("loop se bahar aaya rey..");
/*CREATING ARRAY OF DESPATCHED NAMES FROM THE ARRAY OF ALL STUDENTS EARLIER CREATED IN THE SERVLET*/			
				for(index=0;index<dispatch_student.length;index++)
				{
					for(int z=0;z<student.length;z++)
					{
						if(dispatch_student[index].equals(student[z]))
							{
								dispatch_name[index]=name[z];
							}
					}//end of inner for loop
				}//end of for loop
/*LOGIC FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/
				rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"'");
				while(rs.next())
				available_qty=rs.getInt(1);
				request.setAttribute("available_qty",available_qty);
/*LOGIC ENDS HERE FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/					
/*SETTING THE DESPATCH INDEXES FOR THE NEXT PAGE*/
				request.setAttribute("dispatch_student",dispatch_student);
					request.setAttribute("dispatch_date",dispatch_date);
					request.setAttribute("dispatch_mode",dispatch_mode);
				request.setAttribute("dispatch_name",dispatch_name);
		
				try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
		
				j=j-1;
				if(msg==null)
				msg="You have Skipped the Despatch Of Block "+j+".";
				else
				msg=msg+" <br/>You have Skipped the Despatch of Block "+j+".";

				request.setAttribute("msg",msg);
				System.out.println("sc_code= "+sc_code+" prg_code= "+prg_code+" crs_code= "+crs_code+" year= "+year+" medium= "+medium+" sets= "+student.length );
				request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code="+sc_code+"&prg_code="+prg_code+"&crs_code="+crs_code+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
			}//end of if(number_of_blocks>1)
			else
			{
				msg="Complete Despatch OF COURSE "+crs_code+"<br/>";
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
			}//end of else of if(number_of_blocks>1)	
}//end of if(button_value.equals("SKIP"))
else//IF USER HAS CLICKED ON DESPATCH BUTTON THEN THIS ELSE SECTION WILL WORK
{	
	if (enrno != null)//if atleast one student has been selected by the user then this section will work and if not selected any student by the user then else section will work.
	{
		/*LOGIC FOR FILTERING THE ACTUAL COURSE CODES RECEIVED AS HIDDEN FILED FROM THE BROWSER*/
		String hii[]=new String[enrno.length];
		for(index=0;index<enrno.length;index++)
		{
			for(int k=0;k<student.length;k++)
			{
				if(enrno[index].equals(student[k]))
				hii[index]=hidden_course[k];
			}
		}
		/*LOGIC ENDS HERE FOR FILTERING THE ACTUAL COURSE CODE*/
		qty=enrno.length;	//number of sets to be despatched according to the number of checkboxes checked.
		/*LOGIC FOR GETTING THE ACTUAL CURRENT QUANTITY OF THE BLOCK FROM MATERIAL DATABASE IN ACTUAL_QTY VARIABLE*/
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block_name+"' and medium='"+medium+"'");
			while(rs.next())
			actual_qty=rs.getInt(1);
		/*LOGIC ENDS HERE FOR GETTING THE ACTUAL CURRENT QUANTITY*/
		if(actual_qty-qty>-1)//if stock available then this section will work or else section will work.
		{
			qty=enrno.length;
			for(int i=0;i<enrno.length;i++) 
			{
				result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno[i]+"','"+prg_code+"','"+hii[i]+"','"+block_name+"',1,'"+date+"','"+dispatch_source+"','"+medium+"','NO')");   
			}//end of for loop  
			result2=stmt.executeUpdate("insert into sc_dispatch_"+current_session+"_"+rc_code+" values('"+sc_code+"','"+crs_code+"','"+block_name+"',"+qty+",'"+medium+"','"+date+"','"+remarks+"')");			
			result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-"+qty+" where crs_code='"+crs_code+"' and block='"+block_name+"' and medium='"+medium+"'");

			if(result==1 && result1==1 && result2==1)
			{
				System.out.println("Material of "+crs_code+" Despatched to "+qty+" Students<br/>Of Study centre "+sc_code+"");   
				msg="Material of Block "+block_name+" Of<br/> Course "+crs_code+" Despatched <br/>to "+qty+" Students of Study Centre "+sc_code+"";
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
			if(number_of_blocks>0)//IF MORE BLOCKS TO BE DESPATCHED THEN THIS IF SECTION WILL WORK
			{
				int j=0;
				j=initial_block-number_of_blocks;
				String block="B"+j;
				int sam=0;				
				for(index=0;index<student.length;index++)
				{
					rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and "+despatch_crs_code+" and block='"+block+"' and reentry='NO'");
					if(rs.next())
					{	
						dispatch_student_count++;
					}//end of if
				}//end of for loop
				String[] dispatch_student		= new String[dispatch_student_count];
				String[] dispatch_name			= new String[dispatch_student_count];
				String[] dispatch_date			= new String[dispatch_student_count];
				String[] dispatch_mode			= new String[dispatch_student_count];
				index=0;
				int insert_index=0;
/*INSERTING THE ROLL NUMBERS OF THE DESPATCHED STUDENTS OF TEH STUDY CENTRES*/		
			for(index=0;index<student.length;index++)
			{
					rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and "+despatch_crs_code+" and block='"+block+"' and reentry='NO'");
				if(rs.next())
				{
						dispatch_student[insert_index]			=	rs.getString(1);
						dispatch_date[insert_index]				=	rs.getDate(6).toString();
						dispatch_mode[insert_index]				=	rs.getString(7);
					insert_index++;
				}//end of if
			}//end of for loop

/*CREATING ARRAY OF DESPATCHED NAMES FROM THE ARRAY OF ALL STUDENTS EARLIER CREATED IN THE SERVLET*/			
				for(index=0;index<dispatch_student.length;index++)
				{
					for(int z=0;z<student.length;z++)
					{
						if(dispatch_student[index].equals(student[z]))
							{
								dispatch_name[index]=name[z];
							}
					}//end of inner for loop
				}//end of for loop

/*LOGIC FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED IN MATERIAL DATABASE*/
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='"+block+"' and medium='"+medium+"'");
			while(rs.next())
			available_qty=rs.getInt(1);
		request.setAttribute("available_qty",available_qty);
/*LOGIC ENDS HERE FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/					
/*SETTING ALL THE DESPATCH RELATED INROMATION ON THE REQUEST TO THE NEXT PAGE*/
				request.setAttribute("dispatch_student",dispatch_student);
					request.setAttribute("dispatch_date",dispatch_date);
					request.setAttribute("dispatch_mode",dispatch_mode);
				request.setAttribute("dispatch_name",dispatch_name);
				
				try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
				if(msg==null)
				msg="";
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code="+sc_code+"&prg_code="+prg_code+"&crs_code="+crs_code+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
			}//end of if(number_of_blocks>1)
			else//IF NO MORE BLOCK IS TO BE DESPATCH THEN THIS LOGIC WILL WORK
			{
				msg="Complete Despatch OF COURSE "+crs_code+".<br/>";
				request.setAttribute("msg",msg);
				request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
			}//end of else of if(number_of_blocks>1)
			}//end of if(actual_qty-qty>1)
		else//if out of stock material then this else section will work
		{
			System.out.println("Materials of "+crs_code+" Course can not dispatched to "+qty+" Students as out of Stock");
			msg="Can not Despatch "+qty+" Sets of Block "+block_name+" of<br/> Course "+crs_code+" Course<br/> As in Stock "+actual_qty+" Sets Only";
			request.setAttribute("msg",msg);
			request.setAttribute("number_of_blocks",	number_of_blocks);		
			request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);			
		}//end of else of if(actual_qty-qty>1)
	}//end of if (enrno != null) 
	else//IF NO STUDENT HAS BEEN SELECTED BY THE USER THEN THIS ELSE SECTION WILL WORK
	{
		System.out.println("No Student Selected ..please select Student");
		msg="Please Select Student before Submitting";
		request.setAttribute("alternate_msg",msg);
		request.setAttribute("number_of_blocks",Integer.parseInt(request.getParameter("number_of_blocks")));		
		request.getRequestDispatcher("BYSCSEARCH?mnu_sc_code="+sc_code+"&mnu_prg_code="+prg_code+"&mnu_crs_code="+crs_code+"&textyear="+year+"&textmedium="+medium+"&textsession="+current_session+"&first_timer="+first_timer+"").forward(request,response);	
	}//end of else of if(enrno != null)
}//end of else of if(button_value.equals("SKIP"))
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYSCSTUDENTSUBMIT.java and exception is "+exe);
	msg="Some Serious Exception Hitted the page.Please check on the Server Console for Further Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("To_sc_students.jsp").forward(request,response);
}//end of catch blocks
finally{} //end of finally blocks
}//end of else of session checking
}//end of method doGet()
}//end of class BYSCSTUDENTSUBMIT