<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
//response.sendRedirect("login.jsp");
}
else
{
String rc_code=(String)sess.getAttribute("rc");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
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
		<title>Despatch</title>
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/imgs/favicon.ico" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
		<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
	</head>
	<%! 
		Connection connection=null;
		Statement statement=null,statement_empty=null;
		ResultSet rs=null;
	%>
	<%
		/* try	
			{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
			}//end of try blocks
			catch(Exception e)
			{
				out.println("connection error"+e);	
			}//end of catch blocks*/
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
      <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H" >							<%=home_menu.trim()%>		</a></li>
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
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
    <%//= session %>
    <h1>Despatch Section</h1>
    <h2>Useful Info About Despatch:-</h2>
    <p>Regional Centre sends material to learners via different and best suitable mode as it can.Following are the Modes:-</p>
	<ul>
		<li><a href="${pageContext.request.contextPath}/jsp/By_hand.jsp">By Hand</a> means Direct from the Counter</li>
		<li><a href="${pageContext.request.contextPath}/jsp/By_post.jsp">Single</a> By post for each student </li>
   		<li><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp">Bulk</a> By post for a complete list of students </li>
        <li>Despatch to Study Centre for<a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp"> Office Use</a></li>
        <li>For<a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp"> Students</a> of Study Centre in a bulk</li>
        <li> Some <a href="${pageContext.request.contextPath}/jsp/Complementary.jsp">Complementary</a> Copies on Request to Others</li>
        
	</ul>
    <h2>STATISTICS OF THE CURRENT DESPATCH SESSION</h2>
  </div>

  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>


                <h3>About Despatch Section of RCMS-MDU</h3>
    <p>This page is mainlly deal with all the transactions related to the Despatch of Study Material to either student or any other person via any mode.</p>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
<script type="text/javascript">
function calcOffset() {
    var serverTime = getCookie('serverTime');
    serverTime = serverTime==null ? null : Math.abs(serverTime);
    var clientTimeOffset = (new Date()).getTime() - serverTime;
    setCookie('clientTimeOffset', clientTimeOffset);
}

window.onLoad = function() { calcOffset(); };
function checkSession() {
    var sessionExpiry = Math.abs(getCookie('sessionExpiry'));
    var timeOffset = Math.abs(getCookie('clientTimeOffset'));
    var localTime = (new Date()).getTime();
    if (localTime - timeOffset > (sessionExpiry+15000)) { // 15 extra seconds to make sure
        window.close();
    } else {
        setTimeout('checkSession()', 10000);
    }
}
</script>

</div>
</body>
</html>

<%
}
%>