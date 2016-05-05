package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING DATA TO OTHERS RECEIVE TABLE AND UPDATING MATERIAL TABLE.
IT ALSO CHECKS THE VIOLATION OF PRIMARY KEY MEANS DUPLICATE DATA CAN NOT
BE ENTER IN THE OTHERS RECEIVE TABLE.THIS SERVLET GETS ALL THE REQUIRED FIELDS FROM THE BROWSER AND AFTER 
CHECKING ALL THE CONSTRAINTS INSERT AND UPDATE THE CORRESPONDING TABLES
CALLED JSP:-From_others1.jsp*/
import java.io.IOException;

import static utility.CommonUtility.isNull;

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
 
public class RECEIVEOTHERSPARTIAL extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public void init(ServletConfig config) throws ServletException {
            super.init(config);
            System.out.println("RECEIVEOTHERSPARTIAL SERVLET STARTED TO EXECUTE");
    } 
 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String currentSession = request.getParameter("txt_session").toLowerCase();//getting the value of current session
            String courseCode = request.getParameter("mnu_crs_code").toUpperCase();//gettting the course code
            int blockCount = 0;//int variable for number of blocks available with the course
            String[] temp = new String[0];//array of String for multiple use
            /*logic for getting the number of total courses selected by user*/
            temp = request.getParameterValues(courseCode);
            if(!isNull(temp)) {
                blockCount = blockCount + temp.length;
            }
            String[] courseDispatch =  new String[blockCount];//array for holding the blocks to be receieved
            String[] blockQuantity = new String[blockCount];//array for holding the quantity of the blocks to be received
            /*logic for getting all the courses selected by the user*/
            String[] courseBlock = request.getParameterValues(courseCode);
            if(!isNull(courseBlock)) {
                int lengthDispatch = courseBlock.length;
                for(int e = 0; e < lengthDispatch;e++) {
                    courseDispatch[e] = courseBlock[e];
                    System.out.println("block:" + courseDispatch[e]);
                    blockQuantity[e] = request.getParameter(courseBlock[e]);
                }
            }
            String medium = request.getParameter("mnu_medium").toUpperCase();
            String date = request.getParameter("text_date").toUpperCase();//date from the jsp page date field
            String receiveFrom = request.getParameter("receive_from").toUpperCase();//receive_from from the jsp page receive_from field
            int flagForReturn = 0;
            ResultSet rs = null;
            System.out.println("All the Parameters received");
            request.setAttribute("current_session", currentSession);//setting the value of current session to the request
            String message = "";  
            String regionlaCenterCode = (String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();//creating the connection object for the database
                Statement statement = connection.createStatement();//fetching the reference of the statement from the connection object.
                int result = 5, result1 = 5;
                if (blockCount != 0) {
                    message = "Entry Already Exist for Course: " + courseCode + " <br/>";
                    int length = courseCode.length();
                    for(int y = 0; y < courseDispatch.length; y++) {
                        String courseCheck = courseDispatch[y].substring(0, length);
                        String blockCheck = courseDispatch[y].substring(length);
                        String initial = blockCheck.substring(0, 1);
                        if(courseCode.equals(courseCheck)) {
                            if(initial.equals("B")) {
                                rs = statement.executeQuery("select * from others_receive_" + currentSession + Constants.UNDERSCORE + 
                                        regionlaCenterCode + " where crs_code='" + courseCode + "' and block='" + blockCheck + "' and medium='"
                                        + medium + "' and date='" + date + "'");
                                
                                if(rs.next()) {
                                    message = message + " Block " + blockCheck + " for date " + date + " in medium " + medium + "<br/>";
                                    flagForReturn = 1;
                                }
                            }
                        }
                    }
                    if(flagForReturn==0) {
                        message = "Received Successfully from Others Course " + courseCode + " <br/>";
                        for(int y = 0; y < courseDispatch.length; y++) {
                            String courseCheck = courseDispatch[y].substring(0, length);
                            String blockCheck = courseDispatch[y].substring(length);
                            String initial = blockCheck.substring(0, 1);
                            if(courseCode.equals(courseCheck)) {
                                if(initial.equals("B")) {
                                    result = statement.executeUpdate("insert into others_receive_" + currentSession + Constants.UNDERSCORE + 
                                            regionlaCenterCode + "(crs_code,block,qty,medium,date,receive_from)values('" + courseCode + "','"
                                            + blockCheck + "'," + blockQuantity[y] + ",'" + medium + "','" + date + "','" + receiveFrom + "')");
                                    
                                    result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + 
                                            regionlaCenterCode + " set qty=qty+" + blockQuantity[y] + " where crs_code='" + courseCode + "' and block='"
                                            + blockCheck + "' and medium='" + medium + "'");
                                    
                                    message = message + " Block " + blockCheck + " for date " + date + " in medium " + medium + "<br/>";
                                }
                            }
                        }
                        if(result == 1 && result1 == 1) {   
                            System.out.println("Materials for " + courseDispatch.length + " courses received from Others");
                        } else if(result == 1 && result1 !=1) {
                            System.out.println("Receive table hitted but material table not affected..!!!!!");   
                        } else {
                            System.out.println("NO operation performed.!!!!!");   
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                        
                    } else {
                        //if material is out of stock then this section will work and give message to the user
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                    }
                } else {
                    System.out.println("Sorry !!Not any courses Selected...");
                    message = "Sorry!! Not any courses selected..";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from RECEIVEOTHERSPARTIAL.java and exception is " + exception);
                message = "Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_others.jsp").forward(request, response);
            }
        }
    } 
}