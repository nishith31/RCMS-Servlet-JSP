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
<title>ADD RC</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var emailExp 			=	/^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var letters 			=	/^[A-Za-z]+$/;
var numbers 			=	/^[0-9]+$/;
var code				=	document.form_add_rc.text_rc_code.value;

if(code=="" || code.length>5 || code.match(letters))
{
	alert("ENTER RC CODE PLEASE LESS THEN 5 NUMBERS");
	document.form_add_rc.text_rc_code.value="";
	document.form_add_rc.text_rc_code.focus();
	return false;
}
var name				=	document.form_add_rc.text_rc_name.value;
if(name=="" || name.match(numbers))
{
	alert("ENTER RC NAME IN STRING PLEASE");
	document.form_add_rc.text_rc_name.value="";
	document.form_add_rc.text_rc_name.focus();
	return false;
}
var contact1			=	document.form_add_rc.text_contact_no1.value;
if(contact1.length!=10 || contact1=="" || contact1.match(letters))
{
	alert("CONTACT1 NUMBERS SHOULD OF 10 NUMBERS ONLY..");
	document.form_add_rc.text_contact_no1.value="";
	document.form_add_rc.text_contact_no1.focus();
	return false;
}
var contact2			=	document.form_add_rc.text_contact_no2.value;
if(contact2.length!=10 || contact2=="" || contact2.match(letters))
{
	alert("CONTACT2 NUMBERS SHOULD OF 10 NUMBERS ONLY..");
	document.form_add_rc.text_contact_no2.value="";
	document.form_add_rc.text_contact_no2.focus();
	return false;
}
var city				=	document.form_add_rc.text_city.value;
if(city=="" || city.match(numbers) || city==null)
{
	alert("PLEASE ENTER THE CITY NAME");
	document.form_add_rc.text_city.value="";
	document.form_add_rc.text_city.focus();
	return false;
}
var state				=	document.form_add_rc.text_state.value;
if(state=="" || state.match(numbers) || state==null)
{
	alert("PLEASE ENTER THE STATE NAME");
	document.form_add_rc.text_state.value="";
	document.form_add_rc.text_state.focus();
	return false;
}
var pin					=	document.form_add_rc.text_pincode.value;
if(pin=="" || pin.length!=6 || pin.match(letters))
{
	alert("PLEASE ENTER 6 DIGITS PIN CODE");
	document.form_add_rc.text_pincode.value="";
	document.form_add_rc.text_pincode.focus();
	return false;
}
var website				=	document.form_add_rc.text_website.value;
if(website=="" || website.match(numbers) || website==null)
{
	alert("PLEASE ENTER WEB ADDRESS OF RC");
	document.form_add_rc.text_website.value="";
	document.form_add_rc.text_website.focus();
	return false;
}
var email				=	document.ferm_add_rc.text_email.value;
if(email.match(emailExp))
{
	alert("PLEASE ENTER EMAIL ADDRESS IN RIGHT FORMAT LIKE abc@gmail.com..");
	document.form_add_rc.text_email.value="";
	document.form_add_rc.text_email.focus();
	return false;
}
var address				= 	document.form_add_rc.text_address.value;
if(address=="")
{
	alert("PLEASE ENTER ADDRESS");
	document.form_add_rc.text_address.value="";
	document.form_add_rc.text_address.focus();
	return false;
}
}
</script>
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
/* try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks*/
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
      <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Course.jsp" accesskey="C">																							<U>C</U>OURSE			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Program.jsp" accesskey="P">																						<U>P</U>ROGRAM			</a></li>
<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Add_RC.jsp" accesskey="G">																			RE<U>G</U>IONAL CENTRE	</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
<li><a href="${pageContext.request.contextPath}/jsp/Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
<li><a href="${pageContext.request.contextPath}/jsp/Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_add_rc" action="${pageContext.request.contextPath}/ADDREGION" method="post" onsubmit="return validateForm();">
    <table width="468" height="382" border="0">
      <tr><%! int tab=0; %>
        <td width="207"><strong>REGIONAL CENTRE CODE:</strong></td>
        <td width="251">
<input name="text_rc_code" type="text" class="fieldsize" id="text_rc_code" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New RC Code" required autofocus/>
                <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" /></td>
      </tr>
      <tr>
        <td><strong>REGIONAL CENTRE NAME:</strong></td>
        <td>
 <input name="text_rc_name" type="text" id="text_rc_name" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New RC Name" required /></td>
      </tr>
      <tr>
        <td><strong>CONTACT NUMBER 1:</strong></td>
        <td>
<input name="text_contact_no1" type="text" id="text_contact_no1" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Primary Contacy No."/></td>
      </tr>
      <tr>
        <td><strong>CONTACT NUMBER 2:</strong></td>
        <td>
<input name="text_contact_no2" type="text" id="text_contact_no2" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Second Contact No"/></td>
      </tr>
      <tr>
        <td><strong>E-mail ID:</strong></td>
        <td>
<input name="text_email" type="text" id="text_email" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Email Id for Contact"/></td>
      </tr>
      <tr>
        <td><strong>ADDRESS:</strong></td>
        <td>
<textarea name="text_address" id="text_address" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Address of RC"></textarea></td>
      </tr>
      <tr>
        <td><strong>CITY:</strong></td>
        <td>
<input name="text_city" type="text" id="text_city" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter City Name"/></td>
      </tr>
      <tr>
        <td><strong>STATE:</strong></td>
        <td>
 <input name="text_state" type="text" id="text_state" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter State Name"/></td>
      </tr>
      <tr>
        <td><strong>PIN CODE:</strong></td>
        <td>
<input name="text_pincode" type="text" id="text_pincode" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter PIN Code of RC"/></td>
      </tr>
      <tr>
        <td><strong>WEBSITE:</strong></td>
        <td>
<input name="text_website" type="text" id="text_website" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Web Address of RC"/></td>
      </tr>
      <tr>
        <td><div align="center">
          <input name="reset" type="reset" class="button" id="reset" tabindex="<%= tab+2 %>" onclick="document.form_add_rc.text_rc_code.focus();" value="CLEAR FIELDS"/>
        </div></td>
        <td><div align="center">
          <input name="add" type="submit" class="button" id="add" tabindex="<%= ++tab %>"  value="ADD REGIONAL CENTRE" />
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
    <h3>Addition of New Regional Centre:</h3>
    <p>To Add More Regional Centre to the Database you need to provide the necessary details here and Each Regional centre is Uniquely identified by the RC code.Any RC can not be Added with the RC code which is already associated with any other RC.</p>
		<div id="nav-supp">
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp">Add Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp">Updation Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp"> Material Entry</a></li>
      </ul>
    </div>

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