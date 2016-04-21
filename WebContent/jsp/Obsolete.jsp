<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
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

<title>Damaged</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var program		=	document.frm_obsolete.mnu_prg_code.value;
var course		=	document.frm_obsolete.mnu_crs_code.value;
var medium		=	document.frm_obsolete.txtmedium.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
if(program=="0")
{
	alert("PLEASE SELECT PROGRAMME CODE FIRST...");
	document.frm_obsolete.mnu_prg_code.focus();
	return false;
}
if(course=="0")
{
	alert("PLEASE SELECT COURSE CODE ...");
	document.frm_obsolete.mnu_crs_code.focus();
	return false;
}
if(medium=="0")
{
	alert("PLEASE SELECT MEDIUM FOR THE STUDY MATERIALS...");	
	document.frm_obsolete.txtmedium.focus();
	return false;
}
}

</script>

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

<body onLoad="fillCategory();document.frm_obsolete.write_remarks.disabled=true;">
<form name="frm_obsolete" action="${pageContext.request.contextPath}/BYOBSOLETESEARCH" method="post" onsubmit="return validateForm();remarksvalue();">
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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME"  accesskey="H">						<%=home_menu.trim()%></a>			</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>
  <div id="nav-section">
    <ul><br />
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a> 		
	</ul>
    <table width="441" height="289" border="0">
      <tr><%! int tab=0; %>
        <td height="35"><strong>PROGRAMME CODE:</strong></td>
        <td><select  name="mnu_prg_code" class="fieldsize" onchange="SelectSubCat();SelectSubMedium();" tabindex="<%= ++tab %>" autofocus>
          <option value="0">SELECT PROGRAMME</option>
        </select></td>
      </tr>
      <tr>
        <td height="33"><strong>COURSE CODE:</strong></td>
        <td><select id="mnu_crs_code"  name="mnu_crs_code" class="fieldsize" tabindex="<%= ++tab %>">
          <option value="0">SELECT COURSE</option>
        </select></td>
      </tr>
      <tr>
        <td height="33"><strong>SESSION:</strong></td>
        <td><%!String current_session=null; %>
          <%
      				try
	  				{
						rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
						while(rs.next())
						current_session=rs.getString(1);
					}//end of try blocks
					catch(Exception e)
					{
						out.println("connection error"+e);
					}//end of catch blocks
				 %>
          <input name="txt_session" type="text" id="txt_session" class="greysize" value="<%=current_session.toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="33"><strong>MEDIUM:</strong></td>
        <td><select name="txtmedium" id="txtmedium" class="fieldsize" tabindex="<%= ++tab %>" >
          <option value="0">SELECT MEDIUM</option>
        </select></td>
      </tr>
      <tr><input type="hidden" name="remarks" value="" />
        <td><div align="center">
          <input name="reset" class="button" type="reset" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" onclick="document.frm_obsolete.mnu_prg_code.focus();" />
        </div></td>
        <td><div align="center">
          <input name="enter" type="submit" class="button" id="enter" value="NEXT" tabindex="<%= ++tab %>" />
        </div></td>
      </tr>
    </table>
  </div>

  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <h3>ABOUT OBSOLETE SECTION:</h3>
    <p>The Materials which are Obsolete Due to Various reasons are going to affect the Inventory of materials as it will be subtracted from the inventory.All the Transactions related to the Obsolete Materials are entered in the system through this Page.</p>
    <p>  <a href="${pageContext.request.contextPath}/jsp/Obsolete_pg.jsp" title="Click for Damage of Program Guide "><h1><img src="imgs/pg.jpg" alt="Click for Program Guide" width="160" height="190" /></h1></a></p>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</form>

</body>
<script type="text/javascript">

function fillCategory(){ 
 // this function is used to fill the category list on load

<%int i=1;
		  try
{
rs=statement.executeQuery("select prg_code from program");
	while(rs.next())
	{%>
addOption(document.frm_obsolete.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
	<% i++;
	}
}
	catch(Exception e)
{out.println("connection error"+e);}
String str[]=new String[i-1];
%>
<%try
{ResultSet rs1=statement.executeQuery("select prg_code from program");
	int j=0;
		while(rs1.next())
		{str[j]=new String(rs1.getString(1).toString());
		j++;}
}	
catch(Exception e)
{out.println("connection error"+e);}
String khushi;
%>
	addOption(document.frm_obsolete.mnu_prg_code, "ALL", "ALL", "");
}//end of method fillcategory()

function SelectSubCat(){
// ON selection of category this function will work
removeAllOptions(document.frm_obsolete.mnu_crs_code);
addOption(document.frm_obsolete.mnu_crs_code,"0", "SELECT COURSE", "");
<%try
{
ResultSet rs_course;
for(int k=1;k<=str.length;k++)
{
%>
if(document.frm_obsolete.mnu_prg_code.value == "<%=str[k-1]%>")
{<% rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");
int l=1;
	while(rs_course.next())
	{khushi=rs_course.getString(1);%>
	addOption(document.frm_obsolete.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
	<% l++;	}%>
	}//end of if
	<% }%>
	
	if(document.frm_obsolete.mnu_prg_code.value=="ALL")
	{
	<% rs_course=statement_empty.executeQuery("select crs_code from course");
int l=1;
	while(rs_course.next())
	{khushi=rs_course.getString(1);%>
	addOption(document.frm_obsolete.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
	<% l++;	}%>
	
}//end of if all

<%}	
catch(Exception e)
{out.println("connection error"+e);}%>
}

function removeAllOptions(selectbox)
{
	var i;
	for(i=selectbox.options.length-1;i>=0;i--)
	{
		//selectbox.options.remove(i);
		selectbox.remove(i);
	}
}


function addOption(selectbox, value, text )
{
	var optn = document.createElement("OPTION");
	optn.text = text;
	optn.value = value;
	selectbox.options.add(optn);
}


function SelectSubMedium(){
// ON selection of program this function will work
								removeAllOptions(document.frm_obsolete.txtmedium);
								addOption(document.frm_obsolete.txtmedium,"0", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_obsolete.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
								rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
									addOption(document.frm_obsolete.txtmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>
								if(document.frm_obsolete.mnu_prg_code.value=="ALL")
								{
								<%
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_obsolete.txtmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method
</script>
	    <link rel="stylesheet" href="js/jquery-ui.css"  type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() {       $( "#datepicker" ).datepicker();       });	</script>
</body>
</html>
<%
}
%>