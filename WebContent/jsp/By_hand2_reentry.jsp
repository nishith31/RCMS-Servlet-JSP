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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<title>Despatch-By Hand</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<style type="text/css">
<!--/*.style4 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }*/-->
</style>
</head>
<%Connection connection=null;
Statement statement=null,statement_empty=null;
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
//				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body onload="display();">
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/By_hand.jsp" title="BY HAND DESPATCH" accesskey="N">				By Ha<U>n</U>d					</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post.jsp" title="BY POST SINGLE" accesskey="O">									P<U>o</U>st Single Entry		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp" title="BY POST BULK" accesskey="S">								Po<U>s</U>t Bulk Entry			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">								S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_by_hand2" action="${pageContext.request.contextPath}/BYHANDREENTRYSEARCH" method="post">
    <table width="455" border="0">
      <tr><%! int tab=0; %>
        <td height="35" colspan="2"><span class="style4">Enrolment Number: </span></td>
        <td colspan="2"><label>
<input name="text_enr" type="text" id="text_enr" class="greysize" maxlength="9" value="<%=request.getParameter("enrno")%>" readonly="true" autofocus/>
        </label></td>
      </tr>
      <tr>
        <td height="30" colspan="2"><span class="style4">Name of the student: </span></td>
        <td colspan="2"><input name="text_name" type="text" id="text_name" class="greysize" value="<%=request.getParameter("name")%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="34" colspan="2"><span class="style4">Session:</span>          </dt></td>
        <td colspan="2"><% String current_session=(String)request.getAttribute("current_session");%>
          <input name="text_session" type="text" id="text_session" class="greysize" value="<%=current_session.toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="32" colspan="2"><span class="style4">Programme code: </span></td>
        <td colspan="2">
<input name="text_prog_code" type="text" id="text_prog_code" class="greysize" value="<%=request.getParameter("prog")%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="33" colspan="2"><span class="style4">Year/Semester:</span></td>
        <td colspan="2">
<input name="text_year" type="text" id="text_year" class="greysize" value="<%=request.getParameter("year")%>" readonly="true" /></td>
      </tr>
    <tr>
      <td width="94" height="24"><strong>Blocks:</strong></td>
      <td width="106"><div align="right"><strong>Available Stock:</strong></div></td>
      <td width="117"><div align="center"><strong>Serial Number:</strong></div></td>
      <td width="120"><div align="center"><strong>Despatch Date:</strong></div></td>
    </tr>
      <tr>
        <td height="33" colspan="2">
<div id="layer1" style="position:absolute; width:465px; height:259px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;">
            <strong>
              <table border="0">
					<%String[] course			=	(String[])request.getAttribute("course");%>
            		<%String[] course_block		=	(String[])request.getAttribute("course_block");%>
            		<%String[] serial_number	=	(String[])request.getAttribute("serial_number");%>
            		<%int[] blocks				=	(int[])request.getAttribute("blocks");%>
            		<%String[] dispatch			=	(String[])request.getAttribute("dispatch");%>
            		<%String[] dispatch_date	=	(String[])request.getAttribute("dispatch_date");%>
            		<%int[] stock				=	(int[])request.getAttribute("stock");%>            
            		<%int index=0,flag=-1,count=0;%>                
                
				<%
				for(int i=0;i<course.length;i++)
				{%>
                <input type="hidden" name="crs_code" value="<%=course[i]%>" />
 <tr bgcolor="#CCCCCC">
<td colspan="4"><input type="checkbox" disabled="disabled" checked="checked" name="<%= i %>"/><%= course[i]%></td>
</tr>
               
                <%
				for(int k=1;k<=blocks[i];k++)
				{
						for(int j=0;j<dispatch.length;j++)
						{
		//					System.out.println(course_block[count]+"A "+dispatch[j]+"B");
							if(course_block[count].trim().equals(dispatch[j].trim()))
							{flag=j;}
							//System.out.println("flag="+flag);
						}//end of for loop
				%>
<tr>
<td width="112" align="center"><input type="checkbox" checked="checked" disabled="disabled" name="<%= course[i] %>" value="<%= course_block[count]%>" /><%= "B"+k%></td>
<td width="84"><%= stock[count]%></td>
<td width="125" align="center"><%= serial_number[i]%></td>
<td width="111" align="center"><%= dispatch_date[flag] %></td>
</tr>
				<%
				count++;
				flag=-1;
				}//end of for loop int k=1
				}//end of for loop int i=0
				%>
              </table>
</strong>        </div>  </td>
        <td height="33" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="42" colspan="2"></td>
        <td height="42" colspan="2">&nbsp;</td>
      </tr>
      
      <tr><input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td height="37" colspan="2"><strong>Medium:</strong>          </td>
        <td colspan="2">
      						<%String medium_display=null;
							try
							{
							ResultSet rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>        
        
<input name="text_medium_display" type="text" id="text_medium_display" value="<%= medium_display %>" readonly="true" class="greysize" /></td>
      </tr>
      
      <tr>
        <td height="62" colspan="4">
        <label>
        <div align="center">
        <input name="re-enter" type="submit" id="re-enter" value="RE-ENTER" class="button" tabindex="<%= ++tab %>" />
        </div>          </label></td>
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
    <h3>Quick Access to </h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS HOME</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Despatch.jsp">DESPATCH HOME</a></li>
      </ul>    </div>
  </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
<script type="text/javascript">
function display()
{ 
	window.alert('Books have been dispatched to <%=request.getParameter("name").trim()%> <%=request.getParameter("dispatch_mode")%> !');
}//end of method display()
</script>
	    <link rel="stylesheet"    href="${pageContext.request.contextPath}/js/jquery-ui.css"    type="text/css" media="all"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
     <script>     $(function() {        $( "#datepicker" ).datepicker();       });	</script>
</body>
</html>
<%
}
%>