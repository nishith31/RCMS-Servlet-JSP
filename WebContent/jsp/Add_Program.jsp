<%@ page import="java.util.Date" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.InetAddress,java.net.UnknownHostException" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
String uname=null;
uname=(String)sess.getAttribute("admin_user");
if(sess==null || uname==null)
{
	String msg="Please Login As Admin to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
}
else
{
	String rc_code=(String)sess.getAttribute("rc");
	uname=(String)sess.getAttribute("admin_user");

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
	String home_menu=rb.getString("admin_home_menu");
	String add_menu=rb.getString("admin_add_menu");				
	String update_menu=rb.getString("admin_update_menu");	
	String report_menu=rb.getString("admin_report_menu");	
	String driver=rb.getString("driver");
	String url=rb.getString("connectionurl");
	String user_name=rb.getString("username");
	String pswd=rb.getString("password");
%>
<title>ADD PROGRAMME</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<style type="text/css">
<!--
.style4 {font-family: Arial, Helvetica, sans-serif; font-weight: bold; }
-->
</style>
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var code=document.form_program.text_program_code.value;
if (code==""||code==null || code.match(numbers))
  {
  alert("PLEASE ENTER PROGRAMME CODE IN CORRECT FORMAT..");
  document.form_program.text_program_code.value="";  
  document.form_program.text_program_code.focus();
  return false;
  }
var name=document.form_program.text_program_name.value;
if (name=="" || name.match(numbers))
  {
  alert("PLEASE ENTER PROGRAMME NAME IN CORRECT FORM..");
  document.form_program.text_program_name.value="";
  document.form_program.text_program_name.focus();
  return false;
  }
var duration=document.form_program.text_program_duration.value;
if (duration.length==0 || duration.length>100 || duration.match(letters))
  {
  alert("PLEASE ENTER PROGRAMME DURATION IN MONTHS ONLY..");
   document.form_program.text_program_duration.value="";
   document.form_program.text_program_duration.focus();
  return false;
  }
var type=document.form_program.text_program_type.value;
if (type=="" || type.match(numbers) || type==null)
  {
  alert("PLEASE ENTER TYPE OF PROGRAMME..");
  document.form_program.text_program_type.value="";
  document.form_program.text_program_type.focus();
  return false;
  }
var school=document.form_program.text_program_school.value;
  if (school=="" || school.match(numbers) || school==null)
  {
  alert("PLEASE ENTER SCHOOL CODE LIKE SOCS OR SOCIS..");
   document.form_program.text_program_school.value="";
   document.form_program.text_program_school.focus();
  return false;
  }
}//end of method validateForm()
</script>

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
    <h1>RCMS-MDU ADMIN</h1>
    <div id="nav-meta">
      <ul>
        <li style="color:#FFFFFF">RC:&nbsp;<%= rc_code%></li>
        <li style="color:#FFFFFF">Welcome <%= uname%></li>
                <li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>
                                </ul>
    </div>
  </div>

  <div id="nav-main">
    <ul>
      <li >						<a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Course.jsp" accesskey="C">																							<U>C</U>OURSE			</a></li>
<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Add_Program.jsp" accesskey="P">																		<U>P</U>ROGRAM			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
<li><a href="${pageContext.request.contextPath}/jsp/Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li><a href="${pageContext.request.contextPath}/jsp/Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
<li><a href="${pageContext.request.contextPath}/jsp/Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>

<form name="form_program" action="${pageContext.request.contextPath}/ADDPROGRAM" method="post" onsubmit="return validateForm();">
    <table width="468" height="330" border="0">
      <tr><%int tab=0;%>
        <td width="203"><strong><span class="style4">PROGRAMME CODE :</span></strong></td>
        <td width="255">
 <input name="text_program_code" type="text" id="text_program_code" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" placeholder="Enter New Program Code" onmouseover="mover(this)"  onmouseout="mout(this)" required autofocus/>
        <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" />        </td>
      </tr>
      <tr>
        <td><strong><span class="style4">PROGRAMME NAME:</span></strong></td>
        <td>
<input name="text_program_name" type="text" id="text_program_name" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" placeholder="Enter Name of Program" onmouseover="mover(this)"  onmouseout="mout(this)"/></td>
      </tr>
      <tr>
        <td><strong><span class="style4">PROGRAMME DURATION(In Months):</span></strong></td>
        <td>
<input name="text_program_duration" type="text" id="text_program_duration" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" placeholder="Enter Duration of Program" 
onmouseover="mover(this)"  onmouseout="mout(this)"/></td>
      </tr>
      <tr>
        <td><strong><span class="style4">PROGRAMME TYPE :</span></strong></td>
        <td>
<input name="text_program_type" type="text" id="text_program_type" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" placeholder="Enter Type of Program" onmouseover="mover(this)"  onmouseout="mout(this)"/></td>
      </tr>
      <tr>
        <td><strong><span class="style4">PROGRAMME SCHOOL CODE : </span></strong></td>
        <td>
<input name="text_program_school" type="text" id="text_program_school" class="fieldsize" tabindex="<%= ++tab %>" onchange="upper(this)" placeholder="Enter School Code" onmouseover="mover(this)"  onmouseout="mout(this)"/></td>
      </tr>
      <tr>
        <td><div align="center"><strong>PLEASE SELECT THE MEDIUMS </strong></div></td>
        <td><div align="left"><strong> Initial Quantity of Programme Guide</strong></div></td>
      </tr>
        <%String check=null;
				try
				{
				rs=statement_empty.executeQuery("select * from medium order by id asc");			
				while(rs.next())
				{check=rs.getString(1);%>
      <tr>
        <td><div align="justify"><strong>          <input type="checkbox" name="medium" value="<%=check%>" tabindex="<%= ++tab %>" >   <%= rs.getString(2) %></strong> </div></td>
        <td><div align="center">
          <input type="text" name="<%=check%>" class="fieldsize" placeholder="Enter Initial quantity of PG" tabindex="<%= ++tab %>"/>
        </div></td>
      </tr>
      				<%}//end of while
				}
			catch(Exception e){out.println("excepiton is"+e);}%>
      <tr>
        <td><div align="center">
          <strong>
          <input name="reset" type="reset" class="button" id="reset" tabindex="<%= tab+2 %>" onclick="document.form_program.text_program_code.focus();" value="CLEAR FIELDS"/>
          </strong></div></td>
        <td><div align="center">
          <input name="add" type="submit" class="button" id="add" tabindex="<%= ++tab %>" value="ADD PROGRAM" />
        </div></td>
      </tr>
    </table>
    </form>
  </div>
<div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>
                <%if(msg==null){%>
    <h3>Addition Of New Programme:</h3>
    <p>To Add a New Programme to the Database we enter necessary details here.A Programme Can not be entered more than one time so Please check before Adding new Programme as Each Programme is Uniquely identified by its Programme Code.</p>
    <div id="nav-supp">
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp">Add Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp">Updation Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp"> Material Entry</a></li>
      </ul>
    </div>

    <%}%>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>

</body>
</html>
<%}%>