<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
String msg="Please Login to Access MDU System";
request.setAttribute("msg",msg);
	request.getRequestDispatcher("main_login.jsp").forward(request,response);
}
else
{
String rc_code=(String)sess.getAttribute("rc");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta  charset="utf-8" http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
<%  
ResourceBundle rb=ResourceBundle.getBundle("NishithBundle",Locale.getDefault());
	String home_menu=rb.getString("home_menu");
		String dispatch_menu=rb.getString("dispatch_menu");				
			String receive_menu=rb.getString("receive_menu");	
				String obsolete_menu=rb.getString("obsolete_menu");							
					String update_menu=rb.getString("update_menu");				
					String enquiry_menu=rb.getString("enquiry_menu");								
				String report_menu=rb.getString("report_menu");												
			String driver=rb.getString("driver");
	    String url=rb.getString("connectionurl");
	String user_name=rb.getString("username");
String pswd=rb.getString("password");
%>
<title>Update Student Details</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
<script>
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var Enrolment=document.form_student.text_enr.value;
if (Enrolment==null || Enrolment=="" || Enrolment.length!=9 || Enrolment.match(letters))
  {
  alert("Enrolment Must be of Nine Numbers");
  document.form_student.text_enr.value="";
  document.form_student.text_enr.focus();
  return false;
  }
}
function submitting()
{
				var name		=	document.form_student_update.text_name.value;
					var fname		=	document.form_student_update.text_fname.value;
					var program		=	document.form_student_update.text_program.value;
					var sc_code		=	document.form_student_update.text_sc.value;
					var rc_code		=	document.form_student_update.text_rc.value;
					var medium		=	document.form_student_update.text_medium.value;
					var add1		=	document.form_student_update.text_add1.value;
					var add2		=	document.form_student_update.text_add2.value;
					var add3		=	document.form_student_update.text_add3.value;
					var city		=	document.form_student_update.text_city.value;
					var state		=	document.form_student_update.text_state.value;
					var pin			=	document.form_student_update.text_pin.value;
					var mobile		=	document.form_student_update.text_mobile.value;
					var email		=	document.form_student_update.email.value;
	
	
				if(name=="")
				{
					document.form_student_update.text_name.value="NA";
				}

				if(fname=="")
				{
					document.form_student_update.text_fname.value="NA";
				}

				if(program=="")
				{
					document.form_student_update.text_program.value="NA";
				}

				if(sc_code=="")
				{
					document.form_student_update.text_sc.value="NA";
				}

				if(rc_code=="")
				{
					document.form_student_update.text_rc.value="NA";
				}

				if(medium=="")
				{
					document.form_student_update.text_medium.value="NA";
				}

				if(add1=="")
				{
					document.form_student_update.text_add1.value="NA";
				}

				if(add2=="")
				{
					document.form_student_update.text_add2.value="NA";
				}

				if(add3=="")
				{
					document.form_student_update.text_add3.value="NA";
				}

				if(city=="")
				{
					document.form_student_update.text_city.value="NA";
				}

				if(state=="")
				{
					document.form_student_update.text_name.state="NA";
				}

				if(pin=="")
				{
					document.form_student_update.text_pin.value="NA";
				}
				if(mobile=="")
				{
					document.form_student_update.text_mobile.value="NA";
				}

				if(email=="")
				{
					document.form_student_update.text_email.value="NA";
				}


}//end of method submitting


</script>
<script type="text/javascript" src="js/general.js"></script>

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
    <h1>RCMS-MDU PROJECT</h1>
    <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;<%= (String)sess.getAttribute("rc") %></li>      
        <li style="color:#FFFFFF">Welcome <%= (String)sess.getAttribute("user") %></li>
    <li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>
      </ul>
    </div>
  </div>
  <div id="nav-main">
    <ul>
      <li>						<a href="Home.jsp" title="HOME" accesskey="H">						<%=home_menu.trim()%>				</a></li>
      <li>						<a href="Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%>			</a></li>
	  <li>						<a href="Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%>			</a></li>
      <li>						<a href="Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%>			</a></li>
      <li>						<a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %>					</a></li>
      <li>						<a href="Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %>					</a></li>
     <li class="current">		<a href="Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %>					</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
        <li><a href="Update_parcel_no.jsp">Parcel Number</a></li>
   <li class="youarehere"><a href="Student_Update.jsp" >Student Details</a></li>
  <li><a href="Lot_Update.jsp" >LOT Name</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_student_update" action="STUDENTUPDATE" method="post" onsubmit="return validateForm()">  
    <hr /><hr />
    <table width="470" border="0">
      <tr><%! int tab=0; %>
        <td height="33"><strong>Enrolment Number:</strong></td>
        <td><label><%String enrno=request.getParameter("enrno").trim();%>
<input name="text_enr" type="text" class="greysize" id="text_enr"  <%if(enrno.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=enrno%>"<%}%> readonly="readonly" tabindex="<%=++tab%>"/>
        </label></td>
      </tr>
      <tr>
        <td><strong>Programme:</strong></td>
        <td><%String program=request.getParameter("program").trim();%>
 <input name="text_program" type="text" class="greysize" id="text_program" <%if(program.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=program%>"<%}%> readonly="readonly" tabindex="<%=++tab%>"/></td>
      </tr>
      
      </table>
      <hr /><hr />
          <table width="470" height="325" border="0">
      <tr>
        <td><strong>Name:</strong></td>
        <td><%String student_name=request.getParameter("name").trim();%>
<input name="text_name" type="text" class="fieldsize" id="text_name"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(student_name.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=student_name%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Father Name:</strong></td>
        <td><%String fname=request.getParameter("fname").trim();%>
<input name="text_fname" type="text" class="fieldsize" id="text_fname"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(fname.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=fname%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Study Centre:</strong></td>
        <td><%String sc_code=request.getParameter("sc_code").trim();%>
<input name="text_sc" type="text" class="fieldsize" id="text_sc"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(sc_code.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=sc_code%>"<%}%> onchange="upper(this)"/ tabindex="<%=++tab%>"></td>
      </tr>
      <tr>
        <td><strong>Regional Centre:</strong></td>
        <td><%String reg_code=request.getParameter("reg_code").trim();%>
<input name="text_rc" type="text" class="fieldsize" id="text_rc"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(reg_code.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=reg_code%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>medium:</strong></td>
        <td><%String medium=request.getParameter("medium").trim();%>
<input name="text_medium" type="text" class="fieldsize" id="text_medium"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(medium.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=medium%>"<%}%>  onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Address(Part1):</strong></td>
        <td><%String add1=request.getParameter("add1").trim();%>
<input name="text_add1" type="text" class="fieldsize" id="text_add1"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(add1.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=add1%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Address(Part2):</strong></td>
        <td><%String add2=request.getParameter("add2").trim();%>
<input name="text_add2" type="text" class="fieldsize" id="text_add2"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(add2.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=add2%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Address(Part3):</strong></td>
        <td><%String add3=request.getParameter("add3").trim();%>
        <input name="text_add3" type="text" class="fieldsize" id="text_add3"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(add3.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=add3%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>City:</strong></td>
        <td><%String city=request.getParameter("city").trim();%>
<input name="text_city" type="text" class="fieldsize" id="text_city"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(city.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=city%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>State:</strong></td>
        <td><%String state=request.getParameter("state").trim();%>
<input name="text_state" type="text" class="fieldsize" id="text_state"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(state.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=state%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Pin Code:</strong></td>
        <td><%String pin=request.getParameter("pin").trim();%>
<input name="text_pin" type="text" class="fieldsize" id="text_pin"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(pin.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=pin%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong>Mobile:</strong></td>
        <td><%String mobile=request.getParameter("mobile").trim();%>
<input name="text_mobile" type="text" class="fieldsize" id="text_mobile"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(mobile.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=mobile%>"<%}%> onchange="upper(this)" tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td><strong><label for="email">Email:</label></strong></td>
        <td><%String email=request.getParameter("email").trim();%>       
 <input name="text_email" type="email" class="fieldsize" id="email"  onmouseover="mover(this)"  onmouseout="mout(this)" <%if(email.equals("NA")){%> placeholder="NA, PLEASE PROVIDE" <%}else{%>value="<%=email%>"<%}%> tabindex="<%=++tab%>"/></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      
      
      <tr>
        <td><div align="center"><strong>
          <input type="reset" name="clear" value="CLEAR FIELDS" tabindex="<%=tab+2%>" class="button" />
        </strong></div></td>
        <td><div align="center">
          <input type="submit" name="submit" value="UPDATE" tabindex="<%=++tab%>" class="button" onclick="submitting()"/>
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
                <h3>About the RCMS-MDU:</h3>
    <p>The main idea behind this application is to maintain the Material Inventory of the Regional Centres in an Efficient Way.</p>
    
    <h3>Note:<BR />
    NA:-INFORMATION NOT AVAILABLE</h3>
    
</div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%
}
%>