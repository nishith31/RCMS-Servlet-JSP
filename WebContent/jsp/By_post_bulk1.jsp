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
<title>Despatch-By Post</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;

var program=document.frm_post_bulk.mnu_prg_code.value;
var course=document.frm_post_bulk.mnu_crs_code.value;
var medium=document.frm_post_bulk.mnu_medium.value;
var lot=document.frm_post_bulk.text_lot.value;    
var start=document.frm_post_bulk.text_start.value;
var end=document.frm_post_bulk.text_end.value;

if (program=="0")
  {
	alert("Please Select Program Code First");
	document.frm_post_bulk.mnu_prg_code.focus();
	return false;
  }
if (course=="0")
  {
	alert("Please Select Course Code....");
	document.frm_post_bulk.mnu_crs_code.focus();
	return false;
  }
if (medium=="0")
  {
	alert("Please Select Medium For Study Material....");
	document.frm_post_bulk.mnu_medium.focus();
	return false;
  }
if (lot=="0" || lot=="")
  {
	alert("Please Enter the Lot Number....");
	document.frm_post_bulk.text_lot.focus();
	return false;
  }
if (start=="0" || start=="" || start.match(letters))
  {
	alert("Please Enter Starting Range in Numbers....");
	document.frm_post_bulk.text_start.focus();
	return false;
  }
if (end=="0" || end=="" || end.match(letters))
  {
	alert("Please Enter Ending Range in Numbers....");
	document.frm_post_bulk.text_end.focus();
	return false;
  }
if (end-start<0)
  {
	alert("Please Enter Ending Range Greater Than Starting Range....");
	document.frm_post_bulk.text_end.focus();
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

<body onLoad="fillCategory();">
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp" title="BY POST BULK" accesskey="S">			Po<U>s</U>t Bulk Entry			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">								S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>
  <div id="content">
    <a name="contentstart" id="contentstart"></a>
    <form name="frm_post_bulk" action="${pageContext.request.contextPath}/BYPOSTBULKSEARCH" onsubmit="return validateForm()" method="post">
    <table width="471" height="257" border="0">
      <tr><%! int tab=0; %>
        <td width="74"><strong>PROGRAMME </strong></td>
        <td width="74"><strong>CODE:</strong></td>
        <td colspan="3">
<select name="mnu_prg_code" class="fieldsize" id="mnu_prg_code"  tabindex="<%= ++tab %>" onchange="SelectSubCat();SelectSubMedium();upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" autofocus >
          <option value="0">SELECT PROGRAMME</option>
        </select></td>
      </tr>
      <tr>
        <td colspan="2"><strong>COURSE CODE:</strong></td>
        <td colspan="3">
<select name="mnu_crs_code" class="fieldsize" id="mnu_crs_code"  tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="0">SELECT COURSE</option>
        </select></td>
      </tr>
      <tr>
        <td colspan="2"><strong>MEDIUM:</strong></td>
        <td colspan="3"><select name="mnu_medium" class="fieldsize" id="mnu_medium" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
     <option value="0">SELECT MEDIUM</option>        </select></td>
      </tr>
      <tr>
        <td colspan="2"><strong>LOT NO:</strong></td><%!String current_session=null; %>
        <td colspan="3">
<input name="text_lot" list="lot_values" type="text" placeholder="Enter LOT Number" class="fieldsize" id="text_lot"  tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" required/></td>
					<datalist id="lot_values">
						<%
						try
							{	 rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
									while(rs.next())
									current_session=rs.getString(1);
		
							rs=statement.executeQuery("select distinct lot from student_"+current_session+"_"+rc_code+" order by lot asc");
							while(rs.next())
							{%>
							  <option value="<%= rs.getString(1) %>">
							<% }
							}catch(Exception e){out.println("connection error"+e);}%>
                            </datalist>

      </tr>
      <tr>
        <td colspan="2"><strong>RANGE:</strong></td>
        <td width="147"><label>
          <input name="text_start" type="text" class="fieldsize" placeholder="Starting Range of Selection" id="text_start" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" required/>
        </label></td>
        <td width="19"><strong>TO</strong></td>
        <td width="127"><label>
<input name="text_end" type="text" class="fieldsize" placeholder="Ending Range of Selection" id="text_end" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" required/>
        </label></td>
      </tr>
      <input type="hidden" name="first_timer" value="YES" />
      <tr>
        <td colspan="2"><div align="center">
          <input name="clear" type="reset" id="CLEAR FIELDS" tabindex="<%= tab+2 %>" value="Reset" class="button"/>
        </div></td>
        <td colspan="3"><div align="center">
          <input type="submit" value="SEARCH" tabindex="<%= ++tab %>"  class="button" />
        </div></td>
      </tr>
    </table>
    </form>
    <h2>&nbsp;</h2>
  </div>

  <div id="sidebar">
  				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>

  <div id="nav-supp">
    </div>
    <h3>Bulk Entry means</h3>
        <p>Bulk Entry by Post means selecting students on the basis of lot and medium crieteria and despatch the materials to them in a bulk to save time of manual entry for each student.</p>
    <p>&nbsp;</p>
    <a href="${pageContext.request.contextPath}/jsp/By_post_bulk_pg1.jsp" title="Click for Despatch Program Guide in Bulk"><h1><img src="imgs/pg.jpg" alt="Click for Program Guide" width="160" height="190" /></h1></a>

  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>


</div>
<script type="text/javascript">
function fillCategory(){ 
						<%int i=1;
						try
							{rs=statement.executeQuery("select prg_code from program");
							while(rs.next())
							{%>
							addOption(document.frm_post_bulk.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
						<% i++;
							}
							}
						catch(Exception e)
							{out.println("connection error"+e);}
							String str[]=new String[i-1];
							%>
						<%try
							{
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
							addOption(document.frm_post_bulk.mnu_prg_code, "ALL", "ALL", "");
}//end of method fillcategory()

function SelectSubCat(){
// ON selection of category this function will work
						removeAllOptions(document.frm_post_bulk.mnu_crs_code);
						addOption(document.frm_post_bulk.mnu_crs_code, "0", "SELECT COURSE", "");
						<%try
							{ResultSet rs_course;
							for(int k=1;k<=str.length;k++)
							{
						%>
							if(document.frm_post_bulk.mnu_prg_code.value == "<%=str[k-1]%>")
							{<% rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");
							int l=1;
							while(rs_course.next())
							{khushi=rs_course.getString(1);%>
							addOption(document.frm_post_bulk.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
						<% l++;	}%>
							}//end of if
						<% }%>
	
							if(document.frm_post_bulk.mnu_prg_code.value=="ALL")
							{
						<% rs_course=statement_empty.executeQuery("select crs_code from course");
							int l=1;
							while(rs_course.next())
							{khushi=rs_course.getString(1);%>
							addOption(document.frm_post_bulk.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
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
function SelectSubMedium()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_post_bulk.mnu_medium);
								addOption(document.frm_post_bulk.mnu_medium, "0", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_post_bulk.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<%
							rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									//select medium from program_medium where prg_code='"+str[k-1]+"'");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_post_bulk.mnu_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% 
									l++;	
								}
								%>
								}//end of if
								<% }%>
								if(document.frm_post_bulk.mnu_prg_code.value=="ALL")
								{
								<%
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_post_bulk.mnu_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}
								%>
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method
</script>

</body>
</html>
<%
}
%>