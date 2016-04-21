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
<title>Material_Dispatch</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! String roll="Enter Roll NO...."; %>
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
<div id="container">  <div id="banner">
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
      <li>						<a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H" >						<%=home_menu.trim()%></a>			</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="${pageContext.request.contextPath}/jsp/Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>						<a href="${pageContext.request.contextPath}/jsp/Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li class="current">		<a href="${pageContext.request.contextPath}/jsp/Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="${pageContext.request.contextPath}/jsp/Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Material_despatch.jsp">Material Despatch</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Material_receipt.jsp">Material Receipt</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>                     
      </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="${pageContext.request.contextPath}/frm_material_despatch" action="MATERIALDESPATCH" onsubmit="return validateForm();submit_value()">
    <table width="469" border="0">
      <tr><%! int tab=0; %>
        <td height="51">Select Program:</td>
        <td colspan="3"><label>
<select name="mnu_prg_code" id="mnu_prg_code" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  
onchange="SelectSubCat();SelectSubMedium();upper(this)" autofocus>
          <option value="0">SELECT PROGRAMME</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td height="51">Select Course:</td>
        <td colspan="3"><label>
          <select name="mnu_crs_code" id="mnu_crs_code" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="0">SELECT COURSE</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td height="51">Medium:</td>
        <td colspan="3"><label>
          <select name="mnu_medium" id="mnu_medium" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="0">SELECT MEDIUM</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td height="51"><input type="radio" name="radio" id="radio" value="date" 
		onclick="document.getElementsByName('text_date')[0].removeAttribute('disabled');selection();" />
Date wise</td>
        <td colspan="3"><label>
 <input type="text" name="text_date" class="datepicker" disabled="disabled" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" onchange="upper(this)" placeholder="Click to Select Date"/>
        </label></td>
      </tr>
      <tr>
        <td height="51"><label>
        <input type="radio" name="radio" id="radio" value="month" 
		onclick="document.getElementById('mnu_month').removeAttribute('disabled');selection();" />
Month wise</label></td>
        <td colspan="3"><label>
          <select name="mnu_month" id="mnu_month" disabled="disabled" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="1">JANUARY</option>
          <option value="2">FEBRUARY</option>
          <option value="3">MARCH</option>
          <option value="4">APRIL</option>
          <option value="5">MAY</option>
          <option value="6">JUNE</option>
          <option value="7">JULY</option>
          <option value="8">AUGUST</option>
          <option value="9">SEPTEMBER</option>
          <option value="10">OCTOBER</option>
          <option value="11">NOVEMBER</option>
          <option value="12">DECEMBER</option>
          </select>
        </label></td>
      </tr>
      <tr>
        <td width="123" height="51"><label>
<input type="radio" name="radio" id="radio" value="dates" onclick="document.getElementsByName('text_date1')[0].removeAttribute('disabled');document.getElementsByName('text_date2')[0].removeAttribute('disabled');selection();" />
          Between</label></td>
        <td width="144">
<input type="text" name="text_date1" class="datepicker" disabled="disabled" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Select Starting Date"/>        </td>
        <td width="31"><div align="center">TO</div></td>
        <td width="153"><label>
<input type="text" name="text_date2" class="datepicker" disabled="disabled" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Select Ending Date"/>
        </label></td>
      </tr>
      <tr>
        <td height="66"><label>
          <label></label>
          <div align="center">
            <input type="reset" name="clear" id="clear" value="RESET" onclick="document.frm_by_hand.txt_enr.focus();" tabindex="<%=tab+2%>" class="button" />
          </div>
          </label></td>
          <input type="hidden" name="flag" id="flag"/>
        <td colspan="3"><label></label>
          <div align="center">
            <input name="submit" type="submit" id="submit" tabindex="<%=++tab%>" value="Generate Report" class="button" />
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
    	<div id="nav-supp">
        <h3><p>Quick Access to </p></h3>
      <ul>
        <li><a href="Home.jsp">RCMS HOME</a></li>
        <li><a href="Enquiry.jsp">ENQUIRY HOME</a></li>
      </ul>
    </div>
  </div>
  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
<script>
function validateForm()
{
}
</script>
<link rel="stylesheet"
    href="js/jquery-ui.css"
    type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
   
    <script>
        $(function() {
            $( "input.datepicker" ).datepicker();
        });
	</script>
<script type="text/javascript">
function fillCategory(){ 
<%int i=1;
	try{
		rs=statement.executeQuery("select prg_code from program");
		while(rs.next())
		{
%>
		addOption(document.frm_material_despatch.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
<% 		i++;
		}//end of while loop
		}//end of try blocks
	catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
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
		}//end of while loop
		}//end of try blocks	
catch(Exception e)
{out.println("connection error"+e);}
String khushi;
%>

}//end of method fillcategory()

function SelectSubMedium(){
// ON selection of program this function will work
				removeAllOptions(document.frm_material_despatch.mnu_medium);
				addOption(document.frm_material_despatch.mnu_medium,"0", "SELECT MEDIUM", "");
				<%try{
					ResultSet rs_course;
					for(int k=1;k<=str.length;k++)
					{
				%>
					if(document.frm_material_despatch.mnu_prg_code.value == "<%=str[k-1]%>")
					{<% rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
					int l=1;
					while(rs_course.next())
					{khushi=rs_course.getString(1);%>
					addOption(document.frm_material_despatch.mnu_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
					<% l++;	}%>
					}//end of if
				<% }%>
				if(document.frm_material_despatch.mnu_prg_code.value=="ALL")
				{
				<% rs_course=statement_empty.executeQuery("select * from medium");
				int l=1;
				while(rs_course.next())
				{khushi=rs_course.getString(1);%>
				addOption(document.frm_material_despatch.mnu_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
				<% l++;	}%>
				}//end of if all
				<%}	
				catch(Exception e)
				{out.println("connection error"+e);}%>

}//end of method

function SelectSubCat(){
					removeAllOptions(document.frm_material_despatch.mnu_crs_code);
					addOption(document.frm_material_despatch.mnu_crs_code, "0", "SELECT COURSE", "");
					<%try
						{
						ResultSet rs_course;
						for(int k=1;k<=str.length;k++)
						{rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");%>
						if(document.frm_material_despatch.mnu_prg_code.value == "<%=str[k-1]%>")
						{<% 
						int l=1;
						while(rs_course.next())
						{khushi=rs_course.getString(1);%>
						addOption(document.frm_material_despatch.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
						<% l++;	}%>
						}//end of if
					<% }%>
					if(document.frm_material_despatch.mnu_prg_code.value=="ALL")
					{
					<% rs_course=statement_empty.executeQuery("select crs_code from course");
						int l=1;
						while(rs_course.next())
						{khushi=rs_course.getString(1);%>
						addOption(document.frm_material_despatch.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
						<% l++;	}%>		
					}//end of if all
					<%}	
					catch(Exception e){out.println("connection error"+e);}%>
}//end of method
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

function mover(obj)
{document.frm_by_hand.txt_enr.className="zoomsize";}
function mout(obj)
{document.frm_by_hand.txt_enr.className="fieldsize";}

function selection()
{
var val=$("input:radio[name='radio']:checked").val();
	if(val=="date")
	{document.frm_material_despatch.flag.value="date";
		document.frm_material_despatch.mnu_month.disabled=true;
		document.frm_material_despatch.text_date1.disabled=true;
		document.frm_material_despatch.text_date2.disabled=true;		
	}
	if(val=="month")
	{document.frm_material_despatch.flag.value="month";
		document.frm_material_despatch.text_date.disabled=true;
		document.frm_material_despatch.text_date1.disabled=true;
		document.frm_material_despatch.text_date2.disabled=true;		
	}
	if(val=="dates")
	{document.frm_material_despatch.flag.value="dates";
		document.frm_material_despatch.text_date.disabled=true;
		document.frm_material_despatch.mnu_month.disabled=true;		
	}
}//end of function selection()

</script>
<script type="text/javascript" src="js/general.js"></script>
</body>
</html>
<%
}
%>