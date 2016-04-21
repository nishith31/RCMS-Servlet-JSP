<%@ page import="java.util.Date" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.InetAddress,java.net.UnknownHostException" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
String uname=null;
uname=(String)sess.getAttribute("admin_user");
if(sess==null || uname==null)
{
String msg="Please Login As Admin to Access MDU System";
request.setAttribute("msg",msg);
	request.getRequestDispatcher("main_login.jsp").forward(request,response);
}
else
{
String rc_code=(String)sess.getAttribute("rc");
uname=(String)sess.getAttribute("admin_user");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
<%  
ResourceBundle rb=ResourceBundle.getBundle("NishithBundle",Locale.getDefault());
	String home_menu=rb.getString("admin_home_menu");
		String add_menu=rb.getString("admin_add_menu");				
			String update_menu=rb.getString("admin_update_menu");	
				String report_menu=rb.getString("admin_report_menu");	
			String driver=rb.getString("driver");
    	String url=rb.getString("connectionurl");
	String user_name=rb.getString("username");
String pswd=rb.getString("password");
%>
<title>NEW SESSION</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
//				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body>
<div id="container">
  <div id="banner">
    <h1>RCMS-MDU ADMIN</h1>
   <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;<%= rc_code%></li>
        <li style="color:#FFFFFF">Welcome <%= uname%></li>
                <li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>
                                </ul>
    </div>
  </div>

  <div id="nav-main">
    <ul>
      <li >						<a href="Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li class="current">		<a href="Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
<li><a href="Add_Course.jsp" accesskey="C">																							<U>C</U>OURSE			</a></li>
<li><a href="Add_Program.jsp" accesskey="P">																						<U>P</U>ROGRAM			</a></li>
<li><a href="Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
<li><a href="Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
<li><a href="Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
<li class="youarehere"><a href="Session_Create.jsp" accesskey="N">																	SESSIO<U>N</U>			</a></li>
<li><a href="Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
<li><a href="Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>
     <%String current_session=null,session_date=null,session_created_by=null,ip_address=null;
      try
	  {
		 rs=statement.executeQuery("select TOP 1 * from sessions_"+rc_code+" order by id DESC");
			while(rs.next())
			{
			current_session=rs.getString(2);
			session_date=rs.getString(3);
			session_created_by=rs.getString(4);
			ip_address=rs.getString(5);
			}
		}//end of try blocks
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
	%>	

  <div id="content">
  <form name="form_session" action="SESSIONCHECKING" method="post">
  <%! int tab=0; %>
  <a name="contentstart" id="contentstart"></a>
    <h2>Current Session:-&nbsp;&nbsp;<%=current_session.toUpperCase()%><BR />
    Session Created On:- <%=session_date%><BR />
    Session Created By:- <%=session_created_by.toUpperCase()%><BR />
    IP Address of the System from where Session Created:<%=ip_address%><BR /></h2>
    <hr /><hr />
    <strong>Select Details for New Session:-</strong>
    <hr /><hr />
    <table width="468" height="130" border="0" cellspacing="0">
      <tr>
        <td height="38"><div align="center"><strong>Select Month:
        </strong></div>
          <label></label>
          <div align="center"></div><div align="center"></div></td>
        <td><label>
          <div align="center">
            <strong>
            <select name="month" id="month" tabindex="<%= ++tab %>">
              <option value="jan">JANUARY</option>
              <option value="july">JULY</option>
            </select>
            </strong></div>
        </label></td>
      </tr>
      <tr>
        <td height="37"><div align="center"><strong>Select Year:</strong></div></td>
        <td><div align="center">
          <select name="year" id="year" tabindex="<%= ++tab %>">
            <option value="2012">2012</option>
            <option value="2013">2013</option>
            <option value="2014">2014</option>
            <option value="2015">2015</option>
            <option value="2016">2016</option>
          </select>
        </div></td>
      </tr>
      <tr>
        <td><div align="center">
          <input type="reset" class="button" value="CLEAR FIELDS" tabindex="<%= tab+2 %>"/>
        </div></td>
        <td><input type="submit" class="button" value="CHECK CREATION" tabindex="<%= ++tab %>"/></td>
      </tr>
    </table>
    <p>&nbsp;</p>
    <p>&nbsp;</p>
    </form>
  </div>
<div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
    <%if(msg==null)
	{%>
    <h3>Addition of New Session:</h3>
    <p>To Add a new Session you need to select the Month and Year name which will constitute the Session name and each Session name is uniquely identified by its name like july2012      and so on.A Session name can not be used more than one time and Session creation will create all the necessary tables for the new Session..</p>
    <div id="nav-supp">
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="Admin_Add.jsp">Add Section</a></li>
        <li><a href="Admin_Update.jsp">Updation Section</a></li>
        <li><a href="Admin_Report.jsp"> Material Entry</a></li>
      </ul>
    </div>
      <%}%>    
    </div>
  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</SCRIPT>
</body>
</html>
<%}%>