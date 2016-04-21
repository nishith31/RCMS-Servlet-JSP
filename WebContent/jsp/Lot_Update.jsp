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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
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
<title>Update LOT Name</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script>
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
			var total_box = document.form_lot.lot_name.length;
				if(typeof total_box=='undefined')
				{
					if(document.form_lot.lot_name.checked)
					var nishi='genius';
					else
					{alert("Please Select At least One Lot Name before Update");
					return false;}
				}
				else
				{var checked_course=0;
			    for (i=0; i < total_box; i++) 
				{
    				if(document.form_lot.lot_name[i].checked == 1)
    				{ checked_course++;}
    			
				}
if(checked_course==0)
{
	alert("Please Select At least One Lot Name before Update");
	return false;
}}


}
</script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script></head>
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
<body >
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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H">						<%=home_menu.trim()%>				</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%>			</a></li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%>			</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%>			</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %>					</a></li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %>					</a></li>
     <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %>					</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul>
       <li><a href="${pageContext.request.contextPath}/jsp/Update_parcel_no.jsp">Parcel Number</a></li>
   <li ><a href="${pageContext.request.contextPath}/jsp/Student_Update.jsp" >Student Details</a></li>
  <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Lot_Update.jsp" >LOT Name</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>

    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_lot" action="${pageContext.request.contextPath}/LOTUPDATESEARCH"  method="post">
<% String rc_code=(String)sess.getAttribute("rc");
	String current_session=null,temp=null;
	int index=0;
	String array_of_lots[]=new String[0];
		String name_of_lots[]=new String[0]; %>

    <% try{
	rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
	while(rs.next())
	current_session=rs.getString(1).toLowerCase();
		rs=statement.executeQuery("select count(distinct(lot_name)) from student_"+current_session+"_"+rc_code+"");
		if(rs.next())
		array_of_lots=new String[rs.getInt(1)];
		name_of_lots=new String[array_of_lots.length];
			rs=statement.executeQuery("select distinct(lot_name) from student_"+current_session+"_"+rc_code+" order by lot_name asc");
			while(rs.next())
			{
				array_of_lots[index]=rs.getString(1).trim();
				index++;
			}//end of while loop
			int n=0;
			for(index=0;index<array_of_lots.length;index++)
			{
				temp="";
				n=0;
				rs=statement.executeQuery("select distinct(lot) from student_"+current_session+"_"+rc_code+" where lot_name='"+array_of_lots[index]+"'");
				while(rs.next())
				{
					if(n>0)
					temp=temp+" , "+rs.getString(1);
					else
					temp=rs.getString(1);
					n++;				
				}//end of while loop
				name_of_lots[index]=temp;
			}//end of for loop
			
	}catch(Exception ee){} 
	if(array_of_lots.length==0)
	{%>
	<h2><strong>No Student Data Available for Current Session <%= current_session.toUpperCase() %>	</strong></h2>
	<%}
	else{
	%>
    
    <table width="470" border="2">
      <tr>
      <%!int tab=0;%>
        <td width="254"><strong>ACTUAL NAME OF LOT(FROM .DBF FILE)</strong></td>
        <td width="206"><label><strong>LOT NAME GIVEN BY RCMS-MDU</strong></label></td>
      </tr><%for(index=0;index<array_of_lots.length;index++){%>
      <tr>
        <td><input type="checkbox" name="lot_name" value="<%=array_of_lots[index]%>" tabindex="<%=++tab%>" /><strong>&nbsp;<%=array_of_lots[index]%></strong></td>
        <td><div align="center"><strong><%=name_of_lots[index]%></strong></div></td>
      </tr><%}%></table><%}%>
          <table width="470" border="0">
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
	<%	if(array_of_lots.length==0)
	{%>
      <tr>
        <td colspan="2">   <div align="center">
<a href="Update.jsp" title="Click to go Update Home."> <img src="imgs/home_template.jpg" alt="Save icon"/></a>
    </div></td>
        </tr>
        <%}else{%>
      <tr>
        <td><div align="center">
          <input type="submit" name="enter" value="REFRESH" tabindex="<%=tab+2%>" class="button"/>
        </div></td>
        <td><div align="center">
          <input type="submit" name="enter" onclick="return validateForm()" value="UPDATE" tabindex="<%=++tab%>" class="button"/>
        </div></td>
      </tr><%}%>
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


                <h3>About the RCMS-MDU:</h3>
    <p>The main idea behind this application is to maintain the Material Inventory of the Regional Centres in an Efficient Way.</p>
    <%}%>
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