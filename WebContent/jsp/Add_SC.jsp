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
<title>ADD SC</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var emailExp	 	= /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var letters 		= /^[A-Za-z]+$/;
var numbers 		= /^[0-9]+$/;
var code			=	document.form_add_sc.text_sc_code.value;
if(code=="" || code.length>6 || code==null)
{
	alert("ENTER SC CODE PLEASE LESS THEN 7 NUMBERS");
	document.form_add_sc.text_sc_code.value="";
	document.form_add_sc.text_sc_code.focus();
	return false;
}
var name			=	document.form_add_sc.text_sc_name.value;
if(name=="" || name.match(numbers) || name==null)
{
	alert("ENTER SC NAME IN WORDS...");
	document.form_add_sc.text_sc_name.value="";
	document.form_add_sc.text_sc_name.focus();
	return false;
}
var type			=	document.form_add_sc.text_sc_type.value;
if(type=="" || type.match(numbers) || type==null)
{
	alert("ENTER SC TYPE IN WORDS...");
	document.form_add_sc.text_sc_type.value="";
	document.form_add_sc.text_sc_type.focus();
	return false;
}
var cordinator	=	document.form_add_sc.text_coordinator_name.value;
if(cordinator=="" || cordinator.match(numbers) || cordinator==null)
{
	alert("ENTER SC COORDINATOR NAME IN WORDS...");
	document.form_add_sc.text_coordinator_name.value="";
	document.form_add_sc.text_coordinator_name.focus();
	return false;
}
var contact1		=	document.form_add_sc.text_contact_no.value;
if(contact1.length!=10 || contact1.match(letters) || contact1==null)
{
	alert("ENTER CONTACT NUMBER IN NUMBER FORMAT...");
	document.form_add_sc.text_contact_no.value="";
	document.form_add_sc.text_contact_no.focus();
	return false;
}
var address1		=	document.form_add_sc.text_address_part1.value;
if(address1=="")
{
	alert("PLEASE ENTER PART 1 ADDRESS");
	document.form_add_sc.text_address_part1.value="";
	document.form_add_sc.text_address_part1.focus();	
	return false;
}
var address2		=	document.form_add_sc.text_address_part2.value;
if(address1=="")
{
	alert("PLEASE ENTER PART 2 ADDRESS");
	document.form_add_sc.text_address_part2.value="";
	document.form_add_sc.text_address_part2.focus();	
	return false;
}


var city		=	document.form_add_sc.text_city.value;
if(city=="" || city.match(numbers) || city==null)
{
	alert("PLEASE ENTER THE CITY NAME");
	document.form_add_sc.text_city.value;
	document.form_add_sc.text_city.focus();
	return false;
}
var state		=	document.form_add_sc.text_state.value;
if(state=="" || state.match(numbers) || state==null)
{
	alert("PLEASE ENTER THE STATE NAME");
	document.form_add_sc.text_state.value="";
	document.form_add_sc.text_state.focus();
	return false;
}
var pin			=	document.form_add_sc.text_pincode.value;
if(pin=="" || pin.length!=6 || pin.match(letters) || pin==null)
{
	alert("PLEASE ENTER 6 DIGITS PIN CODE");
	document.form_add_sc.text_pincode.value="";
	document.form_add_sc.text_pincode.focus();
	return false;
}
var website		=	document.form_add_sc.text_website.value;
if(website=="" || website.match(numbers) || website==null)
{
	alert("PLEASE ENTER WEB ADDRESS OF REGIONAL CENTRE");
	document.form_add_sc.text_website.value="";
	document.form_add_sc.text_website.focus();
	return false;
}
var email		=	document.form_add_sc.text_email.value;
if(email.match(emailExp))
{}
else
{
	alert("PLEASE ENTER EMAIL ADDRESS IN RIGHT FORMAT LIKE abc@gmail.com..");
	document.form_add_sc.text_email.focus();
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
<li class="youarehere"><a href="Add_SC.jsp" accesskey="S">																			<U>S</U>TUDY CENTRE		</a></li>
<li><a href="Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
<li><a href="Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li><a href="Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
<li><a href="Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_add_sc" action="ADDSTUDY" method="post" onsubmit="return validateForm();">
    <table width="468" height="540" border="0">
      <tr><%int tab=0;%>
        <td width="208"><strong>STUDY CENTRE CODE:</strong></td>
        <td width="250">
<input name="text_sc_code" type="text" id="text_sc_code" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New SC Code" required autofocus/>
                <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" /></td>
      </tr>
      <tr>
        <td><strong>STUDY CENTRE NAME:</strong></td>
        <td>
<input name="text_sc_name" type="text" id="text_sc_name" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter New SC Name" required /></td>
      </tr>
      <tr>
        <td><strong>STUDY CENTRE TYPE:</strong></td>
        <td>
 <input name="text_sc_type" type="text" id="text_sc_type" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Type Of SC"/></td>
      </tr>
      <tr>
        <td><strong>SELECT INCHARGE/CO-ORDINATOR:</strong></td>
        <td><label>
          <select name="mnu_role" class="fieldsize" id="mnu_role" tabindex="<%= ++tab %>">
            <option value="COORDINATOR" selected="selected">COORDINATOR</option>
            <option value="PROGRAMME INCHARGE">PROGRAMME INCHARGE</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td><strong>NAME OF THE CO-ORDINATOR:</strong></td>
        <td>
<input name="text_coordinator_name" type="text" id="text_coordinator_name" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Co-Ordinator Name"/></td>
      </tr>
      <tr>
        <td><strong>CONTACT NUMBER:</strong></td>
        <td><input name="text_contact_no" type="text" id="text_contact_no" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Contact Number"/></td>
      </tr>
      <tr>
        <td><strong>CONTACT NUMBER(alternate):</strong></td>
        <td><label>
          <input name="text_contact_no_alternate" type="text" class="fieldsize" id="text_contact_no_alternate" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Alternate Contact No."/>
        </label></td>
      </tr>
      <tr>
        <td><strong><label for="email">Email:</label></strong></td>
        <td><input name="text_email" type="email" id="text_email" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Email Id " /></td>
      </tr>
      <tr>
        <td height="37"><strong>ADDRESS(part1):</strong></td>
        <td><input type="text" name="text_address_part1" id="text_address_part1" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Address Part One"/></td>
      </tr>
      <tr>
        <td><strong>ADDRESS(part2):</strong></td>
        <td><input type="text" name="text_address_part2" id="text_address_part2" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Address Part Two"/></td>
      </tr>
      <tr>
        <td><strong>CITY:</strong></td>
        <td><input name="text_city" type="text" id="text_city"  tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter City Name"/></td>
      </tr>
      <tr>
        <td><strong>STATE:</strong></td>
        <td><input name="text_state" type="text" id="text_state" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter State Name"/></td>
      </tr>
      <tr>
        <td><strong>PIN CODE:</strong></td>
        <td><input name="text_pincode" type="text" id="text_pincode" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter PIN Code of SC" /></td>
      </tr>
      <tr>
        <td><strong>WEBSITE:</strong></td>
        <td><input name="text_website" type="text" id="text_website" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Web Address of SC"/></td>
      </tr>
      <tr>
        <td><strong>PROGRAMMES ACTIVATED:</strong></td>
        <td><label>
          <input name="text_programs" type="text" class="fieldsize" id="text_programs" tabindex="<%= ++tab %>" onmouseover="mover(this)"  onmouseout="mout(this)" placeholder="Enter Activated Program in SC" />
        </label></td>
      </tr>
      <tr>
        <td><div align="center">
          <input name="reset" type="reset" class="button" id="reset"  tabindex="<%= tab+2 %>" onclick="document.form_add_sc.text_sc_code.focus();" value="CLEAR FIELDS"/>
        </div></td>
        <td><div align="center">
          <input name="add" type="submit" class="button" id="add" tabindex="<%= ++tab %>" value="ADD STUDY CENTRE" />
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
    <h3>Addition of Study Centre :</h3>
    <p>To Add More Study Centre to the Database you need to provide the necessary details here and Each Study Centre is uniquely identified by the SC code of the Study Centre.Any SC can not be added with the SC code which is already associated with any other Study Centre...</p>
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
</body>
</html>
<%}%>