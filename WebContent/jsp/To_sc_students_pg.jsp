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
<meta name="description" content="To Students of Study Centres" />
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
<title>Despatch-SC Students</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null,rs1=null,rs_course=null;%>
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

<body onLoad="fillCategory();document.frm_sc_pg1.mnu_sc_code.focus();">
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">			SC <U>F</U>or Students			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
  <form name="frm_sc_pg1" onsubmit="return validateForm();" action="${pageContext.request.contextPath}/BYSC_PG_SEARCH" method="post" >
  <div align="center"><strong>    <hr /><hr /><U>DESPATCH OF PROGRAMME GUIDE TO STUDY CENTRE</U><hr /><hr /></strong></div>
  
    <table width="456" border="0">
      <tr height="32"><%! int tab=0; %>
            <input type="hidden" name="first_timer" value="YES" />
        <td width="188"><strong>Study Centre Code:</strong></td>
        <td width="258"><select name="mnu_sc_code" class="fieldsize" tabindex="<%= ++tab %>" autofocus>
          <option value = "0">SELECT SC</option>
          <%int m=1;
		  try{
				rs=statement.executeQuery("select * from study_centre where reg_code='"+rc_code+"'");
				while(rs.next())
				{	
					out.println("<option value ="+rs.getString(1)+">"+rs.getString(1)+"</option>");
					m++;
				}
			}catch(Exception e)
			{out.println("connection error"+e);}
			%>
        </select></td>
      </tr>
      <tr height="32">
        <td><strong>Programme Code:</strong></td>
        <td><select  name="mnu_prg_code" onChange="SelectSubCat();SelectSubMedium();" class="fieldsize" tabindex="<%= ++tab %>" >
          <option value="0">SELECT PROGRAMME</option>
        </select></td>
      </tr>
      <tr height="32">
        <td><strong>Course Code:</strong></td>
        <td><select id="mnu_crs_code" name="mnu_crs_code" class="fieldsize" tabindex="<%= ++tab %>">
          <option value="0">SELECT COURSE</option>
        </select></td>
      </tr>
      <tr height="32">
        <td><strong>Session:</strong></td>
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
          <input name="textsession" type="text" id="textsession" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="true" /></td>
      </tr>
      <tr height="32">
        <td><strong>Year/Semester:</strong></td>
        <td><select name="textyear" id="textyear" class="fieldsize" tabindex="<%= ++tab %>" >
          <option value="NA">NA</option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
        </select></td>
      </tr>
      <tr height="32">
        <td><strong>Medium:</strong></td>
  <td><select name="textmedium" id="textmedium" class="fieldsize" tabindex="<%= ++tab %>" >
                   	<Option value="0">SELECT MEDIUM</option>
        </select></td>
      </tr>
      <tr>
        <td><div align="center">
          <strong>
          <input name="reset" type="reset" id="reset" value="CLEAR FIELDS" class="button" tabindex="<%= tab+2 %>" onclick="document.frm_sc_pg1.mnu_sc_code.focus();" />
          </strong></div></td>
        <td><div align="center">
          <input name="enter" type="submit" id="enter" value="CHECK AVAILABILITY" class="button" tabindex="<%= ++tab %>" />
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
                This Section is used for despatch materials to students of the study centres.
<%}%>
  </div>
  <a href="${pageContext.request.contextPath}/jsp/By_post_bulk_pg1.jsp" title="Click for Despatch Program Guide in Bulk">
  <h1>&nbsp;</h1>
  </a>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</body>
<script type="text/javascript">
function fillCategory(){ 
	<%
		int i=1;
		try
		{
			rs=statement.executeQuery("select prg_code from program");
			while(rs.next())
			{
	%>
addOption(document.frm_sc_pg1.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
	<% 
			i++;
			}//end of while loop
			}//end of try blocks
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
		String str[]=new String[i-1];
	%>
	<%
		try
		{
			rs1=statement.executeQuery("select prg_code from program");
			int j=0;
			while(rs1.next())
			{
				str[j]=new String(rs1.getString(1).toString());
				j++;
			}//end of while loop
		}//end of try blocks	
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
		String khushi;
	%>
	}//end of fillCategory method

function SelectSubCat(){
// ON selection of category this function will work
removeAllOptions(document.frm_sc_pg1.mnu_crs_code);
addOption(document.frm_sc_pg1.mnu_crs_code, "0","SELECT COURSE","");
	<%
		try
		{
			
			for(int k=1;k<=str.length;k++)
			{
				rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");
	%>
if(document.frm_sc_pg1.mnu_prg_code.value == "<%=str[k-1]%>")
{
	<% 
			int l=1;
			while(rs_course.next())
			{
				khushi=rs_course.getString(1);
	%>
addOption(document.frm_sc_pg1.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
	<%
			 l++;
			}//end of while loop
	%>
			}//end of if
	<% 
			}//end of for loop
		}//end of try blocks	
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
	%>
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


function SelectSubMedium()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_sc_pg1.textmedium);
								addOption(document.frm_sc_pg1.textmedium,"0", "SELECT MEDIUM", "");
								<%
								try{
									
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_sc_pg1.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
								rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_sc_pg1.textmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>	
								if(document.frm_sc_pg1.mnu_prg_code.value=="ALL")
								{
								<% 
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_sc_pg1.textmedium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>	
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method



function validateForm()
{
var sc=document.frm_sc_pg1.mnu_sc_code.value;
var program=document.frm_sc_pg1.mnu_prg_code.value;
var course=document.frm_sc_pg1.mnu_crs_code.value;
var sem=document.frm_sc_pg1.textyear.value;
var medium=document.frm_sc_pg1.textmedium.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;

if(sc=="0")
{
alert("Please Select Study Centre Code First...");
document.frm_sc_pg1.mnu_sc_code.focus();
return false;
}
if(program=="0")
{
alert("Please Select Program Code ...");
document.frm_sc_pg1.mnu_prg_code.focus();
return false;
}
if(course=="0")
{
alert("Please Select Course Code ...");
document.frm_sc_pg1.mnu_crs_code.focus();
return false;
}
if(medium=="0")
{
alert("Please Enter Medium of the course...");
document.frm_sc_pg1.textmedium.focus();
return false;
}
if(student.match(letters) || student.length==0 || student=="")
{
alert("please enter the number of students for the study center..");
document.frm_sc_pg1.text_no_of.stu.focus();
return false;
}

}
</script>

</html>
<%}%>