package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERT INTO RC DESPATCH TABLE AND UPDATE INTO MATERIAL TABLE.THIS WILL ALSO CHECK THE VIOLATION OF 
THE PRIMARY KEY FIRST IF NO VIOLATION FOUND IN THE RC DESPATCH TABLE THEN WILL SAVE THE REQUESTED DATA TO THE CORRESPONDING
TABLES AND GENERATE APPROPRIATE MESSAGE.
CALLED JSP:-By_rc_pg1.jsp*/
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
 
public class BYRC_PG_SUBMIT extends HttpServlet {

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
            String reg_code = request.getParameter("mnu_reg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
            String reg_name = request.getParameter("mnu_reg_name").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();//FIELD FOR HOLDING THE REGIONAL CENTRE CODE
            int quantity = Integer.parseInt(request.getParameter("text_qty"));
            String medium = request.getParameter("txtmedium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
            String date = request.getParameter("txtdate");//FIELD FOR HOLDING THE DATE SELECTED BY THE STUDENT
            String remarks = request.getParameter("txtrsn").toUpperCase();//FIELD FOR HOLDING THE REASON FOR Despatch OF MATERIAL TO REGIONAL CENTRE
            String currentSession = request.getParameter("txtsession").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
            int remainingQuantity = 0;                                                               //FIELD FOR HOLDING THE REMAINING QUANTITY AFTER Despatch
            int actualQuantity = 0;                                                           //FIELD FOR HOLDING THE AVAILABLE QUANTITY OF MATERIALS BEFORE Despatch IN STOCK
            int result = 5, result1 = 5;
            String message = null;
            ResultSet rs = null;//RESULTSET VARIABLE FOR FETCHING DATA FROM THE TABLES VARIOUS TIMES....
            String regionalCenterCode = (String)session.getAttribute("rc");//getting the rc code of the logged rc from the session

            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();
                Statement statement = connection.createStatement();
                int flagForReturn = 0, flagForDuplicate = 0;
                String quantityRemain = ""; 

                rs = statement.executeQuery("select * from rc_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode +
                        " where reg_code='" + reg_code + "' and crs_code='" + programmeCode + "' and block='PG' and date='" + date + "'");
                if(!rs.next()) {
                    //IF DUPLICATE RECORDS NOT FOUND THEN ENTER ON THIS SECTION FOR FURTHER ACTIONS OTHERWISE TO ELSE BLOCK.
                    rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                            " where crs_code='" + programmeCode + "' and block='PG' and medium='" + medium + "'");

                    while(rs.next()) {
                        actualQuantity = rs.getInt(1);
                    }

                    if(actualQuantity - quantity > -1) {
                        result = statement.executeUpdate("insert into rc_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " values('" + reg_code + "','" + programmeCode + "','PG'," + quantity + ",'" + medium + "','" + date + "','" + remarks + "')");

                        result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " set qty=qty-" + 
                        quantity + " where crs_code='" + programmeCode + "' and block='PG' and medium='" + medium + "'");

                        rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + " where crs_code='" + 
                        programmeCode + "' and block='PG' and medium='" + medium + "'");

                        while(rs.next()) {
                            remainingQuantity = rs.getInt(1);
                            quantityRemain = quantityRemain + remainingQuantity + " set remained of PROGRAMME GUIDE OF " + programmeCode + " <br/>";
                        }

                        if(result == 1 && result1 == 1){   
                            message = "" + quantity + " PRGRAMME GUIDE OF " + programmeCode + " Despatched to " + reg_name + "(" + reg_code + ").<br/>" + quantityRemain;
                        } else if(result == 1 && result1 != 1) {
                            message = "Despatch table Hitted but material Table not Affected!!!";
                        } else {
                            message = "No Operation Performed..!!";
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request, response); 
                    } else {
                        System.out.println("Materials out of Stock,Demanded " + quantity + " Sets and in Store " + actualQuantity + " Sets");
                        message = "Can not Despatch as material is out of stock.";
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request, response); 
                    }
                } else {
                    System.out.println("Records Already Exists..primary key violation.");
                    message = "Can not Enter these Details As they Already Exist.<br/>Change one or more values from the Combination of<br>RC= "+reg_name+"("+reg_code+")<br/> Programme Code:"+programmeCode+"<br/>Date: "+date+"";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from BYRC_PG_SUBMIT.java and is " + exception);
                message = "Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/To_rc_pg.jsp").forward(request, response);
            }
        }
    }
}