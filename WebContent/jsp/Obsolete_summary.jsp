<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
String msg="Please Login to Access MDU";
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

<title>Summary of Damaged</title>

<link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
//				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
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
      <li>						<a href="Home.jsp" title="HOME"  accesskey="H">						<%=home_menu.trim()%></a>			</li>
      <li >						<a href="Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li class="current">		<a href="Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>						<a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li>						<a href="Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
<br />    </ul>
  </div>
<form name="form_obsolete_summary" action="Home.jsp" method="post">
  <div id="content1"><a name="contentstart" id="contentstart"></a>
    <table width="731" border="0" cellspacing="0">
      <tr>
        <td width="142"><strong>COURSE CODE:</strong></td>
        <td width="218"><label><em><%= request.getParameter("crs_code") %></em></label></td>
        <td width="124"><strong>SESSION:</strong></td>
        <td width="239"><label><em><%= request.getParameter("current_session").toUpperCase() %></em></label></td>
      </tr>
      <tr>              						<%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>
           <%int[] blocks				=	(int[])request.getAttribute("blocks");%>
        <td><strong>MEDIUM:</strong></td>
        <td><label><em><%= medium_display.toUpperCase() %></em></label></td>
        <td><strong>DATE:</strong></td>
        <td><label><em><%= request.getParameter("date") %></em></label></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><div align="right"><strong>REMARKS:</strong></div></td>
        <td colspan="2"><label><%= request.getParameter("remarks").toUpperCase() %></label></td>
        </tr>
    </table>
    <table width="731" border="0" cellspacing="0">
    <tr>
      <td><strong>BLOCK NUMBER:</strong></td>
      <td><strong>NUMBER OF COPIES:</strong></td>
    </tr>
    <%int index=0,k=0;
	 for(index=0;index<blocks.length;index++)
	{k=index+1;
	 %>
    <tr>
      <td>BLOCK <%= k %> </td>
      <td><%=blocks[index] %> <% if(blocks[index]<2){ %>Copy<% }else{ %>Copies<% } %></td>
    </tr>
    <% } %>
    <tr><td width="363"><div align="center"><a href="Obsolete.jsp">More Entry</a></div></td>
    <td width="364">    <div align="center">
      <button><img src="imgs/home_template.jpg" alt="Save icon"/></button>
    </div></td>
    </tr>
    </table>
  </div>
  </form>
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