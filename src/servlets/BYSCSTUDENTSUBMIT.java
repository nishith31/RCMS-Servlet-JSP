package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO STUDENT DESPATCH AND SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE MAINLY.BY THIS 
SERVLET SYSTEM SAVE THE DATA OF THOSE STUDENTS TO WHOM MATERIALS ARE DISTRIBUTED BY THE STUDY CENTRE DIRECTLY.THIS SERVLET ALSO CHECKS
FOR THE PRIMARY KEY VOILATION IN THE TWO DESPATCH TABLES, IF NO VIOALTION FOUND THEN SAVES THE DATA TO THE CORRESPONDING TABLES
AND GENERATE APPROPRIATE MSGS.
CALLED JSP:-To_sc_students1.jsp*/
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
public class BYSCSTUDENTSUBMIT extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYSCSTUDENTSUBMIT SERVLET STARTED TO EXECUTE");
    } 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String studyCenterCode              =    request.getParameter("txt_sc_code").toUpperCase();//FIELD FOR STORING THE STUDY CENTRE CODE OF THE STUDENT
            String programmeCode             =    request.getParameter("txt_prog_code").toUpperCase();//FIELD FOR STORING THE PROGRAM CODE OF THE STUDENT
            String courseCode             =    request.getParameter("txt_crs_code").toUpperCase();//FIELD FOR STORING THE COURSE CODE OF THE STUDENTS
            String year                 =    request.getParameter("txt_year").toUpperCase();//FIELD FOR STORING THE YEAR OR SEMESTER DETAILS OF THE STUDENT
            String medium               =    request.getParameter("txt_medium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM OPTED BY THE STUDENT
            String date                 =    request.getParameter("txt_date").toUpperCase();//FIELD FOR HOLDING THE DATE OF Despatch OF MATERIALS
            String currentSession = request.getParameter("txt_session").toLowerCase();//FIELD FOR STORING THE NAME OF THE CURRENT SESSION MEANS CURRENTLY USED SESSION
            String blockName = request.getParameter("block_name").toUpperCase();
            int initialBlock = Integer.parseInt(request.getParameter("initial_block"));
            int numberOfBlocks = Integer.parseInt(request.getParameter("number_of_blocks"));
            numberOfBlocks            =    numberOfBlocks-1;
            String firstTimer          =    request.getParameter("first_timer").toUpperCase();
            String buttonValue = request.getParameter("enter").toUpperCase();           
            buttonValue = buttonValue.trim();
    
            String[] student                =    request.getParameterValues("all_enr");
            System.out.println("Total Number of Students: "+student.length);    
            String[] name               =    request.getParameterValues("name");
            System.out.println("Total Name of Students: "+name.length); 
            String[] hiddenCourse = request.getParameterValues("hide_course");
            System.out.println("Total Number of hidden course : "+hiddenCourse.length);    
            
        
            int dispatchStudentCount = 0, index = 0;
            int quantity =    0;//FIELD FOR HOLDING THE NUMBER OF MATERIALS TO BE DISPATCHED TO THE STUDENTS
            String remarks              =    "FOR STUDENTS";//FIELD FOR THE REMARKS IN THE SC_DISPATCH TABLE BECAUSE THIS CONTAIN TWO TYPE OF ENTRY ON FOR STUDENT AND OTHER FOR SC OFFICE USE
            String dispatchSource      =    "BY SC";//FOR THE DISPATCH_MODE FIELD OF STUDENT_DISPATCH TABLE BECAUSE HERE INFORMATION IS STORED OF MODE OF Despatch TO STUDENTS
            String[] enrno              =   request.getParameterValues("enrno");//ARRAY VARIABLE FOR GETTING ALL THE SELECTED ROLL NUMBERS ON THE BROWSER BY THE CLIENT
            String message = null;//FIELD FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
            String relativeCourse = null;
            int actual_qty = 0;//FIELD FOR CHECKING THE AVAILABLE QUANTITY OF THE STUDY MATERIAL OF SELECTED COURSE BY THE CLIENT

            String regionalCenterCode = (String)session.getAttribute("rc");
            System.out.println("All Parameters received from JSP"); 
            request.setAttribute("first_timer", firstTimer);       
            request.setAttribute("number_of_blocks",    numberOfBlocks);      
            request.setAttribute("initial_block",       initialBlock);
            request.setAttribute("student",             student);
            request.setAttribute("name",                name);
            request.setAttribute("hidden_course",hiddenCourse);            
            request.setAttribute("semester",        year);
            request.setAttribute("current_session",currentSession);        
            request.setAttribute("date",date);      
                            
            int available_qty           =   0;      
            response.setContentType(Constants.HEADER_TYPE_HTML);
            PrintWriter out = response.getWriter();
            ResultSet rs = null,blk = null;
            try {
                Connection con = connections.ConnectionProvider.conn();//creating the object of Connection with the database
                Statement stmt = con.createStatement();//creating the object of Statement and getting the reference of Statement object into it from the Connection Object
                int result = 5,result1 = 5,result2 = 5,blocks = 0;
                blk = stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+courseCode+"' and rc_code='"+regionalCenterCode+"'");
                while(blk.next()) {
                    relativeCourse = blk.getString(1);
                }
    
                /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM THE ACTUAL COURSE CODE*/  
                String[] relativeCourseCode = new String[0];
                rs  =   stmt.executeQuery("select count(*) from course_course where absolute_crs_code='"+courseCode+"' and rc_code='"+regionalCenterCode+"'");
                if(rs.next()) {
                    relativeCourseCode = new String[rs.getInt(1)];
                }
        
                index = 0;
                rs  =   stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+courseCode+"' and rc_code='"+regionalCenterCode+"'");
                while(rs.next()) {
                    relativeCourseCode[index] = rs.getString(1);
                    index++;
                }
                /*LOGIC FOR GETTING THE RELATIVE COURSE CODE FROM ACTUAL COURSE CODE FOR CHECKING IN DESPATCH DATABASE*/
                String dispatchCourseCode="(crs_code='"+courseCode+"'";        
                for(index = 0;index<relativeCourseCode.length;index++) {
                    dispatchCourseCode = dispatchCourseCode + " or crs_code='" + relativeCourseCode[index] + "'";
                }
                dispatchCourseCode = dispatchCourseCode+")";        
                /*LOGIC ENDS HERE OF GETTING RELATIVE COURSE CODE IN DESPATCH DATABASE*/    

                if(buttonValue.equals("SKIP")) {
                    if(numberOfBlocks>0) {
                        int j = 0;
                        j = initialBlock-numberOfBlocks;
                        String block = "B"+j;
                        System.out.println("Created Block name is: "+block);
                        int sam = 0;
                
                        for(index = 0;index<student.length;index++) {
                            rs = stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+block+"' and reentry='NO'");
                            if(rs.next()) {   
                                dispatchStudentCount++;
                            }
                        }
                        String[] dispatch_student       = new String[dispatchStudentCount];
                        String[] dispatch_name          = new String[dispatchStudentCount];
                        String[] dispatch_date          = new String[dispatchStudentCount];
                        String[] dispatch_mode          = new String[dispatchStudentCount];
                        System.out.println("Array of Student Dispatched Created of length "+dispatchStudentCount);
                        index=0;
                        int insert_index = 0;
                        /*Inserting the Roll Numbers of the Despatched Students of the Study Centres*/      
                        for(index = 0;index<student.length;index++) {
                            rs = stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+block+"' and reentry='NO'");
                            if(rs.next()) {
                                dispatch_student[insert_index]          =   rs.getString(1);
                                dispatch_date[insert_index]             =   rs.getDate(6).toString();
                                dispatch_mode[insert_index]             =   rs.getString(7);
                                insert_index++;
                            }
                        }
                        System.out.println("loop se bahar aaya rey..");
                        /*CREATING ARRAY OF DESPATCHED NAMES FROM THE ARRAY OF ALL STUDENTS EARLIER CREATED IN THE SERVLET*/            
                        for(index = 0;index<dispatch_student.length;index++) {
                            for(int z = 0;z<student.length;z++) {
                                if(dispatch_student[index].equals(student[z])) {
                                    dispatch_name[index] = name[z];
                                }
                            }
                        }
                        /*LOGIC FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/
                        rs = stmt.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+courseCode+"' and block='"+block+"' and medium='"+medium+"'");
                        while(rs.next()) {
                            available_qty = rs.getInt(1);
                        }
                
                        request.setAttribute("available_qty",available_qty);
                        /*LOGIC ENDS HERE FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/                  
                        /*SETTING THE DESPATCH INDEXES FOR THE NEXT PAGE*/
                        request.setAttribute("dispatch_student",dispatch_student);
                        request.setAttribute("dispatch_date",dispatch_date);
                        request.setAttribute("dispatch_mode",dispatch_mode);
                        request.setAttribute("dispatch_name",dispatch_name);
        
                        try {
                                message = (String)request.getAttribute("alternate_msg");
                        } catch(Exception ees) { 
                            message = null;
                        }
        
                        j = j-1;
                        if(message==null) {
                            message="You have Skipped the Despatch Of Block "+j+".";
                        } else {
                            message=message+" <br/>You have Skipped the Despatch of Block "+j+".";
                        }

                        request.setAttribute("msg",message);
                        System.out.println("sc_code= "+studyCenterCode+" prg_code= "+programmeCode+" crs_code= "+courseCode+" year= "+year+" medium= "+medium+" sets= "+student.length );
                        request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code="+studyCenterCode+"&prg_code="+programmeCode+"&crs_code="+courseCode+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
                    } else {
                        message="Complete Despatch OF COURSE "+courseCode+"<br/>";
                        request.setAttribute("msg",message);
                        request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
                    }    
                } else {
                    //IF USER HAS CLICKED ON DESPATCH BUTTON THEN THIS ELSE SECTION WILL WORK
                    if (enrno != null) {
                        //if atleast one student has been selected by the user then this section will work and if not selected any student by the user then else section will work.
    
                        /*LOGIC FOR FILTERING THE ACTUAL COURSE CODES RECEIVED AS HIDDEN FILED FROM THE BROWSER*/
                        String hii[]=new String[enrno.length];
                        for(index=0;index<enrno.length;index++) {
                            for(int k=0;k<student.length;k++) {
                                if(enrno[index].equals(student[k])) {
                                    hii[index]=hiddenCourse[k];
                                }
                            }
                        }
                        /*LOGIC ENDS HERE FOR FILTERING THE ACTUAL COURSE CODE*/
                        quantity = enrno.length;   //number of sets to be despatched according to the number of checkboxes checked.
                        /*LOGIC FOR GETTING THE ACTUAL CURRENT QUANTITY OF THE BLOCK FROM MATERIAL DATABASE IN ACTUAL_QTY VARIABLE*/
                        rs = stmt.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+courseCode+"' and block='"+blockName+"' and medium='"+medium+"'");
                        while(rs.next()) {
                            actual_qty=rs.getInt(1);
                        }
            
                        /*LOGIC ENDS HERE FOR GETTING THE ACTUAL CURRENT QUANTITY*/
                        if(actual_qty-quantity>-1){
                            //if stock available then this section will work or else section will work.
        
                            quantity=enrno.length;
                            for(int i=0;i<enrno.length;i++) {
                                result = stmt.executeUpdate("insert into student_dispatch_"+currentSession+"_"+regionalCenterCode+"(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('"+enrno[i]+"','"+programmeCode+"','"+hii[i]+"','"+blockName+"',1,'"+date+"','"+dispatchSource+"','"+medium+"','NO')");   
                            }  
                            result2=stmt.executeUpdate("insert into sc_dispatch_"+currentSession+"_"+regionalCenterCode+" values('"+studyCenterCode+"','"+courseCode+"','"+blockName+"',"+quantity+",'"+medium+"','"+date+"','"+remarks+"')");          
                            result1=stmt.executeUpdate("update material_"+currentSession+"_"+regionalCenterCode+" set qty=qty-"+quantity+" where crs_code='"+courseCode+"' and block='"+blockName+"' and medium='"+medium+"'");

                            if(result==1 && result1==1 && result2==1) {
                                System.out.println("Material of "+courseCode+" Despatched to "+quantity+" Students<br/>Of Study centre "+studyCenterCode+"");   
                                message="Material of Block "+blockName+" Of<br/> Course "+courseCode+" Despatched <br/>to "+quantity+" Students of Study Centre "+studyCenterCode+"";
                            } else if(result==1 && result1 ==1 && result2!=1) {
                                message="Despatch and Material Table Hitted but SC despatch Table Not Affected...";
                            } else if(result==1 && result2 ==1 && result1!=1) {
                                message="Despatch and SC Despatch table Hitted but Material Table Not affected...";
                            } else {
                                message="No Operation Performed.Please Try Again";
                            }
            
                            if(numberOfBlocks>0) {
                                //IF MORE BLOCKS TO BE DESPATCHED THEN THIS IF SECTION WILL WORK
                                int j=0;
                                j=initialBlock-numberOfBlocks;
                                String block="B"+j;
                                int sam=0;              
                                for(index=0;index<student.length;index++) {
                                    rs=stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+block+"' and reentry='NO'");
                                    if(rs.next()) {   
                                        dispatchStudentCount++;
                                    }
                                }
                                String[] dispatch_student       = new String[dispatchStudentCount];
                                String[] dispatch_name          = new String[dispatchStudentCount];
                                String[] dispatch_date          = new String[dispatchStudentCount];
                                String[] dispatch_mode          = new String[dispatchStudentCount];
                                index=0;
                                int insert_index=0;
                                /*INSERTING THE ROLL NUMBERS OF THE DESPATCHED STUDENTS OF TEH STUDY CENTRES*/      
                                for(index=0;index<student.length;index++) {
                                    rs=stmt.executeQuery("select * from student_dispatch_"+currentSession+"_"+regionalCenterCode+" where enrno='"+student[index]+"' and "+dispatchCourseCode+" and block='"+block+"' and reentry='NO'");
                                    if(rs.next()) {
                                        dispatch_student[insert_index]          =   rs.getString(1);
                                        dispatch_date[insert_index]             =   rs.getDate(6).toString();
                                        dispatch_mode[insert_index]             =   rs.getString(7);
                                        insert_index++;
                                    }
                                }

                                /*CREATING ARRAY OF DESPATCHED NAMES FROM THE ARRAY OF ALL STUDENTS EARLIER CREATED IN THE SERVLET*/            
                                for(index=0;index<dispatch_student.length;index++) {
                                    for(int z=0;z<student.length;z++) {
                                        if(dispatch_student[index].equals(student[z])) {
                                            dispatch_name[index]=name[z];
                                        }
                                    }
                                }

                                /*LOGIC FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED IN MATERIAL DATABASE*/
                                rs=stmt.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+courseCode+"' and block='"+block+"' and medium='"+medium+"'");
                                while(rs.next()) {
                                    available_qty=rs.getInt(1);
                                }

                                request.setAttribute("available_qty",available_qty);
                                /*LOGIC ENDS HERE FOR CREATING INT VARIABLE OF AVAILABLE SETS OF THE COURSE SELECTED*/                  
                                /*SETTING ALL THE DESPATCH RELATED INROMATION ON THE REQUEST TO THE NEXT PAGE*/
                                request.setAttribute("dispatch_student",dispatch_student);
                                request.setAttribute("dispatch_date",dispatch_date);
                                request.setAttribute("dispatch_mode",dispatch_mode);
                                request.setAttribute("dispatch_name",dispatch_name);
                
                                try { 
                                    message = (String)request.getAttribute("alternate_msg");
                                } catch(Exception ees) {
                                    message = null;
                                }
                                if(message==null) {
                                    message = "";
                                }
                
                                request.setAttribute("msg",message);
                                request.getRequestDispatcher("jsp/To_sc_students1.jsp?sc_code="+studyCenterCode+"&prg_code="+programmeCode+"&crs_code="+courseCode+"&year="+year+"&medium="+medium+"&sets="+student.length+"").forward(request,response);
                            } else {
                                //IF NO MORE BLOCK IS TO BE DESPATCH THEN THIS LOGIC WILL WORK
                                message="Complete Despatch OF COURSE "+courseCode+".<br/>";
                                request.setAttribute("msg",message);
                                request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);
                            }
                        } else {
                            //if out of stock material then this else section will work
                            System.out.println("Materials of "+courseCode+" Course can not dispatched to "+quantity+" Students as out of Stock");
                            message="Can not Despatch "+quantity+" Sets of Block "+blockName+" of<br/> Course "+courseCode+" Course<br/> As in Stock "+actual_qty+" Sets Only";
                            request.setAttribute("msg",message);
                            request.setAttribute("number_of_blocks",    numberOfBlocks);      
                            request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request,response);           
                        }
                    } else {
                        //IF NO STUDENT HAS BEEN SELECTED BY THE USER THEN THIS ELSE SECTION WILL WORK
                        System.out.println("No Student Selected ..please select Student");
                        message="Please Select Student before Submitting";
                        request.setAttribute("alternate_msg",message);
                        request.setAttribute("number_of_blocks",Integer.parseInt(request.getParameter("number_of_blocks")));        
                        request.getRequestDispatcher("BYSCSEARCH?mnu_sc_code="+studyCenterCode+"&mnu_prg_code="+programmeCode+"&mnu_crs_code="+courseCode+"&textyear="+year+"&textmedium="+medium+"&textsession="+currentSession+"&first_timer="+firstTimer+"").forward(request,response);   
                    }
                }
            } catch(Exception exe) {
                System.out.println("exception mila rey from BYSCSTUDENTSUBMIT.java and exception is "+exe);
                message="Some Serious Exception Hitted the page.Please check on the Server Console for Further Details";
                request.setAttribute("msg",message);
                request.getRequestDispatcher("To_sc_students.jsp").forward(request,response);
            }
        }
    }
}