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
<title>Receive-Others-Partial</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<% String crs_code=(String)request.getAttribute("crs_code"); %>
<% int total_blocks=(Integer)request.getAttribute("blocks"); %>
<% int qty=(Integer)request.getAttribute("qty"); %>
</head>
<script type="text/javascript">
function validateForm()
{
var check = 0;
var blk = document.frm_others1.<%=crs_code%>.length;
for(w=0;w<blk;w++)
{
	if(document.frm_others1.<%=crs_code%>[w].checked == 1)
	check = 1;
}
if(check==0)
{
	alert("Please Select Blocks to be despatched...");
	return false;
}	
//logic for number of blocks to be auto-filled 0 if left unfilled by user 
var flag = 0;
<%for(int i=1;i<=total_blocks;i++)
{%>
var no_of_set = document.getElementById('textid<%=i%>').value;
if(no_of_set == "" || no_of_set == 0 || no_of_set < 0)
{
	document.getElementById('textid<%=i%>').value=0;
}
else
flag = 1;
<%}%>
if(flag == 0)
{
	alert('Please Enter Number Of Sets To Be Despatched For The Block Selected...');
	return false;
}
}//end of validateForm() method

</script> 

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
            <li style="color:#FFFFFF"><a href="LogOut" accesskey="Z">Log Out</a></li>

     </ul>
    </div>
  </div>
  <div id="nav-main">
    <ul>
      <li ><a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H" >							<%= home_menu %>		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">					<%= dispatch_menu %>	</a></li>
	  <li class="current"><a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">		<%= receive_menu %>		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIAL" accesskey="G">			<%= obsolete_menu %>	</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">						<%= enquiry_menu %>		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">						<%= report_menu %>		</a></li>
     <li><a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">							<%= update_menu %>		</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
      <li><a href="${pageContext.request.contextPath}/jsp/From_mpdd.jsp" title="FROM MPDD" accesskey="F">									<U>F</U>rom MPDD				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_rc.jsp" title="FROM RC" accesskey="C">										From R<U>C</U>					</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_sc.jsp" title="FROM SC" accesskey="S">										From <U>S</U>C					</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/" title="FROM STUDENT" accesskey="M">							Fro<U>m</U> Student				</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">			From <U>O</U>thers				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_others1" action="${pageContext.request.contextPath}/RECEIVEOTHERSPARTIAL" method="post" onsubmit="return validateForm();">
    <table width="461" height="393" border="0">
      <tr><%! int tab=0; %>
        <td width="176" height="47" colspan="2"><strong>Course Code:</strong></td>
        <td width="271" colspan="2">
<input type="text" name="mnu_crs_code" class="greysize" value="<%= crs_code%>" /> </td>
      </tr>
            <tr>
        <td height="26" colspan="2"><strong>Blocks:</strong></td>
        <td colspan="2"><strong>Quantity:</strong></td>
      </tr>
      <tr>
        <td height="24" colspan="2">
<div id="layer1" style="position:absolute; width:450px; height:123px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;"> <strong>
          
          <%int blocks	=	(Integer)request.getAttribute("blocks");%>
          <table class="table">
            <%
				for(int i=1;i<=blocks;i++)
				{%>
            <tr>
              <td width="173"><input type="checkbox" name="<%=crs_code %>" value="<%=crs_code%>B<%=i %>" checked="checked" /><strong>B<%=i%></strong></td>
              <td width="135" align="center">
              <input type="text" name="<%=crs_code%>B<%=i %>" id="textid<%= i %>" tabindex="<%= ++tab %>" class="fieldsize" value="<%=qty%>"/></td>
          </tr>
          <%}%>
          </table>
        </strong> </div>        </td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="41" colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="41" colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="41" colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="33" colspan="2"><strong>Session:</strong></td>
        <td colspan="2"><% String current_session=(String)request.getAttribute("current_session"); %>
<input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="readonly"/></td>
      </tr>
      <tr>
        <td height="38" colspan="2"><strong>Medium:</strong></td>
     						<%String medium_display=null;//(String)request.getAttribute("medium");
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+(String)request.getAttribute("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>               
        <td colspan="2">
<input type="text" readonly="readonly" name="mnu_medium" class="greysize" value="<%=medium_display%>" /> </td>
      </tr>
      
      <tr>
        <td height="34" colspan="2"><strong>Date:</strong></td>
        <td colspan="2">
<input name="text_date" type="text" class="greysize"  readonly="readonly" value="<%= request.getAttribute("date") %>"/></td>
      </tr>
      <tr>
        <td height="35" colspan="2"><strong>Received From:</strong></td>
        <td colspan="2"><% String receive_from=(String)request.getAttribute("receive_from"); %>
<input name="receive_from" type="text" class="greysize" id="receive_from" readonly="readonly" value="<%=receive_from.toUpperCase()%>"/></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" class="button"  value="CLEAR FIELDS" />
        </div></td>
        <td colspan="2"><div align="center">
          <input type="submit" name="submit" value="RECEIVE" tabindex="<%= ++tab %>" class="button"/>
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
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS HOME</a></li>
      </ul>
    </div>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>   
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui.css" type="text/css" media="all"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() { $( "#datepicker" ).datepicker();   });</script>
</html>
<%
}
%>