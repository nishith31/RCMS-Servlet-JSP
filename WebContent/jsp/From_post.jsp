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
<title>Post Return</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;

	var roll=document.frm_post_receipt1.txt_enr.value;
	if (roll==null || roll=="" || roll.length!=9 || roll.match(letters))
	{
		alert("ENROLMENT NUMBER MUST BE OF NINE NUMBERS ONLY..");
		document.frm_post_receipt1.txt_enr.value="";
		document.frm_post_receipt1.txt_enr.focus();
		return false;
	}
}
	</script>

</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 /*try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks*/
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
      <li><a href="${pageContext.request.contextPath}/jsp/From_student.jsp" title="FROM STUDENT" accesskey="M">							Fro<U>m</U> Student				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">								From <U>O</U>thers				</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">		Post Retur<U>n</U>				</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_post_receipt1" action="${pageContext.request.contextPath}/POSTRETURNSEARCH" onsubmit="return validateForm()" method="post">
    <table width="464" height="183" border="0">
      <tr><%! int tab=0; %>
        <td width="215"><strong>ENROLMENT NUMBER:</strong></td>
        <td width="239">
 <input name="txt_enr" placeholder="Enter Enrolment Number" type="text"  id="txt_enr" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" required autofocus/></td>
      </tr>
      <tr>
        <td><div align="center">
<input name="reset" type="reset" id="reset" value="CLEAR" tabindex="<%= tab+2 %>" onclick="document.frm_post_receipt1.txt_enr.focus();" class="button"/>
        </div></td>
        <td><div align="center">
<input name="enter" type="submit" id="enter" value="SEARCH" tabindex="<%= ++tab %>" class="button" />
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
        <h3>Quick Access To </h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS-HOME</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Receive.jsp">RECEIVE HOME</a></li>
      </ul>
    </div>
    <h3>&nbsp;</h3>
  </div>

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