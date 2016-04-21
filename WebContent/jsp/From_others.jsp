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
<title>Receive-Others</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />

</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
//				statement_empty=connection.createStatement();				
					
			}//end of try blocks
			catch(Exception e)
			{		out.println("connection error"+e);	}//end of catch blocks
  %>

<body onLoad="fillCategory();startup();"%>
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">			From <U>O</U>thers				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="form_others" action="${pageContext.request.contextPath}/RECEIVEOTHERS" method="post" onsubmit="submit_value();return validateForm();">
    <table width="461" height="349" border="0">
      <tr><%! int tab=0; %>
        <td height="47" colspan="2"><strong>COURSE CODE:</strong></td>
        <td colspan="2">
<select id="mnu_crs_code" name="mnu_crs_code" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" onchange="upper(this)" autofocus>
          <option value="0">SELECT COURSE</option>
        </select></td>
      </tr>
      <tr>
        <td height="47" colspan="2">
          <div align="center"><strong>
            <input type="radio" name="receipt_type" id="partial" value="partial" tabindex="<%= ++tab %>" />
          PARTIAL RECEIPT</strong></div></td>
        <td colspan="2"><label>
        <div align="left">
          <input type="radio" name="receipt_type" id="complete" value="complete" tabindex="<%= ++tab %>"/>
          <strong>COMPLETE RECEIPT</strong></div>
        </label></td>
      </tr>
      <tr>
        <td height="47" colspan="4"><div align="right"> <div align="center">
              <input name="check" type="checkbox" id="check" tabindex="<%= ++tab %>" onclick="selection();" />
          <strong>OR ENTER COURSE DETAILS MANUALLY</strong></div></td>
        </tr>
      <tr>
        <td width="88" height="47"><strong>CODE:</strong></td>
        <td width="88">
<input name="text_crs_code" placeholder="Enter Course Code" type="text" class="fieldsize" id="text_crs_code" tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)"/></td>
        <td width="135"><div align="center"><strong> NAME:</strong></div></td>
        <td width="136">
<input name="course_name" type="text" placeholder="Enter Course Name" class="fieldsize" id="course_name" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" /></td>
      </tr>
      
      <tr>
        <td height="41" colspan="2"><strong>SESSION:</strong></td>
        <td colspan="2"><%!String current_session=null; %>
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
          <input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" class="greysize" onmouseover="mover(this)" onmouseout="mout(this)" readonly="true" /></td>
      </tr>
      <tr>
        <td height="47" colspan="2"><strong>MEDIUM:</strong></td>
        <td colspan="2"><label>
          <select name="mnu_medium" class="fieldsize" id="mnu_medium" tabindex="<%= ++tab %>">
          <option value="0">SELECT MEDIUM</option>
          </select>
        </label></td>
      </tr>
      <tr><input type="hidden" name="course_code" value="" />
      	<input type="hidden" name="new_course_code" value=""/>
        <input type="hidden" name="new_course_name" value="" />
        <input type="hidden" name="flag" value="none" />
        <td height="47" colspan="2"><strong>NUMBER OF SETS:</strong></td>
        <td colspan="2">
<input name="text_set" type="text" placeholder="Enter No of Sets" class="fieldsize" id="text_set" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required/></td>
      </tr>
      <tr>
        <td height="45" colspan="2"><strong>DATE:</strong></td>
        <td colspan="2">
<input name="text_date" type="text" placeholder="Click to Select Date" class="fieldsize" id="datepicker" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required/></td>
      </tr>
      <tr>
        <td height="45" colspan="2"><strong>RECEIVED FROM:</strong></td>
        <td colspan="2">
<input name="receive_from" type="text" placeholder="Receiving Source" class="fieldsize" id="receive_from" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required/></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" class="button" onclick="document.frm_others.mnu_crs_code.focus();" value="CLEAR FIELDS" />
        </div></td>
        <td colspan="2"><div align="center">
          <input type="submit" name="submit" value="RECEIVE" tabindex="<%= ++tab %>" class="button"/>
        </div></td>`      </tr>
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
    <%if(msg==null)
	{%>
    <h3>ABOUT RECEIVE OTHERS</h3>
      <p>Whenever RC Receives any Material from any Other source Rather than all the regular receiving sources than those transactions are managed by this page, like receiving of material from any staff or from any visitor.
        <%}%>
      </p>
  <a href="${pageContext.request.contextPath}/jsp/From_others_pg.jsp" title="Click for RECEIPT Program Guide "><h1><img src="imgs/pg.jpg" alt="Click for Program Guide" width="160" height="190" /></h1></a>
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
    <script type="text/javascript">
function fillCategory()
{
<%
try
{
rs=statement.executeQuery("select crs_code from course");
	while(rs.next())
	{%>
addOption(document.form_others.mnu_crs_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
	<% 
	}
		rs=statement.executeQuery("select * from medium");
	while(rs.next())
	{%>
addOption(document.form_others.mnu_medium,"<%=rs.getString(1)%>","<%=rs.getString(2)%>","");
	<% 
	}
	
}
	catch(Exception e)
{out.println("connection error"+e);}
%>
}//end of method fillcategory()
function addOption(selectbox, value, text )
{
	var optn = document.createElement("OPTION");
	optn.text = text;
	optn.value = value;
	selectbox.options.add(optn);
}
function selection()
{
	if(document.form_others.check.checked==true)
	{
		document.form_others.mnu_crs_code.disabled=true;
		document.form_others.receipt_type[0].disabled=true;				
		document.form_others.receipt_type[1].disabled=true;				
		
		document.form_others.text_crs_code.disabled=false;
		document.form_others.course_name.disabled=false;		
//		document.getElementById("partial").disabled=true;		
	}
	if(document.form_others.check.checked==false)
	{
		document.form_others.mnu_crs_code.disabled=false;
		document.form_others.receipt_type[0].disabled=false;				
		document.form_others.receipt_type[1].disabled=false;				

		document.form_others.text_crs_code.disabled=true;
		document.form_others.course_name.disabled=true;		
		
	}


}//end of method selection
function startup()
{
		document.form_others.text_crs_code.disabled=true;
		document.form_others.course_name.disabled=true;		

}
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
	if(document.form_others.check.checked==true)
	{
		var course_code=document.form_others.text_crs_code.value;
		if(course_code=="0" || course_code=="" || course_code.match(numbers) || course_code==null)
		{
			alert("PLEASE ENTER NEW COURSE CODE MANUALLY....");
			document.form_others.text_crs_code.value="";
			document.form_others.text_crs_code.focus();
			return false;
		}
		var course_name=document.form_others.course_name.value;
		if(course_name=="0" || course_name=="" || course_name.match(numbers) || course_name==null)
		{
			alert("PLEASE ENTER NAME OF THE NEW COURSE..");
			document.form_others.course_name.value="";
			document.form_others.course_name.focus();
			return false;	
		}		
	}//end of if
	if(document.form_others.check.checked==false)
	{
		var crs_code=document.form_others.mnu_crs_code.value;
		if(crs_code=="0")
		{
			alert("PLEASE SELECT COURSE CODE FIRST..");
			document.form_others.mnu_crs_code.focus();
			return false;
		}
	}


var medium			=	document.form_others.mnu_medium.value;
if(medium=="0")
{
alert("PLEASE SELECT MEDIUM");
document.form_others.mnu_medium.focus();
return false;
}
var sets			=	document.form_others.text_set.value;
if(sets==0 || sets.match(letters) || sets==null)
{
alert("PLEASE ENTER QUANTITY IN NUMBER");
document.form_others.text_set.value="";
document.form_others.text_set.focus();
return false;
}
var rec_date			=	document.form_others.text_date.value;
if(rec_date=="0" || rec_date==null || rec_date==0)
{
alert("PLEASE SELECT DATE..");
document.form_others.text_date.value="";
document.form_others.text_date.focus();
return false;
}
else
{
	var passedDate = new Date(rec_date);
	var currentDate= new Date();
	if (passedDate > currentDate ) 
	{
		   alert("PLEASE ENTER CURRENT DATE OR LESS THAN CURRENT DATE");
			document.form_others.text_date.focus();
		   return false;
	  }	
}//end of else

var receive_from			=	document.form_others.receive_from.value;
if(receive_from=="" || receive_from==null || receive_from.match(numbers))
{
alert("PLEASE ENTER RECEIVER'S NAME IN WORK");
document.form_others.receive_from.value="";
document.form_others.receive_from.focus();
return false;
}
}//end of validateForm() method

function submit_value()
{
		if(document.form_others.check.checked==true)
		{
			document.form_others.course_code.value="NONE";
			document.form_others.new_course_code.value=document.form_others.text_crs_code.value;
			document.form_others.new_course_name.value=document.form_others.course_name.value;
			document.form_others.flag.value="NEW";
		}
		if(document.form_others.check.checked==false)		
		{
			document.form_others.course_code.value=document.form_others.mnu_crs_code.value;
			document.form_others.new_course_code.value="NONE";
			document.form_others.new_course_name.value="NONE";
			document.form_others.flag.value="OLD";		
		}

}//end of function submit_value()
</script> 
</html>
<%
}
%>