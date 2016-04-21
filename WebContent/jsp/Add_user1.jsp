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
<title>USER ADD</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var pswd=document.form_user_add.text_password.value;
if(pswd==null || pswd=="")
{
	alert("PLEASE ENTER NEW PASSWORD");
	document.form_user_add.text_password.value="";	
	document.form_user_add.text_password.focus();
	return false;
}
var confirm_pswd=document.form_user_add.text_confirm_password.value;
if(confirm_pswd==null || confirm_pswd=="")
{
	alert("PLEASE CONFIRM PASSWORD");
	document.form_user_add.text_confirm_password.value="";	
	document.form_user_add.text_confirm_password.focus();
	return false;
}
if(confirm_pswd != pswd)
{
alert("Please Enter Same Password in Confirm Password field");
document.form_user_add.text_confirm_password.value="";
document.form_user_add.text_confirm_password.focus();
return false;
}



var r=confirm("Are you Confirm to Proceed?");
if (r==true)
  {
  return true;
  }
else
  {
  return false;
  }

}//end of method validateForm()
function check_confirm()
{
var password=document.form_user_add.text_password.value;
var confirm_password=document.form_user_add.text_confirm_password.value;
if(confirm_password != password)
{
alert("Please Enter Same Password in Confirm Password field");
document.form_user_add.text_confirm_password.value="";
document.form_user_add.text_confirm_password.focus();
return false;
}
}//end of function check_confirm()
</script>
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
      <li>						<a href="Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li>						<a href="Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li class="current">		<a href="Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
    <li><a href="#">																													COURSE				</a></li>
    <li><a href="#">																													PROGRAM				</a></li>
    <li><a href="#">																													REGIONAL CENTRE		</a></li>
    <li><a href="#">																													STUDY CENTRE		</a></li>
    <li><a href="#">																													MEDIUM				</a></li>          
	<li class="youarehere"><a href="Update_user.jsp" title="CLICK TO UPDATE THE USER INFO">												USER				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_user_add" action="ADDUSERADD" method="post" onsubmit="return validateForm()">
<%
String user=(String)request.getAttribute("new_user");
String rc=(String)request.getAttribute("rc");
String rc_name=(String)request.getAttribute("rc_name");
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
        <td height="40"><div align="center"><strong>RC NAME:</strong></div></td>
        <td><strong><%=rc_name%></strong></td><input type="hidden" name="rc_name" value="<%=rc_name%>" />
      </tr>
      <tr>
        <td height="40"><div align="center"><strong>ROLE:</strong></div></td>
        <td><strong><label><%=role.toUpperCase()%></label></strong></td><input type="hidden" name="role" value="<%=role%>" />
      </tr>
      <tr>
        <td height="40"><div align="center"><strong>PASSWORD</strong></div></td>
        <td><label>
<input type="password" name="text_password" id="text_password" tabindex="<%= ++tab %>" class="fieldsize" placeholder="Enter Password" required autofocus/>
          <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" /></label></td>
      </tr>
      <tr>
        <td><div align="center"><strong>CONFIRM  PASSWORD</strong></div></td>
        <td><input type="password" name="text_confirm_password" id="text_confirm_password" tabindex="<%= ++tab %>" class="fieldsize" placeholder="Confirm Password" required  onchange="return check_confirm()"/></td>
      </tr>
      <tr>
        <td><div align="center">
          <input type="reset" class="button"  tabindex="<%=tab+2 %>" value="CLEAR FIELDS"/>
        </div></td>
        <td><div align="center">
          <input type="submit" class="button" tabindex="<%= ++tab %>" value="UPDATE PASSWORD" />
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
    <h3>CREATING USER:</h3>
    <p>To Create User for RC as Staff Provide the Password for that new User and the User will came into existence..</p>
    <%}%>
    </div>
  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%}%>