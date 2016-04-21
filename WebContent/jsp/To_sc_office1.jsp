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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
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
<title>Despatch SC Office Use</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
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
      <li><a href="${pageContext.request.contextPath}/jsp/By_hand.jsp" title="BY HAND DESPATCH" accesskey="N">									By Ha<U>n</U>d					</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post.jsp" title="BY POST SINGLE" accesskey="O">									P<U>o</U>st Single Entry		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp" title="BY POST BULK" accesskey="S">								Po<U>s</U>t Bulk Entry			</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">			S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_sc3" action="${pageContext.request.contextPath}/BYSCPRIVATESUBMIT" method="post" onsubmit="return validateForm();">
    <table width="466" height="417" border="0">
      <tr><%! int tab=0; %>
        <td width="174"><strong>STUDY CENTRE CODE:</strong></td>
        <td width="140">
 <input type="text" name="mnu_sc_code" class="greysize" id="mnu_sc_code" value="<%= request.getParameter("sc_code") %>" readonly="readonly"/></td>
        <td width="140">&nbsp;</td>
      </tr>
      <tr>
        <td width="174"><strong>STUDY CENTRE NAME:</strong></td>
        <td width="140">
 <input type="text" name="mnu_sc_name" class="greysize" id="mnu_sc_name" value="<%= request.getParameter("sc_name") %>" readonly="readonly"/></td>
        <td width="140">&nbsp;</td>
      </tr>

      <tr>
        <td><strong>PROGRAMME CODE:</strong></td>
        <td colspan="2"><input type="text" name="mnu_prg_code" id="mnu_prg_code" class="greysize" value="<%= request.getParameter("prg_code")%>" readonly="readonly" /></td>
      </tr>
      <tr>
        <td><strong>COURSE CODE:</strong></td>
        <td colspan="2"><input type="text" id="mnu_crs_code" name="mnu_crs_code" class="greysize" value="<%= request.getParameter("crs_code") %>" readonly="readonly" /></td>
      </tr>
      <tr>
        <td><strong>BLOCKS:</strong></td>
        <td colspan="2"><strong>AVAILABLE STOCK:</strong></td>
      </tr>
      <tr>
        <td><div id="layer1" style="position:absolute; width:450px; height:109px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;"> <strong>
          <%String[] block		=	(String[])request.getAttribute("block");%>
          <%int[] available_qty	=	(int[])request.getAttribute("available_qty");%>
          <table class="table">
            <%
				for(int i=0;i<block.length;i++)
				{%>
            <tr>
              <td width="163"><input type="checkbox" name="<%= request.getParameter("crs_code") %>" value="<%= block[i]%>" checked="checked" />
                  <%= block[i]%></td>
              <td width="133" align="center"><%= available_qty[i]%></td>
              <td width="11" align="center"></td>
              <td width="17" align="center"></td>
          </tr>
          <%}%>
          </table>
        </strong> </div>          </td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td><strong>SESSION:</strong></td>
        <td colspan="2"><%String current_session=(String)request.getAttribute("current_session"); %>
          <input name="text_session" type="text" value="<%=current_session.toUpperCase()%>" id="text_session" class="greysize" readonly="true" /></td>
      </tr>
      <tr>
      <input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td><strong>MEDIUM:</strong></td>
        <td colspan="2">
      						<%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>        
        <input type="text" name="text_medium_display" id="text_medium_display" class="fieldsize" value="<%= medium_display.toUpperCase() %>" readonly="readonly"/></td>
      </tr>
      <tr>
        <td><strong>NUMBER OF SETS:</strong></td>
        <td colspan="2"><input name="text_no_of_set" type="text" class="fieldsize" id="text_no_of_set" tabindex="<%= ++tab %>" placeholder="Enter Number of Sets"/></td>
      </tr>
      <tr>
        <td><strong>DATE:</strong></td>
        <td colspan="2"><input name="text_date" type="text" class="fieldsize" id="datepicker" tabindex="<%= ++tab %>" placeholder="Click to Select Date"/></td>
      </tr>
      <tr>
        <td><strong>REMARKS:</strong></td>
        <td colspan="2"><select name="mnu_remarks" id="mnu_remarks" class="fieldsize" tabindex="<%= ++tab %>">
          <option value="FOR COUNSELLOR">FOR COUNSELLOR</option>
          <option value="FOR LIBRARY">FOR LIBRARY</option>
        </select></td>
      </tr>
      <tr>
        <td><div align="center">
          <input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" onclick="document.frm_sc3.mnu_sc_code.focus();" value="CLEAR FIELDS" class="button"/>
        </div></td>
        <td colspan="2"><div align="center">
          <input name="enter" type="submit" id="enter" tabindex="<%= ++tab %>" value="DESPATCH" class="button"/>
        </div></td>
      </tr>
    </table>
</form>
    <p>&nbsp;</p>
  </div>
  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <h3>&nbsp;</h3>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
	    <link rel="stylesheet"    href="js/jquery-ui.css"    type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
        <script>  $(function() {  $( "#datepicker" ).datepicker();   });</script>
<script type="text/javascript">
function validateForm()
{
var sets		=	document.frm_sc3.text_no_of_set.value;
var date		=	document.frm_sc3.text_date.value;
var letters 	=	 /^[A-Za-z]+$/;
var numbers 	= /^[0-9]+$/;
var emailExp	= /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
if(sets.match(letters) || sets.length==0 || sets>50)
{
	alert("Please enter less then 50 in numbers..");
	document.frm_sc3.text_no_of_set.value="";
	document.frm_sc3.text_no_of_set.focus();	
	return false;
}
if(date=="")
{
	alert("Please Select Date...");
	document.frm_sc3.text_date.value="";
	document.frm_sc3.text_date.focus();	
	return false;
}
else
{
	var passedDate = new Date(date);
	var currentDate= new Date();
		if (passedDate > currentDate ) 
	 	{
			alert("Please Enter Current Date or Less than Current date");
			document.frm_sc3.text_date.focus();	
			return false;
		}
}//end of else

}//end of method
</script>

</html>
<%
}
%>