package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AVAILABILITY OF PROGRAMME GUIDE SELECTED BY THE USER FOR DESPATCHING TO THE STUDY CENTRE SELECTED,THIS SERVLET TAKES THE SC CODE,COURSE CODE,PROGRAMME CODE,MEDIUM CODE AS INPUT FROM THE BROWSER AND DISPLAY THE OUTPUT IN THE NEXT PAGE.
CALLED JSP:-To_sc_students_pg.jsp*/
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
 
public class BYSC_PG_SEARCH extends HttpServlet
 {
/**
     * 
     */
    private static final long serialVersionUID = 1L;
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYSC_PG_SEARCH SERVLET STARTED");
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
	String msg=null;
	String sc_code				=	 request.getParameter("mnu_sc_code").toUpperCase();//variable for holding the study centre code from the browser
	String prg_code				=	 request.getParameter("mnu_prg_code").toUpperCase();//variable for holding the programe code from the browser
	String crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();//variable for holding the course code from the browser
	String year					=	 request.getParameter("textyear").toUpperCase();//variable for holding the year from the browser
	String medium				= 	 request.getParameter("textmedium").toUpperCase();//variable for holding the medium of student from the browser
	String prg_code2			=		null;//variable for extracting the program code from the combined program code of the database
	String current_session		=	 request.getParameter("textsession").toLowerCase();//variable for holding the name of the current
				request.setAttribute("current_session",current_session);		
	int dispatch_student_count=0,index=0,available_qty=0;
	String rc_code=(String)session.getAttribute("rc");
	
	if(year.equals("NA") || year.equals("1"))
	prg_code2=prg_code;
	else
	prg_code2=prg_code+year;
	int length=0,i=0;
		response.setContentType("text/html");
		String relative_course=null;
		ResultSet rs=null,block=null;
				request.setAttribute("semester",		year);
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
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
/*LOGIC FOR CREATING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
	String despatch_crs_code="(crs_code='"+crs_code+"'";		
	for(index=0;index<relative_crs_code.length;index++)
	{
		despatch_crs_code=despatch_crs_code+" or crs_code='"+relative_crs_code[index]+"'";
	}//end of for loop
	despatch_crs_code=despatch_crs_code+")";		
/*LOGIC ENDS HERE OF CREATING RELATIVE COURSE CODE IN DESPATCH DATABASE*/
/*LOGIC FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL PROGRAMME CODE*/
	String[] relative_prg_code=new String[0];	
	rs	=	stmt.executeQuery("select count(*) from program_program where absolute_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
		if(rs.next())
		relative_prg_code=new String[rs.getInt(1)];
		index=0;
	rs	=	stmt.executeQuery("select relative_prg_code from program_program where absolute_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
		while(rs.next())
		{
			relative_prg_code[index]=rs.getString(1);
			index++;
		}
	String search_prg_code=null;
			if(year.equals("NA") || year.equals("1"))
			search_prg_code="(prg_code='"+prg_code+"'";		
			else
			search_prg_code="(prg_code='"+prg_code+year+"'";		
	for(index=0;index<relative_prg_code.length;index++)
	{
			if(year.equals("NA") || year.equals("1"))
			search_prg_code=search_prg_code+" or prg_code='"+relative_prg_code[index]+"'";		
			else
			search_prg_code=search_prg_code+" or prg_code='"+relative_prg_code[index]+year+"'";		
	}//end of for loop
	search_prg_code=search_prg_code+")";	//creation of prg_code complete like prg_code=this or prg_code=that
	System.out.println("value of search prg code= "+search_prg_code);
/*LOGIC ENDS HERE FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL CODE*/	

/*	block=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
	while(block.next())
	relative_course=block.getString(1);*/
	int result=5,result1=5;
		rs=stmt.executeQuery("select *  from student_"+current_session+"_"+rc_code+" where sc_code='"+sc_code+"' and "+search_prg_code+"");   
	String check=null;
	if(rs.next()) 
	{
		rs=stmt.executeQuery("select *  from student_"+current_session+"_"+rc_code+" where sc_code='"+sc_code+"' and "+search_prg_code+"");   
		while(rs.next())
		{
			for(int j=17;j<=35;)
			{
				check=rs.getString(j);
				check=check.trim();
				if(check.equals(crs_code))
					length++;
				else
				{
					for(index=0;index<relative_crs_code.length;index++)
					{
						if(check.equals(relative_crs_code[index]))
						length++;
					}//end of for loop
				}//end of else				
			j=j+2;					
			}//end of for loop	
		}//end of while loop
		System.out.println("Number of students "+length);
			String student[]			=	new String[length];
			String name[]				=	new String[length];
		rs=stmt.executeQuery("select *  from student_"+current_session+"_"+rc_code+" where sc_code='"+sc_code+"' and "+search_prg_code+"");
		i=0;
			String naam=null;
			String roll=null;
		while(rs.next())
		{
			roll=rs.getString(1);
			naam=rs.getString(5);	
			for(int k=17;k<=35;k=k+2)
			{	
				check=rs.getString(k);
				check=check.trim();				
				if(check.equals(crs_code))
				{	
					student[i]	=	roll;
					name[i]		=	naam;
					i++;
				}//end of if			
				else
				{
					for(index=0;index<relative_crs_code.length;index++)
					{
						if(check.equals(relative_crs_code[index]))
						{
							student[i]	=	roll;
							name[i]		=	naam;
							i++;						
						}//end of if
					}//end of for loop				
				}//end of else				
			}//end of for loop	
		}//end of while loop	
		
			request.setAttribute("student",student);
				request.setAttribute("name",name);
/*LOGIC FOR GETTING THE ACTUAL NUMBER OF STUDENRS TO WHOM PROGRAMME GUIDE HAS BEEN ALREADY DESPATCHED*/			
			for(index=0;index<student.length;index++)
			{
				rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and crs_code='"+prg_code+"' and block='PG' and reentry='NO'");
				if(rs.next())
					dispatch_student_count++;
			}//end of for loop
		String[] dispatch_student		= new String[dispatch_student_count];
		String[] dispatch_name			= new String[dispatch_student_count];
		String[] dispatch_date			= new String[dispatch_student_count];
		String[] dispatch_mode			= new String[dispatch_student_count];
		index=0;
		int insert_index=0;
/*INSERTING THE ROLL NUMBERS OF THE STUDENTS TO WHOM PROGRAMME GUIDE HAS BEEN DESPATCHED ALREADY*/		
			for(index=0;index<student.length;index++)
			{
				rs=stmt.executeQuery("select * from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[index]+"' and crs_code='"+prg_code+"' and block='PG' and reentry='NO'");
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

/*LOGIC FOR GETTING THE AVAILABLE QUANTITY OF THE PROGRAMME GUIDE OF THE SELECTED PROGRAMME IN MATERIAL DATABASE*/
		rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+prg_code+"' and block='PG' and medium='"+medium+"'");
		while(rs.next())
		available_qty=rs.getInt(1);
		request.setAttribute("available_qty",available_qty);
/*LOGIC ENDS HERE FOR GETTING THE AVAILABLE QUANTITY OF THE PROGRAMME GUIDE*/				
/*LOGIC FOR SETTING ALL THE DESPATCH RELATED INFORMATION ON THE REQUEST FOR THE NEXT PAGE*/			
			request.setAttribute("dispatch_student",dispatch_student);
				request.setAttribute("dispatch_date",dispatch_date);
				request.setAttribute("dispatch_mode",dispatch_mode);
			request.setAttribute("dispatch_name",dispatch_name);

			try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
			System.out.println("msg get kiya alternate msg se");
			if(msg==null)
			msg="";

			msg=msg+student.length+" Students Found For the Study Center Selected";
			request.setAttribute("msg",msg);
			if(student.length<1)
			request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);
			else
			request.getRequestDispatcher("jsp/To_sc_students_pg1.jsp?sc_code="+sc_code+"&prg_code="+prg_code+"&crs_code="+crs_code+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
	}//end of if(rs.next()) 
	else
	{
		msg="No Students for Study Centre "+sc_code+"<br/>  Of Program "+prg_code+" <br/> Of Course"+crs_code;
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);	
	}//end of else of first if(rs.next()) 
}//end of try blocks
catch(Exception exe)
{
		System.out.println("exception mila rey from BYSC_PG_SEARCH.java and exception is "+exe);
		msg="Some Serious exception hitted the page.Please check on the server console for more details";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request,response);
}//end of catch block
finally{}//end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class BYSC_PG_SEARCH