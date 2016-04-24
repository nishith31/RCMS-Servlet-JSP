package servlets;
/*THIS SERVLET IS RESPONSIBLE FOR UPDATING THE EXPRESS PARCEL NUMBER OF THE COURSES DESPATCHED BY POST FOR THE STUDENTS.
THIS SERVLET TAKES THE DETAILS OF THE DESPATCHED COURSES FROM THE BROWSER AND THEN UPDATE THE NEW EXPRESS PARCEL NUMBER FOR
THE SELECTED COURSES.
CALLED JSP:-Lot_Update.jsp*/
import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.Constants;
 
public class LOTUPDATESEARCH extends HttpServlet {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("LOTUPDATESEARCH SERVLET STARTED TO EXECUTE");
    } 

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session=request.getSession(false);//getting and checking the availability of session of java
    
        if(session == null) {
            String message = Constants.LOGIN_ACCESS_MESSAGE;
            request.setAttribute("msg", message);
            request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
        } else {
            /*LOGIC FOR GETTING THE PARAMETERS FROM THE BROWSER LIKE NAME ROLL NO*/
            String message="";
            String buttonValue             =    request.getParameter("enter").toUpperCase();           
            buttonValue                =    buttonValue.trim();           
            System.out.println("Value of Button: "+buttonValue);   
            if(buttonValue.equals("REFRESH")) {
                System.out.println("Entered into REFRESH block");
                request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
            } else {      
                try {
                    String lots[]           =    request.getParameterValues("lot_name");//all the lot name from the jsp page
                    int index=0,len=0;
                    int pg_result=0,pg_result1=0,pg_result2=0;
                    if(lots==null ) {
                        message="Please Select Any One Lot Name to Update.<br/>";
                        request.setAttribute("msg",message);            
                        request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request,response);
                    } else {
                        message=lots.length+" Lots Selected For Updation.<br/>";
                        request.setAttribute("lots", lots);
                        request.setAttribute("msg", message);
                        request.getRequestDispatcher("jsp/Lot_Update1.jsp").forward(request, response);
                    }
                } catch(Exception exception) {
                    message = "Some Serious Exception Hitted the page. Please check on Server Console for Details";
                    request.setAttribute("msg", message);
                    request.getRequestDispatcher("jsp/Lot_Update.jsp").forward(request, response);
                }
            }
        }
    }
}