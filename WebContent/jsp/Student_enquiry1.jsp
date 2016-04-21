<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
String msg="Please Login to Access MDU System";
request.setAttribute("msg",msg);
	request.getRequestDispatcher("main_login.jsp").forward(request,response);
//response.sendRedirect("main_login.jsp");
}
else
{
String rc_code=(String)sess.getAttribute("rc");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" />
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
<title>Enquiry-student_despatch</title>
<script type="text/javascript" src="js/general.js"></script><link rel="shortcut icon" href="imgs/favicon.ico" /><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
			//	statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body>
<div id="container">  <div id="banner">
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
      <li>						<a href="Home.jsp" title="HOME"  accesskey="H">						<%=home_menu.trim()%></a>			</li>
      <li>						<a href="Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li>						<a href="Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li class="current">		<a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li>						<a href="Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
</ul>
  </div>

  <div id="nav-section">
    <ul>
      <li class="youarehere"><a href="Student_enquiry.jsp">Student Despatch</a></li>
      <li><a href="#">Hand Despatch</a></li>
      <li><a href="#">Post Despatch</a></li>
      <li><a href="#">SC Despatch</a></li>
      <li><a href="#">Hand Receipt</a></li>
      <li><a href="#">Post Despatch</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_student_enquiry1" action="Student_enquiry.jsp">
  <table width="464" border="0">
    <tr>
      <%! int tab=0; %>
      <td height="32" colspan="2"><strong>Enrolment Number:</strong></td>
      <td colspan="2"><strong>
        <label>
<input name="text_enr" type="text" id="text_enr" class="greysize" value="<%=request.getParameter("enrno")%>" readonly="true" />
        </label>
      </strong></td>
    </tr>
    <tr>
      <td height="31" colspan="2"><strong>Name:</strong> </td>
      <td colspan="2"><input name="text_name" type="text" class="greysize" id="text_name" value="<%=request.getParameter("name")%>" readonly="true" /></td>
    </tr>
    <tr>
      <td height="33" colspan="2"><strong>Session:</strong> </td>
      <td colspan="2"><% String current_session=(String)request.getAttribute("current_session");%>
          <input name="text_session" type="text" class="greysize" id="text_session" value="<%=current_session.toUpperCase()%>" readonly="true" /></td>
    </tr>
    <tr>
      <td height="34" colspan="2"><strong>Programme Code:</strong> </td>
      <td colspan="2"><input name="text_prog_code" type="text" class="greysize" id="text_prog_code" value="<%=request.getParameter("program")%>" readonly="true" /></td>
    </tr>
    <tr>
      <td height="33" colspan="2"><strong>Year/Semester:</strong></td>
      <td colspan="2"><input name="text_year" class="greysize" type="text" id="text_year" value="<%=request.getParameter("year")%>" readonly="true" /></td>
    </tr>
    <tr>
      <input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
      <td height="37" colspan="2"><strong>Medium:</strong></td>
      <td colspan="2"><%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>
          <input name="text_medium_display" type="text" id="text_medium_display" value="<%=medium_display%>" readonly="true" class="greysize" /></td>
    </tr>
    <tr>
      <td height="33" colspan="2"><strong>Sc_code:</strong></td>
      <td colspan="2"><input name="text_year" class="greysize" type="text" id="text_year" value="<%=request.getParameter("sc_code")%>" readonly="true" /></td>
    </tr>
    <tr>
      <td height="33" colspan="2"><strong>Contact No:</strong></td>
      <%String[] crs_dispatch			=	(String[])request.getAttribute("crs_dispatch");%>
        <%String[] dispatch_date	=	(String[])request.getAttribute("dispatch_date");%>
        <%String[] dispatch_mode	=	(String[])request.getAttribute("dispatch_mode");%>
        
      <td colspan="2"><input name="text_year" class="greysize" type="text" id="text_year" value="<%=request.getParameter("mobile")%>" readonly="true" /></td>
    </tr>
    <tr>
      <td height="33" colspan="2"><strong>Registered Courses:</strong></td>
      <td colspan="2">&nbsp;</td>
    </tr>
    <%String[] courses			=	(String[])request.getAttribute("courses");%>
    <%	for(int i=0;i<courses.length;)
    {%>
    <tr>
      <%	for(int j=0;j<4;j++)
	{
		if(i<courses.length){
	%>
      <td width="232"><strong><%=courses[i]%></strong></td>
      <%i++;}else{%>
      <td width="14"></td>
      <%}}%>
    </tr>
    <%}%>
    <tr>
      <td width="200"><strong>Courses:</strong></td>
      <td></td>
      <td width="140"><strong>Despatch Date:</strong></td>
      <td width="116"><strong>Despatch Mode:</strong></td>
    </tr>
   <%	for(int k = 0; k < crs_dispatch.length; k++)
				{%>
      <tr>
      <td colspan="2" width="200"><strong><%=crs_dispatch[k]%></strong></td>
      <td width="92" align="center"><strong><%= dispatch_date[k]%></strong></td>
      <td width="108" align="center"><strong><%= dispatch_mode[k]%></strong></td>
    </tr>
    <%}%>
    <tr>
      <td height="55" colspan="4"><div align="center">
          <label>
          <input type="submit" name="ok" id="ok" value="OK" class="button"/>
          </label>
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

                <h3>Information</h3>
    <p>&nbsp;</p>
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