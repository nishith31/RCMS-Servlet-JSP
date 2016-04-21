package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE STUDENTS FOR THE COURSE CODE,PROGRAMME CODE,MEDIUM AND LOT NUMBER PROVIDED BY THE USER ON THE BROWSER AND IN THAT RANGE OF STUDENTS ALSO CHECKS THE STUDENTS TO WHOM MATERIALS HAS BEEN ALREADY SENT AND SENDS THOSE STUDENTS AS DISABLED FOR DESPATCHING,IT ALSO CHECKS AND DISPLAY THE AVAILABLE QUANTITY OF THE STUDY MATERIAL SELECETED FOR DESPATCHING.
CALLED JSP;-By_post_bulk1.jsp*/
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*; 
import javax.servlet.http.*;
import javax.servlet.*;
 
public class BYPOSTBULKSEARCH extends HttpServlet
{
public void init(ServletConfig config) throws ServletException 
{
	super.init(config);
	System.out.println("BYPOSTBULKSEARCH SERVLET STARTED TO EXECUTE");
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
/*LOGIC FOR GETTING ALL THE PARAMETERS FROM THE BROWSER*/	
	String first_timer				=	 request.getParameter("first_timer").toUpperCase();
	System.out.println("value of first_timer is "+first_timer);
	

	String prg_code				=	 request.getParameter("mnu_prg_code").toUpperCase();
		String crs_code				=	 request.getParameter("mnu_crs_code").toUpperCase();
			String medium				= 	 request.getParameter("mnu_medium").toUpperCase();
		String lot					=	 request.getParameter("text_lot").toUpperCase();
	int start					=	 Integer.parseInt(request.getParameter("text_start"));
	int end						=	 Integer.parseInt(request.getParameter("text_end"));

	System.out.println("All parameters received. Course code: "+crs_code+" Programme Code: "+prg_code);

	String rc_code=(String)session.getAttribute("rc");
	System.out.println("course code "+crs_code);
	String msg			=null;
	String query		=null;
	String check		=null;
	int number_of_blocks=0,index=0,length=0,i=0,available_qty=0;//Field for storing the available sets of the selected course and send to browser
	String current_session		=	 null;
	response.setContentType("text/html");
		PrintWriter out=response.getWriter();
		try{msg=(String)request.getAttribute("alternate_msg");}catch(Exception ees){msg=null;}
			if(msg==null)
			msg="";
			ResultSet rs=null;
			ResultSet block=null;
			request.setAttribute("start",start);
			request.setAttribute("end",end);
			
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	block=stmt.executeQuery("select no_of_blocks from course where crs_code='"+crs_code+"'");
	while(block.next())
	number_of_blocks=block.getInt(1);
		request.setAttribute("number_of_blocks",number_of_blocks);		
		request.setAttribute("first_timer",first_timer);		
		/*request.setAttribute("date",date);		
		request.setAttribute("packet_type",packet_type);		*/
		request.setAttribute("start",start);		
		request.setAttribute("end",end);		
	rs=stmt.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
	while(rs.next())
	current_session=rs.getString(1).toLowerCase();
	request.setAttribute("current_session",current_session);		
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
	String crs1="(crs1='"+crs_code+"'";
	String crs2="(crs2='"+crs_code+"'";
	String crs3="(crs3='"+crs_code+"'";
	String crs4="(crs4='"+crs_code+"'";
	String crs5="(crs5='"+crs_code+"'";
	String crs6="(crs6='"+crs_code+"'";
	String crs7="(crs7='"+crs_code+"'";
	String crs8="(crs8='"+crs_code+"'";
	String crs9="(crs9='"+crs_code+"'";
	String crs10="(crs10='"+crs_code+"'";
	String crs11="(crs11='"+crs_code+"'";
	String crs12="(crs12='"+crs_code+"'";
	String crs13="(crs13='"+crs_code+"'";
	String crs14="(crs14='"+crs_code+"'";
	String crs15="(crs15='"+crs_code+"'";
	String crs16="(crs16='"+crs_code+"'";
	String crs17="(crs17='"+crs_code+"'";
	String crs18="(crs18='"+crs_code+"'";
	String crs19="(crs19='"+crs_code+"'";
	String crs20="(crs20='"+crs_code+"'";
	for(index=0;index<relative_crs_code.length;index++)
	{
		crs1=crs1+" or crs1='"+relative_crs_code[index]+"'";
		crs2=crs2+" or crs2='"+relative_crs_code[index]+"'";
		crs3=crs3+" or crs3='"+relative_crs_code[index]+"'";
		crs4=crs4+" or crs4='"+relative_crs_code[index]+"'";
		crs5=crs5+" or crs5='"+relative_crs_code[index]+"'";
		crs6=crs6+" or crs6='"+relative_crs_code[index]+"'";
		crs7=crs7+" or crs7='"+relative_crs_code[index]+"'";
		crs8=crs8+" or crs8='"+relative_crs_code[index]+"'";
		crs9=crs9+" or crs9='"+relative_crs_code[index]+"'";
		crs10=crs10+" or crs10='"+relative_crs_code[index]+"'";
		crs11=crs11+" or crs11='"+relative_crs_code[index]+"'";
		crs12=crs12+" or crs12='"+relative_crs_code[index]+"'";
		crs13=crs13+" or crs13='"+relative_crs_code[index]+"'";
		crs14=crs14+" or crs14='"+relative_crs_code[index]+"'";
		crs15=crs15+" or crs15='"+relative_crs_code[index]+"'";
		crs16=crs16+" or crs16='"+relative_crs_code[index]+"'";
		crs17=crs17+" or crs17='"+relative_crs_code[index]+"'";
		crs18=crs18+" or crs18='"+relative_crs_code[index]+"'";
		crs19=crs19+" or crs19='"+relative_crs_code[index]+"'";
		crs20=crs20+" or crs20='"+relative_crs_code[index]+"'";
	}
	crs1=crs1+")";
	crs2=crs2+")";
	crs3=crs3+")";
	crs4=crs4+")";
	crs5=crs5+")";
	crs6=crs6+")";
	crs7=crs7+")";
	crs8=crs8+")";
	crs9=crs9+")";
	crs10=crs10+")";
	crs11=crs11+")";
	crs12=crs12+")";
	crs13=crs13+")";
	crs14=crs14+")";
	crs15=crs15+")";
	crs16=crs16+")";
	crs17=crs17+")";
	crs18=crs18+")";
	crs19=crs19+")";
	crs20=crs20+")";
/*LOGIC ENDS FOR CREATING RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/	
/*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
	String despatch_crs_code="(crs_code='"+crs_code+"'";		
	for(index=0;index<relative_crs_code.length;index++)
	{
		despatch_crs_code=despatch_crs_code+" or crs_code='"+relative_crs_code[index]+"'";
	}//end of for loop
	despatch_crs_code=despatch_crs_code+")";		
/*LOGIC ENDS HERE OF GETTING RELATIVE COURSE CODE IN DESPATCH DATABASE*/
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
	String search_prg_code="(prg_code like '"+prg_code+"%'";		
	for(index=0;index<relative_prg_code.length;index++)
	{
		search_prg_code=search_prg_code+" or prg_code like '"+relative_prg_code[index]+"%'";
	}//end of for loop
	search_prg_code=search_prg_code+")";		
/*LOGIC ENDS HERE FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL CODE*/	
	System.out.println("value of despatch course "+despatch_crs_code);
	System.out.println("select * from student_"+current_session+"_"+rc_code+" where medium='"+medium+"' and "+crs1+" and lot='"+lot+"' or medium='"+medium+"' and "+crs2+" and lot='"+lot+"' or medium='"+medium+"' and "+crs3+" and lot='"+lot+"' or medium='"+medium+"' and "+crs4+" and lot='"+lot+"' or medium='"+medium+"' and "+crs5+" and lot='"+lot+"' or medium='"+medium+"' and "+crs6+" and lot='"+lot+"' or medium='"+medium+"' and "+crs7+" and lot='"+lot+"' or medium='"+medium+"' and "+crs8+" and lot='"+lot+"' or medium='"+medium+"' and "+crs9+" and lot='"+lot+"' or medium='"+medium+"' and "+crs10+" and lot='"+lot+"' or medium='"+medium+"' and "+crs11+" and lot='"+lot+"' or medium='"+medium+"' and "+crs12+" and lot='"+lot+"' or medium='"+medium+"' and "+crs13+" and lot='"+lot+"' or medium='"+medium+"' and "+crs14+" and lot='"+lot+"' or medium='"+medium+"' and "+crs15+" and lot='"+lot+"' or medium='"+medium+"' and "+crs16+" and lot='"+lot+"' or medium='"+medium+"' and "+crs17+" and lot='"+lot+"' or medium='"+medium+"' and "+crs18+" and lot='"+lot+"' or medium='"+medium+"' and "+crs19+" and lot='"+lot+"' or medium='"+medium+"' and "+crs20+" and lot='"+lot+"'");
	if(prg_code.equals("ALL"))
	{
//	query="select * from student_"+current_session+"_"+rc_code+" where medium='"+medium+"' and crs1='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs2='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs3='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs4='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs5='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs6='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs7='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs8='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs9='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs10='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs11='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs12='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs13='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs14='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs15='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs16='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs17='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs18='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs19='"+crs_code+"' and lot='"+lot+"' or medium='"+medium+"' and crs20='"+crs_code+"' and lot='"+lot+"'";
		query="select * from student_"+current_session+"_"+rc_code+" where medium='"+medium+"' and "+crs1+" and lot='"+lot+"' or medium='"+medium+"' and "+crs2+" and lot='"+lot+"' or medium='"+medium+"' and "+crs3+" and lot='"+lot+"' or medium='"+medium+"' and "+crs4+" and lot='"+lot+"' or medium='"+medium+"' and "+crs5+" and lot='"+lot+"' or medium='"+medium+"' and "+crs6+" and lot='"+lot+"' or medium='"+medium+"' and "+crs7+" and lot='"+lot+"' or medium='"+medium+"' and "+crs8+" and lot='"+lot+"' or medium='"+medium+"' and "+crs9+" and lot='"+lot+"' or medium='"+medium+"' and "+crs10+" and lot='"+lot+"' or medium='"+medium+"' and "+crs11+" and lot='"+lot+"' or medium='"+medium+"' and "+crs12+" and lot='"+lot+"' or medium='"+medium+"' and "+crs13+" and lot='"+lot+"' or medium='"+medium+"' and "+crs14+" and lot='"+lot+"' or medium='"+medium+"' and "+crs15+" and lot='"+lot+"' or medium='"+medium+"' and "+crs16+" and lot='"+lot+"' or medium='"+medium+"' and "+crs17+" and lot='"+lot+"' or medium='"+medium+"' and "+crs18+" and lot='"+lot+"' or medium='"+medium+"' and "+crs19+" and lot='"+lot+"' or medium='"+medium+"' and "+crs20+" and lot='"+lot+"'";
	}

	else
	{
		query="select * from student_"+current_session+"_"+rc_code+" where "+search_prg_code+" and medium='"+medium+"' and "+crs1+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs2+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs3+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs4+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs5+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs6+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs7+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs8+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs9+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs10+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs11+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs12+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs13+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs14+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs15+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs16+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs17+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs18+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs19+" and lot='"+lot+"' or "+search_prg_code+" and medium='"+medium+"' and "+crs20+" and lot='"+lot+"'";
	}
	rs=stmt.executeQuery(query);
	int ll=1;
	if(rs.next()) 
	{
		rs=stmt.executeQuery(query);
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
		ll=1;
			System.out.println("Number of students "+length);
		String student[]=new String[length];
			System.out.println("length of student array in servlet "+student.length);
		String name[]=new String[length];
			System.out.println("length of student's name array in servlet "+name.length);
		String serial_number[]=new String[length];
			System.out.println("length of student's serial number array in servlet "+serial_number.length);
		String hidden_course[]=new String[length];
			System.out.println("length of hidden course array in servlet "+hidden_course.length);

		rs=stmt.executeQuery(query);
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
					student[i]				=	roll;
					name[i]					=	naam;
					serial_number[i]		=	rs.getString(k+1);
					hidden_course[i]		=	crs_code;
					i++;
				}//end of if			
				else
				{
					for(index=0;index<relative_crs_code.length;index++)
					{
						if(check.equals(relative_crs_code[index]))
						{
							//System.out.println("inserted  in roll no "+roll );
							student[i]	=	roll;
							//System.out.println("inserted  in name "+naam );
							name[i]		=	naam;
							//System.out.println("inserted  in serial number " );
							serial_number[i]		=	rs.getString(k+1);
							//System.out.println("inserted  in hidden course " );
							hidden_course[i]		=	relative_crs_code[index];
							i++;						
						}//end of if
					}//end of for loop				
				}//end of else
			}//end of for loop	
		}//end of while loop	
		naam=null;
		roll=null;
		String number=null;
		String hide_course=null;
		int first=0;
		int second=0;
		int lenn=0;
		if(prg_code.equals("ALL"))
		lenn=serial_number.length;
		else 
		lenn=serial_number.length;
		int final_length=0;
		for(i=0;i<serial_number.length;i++)
		{
			if(serial_number[i]!=null)
			final_length++;
		}
			System.out.println("final length is "+final_length);
/*LOGIC FOR SORTING THE ARRAY OF SERIAL NUMBER ON THE ASCENDING ORDER*/
		for(i=0;i<final_length;i++)
		{
			for(int j=i+1;j<final_length;j++)
			{
				first=Integer.parseInt(serial_number[i].trim());
				second=Integer.parseInt(serial_number[j].trim());
				//System.out.println("value of serial number in number is "+first);
				if(first>second)
				{
					number=serial_number[i];
					serial_number[i]=serial_number[j];
					serial_number[j]=number;
	
					naam=name[i];
					name[i]=name[j];
					name[j]=naam;

					roll=student[i];
					student[i]=student[j];
					student[j]=roll;

					hide_course=hidden_course[i];
					hidden_course[i]=hidden_course[j];
					hidden_course[j]=hide_course;
				}//end of if
			}//end of j for loop
		}//end of for loop
/*Logic for creating int variable of available sets of the course selected*/
rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+crs_code+"' and block='B1' and medium='"+medium+"' ");
while(rs.next())
available_qty=rs.getInt(1);
request.setAttribute("available_qty",available_qty);

		/*logic for checking the students filtered above in the Despatch table*/
		int[] dispatch_index;
		int j=0;
		for(i=0;i<final_length;i++)
		{
			try
			{
				rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and "+despatch_crs_code+" and block='B1' and medium='"+medium+"'");
				if(rs.next())
				{j++;}
			}catch(Exception ecc){System.out.print("nahi hai "+student[i]+" "+ecc);}
		}//end of for loop
		System.out.println("length of Despatch students "+j);
		dispatch_index=new int[j];
		j=0;
		for(i=0;i<final_length;i++)
		{
			try
			{
				rs=stmt.executeQuery("select distinct enrno from student_dispatch_"+current_session+"_"+rc_code+" where enrno='"+student[i]+"' and "+despatch_crs_code+" and block='B1' and medium='"+medium+"'");
					if(rs.next())
					{	
					dispatch_index[j]=i;
					j++;
					}//end of if
			}catch(Exception jd){System.out.print("nahi hai "+jd);}
		}//end of for loop
		//for(i=0;i<dispatch_index.length;i++)System.out.println("index of Despatched students "+dispatch_index[i]);
	///////////////////////////////////////////////////////////////////////////////
			request.setAttribute("student",student);
				request.setAttribute("name",name);
					request.setAttribute("serial_number",serial_number);
				request.setAttribute("hidden_course",hidden_course);
			request.setAttribute("dispatch_index",dispatch_index);
		if(final_length==0)
		{
			System.out.println("No Student found...");
			msg=msg+"No Student Found";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
		}
		else if(end>final_length)
		{
			System.out.println("Your Selection is out of Range:- Total Student "+final_length+" and Range is "+start+" to "+end+"");
			msg=msg+"Your Selection is out of Range:- Total Student "+final_length+" and Range is "+start+" to "+end+" "; 
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
		}
		else
		{
			System.out.println("NO OF STUDENTS ARE "+final_length+"");
			msg=msg+"No Of Students Are "+final_length+" ";
			request.setAttribute("msg",msg);
			request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code="+prg_code+"&crs_code="+crs_code+"&medium="+medium+"&lot="+lot+"&start="+start+"&end="+end+"&length="+final_length+"").forward(request,response);
		}//end of else	
	}//end of main if(rs.next())	
	else
	{
		System.out.println("No Student found...");
		msg=msg+"No Student Found";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
	}//end of main else of if(rs.next())
}//end of try blocks
catch(Exception exe)
{
	System.out.println("exception mila rey from BYPOSTBULKSEARCH.java "+exe);
	msg=msg+"Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);		
}//end of catch blocks
finally{}//end of finally blocks
}//end of else of session checking
}//end of method 
}//end of class BYPOSTBULKSEARCH