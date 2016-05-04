package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR DESPATCHING STUDY MATERIALS TO STUDNETS BY POST IN ONE BY ONE METHOD,IT TAKES THE ENROLLMENT NO,NAME,COURSE CODES,PROGRAMME CODE,MEDIUM AS INPUT FROM THE BROWSER AND BY CHECKING THE AVAILABILITY OF THE MATERIALS COMPLETE THE TRANSACTION,IF MATERIALS ARE OUT OF STOCK THEN IT SENDS APPROPRIATE MESSAGE TO THE BROWSER AND IF TRANSACTION IS SUCCESSFULLY COMPLETED THEN IT SENDS THE SUCCESS MESSAGE TO THE BROWSER
CALLED JSP:-By_post1.jsp*/
import static utility.CommonUtility.isNull;

import java.io.IOException;
import java.io.PrintWriter;
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
 
public class BYPOSTSUBMIT extends HttpServlet {
    
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYPOSTSUBMIT SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession(false);//getting and checking the availability of session of java
    	if(isNull(session)) {
    		String message = Constants.LOGIN_ACCESS_MESSAGE;
    		request.setAttribute("msg", message);
    		request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
    	} else {
    	    String enrno			=	 request.getParameter("text_enr").toUpperCase();//done
    	    String name				=	 request.getParameter("text_name").toUpperCase();//done
    	    String current_session	=	 request.getParameter("text_session").toLowerCase();//done
    	    String prg_code			= 	 request.getParameter("text_prog_code").toUpperCase();//done
    	    String year				=	 request.getParameter("text_year");//done
    	    String[] course			=	 request.getParameterValues("crs_code");//all the course codes from the jsp page
    	    int block_count			=	 0;
    	    int count				=	 0;
    	    String[] temp			=	 new String[0];
    	    int crs_select=0;//variable used to store number of courses selected to be Despatched
    	    String medium					= 	 request.getParameter("text_medium").toUpperCase();//done
    	    String date						= 	 request.getParameter("text_date").toUpperCase();//done
    	    String pkt_type					=	 request.getParameter("text_pkt_type").toUpperCase();//done
    	    int pkt_weight					=	 Integer.parseInt(request.getParameter("text_pkt_wt"));//done
    	    String challan_no				=	 request.getParameter("text_chln_no").toUpperCase();//done
    	    String	express_no				=	 request.getParameter("text_express_number").toUpperCase();//done
        	String dispatch_source			= 	 "BY POST";
        	String relative_course			=		null;
        	int qty							=		0;
        	int actual_qty					=		0;
        	int flag_for_pg					= 		0;
        	int flag_for_return				=		0;
        	int index						=		0;
        	System.out.println("All the Parameters received");
        	String msg="";	

        	String rc_code=(String)session.getAttribute("rc");
        	/*logic for getting the number of total courses selected by user*/
        	for(int c=0;c<course.length;c++) {
        	    temp = request.getParameterValues(course[c]);
    	        if(temp != null) {
    	            crs_select++;
	                block_count = block_count + temp.length;
	            }
        	}
    	    /*logic ends here*/

	String[] course_dispatch	=	 new String[block_count];//array for holding the courses to be Despatched
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
				//System.out.println("courses Despatched:"+course_dispatch[count]);
				count++;
			}
		}
	}
	/*logic ends here*/
	String pg_flag			=	 request.getParameter("pg_flag").trim();//
	String pg_value			=	null;
	//String relative_prg_code			=	null;
	if(pg_flag.equals("NO"))
	pg_value=request.getParameter("program_guide");
	System.out.println("pg_value:"+pg_value);
	
	System.out.println("Courses selected for Despatch:"+block_count);
		ResultSet rs=null,rs1=null;

			response.setContentType("text/html");
			PrintWriter out=response.getWriter();
try
{
	Connection con=connections.ConnectionProvider.conn();
	Statement stmt=con.createStatement();
	int result=5,result1=5,result2=5;
/*logic of getting the ABSOLUTE PROGRAMME CODE*/
	String[] relative_prg_code=new String[0];
	rs	=	stmt.executeQuery("select count(*) from program_program where relative_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
		if(rs.next())
		relative_prg_code = new String[rs.getInt(1)];
	index=0;
	rs	=	stmt.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+prg_code+"' and rc_code='"+rc_code+"'");
	while(rs.next())
	{
		relative_prg_code[index]=rs.getString(1);
		index++;
	}
	String search_crs_code="(crs_code='"+prg_code+"'";		
		for(index=0;index<relative_prg_code.length;index++)
			search_crs_code=search_crs_code+" or crs_code='"+relative_prg_code[index].trim()+"'";
		search_crs_code=search_crs_code+")";		
	System.out.println("value of search_crs_code "+search_crs_code);
	
	if(pg_flag.equals("NO") && pg_value!=null )
	{
		int o=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry,express_no)values('"+enrno+"','"+prg_code+"','"+prg_code+"','PG',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+challan_no+"',"+pkt_weight+",'"+pkt_type+"','NO','"+express_no+"')");   
		int p=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-1 where "+search_crs_code+" and block='PG' and medium='"+medium+"'");
		flag_for_pg=1;
	}//end of if(pg_flag.equals("NO") && pg_value!=null)					
	
	if (block_count != 0) 
	{
		//qty=course.length;
		qty=block_count;
		for(int z=0;z<course.length;z++)
		{
			int len=course[z].length();
			for(int y=0;y<course_dispatch.length;y++)
			{
				rs1		=	stmt .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
				if(rs1.next())
					relative_course=course[z];
				else
				{
					rs1	=	stmt.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
					while(rs1.next()) 
					relative_course=rs1.getString(1);
				}
				String course_check=course_dispatch[y].substring(0,len);
				String block_check=course_dispatch[y].substring(len);
				String initial=block_check.substring(0,1);
				if(course[z].equals(course_check))
				{
					if(initial.equals("B"))
					{
						rs=stmt.executeQuery("select qty from material_"+current_session+"_"+rc_code+" where crs_code='"+relative_course+"' and block='"+block_check+"' and medium='"+medium+"'");
						while(rs.next())
						actual_qty=rs.getInt(1);
						if(actual_qty<1)
						{
							flag_for_return++;
							msg=msg+" 1 set of Block "+block_check.substring(1)+" of "+course[z]+" Course.<br/>";
						}//end of if
					}//end of if(initial.equals("B"))
				}//end of if(course[z].equals(course_check))
			}//end of for loop of y
		}//end of for loop z
		if(flag_for_return==0)
		{
			for(int z=0;z<course.length;z++)
			{
				int len=course[z].length();
				for(int y=0;y<course_dispatch.length;y++)
				{
					rs1		=	stmt .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
					if(rs1.next())
					relative_course=course[z];
					else
					{
						rs1	=	stmt.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
						while(rs1.next()) 
						relative_course=rs1.getString(1);
					}
					String course_check=course_dispatch[y].substring(0,len);
					String block_check=course_dispatch[y].substring(len);
					String initial=block_check.substring(0,1);
					if(course[z].equals(course_check))
					{
						if(initial.equals("B"))
						{
							result=stmt.executeUpdate("insert into student_dispatch_"+current_session+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry,express_no)values('"+enrno+"','"+prg_code+"','"+course[z]+"','"+block_check+"',1,'"+date+"','"+dispatch_source+"','"+medium+"','"+challan_no+"',"+pkt_weight+",'"+pkt_type+"','NO','"+express_no+"')");   
							result1=stmt.executeUpdate("update material_"+current_session+"_"+rc_code+" set qty=qty-1 where crs_code='"+relative_course+"' and block='"+block_check+"' and medium='"+medium+"'");
						}//end of if(initial.equals("B"))
					}//end of if(course[z].equals(course_check))
				}//end of for loop of y
			}//end of for loop z	
		if(result==1 && result1==1)
		{	
			System.out.println("Materials for "+course.length+" courses given to "+name+"");   
			msg=""+course_dispatch.length+" Books Despatched to "+name+".";
		}
		else if(result==1 && result1 !=1)
		{
			System.out.println("Despatch table hitted but material table not affected..!!!!!");   
			msg="Despatch Table Hitted But Material Table not Affected!!!";
		}
		else
		{
			System.out.println("NO operation performed.!!!!!");   
			msg="No Operation Performed..!!";
		}
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_post.jsp").forward(request,response);			
			
	}//end of if(flag_for_return=0)
	else
	{
		System.out.println("Sorry Material out of stock for "+flag_for_return+" Courses.");
		String supplementary_msg="Sorry Can not Despatch<br/>";
		msg=supplementary_msg+msg+"As Not Available in Stock.";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYEPOSTSEARCH?txt_enr="+enrno+"").forward(request,response);
	}//end of else of if(flag_for_return==0)
	}//end of if(block_count!=null)
	else if (block_count == 0 && flag_for_pg == 1)
	{
		System.out.println("Program Guide Successfully Despatched...");
		msg="Program Guide Successfully Despatched to "+enrno+"";
		request.setAttribute("msg",msg);
		request.getRequestDispatcher("jsp/By_post.jsp").forward(request,response);			
	}//end of else of if(block_count!=null)
	else
	{
		System.out.println("Sorry !!Not any courses Selected...");
		msg="Sorry!! Not any courses selected..";
		request.setAttribute("alternate_msg",msg);
		request.getRequestDispatcher("BYEPOSTSEARCH?txt_enr="+enrno+"").forward(request,response);
	}//end of else of if(block_count!=null)
}//end of try blocks
catch(Exception exe)
{
	msg="Some Serious Exception found .please check on the Server console for details";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("jsp/By_post.jsp").forward(request,response);
	System.out.println("exception mila rey from BYPOSTSUBMIT.java"+exe);
}//end of catch blocks
finally
{} //end of finally blocks
}//end of else of session checking
}//end of method
 
}//end of class BYPOSTSUBMIT