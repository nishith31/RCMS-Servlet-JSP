<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
}
else
{
	String rc_code=(String)sess.getAttribute("rc");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
<%! String roll="Enter Enrolment No"; %>
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
<title>Parcel Number Updation</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js" ></script>
</head>
<%/*Connection connection=null;
Statement statement=null,statement_empty=null;
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks*/
  %>
<body>
<div id="container">  <div id="banner"><script type="text/javascript" src="js/general.js"></script>
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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H">						<%=home_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%>			</a></li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%>			</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%>			</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %>					</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %>					</a></li>
     <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %>					</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
        <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Update_parcel_no.jsp">Parcel Number</a></li>
   <li ><a href="${pageContext.request.contextPath}/jsp/Student_Update.jsp" >Student Details</a></li>
  <li><a href="${pageContext.request.contextPath}/jsp/Lot_Update.jsp" >LOT Name</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_update_parcel" action="${pageContext.request.contextPath}/PARCELUPDATESEARCH" method="post" onsubmit="return validateForm()">
    <table width="469" border="0">
      <tr height="30"><%! int tab=0; %>
        <td><div align="center"><strong>Enrolment Number:</strong></div></td>
        <td>
          <label>
          <div align="center">
<input type="text" class="fieldsize"  name="text_enr" id="text_enr" maxlength="9" onmouseover="mover(this)" onmouseout="mout(this)" tabindex="<%= ++tab %>" placeholder="Enter Enrolment Number" required autofocus/>
            </div>
          </label>  </td>    </tr>
      <tr height="60">
        <td><div align="center">
          <input type="reset" value="CLEAR" tabindex="<%= tab+2 %>" class="button" />
        </div></td>
        <td><div align="center">
          <input type="submit" value="SEARCH" tabindex="<%= ++tab %>" class="button" />
        </div></td>
      </tr>
    </table>
</form>
    <h1>&nbsp;</h1>
  </div>
  <div id="sidebar">
  				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <%if(msg==null){%>
    <div id="nav-supp">
    <h3>Quick Access to </h3>
    
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS HOME</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">Reporting</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/day.jsp">Day Calulator App</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp">Obsolete Material Entry</a></li>
      </ul>
    </div>
    <h3>About Despatch Section of RCMS-MDU</h3>
    <p>Update Parcel Number page Update the Latest and Associated parcel number with the despatch of Materials via Post and whenever infromation regarding parcel number is Required it displays it in the Required Format.</p>
    <%}%>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<script>
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;

var Enrolment=document.frm_update_parcel.text_enr.value;
if (Enrolment==null || Enrolment=="" || Enrolment.length!=9 || Enrolment.match(letters))
  {
  alert("Enrolment Must be of Nine Numbers");
  document.frm_update_parcel.text_enr.value="";
  document.frm_update_parcel.text_enr.focus();
  return false;
  }
}
</script>
</html>
<%
}
%>