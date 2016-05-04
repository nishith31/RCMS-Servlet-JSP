package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR SEARCHING THE STUDENTS OF THE STUDY CENTRE SELECTED FOR THE COURSE 
AND PROGRAMME CODE SELECTED AND AMONG THOSE STUDENTS ALSO CHECKS THE STUDENTS TO WHOM MATERIALS HAVE BEEN ALREADY 
SENT,THIS SERVLET TAKES SC CODE,PROGRAMME CODE,SEMESTER,COURSE CODE FROM THE BROWSER AND SENDS APPROPORIATE RESULTS IN THE NEXT PAGE.
CALLED JSP:-To_sc_students.jsp*/
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
 
public class BYSCSEARCH extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYSCSEARCH SERVLET STARTED");
    } 
 
public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session=request.getSession(false);//getting and checking the availability of session of java
    if(isNull(session)) {
        String message = Constants.LOGIN_ACCESS_MESSAGE;
        request.setAttribute("msg", message);
        request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
    } else {
        String message = null;
        String studyCenterCode              =    request.getParameter("mnu_sc_code").toUpperCase();//variable for holding the study centre code from the browser
        String programmeCode             =    request.getParameter("mnu_prg_code").toUpperCase();//variable for holding the programe code from the browser
        String courseCode             =    request.getParameter("mnu_crs_code").toUpperCase();//variable for holding the course code from the browser
        String year                 =    request.getParameter("textyear").toUpperCase();//variable for holding the year from the browser
        String medium               =    request.getParameter("textmedium").toUpperCase();//variable for holding the medium of student from the browser
        String programmeCode2            =       null;//variable for extracting the program code from the combined program code of the database
        String first_timer              =    request.getParameter("first_timer").toUpperCase();
        String currentSession      =    request.getParameter("textsession").toLowerCase();//variable for holding the name of the current
        int dispatch_student_count=0,index=0,available_qty=0,temp=0,temp1=0,length=0,i=0;
        try {
            temp    =   (Integer)request.getAttribute("initial_block");
            temp1   =   (Integer)request.getAttribute("number_of_blocks");
            request.setAttribute("initial_block",   temp);
            request.setAttribute("initial_block",   temp);
        } catch(Exception ex) {
            temp = 0;
        }
        int numberOfBlocks=0;
        String regionalCenterCode=(String)session.getAttribute("rc");
        String blockName = "B1"; 
        if(year.equals("NA") || year.equals("1")) {
            programmeCode2 = programmeCode;
        } else {
            programmeCode2=programmeCode+year;
        }
        
        response.setContentType(Constants.HEADER_TYPE_HTML);
        String relativeCourse;
        ResultSet rs=null,block=null;
        request.setAttribute("semester",        year);
        request.setAttribute("current_session",currentSession);
        try {
            Connection connection = connections.ConnectionProvider.conn();
            Statement statement = connection.createStatement();
            /*LOGIC FOR GETTING THE TOTAL NUMBER OF BLOCKS OF THE COURSE SELECTED BY THE USER IN THE SELECTION SCREEN*/ 
            block = statement.executeQuery("select no_of_blocks from course where crs_code='" + courseCode + "'");
            while(block.next()) {
                numberOfBlocks=block.getInt(1);
            }
        
            /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/  
            String[] relativeCourseCode = new String[0];
            rs  =   statement.executeQuery("select count(*) from course_course where absolute_crs_code='" + courseCode + "' and rc_code='" + regionalCenterCode + "'");
            if(rs.next()) {
                relativeCourseCode = new String[rs.getInt(1)];
            }
            
            index=0;
            rs  =   statement.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+courseCode+"' and rc_code='"+regionalCenterCode+"'");
            while(rs.next()) {
                relativeCourseCode[index]=rs.getString(1);
                index++;
            }
            /*LOGIC FOR CREATING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
            String dispatchCourseCode = "(crs_code='"+courseCode+"'";
            for(index=0;index<relativeCourseCode.length;index++) {
                dispatchCourseCode=dispatchCourseCode+" or crs_code='"+relativeCourseCode[index]+"'";
            }
            dispatchCourseCode=dispatchCourseCode+")";        
            /*LOGIC FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL PROGRAMME CODE*/
            String[] relativeProgrammeCode=new String[0];   
            rs  =   statement.executeQuery("select count(*) from program_program where absolute_prg_code='"+programmeCode+"' and rc_code='"+regionalCenterCode+"'");
            if(rs.next()) {
                relativeProgrammeCode=new String[rs.getInt(1)];
            }
            
            index = 0;
            rs  =   statement.executeQuery("select relative_prg_code from program_program where absolute_prg_code='"+programmeCode+"' and rc_code='"+regionalCenterCode+"'");
            while(rs.next())
            {
                relativeProgrammeCode[index]=rs.getString(1);
                index++;
            }
        String search_prg_code=null;
                if(year.equals("NA") || year.equals("1"))
                search_prg_code="(prg_code='"+programmeCode+"'";     
                else
                search_prg_code="(prg_code='"+programmeCode+year+"'";        
        for(index=0;index<relativeProgrammeCode.length;index++)
        {
                if(year.equals("NA") || year.equals("1"))
                search_prg_code=search_prg_code+" or prg_code='"+relativeProgrammeCode[index]+"'";      
                else
                search_prg_code=search_prg_code+" or prg_code='"+relativeProgrammeCode[index]+year+"'";     
        }//end of for loop
        search_prg_code=search_prg_code+")";    //creation of prg_code complete like prg_code=this or prg_code=that
        System.out.println("value of search prg code= "+search_prg_code);
    /*LOGIC ENDS HERE FOR CREATING RELATIVE PROGRAMME CODE FROM THE ACTUAL CODE*/   
        
    /*  block=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
        while(block.next())
        relative_course=block.getString(1);*/
            request.setAttribute("number_of_blocks",numberOfBlocks);      
            request.setAttribute("first_timer",first_timer);        
        int result=5,result1=5;
            rs=statement.executeQuery("select *  from student_"+currentSession+"_"+regionalCenterCode+" where sc_code='"+studyCenterCode+"' and "+search_prg_code+"");
        String check=null;
        int ll=1;
        if(rs.next()) 
        {
            rs=statement.executeQuery("select *  from student_"+currentSession+"_"+regionalCenterCode+" where sc_code='"+studyCenterCode+"' and "+search_prg_code+"");
            while(rs.next())
            {
                for(int j=17;j<=35;)
                {
                    check=rs.getString(j);
                    check=check.trim();
                    if(check.equals(courseCode))
                        length++;
                    else
                    {
                        for(index=0;index<relativeCourseCode.length;index++)
                        {
                            if(check.equals(relativeCourseCode[index]))
                            length++;
                        }//end of for loop
                    }//end of else
                    j=j+2;                  
                }//end of for loop  
            }//end of while loop
            ll=1;
                String student[]            =   new String[length];
                String name[]               =   new String[length];
                String hidden_course[]      =   new String[length];
            rs=statement.executeQuery("select *  from student_"+currentSession+"_"+regionalCenterCode+" where sc_code='"+studyCenterCode+"' and "+search_prg_code+"");
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
                    if(check.equals(courseCode))
                    {   
                        student[i]  =   roll;
                        name[i]     =   naam;
                        hidden_course[i]        =   courseCode;                   
                        i++;
                    }//end of if            
                    else
                    {
                        for(index=0;index<relativeCourseCode.length;index++)
                        {
                            if(check.equals(relativeCourseCode[index]))
                            {
                                student[i]  =   roll;
                                name[i]     =   naam;
                                hidden_course[i]        =   relativeCourseCode[index];                           
                                i++;                        
                            }//end of if
                        }//end of for loop              
                    }//end of else
                    
                }//end of for loop  
            }//end of while loop    
            
                request.setAttribute("student",student);
                    request.setAttribute("name",name);
                request.setAttribute("hidden_course",hidden_course);            
                for(index=0;index<student.length;index++)
                {
                    rs=statement.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+blockName+"' and reentry='NO'");
                    if(rs.next())
                    {   
                        dispatch_student_count++;
                    }//end of if
                }//end of for loop
            String[] dispatch_student       = new String[dispatch_student_count];
            String[] dispatch_name          = new String[dispatch_student_count];
            String[] dispatch_date          = new String[dispatch_student_count];
            String[] dispatch_mode          = new String[dispatch_student_count];
                    System.out.println("Array of Student Despatched Created of length "+dispatch_student_count);
            index=0;
            int insert_index=0;
    /*Inserting the Roll Numbers of the Despatched Students of the Study Centres*/      
                for(index=0;index<student.length;index++)
                {
                    rs=statement.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+blockName+"' and reentry='NO'");
                    if(rs.next())
                    {
                        rs=statement.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+blockName+"' and reentry='NO'");
                        while(rs.next())
                        {
                            dispatch_student[insert_index]          =   rs.getString(1);
                            dispatch_date[insert_index]             =   rs.getDate(6).toString();
                            dispatch_mode[insert_index]             =   rs.getString(7);
                        }
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
    
    /*Logic for creating int variable of available sets of the course selected*/
            rs=statement.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+courseCode+"' and block='"+blockName+"' and medium='"+medium+"'");
            while(rs.next())
            available_qty=rs.getInt(1);
            request.setAttribute("available_qty",available_qty);
                    
                request.setAttribute("dispatch_student",dispatch_student);
                    request.setAttribute("dispatch_date",dispatch_date);
                        request.setAttribute("dispatch_mode",dispatch_mode);
                    request.setAttribute("dispatch_name",dispatch_name);
                        
                try{message=(String)request.getAttribute("alternate_msg");}catch(Exception ees){message=null;}
                System.out.println("msg get kiya alternate msg se");
                if(message==null)
                message="";
    
                message=message+student.length+" Students Found For the Study Center Selected";
                request.setAttribute("msg",message);
                request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code="+studyCenterCode+"&prg_code="+programmeCode+"&crs_code="+courseCode+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
                System.out.println("forward kiya aur exception nahi hai");
        }//end of if        
        else
        {
            message="No Students for Study Centre "+studyCenterCode+"<br/>  Of Program "+programmeCode+" <br/> Of Course"+courseCode;
            request.setAttribute("msg",message);
            request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
            System.out.println("No Student for Study Centre "+studyCenterCode+" for program "+programmeCode+" Course "+courseCode+"");
        }//end of else of first if
    } catch(Exception exception) {
            System.out.println("exception mila rey from BYSCSEARCH.java"+exception);
            message="Some Serious exception hitted the page.Please check on the server console for more details";
            request.setAttribute("msg",message);
            request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
        }
    }//end of else of session checking
}//end of method 
}//end of class BYSCSEARCH