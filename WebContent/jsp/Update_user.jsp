<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
String uname=null;
if(sess==null)
{
	String msg="Please Login to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("main_login.jsp").forward(request,response);
}
else
{
	String rc_code=(String)sess.getAttribute("rc");
	uname=(String)sess.getAttribute("admin_user");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<link rel="shortcut icon" href="imgs/favicon.ico" /><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
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
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;
	ResultSet rs1=null;%>
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
<title>USER UPDATE</title>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" /></head>
<body>
<div id="container">
  <div id="banner">
    <h1>RCMS-MDU ADMIN</h1>
    <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;<%= (String)sess.getAttribute("rc") %></li>      
   <li style="color:#FFFFFF">Welcome <%= uname%></li> 
    <li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>
   
      </ul>
    </div>
  </div>
  <div id="nav-main">
    <ul>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
    <li><a href="#">																													COURSE				</a></li>
    <li><a href="#">																													PROGRAM				</a></li>
    <li><a href="#">																													REGIONAL CENTRE		</a></li>
    <li><a href="#">																													STUDY CENTRE		</a></li>
    <li><a href="#">																													MEDIUM				</a></li>          
	<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Update_user.jsp" title="CLICK TO UPDATE THE USER INFO">												USER				</a></li>
</ul>
  </div>

  <div id="content1"><a name="contentstart" id="contentstart"></a>
<div align="center">
 <table width="700px" border="0" align="center" cellpadding="4" cellspacing="0">
<tr height="32">
<td width="25%" ><div align="center"><strong>User Name</strong></div></td>
<td width="25%"><strong>RC Code</strong></td>
<td width="25%"><div align="center"><strong>Role</strong></div></td>
<td width="25%"><strong>Action</strong></td>
</tr>
            	<%int m=1;
				String rc=null,user=null,role=null;
		  		try
				{
					rs=statement.executeQuery("select * from login where rc_code='"+rc_code+"' and role='staff' ");
					while(rs.next())
				{
					rc=rs.getString(1);
					user=rs.getString(2);
					role=rs.getString(4);
				%>
                <tr height="32">
			    	<td width="25%"><div align="center"><strong><%= user %></strong></div></td>
                    <td width="25%"><strong><%= rc%></strong></td>
                    <td width="25%"><div align="center"><strong><%=role.toUpperCase()%></strong></div></td>                                                
                     <td width="25%"><strong><a href="UPDATEUSER?user=<%=user%>&rc=<%=rc%>&role=<%=role%>">RESET Password</a></strong></td>                </tr>
				<%
				}//end of while of rs outer loop
				}	catch(Exception e){out.println("connection error"+e);}
				%>
</table>

  </div></div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</body>
</html>
<%
}
%>