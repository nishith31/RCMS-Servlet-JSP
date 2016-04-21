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
<title>Enquiry</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
		//		statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body onLoad="fillCategory();">
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
      <li>						<a href="Home.jsp" title="HOME" accesskey="H" >						<%=home_menu.trim()%></a>			</li>
      <li>						<a href="Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li>						<a href="Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>						<a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li class="current">		<a href="Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
      <li><a href="Material_despatch.jsp">Material Despatch</a></li>
      <li class="youarehere"><a href="Report_full.jsp">Student Details</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
  <form name="form_report" action="FULLREPORT" onsubmit="">
    <table width="471" height="129" border="0">
      <tr><%! int tab=0; %>
        <td colspan="2"><strong>Select Session:</strong></td>
        <td colspan="2"><label>
          <select name="mnu_session_code" id="mnu_session_code" class="fieldsize" tabindex="<%=++tab%>" autofocus>
          </select>
        </label></td>
      </tr>
      <tr>
        <td width="73"><strong>Study Centre:</strong></td>
        <td width="140"><label>
          <select name="mnu_sc_code" id="mnu_sc_code" class="fieldsize" tabindex="<%=++tab%>">
          </select>
        </label></td>
        <td width="100"><strong>Regional Centre:</strong></td>
        <td width="140"><label>
          <select name="mnu_rc_code" id="mnu_rc_code" class="fieldsize" tabindex="<%=++tab%>">
          </select>
        </label></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input type="reset" name="clear" value="RESET"  tabindex="<%=tab+2%>"/>
        </div></td>
        <td colspan="2"><div align="center">
          <input type="submit" name="submit" value="REPORT"  tabindex="<%=++tab%>" />
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
    <div id="nav-supp">
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="Home.jsp">RCMS HOME</a></li>
        <li><a href="Home.jsp">Reporting</a></li>
      </ul>
    </div>
    <h3>About Report Section of RCMS-MDU</h3>
    <p>This Page mainly generates Multiple type of reports for the given selecetion.</p>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

<!--
   End of footer type info
-->

</div>
<script type="text/javascript">
function fillCategory(){ 
						<%int i=1;
						try
							{
							rs=statement.executeQuery("select * from sessions_"+rc_code+"");
							while(rs.next())
							{
						%>
							addOption(document.form_report.mnu_session_code, "<%=rs.getString(2)%>", "<%=rs.getString(2).toUpperCase()%>","");
						<% 
							}//end of while(rs.next())
							rs=statement.executeQuery("select * from study_centre");
							while(rs.next())
							{
						%>
							addOption(document.form_report.mnu_sc_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>","");
						<% 
							}//end of while(rs.next())
							
							rs=statement.executeQuery("select * from regional_centre");
							while(rs.next())
							{
						%>
							addOption(document.form_report.mnu_rc_code, "<%=rs.getString(1)%>", "<%=rs.getString(2).toUpperCase()%>", "");
						<% 
							}//end of while(rs.next())							
							
							}
						catch(Exception e)
							{out.println("connection error"+e);}
					
							%>

}//end of method fillcategory()
function addOption(selectbox, value, text )
{
			var optn = document.createElement("OPTION");
			optn.text = text;
			optn.value = value;
			selectbox.options.add(optn);
}
</script>
</body>
</html>
<%
}
%>