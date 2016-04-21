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
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
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
<title>Programme Abbreviation</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
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

<body onLoad="startup();">
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
      <li >						<a href="Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li class="current">		<a href="Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
<li><a href="Add_Course.jsp" accesskey="C">																							<U>C</U>OURSE			</a></li>
<li><a href="Add_Program.jsp" accesskey="P">																						<U>P</U>ROGRAM			</a></li>
<li><a href="Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
<li><a href="Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
<li><a href="Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
<li><a href="Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
<li class="youarehere"><a href="Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">				ABBRE<U>V</U>IATION		</a></li> 
<li><a href="Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
    </ul>
  </div>
  <%! int tab=0; %>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_abbreviation" action="PGABBREVIATIONCHECK" method="post" onsubmit="submit_value();">
<input type="hidden" name="program_code" value="" />
    <h1>Search The Details Of Programme</h1>
    <p><strong>By Selecting From</strong></p>
    <table width="456" border="0" cellspacing="0">
      <tr>
        <td width="185" height="52"><label>
          <div align="right"><strong>Courses:</strong> </div>
        </label></td>
        <td width="267"><div align="center">
          <select name="menu_program_code" id="menu_program_code" tabindex="<%=++tab%>">
          <option value="0">SELECT PROGRAMME</option>
								<%int i=1;
								  try
									{
											rs=statement.executeQuery("select prg_code from program");
											while(rs.next())
												{
													out.println("<option value ="+rs.getString(1)+">"+rs.getString(1)+"</option>");
														i++;
												}
										}	
										catch(Exception e)
										{out.println("connection error"+e);}
									%>
          
          </select>
        </div></td>
      </tr>
      <tr>
        <td height="54" colspan="2"><label>
          <div align="center">
            <input type="checkbox" name="check" id="check" onclick="selection();" tabindex="<%=++tab%>"/>
            <strong>OR            </strong></div>
        </label></td>
      </tr>
      <tr>
        <td height="41" colspan="2"><div align="center"><strong>Enter Programme Code Manually</strong></div></td>
      </tr>
      <tr>
        <td colspan="2"><label>
          <div align="center">
<input name="text_program_code" type="text" class="ignousize" id="text_course_code" tabindex="<%=++tab%>" onchange="upper(this)" placeholder="Enter the Code Manually to Search"/>
          </div>
        </label></td>
      </tr>
      <tr>
        <td><div align="center">
          <input type="reset" class="button" value="RESET" tabindex="<%=tab+2%>" />
        </div></td>
        <td><div align="center">
          <input type="submit"  class="button" name="submit" value="SEARCH" tabindex="<%=++tab%>" onclick="return myFunction()" />
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
    <h3>Addition of New Abbreviation:</h3>
    <p>To Add new Abbreviation Select the actual code from the IGNOU Database first and then check it and then assign short cut code for the actual code.</p>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>


<script type="text/javascript">
function selection()
{
	if(document.form_abbreviation.check.checked==true)
	{
		document.form_abbreviation.menu_program_code.disabled=true;
		document.form_abbreviation.text_program_code.disabled=false;		

	}
	if(document.form_abbreviation.check.checked==false)
	{
		document.form_abbreviation.menu_program_code.disabled=false;
		document.form_abbreviation.text_program_code.disabled=true;		
		
	}
}//end of method selection
function startup()
{
		document.form_abbreviation.text_program_code.disabled=true;

}
function submit_value()
{
	
	
		if(document.form_abbreviation.check.checked==true)
		{
			document.form_abbreviation.program_code.value=document.form_abbreviation.text_program_code.value;
		}
		if(document.form_abbreviation.check.checked==false)		
		{
			document.form_abbreviation.program_code.value=document.form_abbreviation.menu_program_code.value;
		}

}//end of function submit_value()
function myFunction()
{
var x;
var r=confirm("Are you Confirm to Proceed!");
if (r==true)
  {
  return true;
  }
else
  {
  return false;
  }
}


</script>
</body>
</html>
<%}%>