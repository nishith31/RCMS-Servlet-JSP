<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
//response.sendRedirect("main_login.jsp");
}
else
{
String rc_code=(String)sess.getAttribute("rc");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
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
<title>UPDATE HOME</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
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
			{		out.println("connection error"+e);	}//end of catch blocks
*/  %>

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
        <li><a href="${pageContext.request.contextPath}/jsp/Update_parcel_no.jsp">Parcel Number</a></li>
   <li ><a href="${pageContext.request.contextPath}/jsp/Student_Update.jsp" >Student Details</a></li>
  <li><a href="${pageContext.request.contextPath}/jsp/Lot_Update.jsp" >LOT Name</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
   </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
    <h1>UPDATION PAGE </h1>
    <h2>Important Information about Updation page</h2>
    <p>This page is mainly used to perform update related transactions like to update express parcel number of any despatched material by post or the mobile number or medium of the student in the student registration data. </p>
    <p>Further all update realted transactions will be managed by this page like updating lot number of student data and some other transactions.</p>
  </div>


  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>


                <%if(msg==null){%>
                <h3>About the RCMS-MDU:</h3>
    <p>The main idea behind this application is to maintain the Material Inventory of the Regional Centres in an Efficient Way.</p>
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
<%
}
%>