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
<title>UPDATE SC</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" /></head>
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
      <li >						<a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li >						<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
    <li><a href="#">COURSE</a></li>
    <li><a href="#">PROGRAM</a></li>
    <li><a href="Update_RC.jsp">REGIONAL CENTRE</a></li>
    <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Update_SC.jsp">STUDY CENTRE</a></li>
    <li><a href="#">MEDIUM</a></li>          
	<li><a href="${pageContext.request.contextPath}/jsp/Update_user.jsp" title="CLICK TO UPDATE THE USER INFO">																USER					</a></li>          
              </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
  <form name="update_sc_form" action="" method="post">
  <%!int tab=0;%>
  <%String sc_code=null;
  System.out.println("jsp started");%>
    <table width="470" border="0" cellspacing="0">
      <tr height="34">
        <td width="228"><div align="center"><strong>STUDY CENTRE CODE:</strong></div></td>
        <td width="238"><input name="text_sc_code" type="text" class="greysize" id="text_sc_code" value="<%=(String)request.getAttribute("sc_code")%>" readonly="readonly"/>
        </td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>STUDY CENTRE NAME:</strong></div></td>
        <td><input name="text_sc_name" type="text" class="fieldsize" id="text_sc_name" value="<%=(String)request.getAttribute("sc_name")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>REGION CODE:</strong></div></td>
        <td><input name="text_reg_code" type="text" class="fieldsize" id="text_reg_code" value="<%=(String)request.getAttribute("reg_code")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>SC TYPE:</strong></div></td>
        <td><input name="text_sc_type" type="text" class="fieldsize" id="text_sc_type" value="<%=(String)request.getAttribute("sc_type")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>COORDINATOR/INCHARGE:</strong></div></td>
        <td><input name="text_incharge" type="text" class="fieldsize" id="text_incharge" value="<%=(String)request.getAttribute("incharge")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>COORDINATOR NAME:</strong></div></td>
 <td><input name="text_incharge_name" type="text" class="fieldsize" id="text_incharge_name" value="<%=(String)request.getAttribute("incharge_name")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>CONTACT1:</strong></div></td>
        <td><input name="text_contact1" type="text" class="fieldsize" id="text_contact1" value="<%=(Double)request.getAttribute("contact1")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>CONTACT2:</strong></div></td>
        <td><input name="text_contact2" type="text" class="fieldsize" id="text_contact2" value="<%=(Double)request.getAttribute("contact2")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>E-MAIL:</strong></div></td>
        <td><input name="text_email" type="text" class="fieldsize" id="text_email" value="<%=(String)request.getAttribute("email")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>WEBSITE:</strong></div></td>
        <td><input name="text_website" type="text" class="fieldsize" id="text_website" value="<%=(String)request.getAttribute("website")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>ADDRESS1:</strong></div></td>
        <td><input name="text_add1" type="text" class="fieldsize" id="text_add1" value="<%=(String)request.getAttribute("add1")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>ADDRESS2:</strong></div></td>
        <td><input name="text_add2" type="text" class="fieldsize" id="text_add2" value="<%=(String)request.getAttribute("add2")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>CITY:</strong></div></td>
        <td><input name="text_city" type="text" class="fieldsize" id="text_city" value="<%=(String)request.getAttribute("city")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>STATE:</strong></div></td>
        <td><input name="text_state" type="text" class="fieldsize" id="text_state" value="<%=(String)request.getAttribute("state")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td><div align="center"><strong>PIN CODE:</strong></div></td>
        <td><input name="text_pin" type="text" class="fieldsize" id="text_pin" value="<%=(String)request.getAttribute("pin")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr height="34">
        <td width="228"><div align="center"><strong>PROGRAMMES ACTIVATED:</strong></div></td>
        <td width="238"><input name="text_program" type="text" class="fieldsize" id="text_program" value="<%=(String)request.getAttribute("program")%>" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="add" type="submit" class="button" id="add" tabindex="<%= ++tab %>"  value="UPDATE STUDY CENTRE" />
        </div></td>
      </tr>
    </table>
    </form>
    <h1>&nbsp;</h1>
    <h2>&nbsp;</h2>
  </div>
<div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <h3>Update SC Section:</h3>
    <p>Update SC page displays you the details of any STUDY CENTRE whose code has been entered and allows you to update information about that Study Centre.</p>
    </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%}%>