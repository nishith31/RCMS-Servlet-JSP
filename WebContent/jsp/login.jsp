<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<meta http-equiv="Content-Language" content="en-us" />
		<meta name="description" content="Put a description of the page here" />
		<meta name="keywords" content="Put your keywords here" />
		<meta name="robots" content="index,follow" />
		<title>MDU Login</title>
		<link rel="shortcut icon" href="imgs/favicon.ico" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
		<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
		<script src="${pageContext.request.contextPath}/js/SpryValidationTextField.js" type="text/javascript"></script>
		<link href="${pageContext.request.contextPath}/js/SpryValidationTextField.css" rel="stylesheet" type="text/css"/>
	</head>
	<body onLoad="document.aform.menu_rc_code.focus();" style="background-color:#FFFFCC">

		<font face="verdana,arial" size=-1>
		<center><table cellpadding='2' cellspacing='0' border='0' id='ap_table' width="30%">
		<%! int tab=0; %>
		<tr><td bgcolor="blue"><table cellpadding='0' cellspacing='0' border='0' width='100%'><tr><td bgcolor="blue" align=center style="padding:2;padding-bottom:4"><b><font size=-1 color="white" face="verdana,arial"><b>Enter your login and password</b></font></th></tr>
		<tr><td bgcolor="white" style="padding:5">  
						<div id="blink1" class="highlight">
						<div align="center">
						  <% String msg=null;
						try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
					  </div>
					  <h4 align="center"><%if(msg!=null)
						out.println(msg); %></h4>
		                </div>
		<br>
		<%int count=0;
		
		   Cookie cookie = null;
		   Cookie[] cookies = null;
		   // Get an array of Cookies associated with this domain
		   cookies = request.getCookies();
		   if( cookies != null )
		   {
		      
		      for (int i = 0; i < cookies.length; i++)
			  {
		         cookie = cookies[i];
				 if(cookie.getName()=="rc_code_cookie")
				 {request.setAttribute("menu_rc_code",cookie.getValue());
				 count++;}
				 if(cookie.getName()=="role_cookie")
				 {request.setAttribute("user_type",cookie.getValue());
				 count++;}
				 if(cookie.getName()=="username_cookie")
				 {request.setAttribute("login",cookie.getValue());
				 count++;}
				 if(cookie.getName()=="password_cookie")
				 {request.setAttribute("password",cookie.getValue());
				 count++;}
		      }
			}
			  if(count==4)
			  {
		//	  	request.setAttribute("mode","direct");
				request.getRequestDispatcher("CheckLogin?mode='direct'").forward(request,response);
			  }
		  else{
		  	  	//request.setAttribute("mode","indirect");
		  %>
		
		  
		<form method="post" action="login" name="aform" target="_top" onSubmit="return validate();">
		<input type="hidden" name="action" value="login">
		<input type="hidden" name="hide" value="">
		<input type="hidden" name="mode" value="indirect">
		
		
		<center><table>
		<tr>
		
		  <td>Select RC :</td>
		  <td><select name="menu_rc_code" size="1" tabindex="<%= ++tab %>" autofocus>
		 	<%
		      try
			  {
				Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
				Connection c=DriverManager.getConnection("jdbc:odbc:mdu_rc_block_dsn","sa","sqlserver");
				Statement s=c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				ResultSet rs=s.executeQuery("select * from regional_centre order by reg_name ASC");
					while(rs.next())
				{%>
		    <option value="<%= rs.getString(1) %>" selected><%= rs.getString(2) %></option>		
				<%}
				}
				catch(Exception es){}%>
		  </select></td>
		</tr>
		<tr><td><font face="verdana,arial" size=-1>User Type:</font></td>
		  <td><select name="user_type" size="1" tabindex="<%= ++tab %>">
		    <option value="admin">admin</option>
		    <option value="staff" selected>staff</option>
		  </select></td>
		</tr>
		<tr><td><font face="verdana,arial" size=-1>Login:</font></td>
		  <td><span id="sprytextfield1">
		    <label>
		    <input type="text" name="login" id="login" tabindex="<%= ++tab %>" required></label>
		    </span></td>
		</tr>
		
		<tr><td><font face="verdana,arial" size=-1>Password:</font></td><td><input type="password" name="password" tabindex="<%= ++tab %>" required></td></tr>
		<tr><td><font face="verdana,arial" size=-1>&nbsp;</font></td>
		<td><font face="verdana,arial" size=-1><input type="submit" value="Sign In" tabindex="<%=tab++%>" class="button">
		</font></td></tr>
		<tr><td colspan=2><font face="verdana,arial" size=-1>&nbsp;</font></td></tr>
		<tr>
		<td colspan=2>
		<font face="verdana,arial" size=-1>Remember Me <input name="RememberMe" type="checkbox" /></font></td>
		</tr>
		</table>
		</center>
		
		</form>
		<%
		  }//end of else of if of count==4
		%>
		
		</td></tr></table></td></tr></table>

	</body>
	<script type="text/javascript">
	function validate()
	{
		if(document.aform.login.value=="" || document.aform.login.value=="Enter User name" || document.aform.login.value.length==0)
		{
			alert("Please Enter User Name....");
			document.aform.login.focus();
			return false;
		}
		if(document.aform.password.value=="" || document.aform.login.password.length==0)
		{
			alert("Please Enter Password....");
			document.aform.password.focus();
			return false;
		}
	}
	</script>
</html>
