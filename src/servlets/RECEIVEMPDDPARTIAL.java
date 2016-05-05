package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR INSERTING DATA TO STUDENT DESPATCH TABLE AND UPDATING MATERIAL TABLE.
IT ALSO CHECKS THE VIOLATION OF PRIMARY KEY MEANS DUPLICATE DATA CAN NOT BE
ENTER IN THE STUDENT DESPATCH TABLE.THIS SERVLET GETS ALL THE REQUIRED FIELDS FROM THE BROWSER AND AFTER CHECKING 
ALL THE CONSTRAINTS INSERT AND UPDATE THE CORRESPONDING TABLES
CALLED JSP:-From_mpdd1.jsp*/
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
 
public class RECEIVEMPDDPARTIAL extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYHANDFIRSTSUBMIT SERVLET STARTED TO EXECUTE");
    }
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            String currentSession = request.getParameter("txt_session").toLowerCase();//getting the value of current session
            String[] course = request.getParameterValues("crs_code");//all the course codes from the jsp page
            int blockCount  = 0;//int variable for number of blocks available with the course
            int count = 0;//int variable for multiple use
            String[] temp = new String[0];//array of String for multiple use
            int index = 0;
            /*logic for getting the number of total courses selected by user*/
            for(index = 0; index < course.length; index++) {
                temp = request.getParameterValues(course[index]);
                if(!isNull(temp)) {
                    blockCount = blockCount + temp.length;
                }
            }
            String[] courseDispatch = new String[blockCount];//array for holding the blocks to be receieved
            String[] blockQuantity = new String[blockCount];//array for holding the quantity of the blocks to be received
            /*logic for getting all the courses selected by the user*/
            for(index = 0; index < course.length; index++) {
                String[] courseBlock =  request.getParameterValues(course[index]);
                if(courseBlock!=null) {
                    int length = courseBlock.length;
                    for(int e = 0; e < length; e++) {
                        courseDispatch[count] = courseBlock[e];
                        blockQuantity[count] = request.getParameter(courseBlock[e]);
                        count++;
                    }
                }
            }

            String medium = request.getParameter("txt_medium").toUpperCase();//getting the medium selected by the user
            String date = request.getParameter("txt_date").toUpperCase();//date from the jsp page date field
            int flagForReturn = 0;
            ResultSet rs = null;
            System.out.println("All the Parameters received");
            request.setAttribute("current_session", currentSession);//setting the value of current session to the request
            String message = "";
            String regionalCenterCode = (String)session.getAttribute("rc");//getting the code of the rc which is logged in to the system
            response.setContentType(Constants.HEADER_TYPE_HTML);
            try {
                Connection connection = connections.ConnectionProvider.conn();//creating the connection object for the database
                Statement statement = connection.createStatement();//fetching the refernce of the statement from the connection object.
                int result = 5, result1 = 5;
                if (blockCount != 0) {
                    message = "Entry Already Exist for Course: <br/>";
                    for(int z = 0; z < course.length; z++) {
                        int length = course[z].length();
                        for(int y = 0;y < courseDispatch.length; y++) {
                            String courseCheck = courseDispatch[y].substring(0, length);
                            String blockCheck = courseDispatch[y].substring(length);
                            String initial = blockCheck.substring(0, 1);
                            if(course[z].equals(courseCheck)) {
                                if(initial.equals("B")) {
                                    rs = statement.executeQuery("select * from mpdd_receive_" + currentSession + Constants.UNDERSCORE + 
                                            regionalCenterCode + " where crs_code='" + course[z] + "' and block='" + blockCheck + "' and medium='" 
                                            + medium + "' and date='" + date + "'");
                                    if(rs.next()) {
                                        message = message + course[z] + " Block " + blockCheck + " for date " + date + " in medium " + medium + "<br/>";
                                        flagForReturn = 1;
                                    }
                                }
                            }
                        }
                    }
                    if(flagForReturn == 0) {
                        message = "Received Successfully from MPDD Course <br/>";
                        int increment = 0;
                        for(int z = 0; z < course.length; z++) {
                            int length = course[z].length();
                            for(int y = 0; y < courseDispatch.length; y++) {
                                String courseCheck = courseDispatch[y].substring(0, length);
                                String blockCheck = courseDispatch[y].substring(length);
                                String initial = blockCheck.substring(0, 1);
                                if(course[z].equals(courseCheck)) {
                                    if(initial.equals("B")) {
                                        result = statement.executeUpdate("insert into mpdd_receive_" + currentSession + Constants.UNDERSCORE + 
                                                regionalCenterCode + "(crs_code,block,qty,medium,date)values('" + course[z] + "','" + blockCheck
                                                + "'," + blockQuantity[increment] + ",'" + medium + "','" + date + "')");
                                        
                                        result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + 
                                                regionalCenterCode + " set qty=qty+" + blockQuantity[increment] + " where crs_code='" + 
                                                course[z] + "' and block='" + blockCheck + "' and medium='" + medium + "'");

                                        message = message + course[z] + " Block " + blockCheck + " for date " + date + " in medium " + medium + "<br/>";
                                        increment++;
                                    }
                                }
                            }
                        }
                        if(result == 1 && result1 == 1) {
                            System.out.println("Materials for " + course.length + " courses received from MPDD");
                        } else if(result == 1 && result1 != 1) {
                            System.out.println("Receive table hitted but material table not affected..!!!!!");   
                        } else {
                            System.out.println("NO operation performed.!!!!!");   
                        }
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
                    } else {
                        //if material is out of stock then this section will work and give message to the user
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
                    }
                } else {
                    System.out.println("Sorry !!Not any courses Selected...");
                    message = "Sorry!! Not any courses selected..";
                    request.setAttribute("alternate_msg", message);
                    request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
                }
            } catch(Exception exception) {
                System.out.println("Exception raised from RECEIVEMPDDPARTIAL.java and exception is " + exception);
                message = "Some Serious Exception Occured in the Page. Please Check On the Server Console for More Details";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/From_mpdd.jsp").forward(request, response);
            }
        }
    } 
}