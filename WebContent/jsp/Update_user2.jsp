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
<title>USER UPDATE</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />

</head>
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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
    <li><a href="#">																													COURSE				</a></li>
    <li><a href="#">																													PROGRAM				</a></li>
    <li><a href="#">																													REGIONAL CENTRE		</a></li>
    <li><a href="#">																													STUDY CENTRE		</a></li>
    <li><a href="#">																													MEDIUM				</a></li>          
	<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Update_user.jsp" title="CLICK TO UPDATE THE USER INFO">												USER				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_user_update" action="Update_user.jsp" method="post" >
<%
String user=(String)request.getAttribute("user");
String rc=(String)request.getAttribute("rc");
String role=(String)request.getAttribute("role");
%>
	<table width="468" height="150" border="0">
      <tr><%! int tab=0; %>
        <td width="227" height="43"><div align="center"><strong>USER NAME:</strong></div></td>
        <td width="231"><strong><label><%=user%></label></strong></td><input type="hidden" name="user" value="<%=user%>" />
      </tr>
      <tr>
        <td height="40"><div align="center"><strong>RC CODE:</strong></div></td>
        <td><strong><label><%=rc%></label></strong></td><input type="hidden" name="rc" value="<%=rc%>" />
      </tr>
      <tr>
        <td height="40"><div align="center"><strong>ROLE:</strong></div></td>
        <td><strong><label><%=role.toUpperCase()%></label></strong></td><input type="hidden" name="role" value="<%=role%>" />
      </tr>
      
      <tr>
        <td colspan="2"><div align="center">
          <input type="submit" class="button" tabindex="<%= ++tab %>" value="OK" />
        </div></td>
        </tr>
    </table>
    </form>
  </div>
<div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <%if(msg==null){%>
    <h3>RESETING PASSWORD:</h3>
    <p>To Reset Password for any user provide the new password and update. ..</p>
    <%}%>
    </div>
  <div id="info-site">
    <p id="info-company">
    <a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%}%>