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
<title>Despatch RC(PG)</title>
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

<body onload="fillCategory();document.frm_rc.mnu_reg_code.focus();">
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
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">								S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">				Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>  <div id="content"><a name="contentstart" id="contentstart"></a>
		 <form name="frm_rc" action="${pageContext.request.contextPath}/BYRCAVAILABLE_PG_STOCK" onsubmit="return validateForm();" method="post">
<div align="center"><strong>    <hr /><hr />DESPATCH OF PROGRAMME GUIDE<hr /><hr /></strong></div>
	    <table width="465" height="272" border="0">
      <tr><%! int tab=0; %>
        <td width="201" height="51"><strong>REGIONAL CENTRE:</strong></td>
        <td width="254">
 <select name="mnu_reg_code" class="fieldsize" id="mnu_reg_code"  tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" autofocus>
       <option value="0">SELECT RC</option>
          <%int m=1;
try
	{
		rs=statement.executeQuery("select * from regional_centre where reg_code<>'"+rc_code+"'");
		rs.last();
		rs.beforeFirst();
		while(rs.next())
		{
			out.println("<option value ="+rs.getString(1)+">"+rs.getString(2)+"</option>");
			m++;
		}//end of while
	}//end of try blocks	
	catch(Exception e)
	{
		out.println("connection error"+e);
	}//end of catch blocks
%>
        </select></td>
      </tr>
      <tr>
        <td height="38"><strong>PROGRAMME CODE :</strong></td>
        <td><select  name="mnu_prg_code" class="fieldsize"  tabindex="<%= ++tab %>" onchange="SelectSubMedium();" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="0">SELECT PROGRAMME</option>
        </select></td>
      </tr>
      <tr>
        <td height="46"><strong>SESSION:</strong></td>
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
        <input name="txtsession" type="text" id="txtsession" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="true" /></td>
      </tr>
      <tr>
        <td height="44"><strong>MEDIUM :</strong></td>
        <td><select name="txtmedium" class="fieldsize" id="txtmedium" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
                   	<Option value="0">SELECT MEDIUM</option>        </select></td>
      </tr>
      <tr>
        <td height="58"><div align="center">
          <input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" onclick="document.frm_rc.mnu_reg_code.focus();" value="CLEAR FIELDS" class="button" />
        </div></td>
        <td><div align="center">
          <input name="enter" type="submit" id="enter" tabindex="<%= ++tab %>" value="CHECK AVAILABILITY" class="button"/>
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
                  <%if(msg==null){%>
                  <div id="nav-supp">
     <h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS HOME</a></li>
      </ul>
    </div>
    <h3>ABOUT THE RCMS</h3>
    <%}%>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
<script type="text/javascript">
function fillCategory(){ 
										<%int i=1;
											try{
												rs=statement.executeQuery("select prg_code from program");
												while(rs.next())
												{%>
										addOption(document.frm_rc.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
												<% i++;
												}}
											catch(Exception e)
												{out.println("connection error"+e);}
												String str[]=new String[i-1];
										%>
										<%
											try{
												ResultSet rs1=statement.executeQuery("select prg_code from program");
												int j=0;
												while(rs1.next())
												{str[j]=new String(rs1.getString(1).toString());
												j++;}
												}	
											catch(Exception e)
												{out.println("connection error"+e);}
												String khushi;
										%>
										
}//end of method fill category

function removeAllOptions(selectbox)
{
										var i;
										for(i=selectbox.options.length-1;i>=0;i--)
										{
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

function SelectSubMedium()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_rc.txtmedium);
								addOption(document.frm_rc.txtmedium,"0", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_rc.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
									rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_rc.txtmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>	
								if(document.frm_rc.mnu_prg_code.value=="ALL")
								{
								<% 
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_rc.txtmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>	
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method



</script>
<script type="text/javascript">
function validateForm()
{
var rc			=	document.frm_rc.mnu_reg_code.value;
var program		=	document.frm_rc.mnu_prg_code.value;

var letters 	=	 /^[A-Za-z]+$/;
var numbers 	= 	/^[0-9]+$/;

if (rc==0)
  {
  alert("Please Select Regional Center code First..");
  document.frm_rc.mnu_reg_code.focus();
  return false;
  }
if (program==0)
  {
  alert("Please Select Program Code..");
  document.frm_rc.mnu_prg_code.focus();
  return false;
  }
var course		=	document.frm_rc.mnu_crs_code.value;
var course2		=	document.frm_rc.mnu_crs_code2.value;
var course3		=	document.frm_rc.mnu_crs_code3.value;
var course4		=	document.frm_rc.mnu_crs_code4.value;
var course5		=	document.frm_rc.mnu_crs_code5.value;
if(course=="NONE" && course2=="NONE" && course3=="NONE" && course4=="NONE" && course5=="NONE")
{
	alert("Please Select any one Course Code ...");
	document.frm_rc.mnu_crs_code.focus();
	return false;
}
if((course==course2 && course!="NONE")|| (course==course3 && course!="NONE") || (course==course4 && course!="NONE") || (course==course5 && course!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...");
	document.frm_rc.mnu_crs_code.focus();
	return false;
}

if((course2==course && course2!="NONE")|| (course2==course3 && course2!="NONE") || (course2==course4 && course2!="NONE") || (course2==course5 && course2!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...");
	document.frm_rc.mnu_crs_code2.focus();
	return false;
}

if((course3==course && course3!="NONE")|| (course3==course2 && course3!="NONE") || (course3==course4 && course3!="NONE") || (course3==course5 && course3!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...");
	document.frm_rc.mnu_crs_code3.focus();
	return false;
}

if((course4==course && course4!="NONE")|| (course4==course2 && course4!="NONE") || (course4==course3 && course4!="NONE") || (course4==course5 && course4!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...");
	document.frm_rc.mnu_crs_code4.focus();
	return false;
}

if((course5==course && course5!="NONE")|| (course5==course2 && course5!="NONE") || (course5==course3 && course5!="NONE") || (course5==course4 && course5!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...");
	document.frm_rc.mnu_crs_code5.focus();
	return false;
}


var medium		=	document.frm_rc.txtmedium.value;
if (medium=="0")
  {
  alert("Please Select Medium For the Materials to be Despatch..");
  document.frm_rc.txtmedium.focus();
  return false;
  }
}
</script>
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui.css" type="text/css" media="all"/>
	    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    	<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
    	<script>       $(function() { $( "#datepicker" ).datepicker();  });</script>
</html>
<%
}
%>