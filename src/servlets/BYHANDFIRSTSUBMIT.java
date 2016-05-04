package servlets;
/*This Servlet is Responsible for inserting data to student Despatch table and updating material table.
 * It also checks the violation of primary key means duplicate data can not be enter in the student Despatch table.
 * This servlet gets all the required fields from the browser and after checking all the constraints insert and update the corresponding tables*/
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
 
public class BYHANDFIRSTSUBMIT extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYHANDFIRSTSUBMIT SERVLET STARTED TO EXECUTE");
    } 
 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting the reference of the session of the system to the session variable
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String enrno            =    request.getParameter("text_enr").toUpperCase();//getting the enrolment number of student
            String name             =    request.getParameter("text_name").toUpperCase();//getting the name of the student
            String currentSession  =    request.getParameter("text_session").toLowerCase();//getting the value of current session
            String programmeCode         =    request.getParameter("text_prog_code").toUpperCase();//gettting the prgram code
            String[] course         =    request.getParameterValues("crs_code");//all the course codes from the jsp page
            int blockCount         =    0;//int variable for number of blocks available with the course
            int count               =    0;//int variable for multiple use
            String[] temp           =    new String[0];//array of String for multiple use
            int index               =       0;
            /*logic for getting the number of total courses selected by user*/
            for(index=0;index<course.length;index++) {
                temp        =    request.getParameterValues(course[index]);
                if(temp != null) {
                    blockCount = blockCount + temp.length;
                }
            }
            String[] courseDispatch    =    new String[blockCount];//array for holding the courses to be Despatched
            /*logic for getting all the courses selected by the user*/
            for(index=0;index<course.length;index++) {
                String[] courseBlock=   request.getParameterValues(course[index]);
                if(courseBlock != null) {
                    int len = courseBlock.length;
                    for(int e = 0; e < len; e++) {
                        courseDispatch[count] = courseBlock[e];
                        count++;
                    }
                }
            }
            String pg_flag          =    request.getParameter("pg_flag");//getting the year or semester code    
            String programmeGuideValue         =   null;
            if(pg_flag.equals(Constants.NO)) {
                programmeGuideValue=request.getParameter("program_guide");
            }
            
            String medium           =    request.getParameter("text_medium").toUpperCase();
            String date             =    request.getParameter("text_date").toUpperCase();//date from the jsp page date field
            String remarks          =    request.getParameter("text_remarks").toUpperCase();//remarks from the jsp page remarks field
            String dispatchSource  =   "BY HAND";//for the Despatch source field of the student_Despatch table for post it is BY POST AND BY SC for study centre Despatch moce
            String reentryMessage      =   Constants.NO;
            int qty                 =       0;
            int actualQuantity          =       0;
            int flagForProgrammeGuide         =       0;
            int flagForReturn     =       0;
            String relativeCourse  =   null;
            ResultSet rs            =   null;
            ResultSet rs1           =   null;
            System.out.println("All the Parameters received");
            request.setAttribute("current_session", currentSession);//setting the value of current session to the request
            String message = "";  
        
            String rc_code = (String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
        
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();//creating the connection object for the database
                Statement statement = connection.createStatement();//fetching the refernce of the statement from the connection object.
                int result = 5, result1 = 5;
                /*logic of getting the ABSOLUTE PROGRAMME CODE*/
                String[] relativeProgrammeCode=new String[0];
                rs  =   statement.executeQuery("select count(*) from program_program where relative_prg_code='"+programmeCode+"' and rc_code='"+rc_code+"'");
                if(rs.next()) {
                    relativeProgrammeCode = new String[rs.getInt(1)];
                }
                index = 0;
                rs  =   statement.executeQuery("select absolute_prg_code from program_program where relative_prg_code='"+programmeCode+"' and rc_code='"+rc_code+"'");
                while(rs.next()) {
                    relativeProgrammeCode[index] = rs.getString(1);
                    index++;
                }
                String searchCourseCode = "(crs_code='" + programmeCode + "'";      
                for(index=0;index<relativeProgrammeCode.length;index++) {
                    searchCourseCode=searchCourseCode+" or crs_code='"+relativeProgrammeCode[index].trim()+"'";
                }
                searchCourseCode = searchCourseCode+")";        
                System.out.println("value of search_crs_code "+searchCourseCode);
            
                if(pg_flag.equals(Constants.NO) && programmeGuideValue!=null )  {
                    int o = statement.executeUpdate("insert into student_dispatch_"+currentSession+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno+"','"+programmeCode+"','"+programmeCode+"','PG',1,'"+date+"','"+dispatchSource+"','"+medium+"','"+reentryMessage+"')");   
                    int p = statement.executeUpdate("update material_"+currentSession+"_"+rc_code+" set qty=qty-1 where "+searchCourseCode+" and block='PG' and medium='"+medium+"'");
                    flagForProgrammeGuide = 1;
                }                    
                if (blockCount != 0) {
                    qty = blockCount;
                    for(int z=0;z<course.length;z++) {
                        int len = course[z].length();
                        for(int y=0;y<courseDispatch.length;y++) {
                            rs1     =   statement .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
                            if(rs1.next()) {
                                relativeCourse=course[z];
                            } else  {
                                rs1 =   statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
                                while(rs1.next()) {
                                    relativeCourse = rs1.getString(1);
                                }
                            }
                            String course_check =courseDispatch[y].substring(0,len);
                            String block_check  =courseDispatch[y].substring(len);
                            String initial      =block_check.substring(0,1);
                            if(course[z].equals(course_check)) {
                                if(initial.equals("B")) {
                                    rs = statement.executeQuery("select qty from material_"+currentSession+"_"+rc_code+" where crs_code='"+relativeCourse+"' and block='"+block_check+"' and medium='"+medium+"'");
                                    while(rs.next()) {
                                        actualQuantity=rs.getInt(1);
                                    }
                                    if(actualQuantity<1) {
                                        //    if stock of any block found less than one then it increase the value of flag
                                        flagForReturn++;
                                        message = message+" 1 set of Block "+block_check.substring(1)+" of "+course[z]+" Course.<br/>";
                                    }
                                }
                            }
                        }
                    }
                    if(flagForReturn==0) {
                        for(int z=0;z<course.length;z++) {
                            int len=course[z].length();
                            for(int y=0;y<courseDispatch.length;y++) {
                                rs1     =   statement .executeQuery("Select * from course where crs_code='"+course[z]+"'");//checking the course in course table
                                if(rs1.next()) {
                                    relativeCourse=course[z];
                                } else {
                                    rs1 =   statement.executeQuery("select absolute_crs_code from course_course where relative_crs_code='"+course[z]+"' and rc_code='"+rc_code+"'");
                                    while(rs1.next()) {
                                        relativeCourse=rs1.getString(1);
                                    }
                                }
                                String course_check=courseDispatch[y].substring(0,len);
                                String block_check=courseDispatch[y].substring(len);
                                String initial=block_check.substring(0,1);
                                if(course[z].equals(course_check)) {
                                    if(initial.equals("B")) {
                                        result=statement.executeUpdate("insert into student_dispatch_"+currentSession+"_"+rc_code+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno+"','"+programmeCode+"','"+course[z]+"','"+block_check+"',1,'"+date+"','"+dispatchSource+"','"+medium+"','"+reentryMessage+"')");   
                                        result1=statement.executeUpdate("update material_"+currentSession+"_"+rc_code+" set qty=qty-1 where crs_code='"+relativeCourse+"' and block='"+block_check+"' and medium='"+medium+"'");
                                    }
                                }
                            }
                        }    
                        if(result==1 && result1==1) {   
                        System.out.println("Materials for "+course.length+" courses given to "+name+"");   
                        message=""+courseDispatch.length+" Books Despatched to "+name+".";
                        } else if(result==1 && result1 !=1) {
                            System.out.println("Despatch table hitted but material table not affected..!!!!!");   
                            message="Despatch table Hitted but material Table not Affected!!!";
                        } else {
                            System.out.println("NO operation performed.!!!!!");             
                            message="No Operation Performed..!!";
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);                      
                    }else {
                      //if material is out of stock then this section will work and give message to the user
                        System.out.println("Sorry Material out of stock for "+flagForReturn+" Courses.");
                        String supplementary_msg="Sorry Can not Despatch<br/>";
                        message=supplementary_msg+message+"As Not Available in Stock.";//message for the browser
                        request.setAttribute("alternate_msg",message);
                        request.getRequestDispatcher("BYE?txt_enr="+enrno+"").forward(request,response);//redirecting to the BYE servlet again
                    }
                } else if (blockCount == 0 && flagForProgrammeGuide == 1) {
                    System.out.println("Program guide successfully despatched...");
                    message="Program guide successfully despatched to "+enrno+"";
                    request.setAttribute("msg",message);
                    request.getRequestDispatcher("jsp/By_hand.jsp").forward(request,response);          
                } else {
                    System.out.println("Sorry !!Not any courses Selected...");
                    message = "Sorry!! Not any courses selected..";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("BYE?txt_enr="+enrno+"").forward(request,response);
                }
            } catch(Exception exception) {   
                System.out.println("Exception raised from BYHANDFIRSTSUBMIT.java and exception is "+ exception);
                message = "Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_hand.jsp").forward(request, response);
            }
        }
    } 
}