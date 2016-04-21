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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">

<head>
<link rel="shortcut icon" href="imgs/favicon.ico" />
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
<script type="text/javascript">
function toggle_visibility(tbid,lnkid)
{
  if(document.all){document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "block" ? "none" : "block";}
  else{document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "table" ? "none" : "table";}
  document.getElementById(lnkid).value = document.getElementById(lnkid).value == "[-]" ? "[+]" : "[-]";
 }
</script>
<style type="text/css"><%
int total=0;
try{ rs=statement.executeQuery("SELECT COUNT(DISTINCT CHECKSUM(crs_code,medium)) FROM material_july2012_07");
while(rs.next())
total=rs.getInt(1);
}catch(Exception ed){}%>
#tbl1
<%for(int i=2;i<=total;i++)
{ %>
,#tbl<%=i%>
<% } %>{display:none;}

#lnk1
<%for(int i=2;i<=total;i++)
{ %>
,#lnk<%=i%>
<% } %>{border:none;background:none;width:85px;}


<%/*#tbl1,#tbl2,#tbl3,#tbl4,#tbl5,#tbl6,#tbl7,#tbl8,#tbl9,#tbl10,#tbl11,#tbl12,#tbl13,#tbl14,#tbl15,#tbl16,#tbl17,#tbl18,#tbl19,#tbl20,#tbl21,#tbl22,#tbl23,#tbl24,#tbl25,#tbl26,#tbl27,#tbl28,#tbl29,#tbl30,#tbl31,#tbl32,#tbl33,#tbl34,#tbl35,#tbl36,#tbl37,#tbl38,#tbl39,#tbl40,#tbl41,#tbl42,#tbl43,#tbl44,#tbl45,#tbl46,#tbl47,#tbl48,#tbl49,#tbl50,#tbl51,#tbl52,#tbl53,#tbl54,#tbl55,#tbl56,#tbl57,#tbl58,#tbl59,#tbl60,#tbl61,#tbl62,#tbl63,#tbl64,#tbl65,#tbl66,#tbl67,#tbl68,#tbl69,#tbl70,#tbl71,#tbl72,#tbl73,#tbl74,#tbl75,#tbl76,#tbl77,#tbl78,#tbl79,#tbl80,#tbl81,#tbl82,#tbl83,#tbl84,#tbl85,#tbl86,#tbl87,#tbl88,#tbl89,#tbl90,#tbl91,#tbl92,#tbl93,#tbl94,#tbl95,#tbl96,#tbl97,#tbl98,#tbl99,#tbl100{display:none;}

#lnk1,#lnk2,#lnk3,#lnk4,#lnk5,#lnk6,#lnk7,#lnk8,#lnk9,#lnk10,#lnk11,#lnk12,#lnk13,#lnk14,#lnk15,#lnk16,#lnk17,#lnk18,#lnk19,#lnk20,#lnk21,#lnk22,#lnk23,#lnk24,#lnk25,#lnk26,#lnk27,#lnk28,#lnk29,#lnk30,#lnk31,#lnk32,#lnk33,#lnk34,#lnk35,#lnk36,#lnk37,#lnk38,#lnk39,#lnk40,#lnk41,#lnk42,#lnk43,#lnk44,#lnk45,#lnk46,#lnk47,#lnk48,#lnk49,#lnk50,#lnk51,#lnk52,#lnk53,#lnk54,#lnk55,#lnk56,#lnk57,#lnk58,#lnk59,#lnk60,#lnk61,#lnk62,#lnk63,#lnk64,#lnk65,#lnk66,#lnk67,#lnk68,#lnk69,#lnk70,#lnk71,#lnk72,#lnk73,#lnk74,#lnk75,#lnk76,#lnk77,#lnk78,#lnk79,#lnk80,#lnk81,#lnk82,#lnk83,#lnk84,#lnk85,#lnk86,#lnk87,#lnk88,#lnk89,#lnk90,#lnk91,#lnk92,#lnk93,#lnk94,#lnk95,#lnk96,#lnk97,#lnk98,#lnk99,#lnk100 {border:none;background:none;width:85px;}*/%>
</style>


<title>Material Status</title>

<link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>

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
      <li><a href="Report_full.jsp">Student Details</a></li>
      <li class="youarehere"><a href="Material_status.jsp">Material Status</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>    </ul>
  </div>

  <div id="content1"><a name="contentstart" id="contentstart"></a>
<div align="center">
 <table width="700px" border="0" align="center" cellpadding="4" cellspacing="0">
<tr>
<td width="35%" height="31"><div align="center"><strong>Course Code</strong></div></td>
<td width="35%"><strong>Medium</strong></td>
<td width="30%"><strong>Quantity</strong></td>
</tr>
            									<%int m=1;
												String crs=null,medium=null;
		  										try
													{
													Connection c1=DriverManager.getConnection("jdbc:odbc:mdu_rc_block_dsn","sa","sqlserver");													
													Statement s1=c1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);													
												
													rs=statement.executeQuery("select distinct crs_code,medium,qty from material_july2012_07");
													while(rs.next())
													{crs=rs.getString(1);
													medium=rs.getString(2);
												%>
                                                <tr height="5px">
                                    <td width="35%"><strong>
                                    <input id="lnk<%=m%>" type="button" value="[+]" onClick="toggle_visibility('tbl<%= m %>','lnk<%= m %>');">
                                    <%= crs %></strong></td>
                                                <td width="35%"><strong><%= medium %></strong></td>
                                                <td width="30%"><strong><%= rs.getInt(3) %></strong></td>                                                
                                                </tr>
                                                <tr>
												<%	
													rs1=s1.executeQuery("select * from material_july2012_07 where crs_code='"+crs+"' AND medium='"+medium+"'");
													%>
													   <td colspan="3">
	    												<table width="100%" border="0" cellpadding="4" cellspacing="0" id="tbl<%=m%>">
                                                    <%while(rs1.next())
													{
													%>
                                                <tr>
                                                <td width="35%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= rs1.getString(2) %></td>
                                                <td width="35%"><%= rs1.getString(3) %></td>
                                                <td width="30%"><%= rs1.getInt(4) %></td>                                                
                                                </tr>
													
                                                    <%
													}//end of inner while loop of rs1
													
													m++;
													%>
                                                    </table>                                                    </td>
                                                    </tr>
													<%
													}//end of while of rs outer loop
													}	
												catch(Exception e)
													{out.println("connection error"+e);}
											%>
</table>

  </div></div>
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