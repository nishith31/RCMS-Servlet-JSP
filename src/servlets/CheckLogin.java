package servlets;
/*THIS IS ONE OF THE MOST IMPORTANT SERVLETS IN THE APPLICATION,THIS SERVLET IS RESPONSIBLE FOR CHECKING THE AUTHENTICATION OF 
 * THE USERS WHO WANT TO LOG IN TO THE SYSTEM IN DIFFERENT ROLE,IT 
 * TAKES USER NAME,PASSWORD,RC CODE AND ROLE OF THE USER AS INPUT AND THEN CHECKS THE AUTHENTICITY OF THESE RECORDS 
 * IF THESE ARE AUTHENTICATED TO LOGIN THEN ALLOW THE USER TO LOG IN OR ELSE SENDS THE APPROPRIATE MESSAGE TO THE USER ABOUT 
 * THE WRONG PARAMETERS SELECTED OR ENTERED BY THEM*/
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import utility.Constants;


public class CheckLogin extends HttpServlet {
 
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    /**
     * Log configuration
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("CHECKLOGIN SERVLET STARTED TO EXECUTE");
    }  
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String loginMode = request.getParameter("mode");
        System.out.println("value of mode variable is " + loginMode);
        String regionalCenterCode;
        String userName;
        String password;
        String role;

        if(loginMode=="direct") {
            regionalCenterCode  = (String)request.getAttribute("menu_rc_code");
            userName = (String)request.getAttribute("login");
            password = (String) request.getAttribute("password");
            role = (String)request.getAttribute("user_type");
        } else {
            regionalCenterCode  = request.getParameter("menu_rc_code");
            userName = request.getParameter("login");
            password = request.getParameter("password");
            role = request.getParameter("user_type");
        }
        response.setContentType(Constants.HEADER_TYPE_HTML);
        String message = "";
        try {
            System.out.println("we came through " + loginMode + " mode");
            Connection connection = connections.ConnectionProvider.conn();
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery("select * from login where rc_code='" + regionalCenterCode + "' and username='" + 
            userName + "' and password='" + password + "' and role='" + role + "'");
            if(rs.next()) {
                //LOGIC FOR GETTING THE REMEMBER ME OPTION
                if(request.getParameter("RememberMe") != null) {  
                    System.out.println("come to the RememberMe if sections");
                    Cookie regionalCenterCookie = new Cookie("rc_code_cookie", regionalCenterCode);
                    Cookie roleCookie = new Cookie("role_cookie", role);
                    Cookie userNameCookie = new Cookie("username_cookie", userName);
                    Cookie passwordCookie = new Cookie("password_cookie", password);
                    regionalCenterCookie.setMaxAge( 60 * 60 * 24 );
                    roleCookie.setMaxAge( 60 * 60 * 24 );
                    userNameCookie.setMaxAge( 60 * 60 * 24 );
                    passwordCookie.setMaxAge(60*60*24);
                    response.addCookie(regionalCenterCookie);
                    response.addCookie(roleCookie);
                    response.addCookie(userNameCookie);
                    response.addCookie(passwordCookie);
                } else {
                    System.out.println("come to the Not RememberMe else sections");
                    Cookie regionalCenterCookie = new Cookie("rc_code_cookie", null);
                    Cookie roleCookie = new Cookie("role_cookie", null);
                    Cookie userNameCookie = new Cookie("username_cookie", null);
                    Cookie passwordCookie = new Cookie("password_cookie", null);
                    regionalCenterCookie.setMaxAge( 0 );
                    roleCookie.setMaxAge( 0 );
                    userNameCookie.setMaxAge( 0 );
                    passwordCookie.setMaxAge( 0 );
                    response.addCookie( regionalCenterCookie );
                    response.addCookie( roleCookie );
                    response.addCookie( userNameCookie );
                    response.addCookie( passwordCookie );
                }
                //  LOGIC ENDS OF REMEMBER ME OPTION
                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(600);
                session.setAttribute("rc", regionalCenterCode);
                session.setAttribute("user_role", role);
                Date loginTime = new Date(session.getCreationTime());
            System.out.println("session created "+session);
            /*logic  for getting the name and version of the browser*/
              String browsername = "";
              String browserversion = "";
              String browser = (String)request.getHeader("User-Agent");
              if(browser.contains("MSIE"))
              {
                  String subsString = browser.substring( browser.indexOf("MSIE"));
                  String Info[] = (subsString.split(";")[0]).split(" ");
                  browsername = Info[0];
                    browserversion = Info[1];
            }
             else if(browser.contains("Firefox"))
             {
                  String subsString = browser.substring( browser.indexOf("Firefox"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Chrome"))
             {
                  String subsString = browser.substring( browser.indexOf("Chrome"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Opera"))
             {
                  String subsString = browser.substring( browser.indexOf("Opera"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Safari"))
             {
                  String subsString = browser.substring( browser.indexOf("Safari"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }          
            long start_time = System.currentTimeMillis( );
        /*end of logic of getting the name and version of the browser*/
          String ipAddress = request.getHeader("X-FORWARDED-FOR");  
           if (ipAddress == null)
            {  
                ipAddress = request.getRemoteAddr();  
            }
            //java.sql.Date login_date = new java.sql.Date(session.getCreationTime());//System.currentTimeMillis());
            //System.out.println(new Date(session.getCreationTime()));//System.currentTimeMillis());
            //System.out.println(new Date());//System.currentTimeMillis());
            request.setAttribute("uname",userName);    
            session.setAttribute("login_rc_code",regionalCenterCode);
            session.setAttribute("login_user_role",role);
            session.setAttribute("login_username",userName);
            session.setAttribute("login_time",loginTime);
            session.setAttribute("login_browser_name",browsername);
            session.setAttribute("login_browser_version",browserversion);
            session.setAttribute("login_ip_address",ipAddress);
            session.setAttribute("login_start_time",start_time);
            
            int result=statement.executeUpdate("insert into master_log_details(reg_code,user_role,username,login_time,browser_name,browser_version,ip_address,start_time)values('"+regionalCenterCode+"','"+role+"','"+userName+"','"+loginTime+"','"+browsername+"','"+browserversion+"','"+ipAddress+"',"+start_time+")");
    System.out.println("reg_code: "+regionalCenterCode+" user role: "+role+" username: "+userName);
    System.out.println("login date: "+loginTime+" browser name: "+browsername+" browser version: "+browserversion+" ip address: "+ipAddress);
        if(role.equals("staff"))//if user is staff then this section will work which will sends the staff username to the browser
        {
                session.setAttribute("user",userName);//setting the user name in the java session object
                request.getRequestDispatcher("jsp/Home.jsp").forward(request,response); 
        }//end of if 
        else//if user is admin then this else section will work which will sends the admin username to the browser
        {
            session.setAttribute("admin_user",userName);//setting the admin user name in the java session object
            request.getRequestDispatcher("jsp/Admin_Welcome.jsp").forward(request,response); 
        }//end of else
    }//END OF IF(rs.next())
     else//IF USER OR PASSWORD IS NOT CORRECT THEN THIS ELSE SECTION WILL WORK AND SENDS APPROPRIATE MESSAGE TO THE BROWER
    {
        System.out.println("Wrong User/Password!!!");
        message="Wrong User/Password!!!";
        request.setAttribute("msg",message);
        request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
    }//END OF ELSE
}//END OF TRY BLOCKS
catch(Exception ex)
{
    System.out.println("exception mila rey maaro"+ex);
    message="Exception in login";
    request.setAttribute("msg",message);
    request.getRequestDispatcher("jsp/login.jsp").forward(request,response);
}//END OF CATCH BLOCKS

}

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
{
String mode=request.getParameter("mode");
System.out.println("value of mode variable is "+mode);
    String rc   = null;
    String uname = null;
    String upass = null;
    String role=null;

    if(mode=="direct")
{
    rc  = (String)request.getAttribute("menu_rc_code");
    uname = (String)request.getAttribute("login");
    upass =(String) request.getAttribute("password");
    role=(String)request.getAttribute("user_type");
    }
//  if(mode=="direct")
else
{

    rc  = request.getParameter("menu_rc_code");
    uname = request.getParameter("login");
    upass = request.getParameter("password");
    role=request.getParameter("user_type");
    }
        response.setContentType("text/html");
    String msg="";
try{
System.out.println("we came through "+mode+" mode");
    Connection con=connections.ConnectionProvider.conn();
    Statement stmt=con.createStatement();
    ResultSet rs=stmt.executeQuery("select * from login where rc_code='"+rc+"' and username='"+uname+"' and password='"+upass+"' and role='"+role+"'");
        if(rs.next())// if(uname.equals(upass))
        {
        //LOGIG FOR GETTING THE REMEMBER ME OPTION
if(request.getParameter("RememberMe") != null){  
System.out.println("come to the RememberMe if sections");
Cookie rc_cookie = new Cookie("rc_code_cookie",rc);
Cookie role_cookie = new Cookie("role_cookie",role);
Cookie username_cookie = new Cookie("username_cookie",uname);
Cookie password_cookie = new Cookie("password_cookie",upass);
rc_cookie.setMaxAge(60*60*24);
role_cookie.setMaxAge(60*60*24);
username_cookie.setMaxAge(60*60*24);
password_cookie.setMaxAge(60*60*24);
response.addCookie(rc_cookie);
response.addCookie(role_cookie);
response.addCookie(username_cookie);
response.addCookie(password_cookie);
}
else
{
System.out.println("come to the Not RememberMe else sections");
Cookie rc_cookie = new Cookie("rc_code_cookie",null);
Cookie role_cookie = new Cookie("role_cookie",null);
Cookie username_cookie = new Cookie("username_cookie",null);
Cookie password_cookie = new Cookie("password_cookie",null);
rc_cookie.setMaxAge(0);
role_cookie.setMaxAge(0);
username_cookie.setMaxAge(0);
password_cookie.setMaxAge(0);
response.addCookie(rc_cookie);
response.addCookie(role_cookie);
response.addCookie(username_cookie);
response.addCookie(password_cookie);
 }
//LOGIC ENDS OF REMEMBER ME OPTION
            HttpSession session=request.getSession(true);
            session.setMaxInactiveInterval(600);
            session.setAttribute("rc",rc);
            session.setAttribute("user_role",role);
            Date login_time=new Date(session.getCreationTime());
            System.out.println("session created "+session);
            /*logic  for getting the name and version of the browser*/
              String browsername = "";
              String browserversion = "";
              String browser = (String)request.getHeader("User-Agent");
              if(browser.contains("MSIE"))
              {
                  String subsString = browser.substring( browser.indexOf("MSIE"));
                  String Info[] = (subsString.split(";")[0]).split(" ");
                  browsername = Info[0];
                    browserversion = Info[1];
            }
             else if(browser.contains("Firefox"))
             {
                  String subsString = browser.substring( browser.indexOf("Firefox"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Chrome"))
             {
                  String subsString = browser.substring( browser.indexOf("Chrome"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Opera"))
             {
                  String subsString = browser.substring( browser.indexOf("Opera"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }
             else if(browser.contains("Safari"))
             {
                  String subsString = browser.substring( browser.indexOf("Safari"));
                  String Info[] = (subsString.split(" ")[0]).split("/");
                  browsername = Info[0];
                  browserversion = Info[1];
             }          
            long start_time = System.currentTimeMillis( );
        /*end of logic of getting the name and version of the browser*/
          String ipAddress = request.getHeader("X-FORWARDED-FOR");  
           if (ipAddress == null)
            {  
                ipAddress = request.getRemoteAddr();  
            }
            //java.sql.Date login_date = new java.sql.Date(session.getCreationTime());//System.currentTimeMillis());
            //System.out.println(new Date(session.getCreationTime()));//System.currentTimeMillis());
            //System.out.println(new Date());//System.currentTimeMillis());
            request.setAttribute("uname",uname);    
            session.setAttribute("login_rc_code",rc);
            session.setAttribute("login_user_role",role);
            session.setAttribute("login_username",uname);
            session.setAttribute("login_time",login_time);
            session.setAttribute("login_browser_name",browsername);
            session.setAttribute("login_browser_version",browserversion);
            session.setAttribute("login_ip_address",ipAddress);
            session.setAttribute("login_start_time",start_time);
            
            int result=stmt.executeUpdate("insert into master_log_details(reg_code,user_role,username,login_time,browser_name,browser_version,ip_address,start_time)values('"+rc+"','"+role+"','"+uname+"','"+login_time+"','"+browsername+"','"+browserversion+"','"+ipAddress+"',"+start_time+")");
    System.out.println("reg_code: "+rc+" user role: "+role+" username: "+uname);
    System.out.println("login date: "+login_time+" browser name: "+browsername+" browser version: "+browserversion+" ip address: "+ipAddress);
        if(role.equals("staff"))//if user is staff then this section will work which will sends the staff username to the browser
        {
                session.setAttribute("user",uname);//setting the user name in the java session object
                request.getRequestDispatcher("Home.jsp").forward(request,response); 
        }//end of if 
        else//if user is admin then this else section will work which will sends the admin username to the browser
        {
            session.setAttribute("admin_user",uname);//setting the admin user name in the java session object
            request.getRequestDispatcher("Admin_Welcome.jsp").forward(request,response); 
        }//end of else
    }//END OF IF(rs.next())
     else//IF USER OR PASSWORD IS NOT CORRECT THEN THIS ELSE SECTION WILL WORK AND SENDS APPROPRIATE MESSAGE TO THE BROWER
    {
        System.out.println("Wrong User/Password!!!");
        msg="Wrong User/Password!!!";
        request.setAttribute("msg",msg);
        request.getRequestDispatcher("main_login.jsp").forward(request,response);
    }//END OF ELSE
}//END OF TRY BLOCKS
catch(Exception ex)
{
    System.out.println("exception mila rey maaro"+ex);
    msg="Exception in login";
    request.setAttribute("msg",msg);
    request.getRequestDispatcher("main_login.jsp").forward(request,response);
}//END OF CATCH BLOCKS
finally
{} //END OF FINALLY BLOCKS

}

public void destroy() {
 
}
} //end of class CheckLogin