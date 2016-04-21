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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" />
<meta name="keywords" content="Put your keywords here" />
<meta name="robots" content="index,follow" />
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
<title>ADD MEDIUM</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var name=document.form_medium.text_medium_name.value;
if(name==null || name.match(numbers) || name=="")
{
	alert("PLEASE ENTER THE MEDIUM NAME FIRST");
	document.form_medium.text_medium_name.value="";	
	document.form_medium.text_medium_name.focus();
	return false;
}
var code=document.form_medium.text_medium_code.value;
if(code==null || code.match(numbers) || code=="")
{
	alert("PLEASE ENTER THE MEDIUM CODE");
	document.form_medium.text_medium_code.value="";	
	document.form_medium.text_medium_code.focus();
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
function myFunction()
{
}//end of method myFunction()

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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Course.jsp" accesskey="C">																							<U>C</U>OURSE			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Program.jsp" accesskey="P">																						<U>P</U>ROGRAM			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Add_Medium.jsp" accesskey="E">																		M<U>E</U>DIUM			</a></li>   
<li><a href="${pageContext.request.contextPath}/jsp/Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
<li><a href="${pageContext.request.contextPath}/jsp/Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>

    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_medium" action="${pageContext.request.contextPath}/ADDMEDIUM" method="post" onsubmit="return validateForm()">
	<table width="468" height="150" border="0">
      <tr><%! int tab=0; %>
        <td width="227" height="43"><strong>MEDIUM NAME:</strong></td>
        <td width="231"><label>
<input type="text" name="text_medium_name" id="text_medium_name" class="fieldsize" onchange="upper(this)" tabindex="<%= ++tab %>" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New Medium Name" required autofocus/>
                <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" /></label></td>
      </tr>
      <tr>
        <td height="40"><strong>MEDIUM CODE(to be used in .dbf)</strong></td>
        <td><label>
 <input type="text" name="text_medium_code" id="text_medium_code" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New Medium Code" required />
                <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" /></label></td>
      </tr>
      <tr>
        <td><div align="center">
          <input type="reset" class="button"  tabindex="<%=tab+2 %>" value="CLEAR FIELDS"/>
        </div></td>
        <td><div align="center">
          <input type="submit" class="button" tabindex="<%= ++tab %>" value="ADD MEDIUM" onclick="return myFunction()"/>
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
    <h3>Addition of New Medium:</h3>
    <p>To Add a new Medium you need to provide the necessary details of the Medium accurately as these details are used in the Application and any wrong information will decrease the performance of the Application.Each Medium is uniquely identified by the Medium Code and a Medium Code can not be used for any other Medium name ..</p>
    <%}%>
    </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%}%>