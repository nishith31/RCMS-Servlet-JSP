package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO STUDENT DESPATCH AND SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE MAINLY.BY THIS
SERVLET SYSTEM SAVE THE DATA OF THOSE STUDENTS TO WHOM MATERIALS ARE DISTRIBUTED BY THE STUDY CENTRE DIRECTLY.THIS SERVLET ALSO CHECKS
FOR THE PRIMARY KEY VOILATION IN THE TWO DESPATCH TABLES, IF NO VIOALTION FOUND THEN SAVES THE DATA TO THE CORRESPONDING TABLES
AND GENERATE APPROPRIATE MSGS.
CALLED JSP:-To_sc_students_pg1.jsp*/
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import static utility.CommonUtility.isNull;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.Constants;
 
public class BYSCSTUDENT_PG_SUBMIT extends HttpServlet {

    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    } 

    @SuppressWarnings("unused")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java   
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String buttonValue = request.getParameter("enter").toUpperCase();           
            buttonValue = buttonValue.trim();            
            /*LOGIC FOR CHECKING THAT IF USER HAS CLICKED ON BACK BUTTON IF THERE IS NO WAY TO DESPATCH THEN*/  
            if(buttonValue.equals("BACK")) {
                String message = "Welcome Back to the Searching Page";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request, response);
            } else {
                /*LOGIC FOR DESPATCH THE MATERIALS IF USER HAS CLICKED ON THE DESPATCH BUTTON*/
                String studyCenterCode = request.getParameter("txt_sc_code").toUpperCase();//FIELD FOR STORING THE STUDY CENTRE CODE OF THE STUDENT
                String programmeCode = request.getParameter("txt_prog_code").toUpperCase();//FIELD FOR STORING THE PROGRAM CODE OF THE STUDENT
                String courseCode = request.getParameter("txt_crs_code").toUpperCase();//FIELD FOR STORING THE COURSE CODE OF THE STUDENTS
                String year = request.getParameter("txt_year").toUpperCase();//FIELD FOR STORING THE YEAR OR SEMESTER DETAILS OF THE STUDENT
                String medium = request.getParameter("txt_medium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM OPTED BY THE STUDENT
                String date = request.getParameter("txt_date").toUpperCase();//FIELD FOR HOLDING THE DATE OF Despatch OF MATERIALS
                String currentSession = request.getParameter("txt_session").toLowerCase();//FIELD FOR STORING THE NAME OF THE CURRENT SESSION MEANS CURRENTLY USED SESSION
                String[] student = request.getParameterValues("all_enr");
                String[] name = request.getParameterValues("name");

                int dispatchStudentCount = 0, index = 0;
                int qty = 0;//FIELD FOR HOLDING THE NUMBER OF MATERIALS TO BE DISPATCHED TO THE STUDENTS
                String remarks = "FOR STUDENTS";//FIELD FOR THE REMARKS IN THE SC_DISPATCH TABLE BECAUSE THIS CONTAIN TWO TYPE OF ENTRY ON FOR STUDENT AND OTHER FOR SC OFFICE USE
                String dispatchSource = "BY SC";//FOR THE DISPATCH_MODE FIELD OF STUDENT_DISPATCH TABLE BECAUSE HERE INFORMATION IS STORED OF MODE OF Despatch TO STUDENTS
                String[] enrno = request.getParameterValues("enrno");//ARRAY VARIABLE FOR GETTING ALL THE SELECTED ROLL NUMBERS ON THE BROWSER BY THE CLIENT
                String message = null;//FIELD FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
                String relativeCourse = null;
                int actualQuantity = 0;//FIELD FOR CHECKING THE AVAILABLE QUANTITY OF THE STUDY MATERIAL OF SELECTED COURSE BY THE CLIENT

                String regionalCenterCode = (String)session.getAttribute("rc");
                int availableQuantity = 0;
                response.setContentType(Constants.HEADER_TYPE_HTML);
                ResultSet rs = null, blk = null;
                try {
                    Connection connection = connections.ConnectionProvider.conn();//creating the object of Connection with the database
                    Statement statement = connection.createStatement();//creating the object of Statement and getting the reference of Statement object into it from the Connection Object
                    int result = 5, result1 = 5, result2 = 5, blocks = 0;
                    /*  blk=stmt.executeQuery("select relative_crs_code from course_course where absolute_crs_code='"+crs_code+"' and rc_code='"+rc_code+"'");
                        while(blk.next())
                        relative_course=blk.getString(1);*/
                    if (enrno != null) {
                        //if atleast one student has been selected by the user then this section will work and if not selected any student by the user then else section will work.
                        qty = enrno.length;//number of sets to be despatched according to the number of checkboxes checked.
                        rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" +
                        programmeCode + "' and block='PG' and medium='" + medium + "'");

                        while(rs.next()) {
                            actualQuantity = rs.getInt(1);
                        }
                        if(actualQuantity - qty > -1) {
                          //if stock available then this section will work or else section will work.
                            qty = enrno.length;
                            for(int i = 0;i < enrno.length; i++) {
                                result = statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                        + "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,reentry)values('" + enrno[i] + "','" + programmeCode + 
                                        "','" + programmeCode + "','PG',1,'" + date + "','" + dispatchSource + "','" + medium + "','NO')");
                            }  
                            result2 = statement.executeUpdate("insert into sc_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " values('" + studyCenterCode + "','" + programmeCode + "','PG'," + qty + ",'" + medium + "','" + date + "','" + remarks + "')");

                            result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " set qty=qty-" + qty + 
                                    " where crs_code='" + programmeCode + "' and block='PG' and medium='" + medium + "'");

                            if(result == 1 && result1 == 1 && result2 == 1) {
                                System.out.println("PRGRAMME GUIDE OF " + programmeCode + " dispatched to " + qty + " students of Study centre " + studyCenterCode);
                                message = "PROGRAMME GUIDE Of " + programmeCode + "<br/> Despatched to " + qty + " Students of Study Centre " + studyCenterCode;
                            } else if(result == 1 && result1 == 1 && result2 != 1) {
                                message = "Despatch and Material Table Hitted but SC despatch Table Not Affected...";
                            } else if(result == 1 && result2 == 1 && result1 != 1) {
                                message = "Despatch and SC Despatch table Hitted but Material Table Not affected...";
                            } else {
                                message = "No Operation Performed.Please Try Again";
                            }
                            request.setAttribute("msg", message);
                            request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request, response);
                        } else {
                            //if out of stock material then this else section will work
                            message = "Can not Despatch " + qty + " PROGRAMME GUIDE OF " + programmeCode + " .<br/> As in Stock " + actualQuantity + " Sets Only";
                            request.setAttribute("msg", message);
                            request.getRequestDispatcher("jsp/To_sc_students_pg.jsp").forward(request, response);
                        }
                    } else {
                        //    if no student has been selected by the user then this else section will work
                        System.out.println("No Student Selected ..please select Student");
                        message = "Please Select Student Before Submitting";
                        request.setAttribute("alternate_msg", message);
                        request.getRequestDispatcher("BYSC_PG_SEARCH?mnu_sc_code=" + studyCenterCode + "&mnu_prg_code=" + programmeCode + "&mnu_crs_code=" + courseCode + 
                                "&textyear=" + year + "&textmedium=" + medium + "&textsession=" + currentSession).forward(request, response);
                    } 
                } catch(Exception exception) {
                    System.out.println("Exception raised from BYSCSTUDENT_PG_SUBMIT.java and exception is " + exception);
                    message = "Some Serious Exception Hitted the page.Please check on the Server Console for Further Details";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/To_sc_students.jsp").forward(request, response);
                }
            }
        }
    }
}