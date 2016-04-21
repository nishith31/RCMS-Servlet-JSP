<%@ page import="java.util.Date" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.InetAddress,java.net.UnknownHostException" %>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<meta http-equiv="Content-Language" content="en-us" />
	<meta name="description" content="Put a description of the page here" />
	<meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
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
	<title>RCMS HOME</title>
	<link rel="shortcut icon" href="${pageContext.request.contextPath}/imgs/favicon.ico" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
	<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
	<script language="javascript">
		document.onmousedown=disableclick;
		status="Right Click Disabled";
		Function disableclick(e)
		{
			if(event.button==2)
   			{
    	 		alert(status);
     			return false;    
   			}
		}
	</script>
	</head>
	<%! 
		Connection connection=null;
		Statement statement=null,statement_empty=null;
		ResultSet rs=null;
	%>
	<%
		try		
		{
			Class.forName(driver);
			connection=DriverManager.getConnection(url,user_name,pswd);
	//		statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
			statement_empty=connection.createStatement();				
					
		}//end of try blocks
		catch(Exception e)
		{
			out.println("connection error"+e);	}//end of catch blocks
 	%>

<body oncontextmenu="return false">
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
      <li class="current">	<a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H">						<%=home_menu.trim()%></a>			</li>
      <li >					<a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>					<a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li>					<a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>					<a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li>					<a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>					<a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>

  <div id="nav-section">
    <ul><br />
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
    <h1>Home Page </h1>
    <h2>Important Information About RC MDU System</h2>
    <p>	<%!
		 String current_session=null; 
		String most_popular_course=null;
		int total_students=0;
		int total_courses=0;
		int total_program=0;
		int total_rc=0;
		int total_sc=0;
		int students=0;
	%>

 	<%
      try
	  {
		 rs=statement_empty.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
			while(rs.next())
				current_session=rs.getString(1).toLowerCase();

		rs=statement_empty.executeQuery("select count(*) from student_"+current_session+"_"+rc_code+"");
			while(rs.next())
				total_students=rs.getInt(1);

		rs=statement_empty.executeQuery("select count(*) from course");
			while(rs.next())
				total_courses=rs.getInt(1);
				
		rs=statement_empty.executeQuery("select count(*) from program");
			while(rs.next())
				total_program=rs.getInt(1);

		rs=statement_empty.executeQuery("select count(*) from study_centre");
			while(rs.next())
				total_sc=rs.getInt(1);

		rs=statement_empty.executeQuery("select count(*) from regional_centre");
			while(rs.next())
				total_rc=rs.getInt(1);
		rs=statement_empty.executeQuery("select prg_code, count(*) as records from student_"+current_session+"_"+rc_code+" group by prg_code order by records desc, prg_code desc");
		int z=0;
			while(rs.next() && z==0){
				most_popular_course=rs.getString(1);
				z++;}
		rs=statement_empty.executeQuery("select count(*) from student_"+current_session+"_"+rc_code+" where prg_code like '"+most_popular_course+"%'");
			while(rs.next())
				students=rs.getInt(1);
				
	
		}//end of try blocks
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
	%>
    </select>
    <strong>Current Session is:</strong> &nbsp;<strong><%= current_session.toUpperCase() %></strong><br/>
    <strong>Number of Students in the Session : &nbsp;&nbsp;<%=total_students%>
    <br />
    Number of Courses Available : &nbsp;&nbsp;<%=total_courses%></strong>
    <br />
<strong>    Number of Programs Available : &nbsp;&nbsp;<%=total_program%></strong>
<br />
<strong>    Number of STUDY CENTRES Affliated   : &nbsp;&nbsp;<%=total_sc%></strong>
<br />
<strong>    Number of REGIONAL CENTRES PRESENT : &nbsp;&nbsp;<%=total_rc%></strong>
<br />
<strong>    Most Popular Coruse in Current Session : &nbsp;&nbsp;<%=most_popular_course%> &nbsp; With &nbsp;<%=students%> Students.</strong></p>
  <ul>
		<li><a href="complete_list">See the Complete list of students in the Session</a></li>
		<li><a href="ALLSTUDENT">Know the Most Popular Program in the RC</a></li>
	</ul>
	<p>&nbsp;</p>
    <h2>How to Use this Software:</h2>
	<p>To use this Application just click on the appropriate links as per your need.</p>
	<p>Click on <strong>Despatch</strong> tab to manage all the Despatch related transactions, and <strong>Receive</strong>
    tab to manage all the Receive materials related transactions.</p>
  </div>


  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>



    <div id="nav-supp">
    <%if(msg==null){%>
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Despatch.jsp">Despatch Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Receive.jsp">Receive Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp">Obsolete Material Entry</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Report.jsp">Reports</a></li>
        <li><a href="#">Swtich to Admin Login</a></li>
      </ul>
    </div>
    <h3>About the RCMS-MDU:</h3>
    <p>The main idea behind this application is to maintain the Material Inventory of the Regional Centres in an Efficient Way.</p>
    <%}%>
    </div>

  <div id="info-site">
      <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  <%  String ipAddress = request.getHeader("X-FORWARDED-FOR");  
   if (ipAddress == null)
   {  
	   ipAddress = request.getRemoteAddr();  
   }
/*   InetAddress ip=null;
	  try {
 
		ip = InetAddress.getLocalHost();

	  } catch (UnknownHostException e) {  }*/
 
 %>
    <p id="info-standards">
<h3>    <a href="http://www.ignou.ac.in/" target="_blank">[Your IP Address is:<%= ipAddress %>  <%//out.println(ip.getHostAddress()); %>]</a></h2></p>
        <h3>
        <BR>
Session creation time:
        <BR>        Last accessed time: <%=new Date(sess.getLastAccessedTime())%>
        <BR>
        </h3>
  <% /*SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");

Date today = new Date();

Date todayWithZeroTime =formatter.parse(formatter.format(today)); 
   Date dating=new Date(sess.getCreationTime()); 
  int day=dating.getDay();
  int  month=dating.getDate();
  int year=dating.getYear();
  
  out.println("Date is: "+day+":"+month+":"+year);
  String browserType=(String)request.getHeader("User-Agent");
  out.println(browserType);*/
  %>
  <%
          String browsername = "";
          String browserversion = "";
          String browser = (String)request.getHeader("User-Agent");
          if(browser.contains("MSIE"))
		  {
              String subsString = browser.substring( browser.indexOf("MSIE"));
              String Info[] = (subsString.split(";")[0]).split(" ");
              browsername = Info[0];
              browserversion = Info[1];
           }
         else if(browser.contains("Firefox"))
		 {

              String subsString = browser.substring( browser.indexOf("Firefox"));
              String Info[] = (subsString.split(" ")[0]).split("/");
              browsername = Info[0];
              browserversion = Info[1];
         }
         else if(browser.contains("Chrome"))
		 {

              String subsString = browser.substring( browser.indexOf("Chrome"));
              String Info[] = (subsString.split(" ")[0]).split("/");
              browsername = Info[0];
              browserversion = Info[1];
         }
         else if(browser.contains("Opera"))
		 {

              String subsString = browser.substring( browser.indexOf("Opera"));
              String Info[] = (subsString.split(" ")[0]).split("/");
              browsername = Info[0];
              browserversion = Info[1];
         }
         else if(browser.contains("Safari"))
		 {

              String subsString = browser.substring( browser.indexOf("Safari"));
              String Info[] = (subsString.split(" ")[0]).split("/");
              browsername = Info[0];
              browserversion = Info[1];
         }          
    //out.println(browsername + "-" +browserversion);

%>
  </div>

</div>


</body>
</html>
<%
}
%>