<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
}
else
{
	String rc_code=(String)sess.getAttribute("rc");
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
	`
<title>Despatch RC(PG)</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>

<script>
function validateForm()
{

var date=document.frm_rc.txtdate.value;
var remarks=document.frm_rc.txtrsn.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;

  if(date=="" || date.match(letters))
{
	alert("Please Select Date...");
	document.frm_rc.txtdate.focus();
	document.frm_rc.txtdate.value="";
	return false;
}//end of if
else
{
		var passedDate = new Date(date);
		var currentDate= new Date();
	  	if (passedDate > currentDate ) 
	  	{
		   	alert("Please Enter Current Date or Less than Current date");
		   	document.frm_rc.txtdate.focus();
		   	return false;
	  	}
}//end of else

if(remarks.match(numbers) || remarks==""|| remarks=="Reason of Despatch")
{
	alert("please Enter Remarks in Word Format");
	document.frm_rc.txtrsn.value="";
	document.frm_rc.txtrsn.focus();
	return false;
}
}
</script>
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

<body onload="fillCategory();document.frm_rc.mnu_reg_code.focus();">
<div id="container">
  <div id="banner">
 <h1>RCMS-MDU PROJECT</h1>
    <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;<%= (String)sess.getAttribute("rc") %></li>      
          <li style="color:#FFFFFF">Welcome <%= (String)sess.getAttribute("user") %></li>
    <li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>   </ul>
    </div>

  </div>
  <div id="nav-main">
    <ul>
      <li ><a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H" >							<%=home_menu.trim()%>		</a></li>
      <li class="current"><a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">	<%=dispatch_menu.trim()%>	</a></li>
	  <li><a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">						<%=receive_menu.trim()%>	</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">			<%=obsolete_menu.trim()%>	</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">						<%= enquiry_menu %>			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">						<%= report_menu %>			</a></li>
     <li><a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">							<%= update_menu %>			</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
      <li><a href="${pageContext.request.contextPath}/jsp/By_hand.jsp" title="BY HAND DESPATCH" accesskey="N">									By Ha<U>n</U>d					</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post.jsp" title="BY POST SINGLE" accesskey="O">									P<U>o</U>st Single Entry		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp" title="BY POST BULK" accesskey="S">								Po<U>s</U>t Bulk Entry			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">								S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">				Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>

 <form name="frm_rc" action="${pageContext.request.contextPath}/BYRC_PG_SUBMIT" onsubmit="return validateForm();" method="post">
<div align="center"><strong>    <hr /><hr />DESPATCH OF PROGRAMME GUIDE<hr /><hr /></strong></div>
    <table width="465" height="359" border="0">

      <tr><%! int tab=0; %>
        <td width="166" height="34"><strong>REGIONL CENTRE CODE :</strong></td>
        <td width="146">
  <input type="text" name="mnu_reg_code" id="mnu_reg_code" class="greysize"  value="<%= request.getParameter("reg_code") %>" readonly="readonly"/></td>
        <td width="139">&nbsp;</td>
      </tr>
      <tr>
        <td height="32"><strong>REGIONAL CENTRE NAME:</strong></td>
        <td><label>
          <input type="text" name="mnu_reg_name" id="mnu_reg_name" class="greysize" value="<%= request.getParameter("reg_name") %>" readonly="readonly"/>  </label></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td height="33"><strong>PROGRAMME CODE :</strong></td>
        <td colspan="2"><input type="text" name="mnu_prg_code" id="mnu_prg_code" class="greysize" value="<%= request.getParameter("prg_code") %>" readonly="readonly"/></td>
      </tr>
      <tr>
        <td height="33"><strong>AVAILABLE STOCK :</strong></td>
        <td colspan="2"><strong> <%= request.getAttribute("stock")%></strong></td>
      </tr>
      
      <tr>
        <td height="32"><strong>SESSION:</strong></td>
        <td colspan="2"><%String current_session=(String)request.getAttribute("current_session"); %>
          <input name="txtsession" type="text" id="txtsession" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="true" /></td>
      </tr>
      <tr><input type="hidden" name="txtmedium" value="<%= request.getParameter("medium") %>" />
        <td height="32"><strong>MEDIUM :</strong></td>
<td colspan="2">
        
      						<%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>    
 <input type="text" name="txtmedium_display" id="txtmedium_display" class="greysize" value="<%= medium_display.toUpperCase() %>" readonly="readonly" /></td>
      </tr>
      <tr>
        <td height="33"><strong>QUANTITY :</strong></td>
        <td colspan="2">
 <input type="text" name="text_qty" id="text_qty" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" placeholder="Enter No of Guide" required/></td>
      </tr>
      <tr>
        <td height="33"><strong>DATE:</strong></td>
        <td colspan="2"><input type="text" name="txtdate" id="datepicker" tabindex="<%= ++tab %>" class="fieldsize" placeholder="CLICK TO SELECT DATE" required/></td>
      </tr>
      <tr>
        <td height="29"><strong>REMARKS:</strong></td>
        <td colspan="2"> 
        <input type="text" name="txtrsn" id="txtrsn" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" placeholder="Enter Remarks for Despatch" required/></td>
      </tr>
      <tr>
        <td><div align="center">
          <input name="reset" type="reset" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" class="button" onclick="document.frm_rc.text_qty.focus();" />
        </div></td>
        <td colspan="2"><div align="center">
          <input name="enter" type="submit" id="enter" class="button" value="DESPATCH" tabindex="<%= ++tab %>"/>
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
                <h3>Additional Info </h3>
  </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui.css" type="text/css" media="all"/>
	    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    	<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
    	<script>       $(function() { $( "#datepicker" ).datepicker();  });</script>
</html>
<%
}
%>