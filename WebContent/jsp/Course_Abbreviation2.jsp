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
	request.getRequestDispatcher("login.jsp").forward(request,response);
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
<title>Course Abbreviation</title>
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
				statement_empty=connection.createStatement();				
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body >
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
<li><a href="Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li class="youarehere"><a href="Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">				ABBRE<U>V</U>IATION		</a></li> 
<li><a href="Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>
  <%! int tab=0; %>
  <div id="content"><a name="contentstart" id="contentstart"></a>
  <%String success_flag=null,relative_course=null,course=null;
  success_flag=(String)request.getAttribute("success_flag");
  relative_course=(String)request.getAttribute("relative_course"); 
    course=(String)request.getAttribute("course"); %>
<form name="form_abbreviation" action="Admin_Welcome.jsp" method="get">
<% if(success_flag.equals("YES")){ %>
    <h1>Successfully Assigned Short Name for the Course<%=course%></h1><br />
    <table border="0" cellpadding="0" cellspacing="0">
    <tr><td width="233"><div align="center"><strong>IGNOU COURSE CODE</strong></div></td>
    <td width="232"><strong>RELATIVE COURSE CODE</strong></td>
    </tr>
    
		<tr><td width="233"><div align="center"><strong><%= course%></strong></div></td>
	    <td width="232"><strong><%= relative_course %></strong></td>
	    </tr>    
    
    </table>
    <%}
	else
	{
	%>
    <h1>Sorry Can not Assign this As It Exists Already.</h1><br/>
        <table border="0" cellpadding="0" cellspacing="0">
    <tr><hr />
    <td width="233"><div align="center"><strong>IGNOU COURSE CODE</strong></div></td>
    <td width="232"><div align="center"><strong>RELATIVE COURSE CODE</strong></div></td>
    </tr>
    
		<tr><hr />
        <td width="233"><div align="center"><strong><%= course%></strong></div></td>
	    <td width="232"><div align="center"><strong><%= relative_course %></strong></div></td>	
	 </tr>    
    
    </table>

    <%}%>
    <table width="456" border="0" cellspacing="0">
      <tr><hr /><hr />
        <td width="185"><div align="center">
          <A href="Course_Abbreviation.jsp" title="Click to go Back" tabindex="<%=tab+2%>">Add More</A>
        </div></td>
        <td width="267"><div align="center">
          <input type="submit"  class="button" name="submit" value="HOME" tabindex="<%=++tab%>" />
        </div></td>
      </tr>
    </table>
    </form>
    <p>&nbsp;</p>
  </div>

  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>


    <%if(msg==null){%>
    <h3>Addition of New Abbreviation:</h3>
    <p>To Add new Abbreviation Select the actual code from the IGNOU Database first and then check it and then assign short cut code for the actual code.</p>
      <%}%>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>


<script type="text/javascript">


</script>
</body>
</html>
<%}%>