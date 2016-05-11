package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR DESPATCHING MATERIAL BY POST TO STUDENTS IN BULK MODE,IT TAKES DETAILS OF ALL THE
 *  STUDENTS TO WHOM MATERIALS HAS TO BE SENT AND ALSO TAKES THE COURSE CODE AND MEDIUM AND THEN ENTER ALL THE TRANSACTION
 *   IN STUDENT DESPATCH TABLE WITH REMARKS BY POST AND IN THE MATERAILA TABLE UPDATE THE INVENTORY WHICH IS NOW LESS FROM THE EARLIER QUANTITY.
CALLED JSP:-By_post_bulk2.jsp*/
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
 
public class BYPOSTBULKSUBMIT extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("BYPOSTBULKSUBMIT SERVLET STARTED TO EXECUTE");
    }

    @SuppressWarnings("unused")
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        } else {
            /*Logic for getting all the parameters from the Browser via the request*/
            String programmeCode = request.getParameter("mnu_prg_code").toUpperCase();
            String courseCode = request.getParameter("mnu_crs_code").toUpperCase();
            String blockName = request.getParameter("block_name").toUpperCase();
            String currentSession = request.getParameter("text_session").toLowerCase();
            String medium = request.getParameter("text_medium").toUpperCase();
            String lot = request.getParameter("text_lot").toUpperCase();
            String date = request.getParameter("text_date").toUpperCase();
            String packetType = request.getParameter("text_pkt_type").toUpperCase();
            String firstTimer = request.getParameter("first_timer").toUpperCase();
            int packetWeight = Integer.parseInt(request.getParameter("text_pkt_wt"));
            int initialBlock = Integer.parseInt(request.getParameter("initial_block"));
            int numberOfBlocks = Integer.parseInt(request.getParameter("number_of_blocks"));
            numberOfBlocks = numberOfBlocks - 1;
            System.out.println("Number of Block received: " + numberOfBlocks);  
            String challanNumber = request.getParameter("text_chln_no").toUpperCase();
            String buttonValue = request.getParameter("enter").toUpperCase();           
            buttonValue = buttonValue.trim();
            String[] enrollmentNumber = new String[0];
            int index = 0;
            if(buttonValue.equals("SKIP")) {
                System.out.println("Entered into skip block");
            } else {
                enrollmentNumber = request.getParameterValues("enrno");
            }

            String[] student = request.getParameterValues("all_enr");
            String[] name = request.getParameterValues("name");
            String[] serialNumber = request.getParameterValues("serial");
            System.out.println("Total Number of Serial Numbers: " + serialNumber.length);
            String[] hiddenCourse = request.getParameterValues("hide_course");
            System.out.println("Total Number of hidden course : " + hiddenCourse.length);    

            int quantity = 0;
            int actualQuantity = 0;
            int remainingQuantity = 0;
            String dispatchSource = "BY POST";
            int start = Integer.parseInt(request.getParameter("text_start"));
            int end = Integer.parseInt(request.getParameter("text_end"));
            int finalLength = student.length;
            String message = null;    
            ResultSet rs = null;//ResultSet variable for  fetching the data from the statement
            String regionalCenterCode = (String)session.getAttribute("rc");
            request.setAttribute("first_timer", firstTimer);
            request.setAttribute("number_of_blocks", numberOfBlocks);
            request.setAttribute("initial_block", initialBlock);
            request.setAttribute("student", student);
            request.setAttribute("name", name);
            request.setAttribute("serial_number", serialNumber);
            request.setAttribute("hidden_course", hiddenCourse);
            request.setAttribute("start", start);
            request.setAttribute("end", end);

            request.setAttribute("date", date);
            request.setAttribute("packet_type", packetType);
            request.setAttribute("packet_weight", packetWeight);
            request.setAttribute("challan_no", challanNumber);
            request.setAttribute("current_session", currentSession);
            response.setContentType(Constants.HEADER_TYPE_HTML);

            try {
                Connection connection = connections.ConnectionProvider.conn();//connection object for connecting with the database
                Statement statement = connection.createStatement();//Statement object and fetching the reference from the conneciton object
                int result = 0, result1 = 0, result2 = 5, blocks = 0;
                /*logic for fetching the number of blocks of the course selected by the user to Despatch*/
                if(buttonValue.equals("SKIP")) {
                    int[] dispatchIndex;
                    if(numberOfBlocks > 0) {
                        /*logic for checking the students filtered above in the Despatch table*/
                        int j = 0;
                        j = initialBlock - numberOfBlocks;
                        String block = "B" + j;
                        int sam = 0;
                        for(int i = 0; i < finalLength; i++) {
                            try {
                                rs = statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                        + " where enrno='" + student[i] + "' and crs_code='" + courseCode + "' and block='" + block + "' and medium='" + medium + "'");
                                if(rs.next()) {
                                    sam++;
                                }
                            } catch(Exception exception) {
                                System.out.print("nahi hai " + student[i] + "---" + exception);
                            }
                        }
                        dispatchIndex = new int[sam];
                        sam = 0;
                        for(int i = 0; i < finalLength; i++) {
                            try {
                                rs = statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                        + " where enrno='" + student[i] + "' and crs_code='" + courseCode + "' and block='" + block + "' and medium='" + medium + "'");
                                if(rs.next()) {   
                                    dispatchIndex[sam] = i;
                                    sam++;
                                }
                            } catch(Exception exception) { 
                                System.out.print("Exception from for loop: " + exception);
                            }
                        }
                        int availableQuantity=0;
                        j = j - 1;
                        message = "You have Skipped the despatch of Block " + j + ".";
                        /*Logic for creating int variable of available sets of the course selected*/
                        rs = statement.executeQuery("select qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode
                                + " where crs_code='" + courseCode + "' and block='" + block + "' and medium='" + medium + "'");

                        while(rs.next()) {
                            availableQuantity = rs.getInt(1);
                        }

                        request.setAttribute("available_qty", availableQuantity);

                        request.setAttribute("dispatch_index", dispatchIndex);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code=" + programmeCode + "&crs_code=" + courseCode + "&medium=" + medium+"&lot="+lot+"&start="+start+"&end="+end+"&length="+finalLength+"").forward(request,response);
                    } else {
                        message = "Complete despatch";
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
                    }
                } else {
                    if (enrollmentNumber != null) {
                        //checking that any student has been selected or not if not then redirect to the browser
                        String hii[] = new String[enrollmentNumber.length];
                        for(index = 0; index < enrollmentNumber.length; index++) {
                            for(int k = 0; k <student.length; k++) {
                                if(enrollmentNumber[index].equals(student[k])) {
                                    hii[index] = hiddenCourse[k];
                                }
                            }
                        }

                        quantity = enrollmentNumber.length;//getting the total number of student selected by the user
                        rs = statement.executeQuery("select TOP 1 qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                " where crs_code='" + courseCode + "' and block='" + blockName + "' and medium='" + medium + "' ");
                        while(rs.next()) {
                            actualQuantity = rs.getInt(1);
                        }

                        if(actualQuantity - quantity > -1) {
                            //checking that stock available or not for course selected if not then else parr will work
                            if(programmeCode.equals("ALL")) {
                                for(int i = 0; i <enrollmentNumber.length; i++) {
                                    result = statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                            "(enrno,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry)values('" + enrollmentNumber[i] + 
                                            "','" + hii[i] + "','" + blockName + "',1,'" + date + "','" + dispatchSource + "','" + medium + "','" + challanNumber + "'," + packetWeight + ",'" + packetType + "','NO')");
                                }
                            } else {
                                for(int i = 0; i < enrollmentNumber.length; i++) {
                                    result = statement.executeUpdate("insert into student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                            "(enrno,prg_code,crs_code,block,qty,date,dispatch_source,medium,challan_no,pkt_weight,pkt_type,reentry)values('"  + 
                                            enrollmentNumber[i] + "','" + programmeCode + "','" + hii[i] + "','" + blockName + "',1,'" + date + "','" + dispatchSource + "','" + medium + "','"+challanNumber+"',"+packetWeight+",'"+packetType+"','NO')");
                                }
                            }
                            /*Logic for updating the material table after inserting the records into the student Despatch table*/
                            result1 = statement.executeUpdate("update material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                    " set qty=qty-" + quantity + " where crs_code='"  +courseCode + "' and block='" + blockName + "' and medium='" + medium + "'");
                            if(result == 1 && result1 == 1) {   
                                System.out.println("Material of " + courseCode + " of " + blockName + " despatched to " + quantity + " students of Study By Post");
                                message = "Material of " + courseCode + " of " + blockName + " Despatched to " + quantity + " students By Post";
                            } else if(result == 1 && result1 != 1) {   
                                System.out.println("Despatch table hitted but material table not affected..!!!!!!");   
                                message = "Despatch Table Hitted but material table Not Affected..";
                            } else if(result != 1 && result1 == 1) {
                                System.out.println("Material table affected..but despatch table not..!!!!!!");   
                                message = "Material Table Affected ,but Despatch table not affected..";
                            } else {
                                System.out.println("NO operation performed.!!!!!!");   
                                message = "No Operation Performed";
                            }

                            int[] dispatchIndex;
                            if(numberOfBlocks > 0) {
                                /*logic for checking the students filtered above in the Despatch table*/
                                int j = 0;
                                j = initialBlock - numberOfBlocks;
                                String block = "B" + j; 
                                System.out.println("Created Block name is: " + block);
                                int sam = 0;
                                for(int i=0;i<finalLength;i++) {
                                    try {
                                        rs = statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + 
                                                regionalCenterCode + " where enrno='" + student[i] + "' and crs_code='"  + hiddenCourse[i] + "' and block='" + block
                                                + "' and medium='" + medium + "'");
                                        if(rs.next()) {
                                            System.out.println("student found in Despatch table is: "  +rs.getString(1));
                                            sam++;
                                        }
                                    } catch(Exception exception) {
                                        System.out.print("nahi hai " + student[i] + "---" + exception);
                                    }
                                }
                                dispatchIndex = new int[sam];
                                sam = 0;
                                for(int i = 0; i < finalLength; i++) {
                                    try {
                                        rs  =statement.executeQuery("select distinct enrno from student_dispatch_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                                " where enrno='" + student[i] + "' and crs_code='" + hiddenCourse[i] + "' and block='" + block + "' and medium='" + medium + "'");
                                        if(rs.next()) {
                                            dispatchIndex[sam] = i;
                                            sam++;
                                        }
                                    } catch(Exception exception) {
                                        System.out.print("nahi hai " + exception);
                                    }
                                }
                                int avaialbleQuantity = 0;
                                /*Logic for creating int variable of available sets of the course selected*/
                                rs = statement.executeQuery("select TOP 1 qty from material_" + currentSession + Constants.UNDERSCORE + regionalCenterCode + 
                                        " where crs_code='" + courseCode + "' and block='" + block + "' and medium='" + medium + "' order by qty");
                                while(rs.next()) {
                                    avaialbleQuantity=rs.getInt(1);
                                }

                                request.setAttribute("available_qty", avaialbleQuantity);
                                request.setAttribute("dispatch_index", dispatchIndex);
                                request.setAttribute("msg", message);
                                request.getRequestDispatcher("jsp/By_post_bulk2.jsp?prg_code="+programmeCode+"&crs_code="+courseCode+"&medium="+medium+"&lot="+lot+"&start="+start+"&end="+end+"&length="+finalLength+"").forward(request,response);
                            } else {
                                message = "Complete Despatch of Course " + courseCode;
                                request.setAttribute("msg", message);
                                request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request, response);
                            }
                        } else {
                            System.out.println("Sorry...Materials out of stock for "+courseCode+".As only "+actualQuantity+" Sets are in Stock");
                            message = "Can not Despatch "+quantity+" Sets of "+courseCode+"<br/> As in Stock Only "+actualQuantity+" Sets";
                            request.setAttribute("alternate_msg", message);
                            request.getRequestDispatcher("BYPOSTBULKSEARCH?mnu_prg_code="+programmeCode+"&mnu_crs_code="+courseCode+"&mnu_medium="+medium+"&text_lot="+lot+"&text_start="+start+"&text_end="+end+"&").forward(request,response);
                        }
                    } else {
                        System.out.println("NO roll no selected..please select any roll no first..sending to servlet again");
                        message = "No Roll Number Selected<br/>";
                        request.setAttribute("alternate_msg", message);
                        request.getRequestDispatcher("BYPOSTBULKSEARCH?mnu_prg_code="+programmeCode+"&mnu_crs_code="+courseCode+"&mnu_medium="+medium+"&text_lot="+lot+"&text_start="+start+"&text_end="+end+"&").forward(request,response);

                    }
                }
            } catch(Exception exception) {
                System.out.println("EXCEPTION ON THE BYPOSTBULKSUBMIT SERLVET AND EXCEPTION IS "+exception);   
                message = "Some Serious exception come on the page.Please check on the Server Console for More Details.";
                request.setAttribute("msg", message);
                request.getRequestDispatcher("jsp/By_post_bulk1.jsp").forward(request,response);
            }
        }
    } 
}