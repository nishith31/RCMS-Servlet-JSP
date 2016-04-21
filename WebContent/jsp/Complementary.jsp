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
<title>Despatch-Complementary</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{//alert("hello");
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;

var program		=	document.frm_complementary.mnu_prg_code.value;
if(program=="NONE")
{
	alert("Please select Program Code First...");
	document.frm_complementary.mnu_prg_code.focus();
	return false;
}

var course		=	document.frm_complementary.mnu_crs_code.value;
var course2		=	document.frm_complementary.mnu_crs_code2.value;
var course3		=	document.frm_complementary.mnu_crs_code3.value;
var course4		=	document.frm_complementary.mnu_crs_code4.value;
if(course=="NONE" && course2=="NONE" && course3=="NONE" && course4=="NONE")
{
	alert("Please select any one Course Code ...");
	document.frm_complementary.mnu_crs_code.focus();
	return false;
}
if((course==course2 && course!="NONE")|| (course==course3 && course!="NONE") || (course==course4 && course!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...cell one prime");
	document.frm_complementary.mnu_crs_code.focus();
	return false;
}

if((course2==course && course2!="NONE")|| (course2==course3 && course2!="NONE") || (course2==course4 && course2!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...cell two prime");
	document.frm_complementary.mnu_crs_code2.focus();
	return false;
}

if((course3==course && course3!="NONE")|| (course3==course2 && course3!="NONE") || (course3==course4 && course3!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...cell three prime");
	document.frm_complementary.mnu_crs_code3.focus();
	return false;
}

if((course4==course && course4!="NONE")|| (course4==course2 && course4!="NONE") || (course4==course3 && course4!="NONE"))
{
	alert("Please Do not Select One Course More than One time ...cell four prime");
	document.frm_complementary.mnu_crs_code4.focus();
	return false;
}

var medium		=	document.frm_complementary.txt_medium.value;
if(medium=="0")
{
	alert("Please Select Medium of Materials...");	
	document.frm_complementary.txt_medium.focus();
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

<body onLoad="fillCategory();document.frm_complementary.mnu_prg_code.focus();">
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
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">	Complementar<U>y</U>			</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_complementary" action="${pageContext.request.contextPath}/AVAILABLECOMPLEMENTARY" method="post" onSubmit="return validateForm();">
    <table width="467" height="408" border="0">
      <tr><%! int 	tab=0; %>
        <td width="210" height="53"><strong>PROGRAMME CODE :</strong></td>
        <td width="247">
<select  name="mnu_prg_code" onchange="SelectSubCat();SelectSubMedium();upper(this)" tabindex="<%= ++tab %>"  class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)" autofocus >
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
        </tr>
      <tr>
        <td height="49"><strong>COURSE CODE1 :</strong></td>
        <td><select id="mnu_crs_code" name="mnu_crs_code" tabindex="<%= ++tab %>" class="fieldsize"  onchange="upper(this)">
          <option value="NONE">SELECT COURSE</option>
        </select></td>
        </tr>
      <tr>
        <td height="48"><strong>COURSE CODE2 :</strong></td>
        <td><select id="mnu_crs_code2" name="mnu_crs_code2" tabindex="<%= ++tab %>" class="fieldsize"  onchange="upper(this)">
          <option value="NONE">SELECT COURSE</option>
        </select></td>
        </tr>
      <tr>
        <td height="45"><strong>COURSE CODE3 :</strong></td>
        <td><select id="mnu_crs_code3" name="mnu_crs_code3" tabindex="<%= ++tab %>" class="fieldsize"  onchange="upper(this)">
          <option value="NONE">SELECT COURSE</option>
        </select></td>
        </tr>
      <tr>
        <td height="42"><strong>COURSE CODE4 :</strong></td>
        <td><select id="mnu_crs_code4" name="mnu_crs_code4" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)">
          <option value="NONE">SELECT COURSE</option>
        </select></td>
        </tr>
      <tr>
        <td height="37"><strong>SESSION:</strong></td>
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
          <input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
        <td height="38"><strong>MEDIUM:</strong></td>
        <td>
<select name="txt_medium" id="txt_medium" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this);" >
          <option value="0">SELECT MEDIUM</option>
                  </select></td>
      </tr>     
      <tr>
        <td height="45"><div align="center">
          <input name="reset" type="reset" id="reset" class="button" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" onclick="document.frm_complementary.mnu_prg_code.focus();" />
        </div></td>
        <td><div align="center">
          <input name="enter" type="submit" id="enter" value="CHECK AVAILABILITY" tabindex="<%= ++tab %>" class="button" />
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
    
                <h3>About Complementary </h3>
    <p>Whenever Regional Centre distributes study materials to other persons rather than learners it is treated as Complementary Despatch of Material and these transactions are of Despatch Nature as reducing the Inventory of Materials.</p>
    <h2>Note: A Contact Number can not be used twice for the Same Date for the Despatch.This is the Only Restriction for this Module.</h2>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
<script type="text/javascript">

function fillCategory()
{ 
								<%
									int i=1;
									try{
							 rs=statement.executeQuery("select prg_code from program");
										while(rs.next())
										{
								%>
								addOption(document.frm_complementary.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
								<% i++;
										}
										}
									catch(Exception e)
										{
										out.println("connection error"+e);
										}
										String str[]=new String[i-1];
										
								%>
								<%
									try{
										ResultSet rs1=statement.executeQuery("select prg_code from program");
										int j=0;
										while(rs1.next())
										{
											str[j]=new String(rs1.getString(1).toString());
											j++;
										}
										}	
										catch(Exception e)
										{
											out.println("connection error"+e);
										}
										String khushi;
								%>
								addOption(document.frm_complementary.mnu_prg_code,"ALL", "ALL", "");
}//end of fillCategory

function SelectSubCat()
{
// ON selection of category this function will work
								removeAllOptions(document.frm_complementary.mnu_crs_code);
									removeAllOptions(document.frm_complementary.mnu_crs_code2);
										removeAllOptions(document.frm_complementary.mnu_crs_code3);
											removeAllOptions(document.frm_complementary.mnu_crs_code4);

								addOption(document.frm_complementary.mnu_crs_code, "NONE", "SELECT COURSE", "");
									addOption(document.frm_complementary.mnu_crs_code2, "NONE", "SELECT COURSE", "");
										addOption(document.frm_complementary.mnu_crs_code3, "NONE", "SELECT COURSE", "");
											addOption(document.frm_complementary.mnu_crs_code4, "NONE", "SELECT COURSE", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
										rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");
								%>
								if(document.frm_complementary.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
									int l=1;
									while(rs_course.next())
									{
										khushi=rs_course.getString(1);
								%>
								addOption(document.frm_complementary.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
									addOption(document.frm_complementary.mnu_crs_code2,"<%=khushi%>","<%=khushi%>");
										addOption(document.frm_complementary.mnu_crs_code3,"<%=khushi%>","<%=khushi%>");
											addOption(document.frm_complementary.mnu_crs_code4,"<%=khushi%>","<%=khushi%>");
								<% l++;	}%>
								}//end of if
								<% }//end of for loop
								%>
								if(document.frm_complementary.mnu_prg_code.value=="ALL")
								{
								<% 
									rs_course=statement_empty.executeQuery("select crs_code from course");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
									
								%>
								addOption(document.frm_complementary.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
									addOption(document.frm_complementary.mnu_crs_code2,"<%=khushi%>","<%=khushi%>");
										addOption(document.frm_complementary.mnu_crs_code3,"<%=khushi%>","<%=khushi%>");
											addOption(document.frm_complementary.mnu_crs_code4,"<%=khushi%>","<%=khushi%>");

								<% l++;	}%>
								}//end of if all
	
	
								<%
									}
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method



function SelectSubMedium()
{
//alert("onchange medium activated");
// ON selection of program this function will work
								removeAllOptions(document.frm_complementary.txt_medium);
								addOption(document.frm_complementary.txt_medium,"0", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_complementary.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
							rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
									addOption(document.frm_complementary.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>
								if(document.frm_complementary.mnu_prg_code.value=="ALL")
								{
								<%
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_complementary.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method

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
</script>
	    <link rel="stylesheet"
    href="${pageContext.request.contextPath}/js/jquery-ui.css"
    type="text/css" media="all"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() {
            $( "#datepicker" ).datepicker();
        });
	</script>
</html>
<%
}
%>