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
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
				<meta http-equiv="Content-Language" content="en-us" />
				<meta name="description" content="Put a description of the page here" />
				<meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
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
				<title>ABBREVIATION SECTION</title>
				<link rel="shortcut icon" href="imgs/favicon.ico" />
				<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
				<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
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
							<li><a href="${pageContext.request.contextPath}/jsp/Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
							<li><a href="${pageContext.request.contextPath}/jsp/Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
							<li><a href="${pageContext.request.contextPath}/jsp/Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
							<li><a href="${pageContext.request.contextPath}/jsp/Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
							<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">				ABBRE<U>V</U>IATION		</a></li> 
							<li><a href="${pageContext.request.contextPath}/jsp/Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
						</ul>
						</div>
 
  <div id="content"><a name="contentstart" id="contentstart"></a>
    <h1>ABBREVIATION ADDITION PAGE OF RCMS</h1>
    <h2>&nbsp;</h2>
    <p>	

    </p>
	<ul>
		<li><a href="${pageContext.request.contextPath}/jsp/Program_Abbreviation.jsp">Click here for Programme Code Abbreviation</a></li>
		<li><a href="${pageContext.request.contextPath}/jsp/Course_Abbreviation.jsp">Click here for Course Code Abbreviation</a></li>        
	</ul>
	<p>&nbsp;</p>
    <h2>ABOUT THE ABBREVIATION PAGE OF ADMIN:</h2>
	<p>IN THIS PAGE YOU CAN ASSIGN NEW <strong>ABBREVIATION</strong> FOR THE PROGRAMME CODES OR FOR THE COURSE CODES OFFERED BY THE IGNOU FOR EASE OF YOUR USE.FOR ASSIGNING <strong>PROGRAMME CODE</strong> CLICK ON PROGRAMME CODE LINK ABOVE AND FOR ASSIGNING <strong>COURSE CODE</strong> CLICK ON COURSE CODE LINK ABOVE.</p>
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
    </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>


<STYLE type="text/css">
<!--
.css1
{
   position: absolute;
   top: 0px;
   left: 0px;
   width: 16px;
   height: 16px;
   font-family: Arial,sans-serif;
   font-size: 16px;
   text-align: center;
   font-weight: bold;
}

.css2
{
   position: absolute;
   top: 0px;
   left: 0px;
   width: 12px;
   height: 12px;
   font-family: Arial,sans-serif;
   font-size: 12px;
   text-align: center;
}
//-->
</STYLE>
</SCRIPT>
</body>
</html>
<%}%>