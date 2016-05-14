package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING THE DATA INTO SC DESPATCH TABLE AND UPDATING THE MATERIAL TABLE OF RC LOGGED IN.HERE WE GET THE NUMBER OF SETS OF SELECTED COURSE AND THE NAME OF THE COURSE TO BE DESPATCHED TO THE THE STUDY CENTRES AND WITH THE REASON OF DESPATCH MEANS PURPOSE OF DESPATCH OF MATERIAL. 
CALLED JSP:-To_sc_office1.jsp*/
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
 
public class BYSCPRIVATE_PG_SUBMIT extends HttpServlet {
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
            String studyCenterCode = request.getParameter("mnu_sc_code").toUpperCase();//FIELD FOR GETTING THE STUDY CENTRE CODE
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR GETTING THE COURSE CODE
            int quantity = Integer.parseInt(request.getParameter("text_no_of_set"));//FIELD FOR GETTING THE QUANTITY OF STUDY MATERIALS
            String medium = request.getParameter("text_medium").toUpperCase();//FIELD FOR GETTING THE MEDIUM OPTED BY THE STUDENT
            String date = request.getParameter("text_date").toUpperCase();//FIELD FOR GETTING THE DATE ENTERED IN THE BROWSER
            String remarks = request.getParameter("mnu_remarks").toUpperCase();//FIELD FOR GETTING THE REMARKS
            String currentSession = request.getParameter("text_session").toLowerCase();//FIELD FOR GETTING THE  SESSION NAME
            String message = "";//VARIABLE FOR SENDING APPROPRIATE MESSAGE TO THE BROWSER
            int remainQuantity = 0;//VARIABLE FOR HOLDING THE REMAINING QUANTITY OF MATERIALS AFTER SUCCESSFUL Despatch OF MATERIALS
            int result = 0, result1 = 0;
            String regionalCenterCode = (String)session.getAttribute("rc");//getting the code of thr rc which is logged in to the system

            response.setContentType(Constants.HEADER_TYPE_HTML);
            ResultSet rs = null;
            try {
                Connection connection = connections.ConnectionProvider.conn();//creating the connection object with the database
                Statement statement = connection.createStatement();//creating the statement object and getting the reference from the connection
                /*Logic for checking the primary key violation of the transaction*/
                rs = statement.executeQuery("select * from sc_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                        + " where sc_code='" + studyCenterCode + "' and crs_code='" + programmeCode + "' and block='PG' and date='" + date + "' and remarks='" + remarks + "'");
                if(!rs.next()) {
                    //this means no duplicate records found in the database and can enter the received details
                    int actualQuantity = 0;//variable for holding the actual quantity of the blocks of the course to Despatch
                    int success = 0;
                    /*logic for getting actual quantity of each block and inserting into sc_dispatch table and updating material table*/
                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" 
                            + programmeCode + "' and block='PG' and medium='" + medium + "'");
                    while(rs.next()) {
                        actualQuantity = rs.getInt(1);
                    }

                    if(actualQuantity - quantity > -1) {
                        //IF MATERIAL IS AVAILABLE FOR Despatch THEN THIS SECTION WILL WORK OTHERWISE ELSE BLOCK WILL WORK
                        result = statement.executeUpdate("insert into sc_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " values('" + 
                                studyCenterCode + "','" + programmeCode + "','PG'," + quantity + ",'" + medium + "','" + date + "','" + remarks + "')");

                        result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " set qty=qty-" + quantity
                                + " where crs_code='" + programmeCode + "' and block='PG' and medium='" + medium + "'");

                        rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" 
                                + programmeCode + "' and block='PG' and medium='" + medium + "'");
                        while(rs.next()) {
                            remainQuantity = rs.getInt(1);
                        }

                        if(result == 1 && result1 == 1) {
                            message = "Successfully despatched to SC " + studyCenterCode + " PROGRAMME GUIDE OF  " + programmeCode + " sets= " + quantity;
                        } else if(result == 1 && result1 != 1) {
                            message = "SC Despatch Table Hitted but Material Table Not Affected...";
                            request.setAttribute("msg", message);
                            request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
                        } else {
                            message = "No Operation Performed";
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
                    } else {
                        System.out.println("Materials Not Available for PROGRAMME GUIDE OF  : " + programmeCode);
                        message = "Sorry..<br/>Can not Despatch " + quantity + " PROGRAMME GUIDE OF " + programmeCode + "<br/> As Total sets in stock is " + actualQuantity;
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
                    }
                } else {
                    System.out.println("Sorry..Primary key violation..can not enter these details in the System...");
                    message = "You Cannot enter these details as they already Exists.<br/>Please Change One or More thing from the Combination of<br/> Study Centre= "
                            + studyCenterCode + "<br/>PROGRAMME GUIDE OF = " + programmeCode + "<br/>Date = " + date + "<br/> Remarks= " + remarks;

                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from BYSCPRIVATE_PG_SUBMIT.java " + exception);
                message = "Some Serious Exception came.Please check on the Server Console for more Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_sc_office_pg.jsp").forward(request, response);
            }
        }
    } 
}