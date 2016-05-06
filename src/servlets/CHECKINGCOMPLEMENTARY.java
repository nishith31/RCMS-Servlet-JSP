package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR DISTRIBUTNG STUDY MATERIALS AS COMPLEMENTARY COPIES WITH SOME REFERENCE. 
 * HERE WE DISPTRIBUTE MATERIALS BLOCK WISE MEANS NUMBER OF BLOCKS AND IF ANY BLOCK IS NOT AVAILABLE THEN WE CAN DISTRIBUTE EXPECT THAT BLOCKS.
CALLED JSP:-Complementary1.jsp*/    
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
 
public class CHECKINGCOMPLEMENTARY extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);    
        System.out.println("CHECKINGCOMPLEMENTARY SERVLET STARTED TO EXECUTE");
    } 
 
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);//getting and checking the availability of session of java
        if(isNull(session)) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            } else {
    
                String[] course = request.getParameterValues("crs_code");//all the course codes from the jsp page
                String[] quantity = request.getParameterValues("txt_no_of_set");
                int[] qty = new int[quantity.length];
            
                int blockCount = 0;
                int count = 0;
                String[] temp = new String[0];
                for(int i = 0; i < quantity.length; i++) {
                    qty[i] = Integer.parseInt(quantity[i]);//FIELD FOR HOLDING THE QUANTITY OF MATERIALS TO BE DESPATCHED
                }
                String medium = request.getParameter("txt_medium").toUpperCase();//FIELD FOR HOLDING THE MEDIUM SELECTED BY THE STUDENT
                String date = request.getParameter("txt_date");//FIELD FOR HOLDING THE DATE SELECTED BY THE STUDENT
                String name = request.getParameter("txt_name");//FIELD FOR HOLDING THE DATE SELECTED BY THE STUDENT
                String reference = request.getParameter("txt_rfrnc");//FIELD FOR HOLDING THE DATE SELECTED BY THE STUDENT
                double contact = Double.parseDouble(request.getParameter("txt_cont_no"));
                String purpose = request.getParameter("mnu_prps").toUpperCase();    
                String currentSession = request.getParameter("txt_session").toLowerCase();//FIELD FOR HOLDING THE NAME OF THE CURRENT SESSION THAT IS BEING CREATED
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
                    String quantityRemaining = ""; 
                    /*logic for getting the number of total courses selected by user*/
                    for(int c = 0; c < course.length; c++) {
                        temp = request.getParameterValues(course[c]);
                        if(!isNull(temp)) {
                            blockCount = blockCount + temp.length;
                        }
                    }
                    System.out.println("Number of Selected Checkbox of blocks " + blockCount);
                    String[] courseDispatch = new String[blockCount];//array for holding the courses to be dispatched
                /*logic for getting all the courses selected by the user*/
                for(int d=0;d<course.length;d++)
                {
                    String[] course_block=   request.getParameterValues(course[d]);
                    if(course_block!=null)
                    {
                        int len=course_block.length;
                        for(int e=0;e<len;e++)
                        {
                            courseDispatch[count]=course_block[e];
                            count++;
                        }
                    }
                }
                /*logic ends here*/
                System.out.println("Courses selected for Despatch:"+blockCount);
                if (blockCount != 0) 
                {
                    for(int z=0;z<course.length;z++)
                    {
                        int len=course[z].length();
                        for(int y=0;y<courseDispatch.length;y++)
                        {
                            String course_check=courseDispatch[y].substring(0,len);
                            String block_check=courseDispatch[y].substring(len);
                            String initial=block_check.substring(0,1);
                            if(course[z].equals(course_check))
                            {
                                if(initial.equals("B"))
                                {
            rs=statement.executeQuery("select * from complementary_dispatch_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+course[z]+"' and block='"+block_check+"' and date='"+date+"' and contact="+contact+"");
                                    if(!rs.next())//IF DUPLICATE RECORDS NOT FOUND THEN ENTER ON THIS SECTION FOR FURTHER ACTIONS OTHERWISE TO ELSE BLOCK.
                                    {
            rs=statement.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
                                while(rs.next())
                                        actualQuantity=rs.getInt(1);
                                        if(actualQuantity<1)
                                        {
                                            flagForReturn++;
                                            message=message+" 1 set of Block "+block_check.substring(1)+" of "+course[z]+" Course.<br/>";
                                        }//end of if
                                    }//end of if(!rs.next)
                                    else
                                    {
                                        flagForDuplicate=1;
                                    }//end of else(!rs.next)
                                }//end of if(initial.equals("B"))
                            }//end of if(course[z].equals(course_check))
                        }//end of for loop of y
                    }//end of for loop z
                    if(flagForDuplicate==0)
                    {
                    if(flagForReturn==0)
                    {
                        for(int z=0;z<course.length;z++)
                        {
                            int len=course[z].length();
                            for(int y=0;y<courseDispatch.length;y++)
                            {
                                String course_check=courseDispatch[y].substring(0,len);
                                String block_check=courseDispatch[y].substring(len);
                                String initial=block_check.substring(0,1);
                                if(course[z].equals(course_check))
                                {
                                    if(initial.equals("B"))
                                    {
            result=statement.executeUpdate("insert into complementary_dispatch_"+currentSession+"_"+regionalCenterCode+" values('"+course[z]+"','"+block_check+"',"+qty[z]+",'"+medium+"','"+date+"','"+name+"','"+reference+"',"+contact+",'"+purpose+"')");   
            System.out.println("query chala rey");
            result1=statement.executeUpdate("update material_"+currentSession+"_"+regionalCenterCode+" set qty=qty-"+qty[z]+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
            rs=statement.executeQuery("select qty from material_"+currentSession+"_"+regionalCenterCode+" where crs_code='"+course[z]+"' and block='"+block_check+"' and medium='"+medium+"'");
                                        while(rs.next())
                                        {
                                            remainingQuantity=rs.getInt(1);
                                            quantityRemaining=quantityRemaining+" set remained of "+block_check+" of "+course[z]+": "+remainingQuantity+"<br/>";
                                        }//end of while loop
                                    }//end of if(initial.equals("B"))
                                }//end of if(course[z].equals(course_check))
                            }//end of for loop of y
                        }//end of for loop z
            System.out.println("loop se bahar aaya");           
                        if(result==1 && result1==1)
                        {   
                            message=""+courseDispatch.length+" Books Despatched.<br/>"+quantityRemaining;
                        }
                        else if(result==1 && result1 !=1)
                        {
                            message="Despatch table Hitted but material Table not Affected!!!";
                        }
                        else
                        {
                            message="No Operation Performed..!!";
                        }
                        request.setAttribute("msg",message);
                        request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);    
                    }//end of if(flag_for_return=0)
                    else
                    {
                        System.out.println("Materials out of Stock,Demanded "+qty+" Sets and in Store "+actualQuantity+" Sets");
                        message="Can not Despatch,As Out of Stock.<br/>Thank you.";
                        request.setAttribute("msg",message);
                        request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);    
                    }//end of else of if(flag_for_return=0)
                    }//end of if(flag_for_duplicate=0)
                    else
                    {
                        System.out.println("Records Already Exists..primary key violation.");
                        message="Can not Enter these Details As they Already Exist.<br/>Change one or more values from the Combination<br/>";
                        request.setAttribute("msg",message);
                        request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);
                    }//end of else of if(flag_for_duplicate=0)
                }//end of if(block_count!=null)
            }//end of try blocks
            catch(Exception exe)
            {
                System.out.println("exception mila rey from BYRCSUBMIT.java and is "+exe);
                message="Some Serious Exception Hitted the Page.Please check on the Server Console for More Details";
                request.setAttribute("msg",message);
                request.getRequestDispatcher("jsp/Complementary.jsp").forward(request,response);
            }//end of catch blocks
            finally     
            {   } //END OF FINALLY BLOCKS
        }
    } 
}