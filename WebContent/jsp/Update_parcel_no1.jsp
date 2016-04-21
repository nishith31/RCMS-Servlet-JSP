<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
	String msg="Please Login to Access MDU";
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
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" />
<meta name="robots" content="index,follow" /><%! String roll="Enter Enrolment No"; %>
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
<title>Parcel Number Updation</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js" ></script>
</head>
<%Connection connection=null;
Statement statement=null,statement_empty=null;
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
<div id="container">  <div id="banner"><script type="text/javascript" src="js/general.js"></script>
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
        <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Update_parcel_no.jsp">Parcel Number</a></li>
   <li><a href="${pageContext.request.contextPath}/jsp/Student_Update.jsp" >Student Details</a></li>
  <li><a href="${pageContext.request.contextPath}/jsp/Lot_Update.jsp" >LOT Name</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_update_parcel1" action="${pageContext.request.contextPath}/PARCELUPDATESUBMIT" method="post" onsubmit="return validateForm()">
    <table width="469" border="0">
      <tr height="30"><%! int tab=0; %>
        <td colspan="2"><strong>Enrolment Number:</strong></td>
        <td colspan="2">
<input name="text_enr" type="text" id="text_enr" class="greysize" value="<%=request.getParameter("enrno")%>" maxlength="9" readonly="true" /> </td>         </tr>
      <tr height="30">
        <td colspan="2"><strong>Name:</strong></td>
        <td colspan="2">
<input name="text_name" type="text" class="greysize" id="text_name" value="<%=request.getParameter("name")%>" readonly="true" /></td>          </tr>
      <tr height="30">
        <td colspan="2"><strong>Program:</strong></td>
<td colspan="2">
<input name="text_prog_code" type="text" class="greysize" id="text_prog_code" value="<%=request.getParameter("prog")%>" readonly="true"/>  </td> </tr>
      <tr height="30">
        <td colspan="2"><strong>Year/Semester:</strong></td>
        <td colspan="2">
 <input name="text_year" class="greysize" type="text" id="text_year" value="<%=request.getParameter("year")%>" readonly="true" />   </td>   </tr>
      <tr height="30">
        <td colspan="2"><strong>Session:</strong></td>
        <td colspan="2"><% String current_session=(String)request.getAttribute("current_session");%>
<input name="text_session" type="text" class="greysize" id="text_session" value="<%=current_session.toUpperCase()%>" readonly="true" />    </td> </tr>

      <tr height="30"><input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td colspan="2"><strong>Medium:</strong></td>
        <td colspan="2"><label></label>       
      						<%String medium_display=null;
							try
							{ResultSet rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>        
                       					<%String course_dispatch[]		=	new String[0];%>    
<input name="text_medium_display" type="text" class="greysize" id="text_medium_display" value="<%=medium_display.toUpperCase()%>" readonly="true" /> </td></tr>
      <tr height="30">
        <td colspan="2"><strong>Enter Parcel Number:</strong></td>
        <td colspan="2">
<input type="text" name="text_parcel_number" id="text_parcel_number" input placeholder="Enter Express Parcel Number" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required/>  </td>    </tr>
      <tr height="30">
        <td width="91"><strong>Blocks:</strong></td>
        <td width="104"><strong>Despatch Date:</strong></td>
        <td width="114"><strong>Challan Number:</strong></td>
        <td width="142"><strong>Parcel Number: </strong></td>     
      </tr>
            <%  String pg_flag=(String)request.getAttribute("pg_flag");%>
	<input type="hidden" name="pg_flag"	  value="<%=pg_flag%>" />

	 <% if(pg_flag=="YES"){
	  String pg_date=(String)request.getAttribute("pg_date");
	  String pg_parcel_number=(String)request.getAttribute("pg_parcel_number");	  
	  String pg_challan_number=(String)request.getAttribute("pg_challan_number");	  
	  String pg_packet_type=(String)request.getAttribute("pg_packet_type");	  
	  String pg_medium=(String)request.getAttribute("pg_madhyam");	  	  
	  %>
            <tr height="30">
        <td width="91"><input type="checkbox" name="pg_checkbox" value="<%= request.getParameter("prg_code") %>" /><strong>PG</strong></td>
        <td width="104"><strong><%= pg_date %></strong></td><input type="hidden" name="pg_date" value="<%= pg_date%>" />
        <td width="114"><div align="center"><strong><%= pg_challan_number%></strong></div></td>
        <td width="142"><strong><%= pg_parcel_number%></strong></td><input type="hidden" name="pg_express" value="<%= pg_parcel_number%>" />
      </tr>        <input type="hidden" name="pg_medium" value="<%= pg_medium%>" />
<%}  %>
            <%  String course_flag=(String)request.getAttribute("course_flag");%>
	<input type="hidden" name="course_flag"	  value="<%=course_flag%>" />            
	 <% if(course_flag=="YES"){ %>
              <tr height="30">
        <td colspan="2">
<div id="layer1" style="position:absolute; width:470px; height:354px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300; left: 298px; top: 480px;"><strong>
<table border="0">
								<%course_dispatch		=	(String[])request.getAttribute("course_dispatch");%>
                                <%String course_block[]			=	(String[])request.getAttribute("course_block");%>
								<%String date_dispatch[]		=	(String[])request.getAttribute("date_dispatch");%>
                                <%String medium[]				=	(String[])request.getAttribute("medium");%>
								<%String challan_number[]		=	(String[])request.getAttribute("challan_number");%>
								<%String parcel_number[]		=	(String[])request.getAttribute("parcel_number");%>
                                <% int index=0; int len=0; int count=0; %>
<% request.setAttribute("course_dispatch",course_dispatch);%><%request.setAttribute("date_dispatch",date_dispatch);%><%request.setAttribute("challan_number",challan_number);%>

                                <%
								for(int i=0;i<course_dispatch.length;i++)
								{ 
									len=course_dispatch[i].length();%>
                <input type="hidden" name="crs_code" value="<%=course_dispatch[i]%>" />
 <tr bgcolor="#CCCCCC" style="width:470px;">
	<td colspan="5"><input type="checkbox" name="checkit" value="<%= course_dispatch[i]%>" onclick="selection(this)"/><%= course_dispatch[i]%></td>
                    </tr>
                    
								<%for(index=0;index<course_block.length;index++)	
								{%>
								<input type="hidden" name="<%= course_block[index] %>" value="<%=parcel_number[index]%>" />
                                <input type="hidden" name="<%= course_block[index]+"D" %>" value="<%=date_dispatch[index]%>" />
                                <input type="hidden" name="<%= course_block[index]+"M" %>" value="<%=medium[index]%>" />
                                <%String course_check=course_block[index].substring(0,len);
								String block_check=course_block[index].substring(len);
								String initial=block_check.substring(0,1);
								if(course_dispatch[i].equals(course_check))
								{
									if(initial.equals("B"))
									{%>
<tr height="30">
<td width="100">	<input type="checkbox" name="<%=course_dispatch[i]%>" value="<%= course_block[index] %>" />				<%= block_check %>			</td>
<td width="100">																									<%= date_dispatch[count] %>				</td>
<td width="120">																								<%= challan_number[count] %>			</td>
<td width="100">																								<%= parcel_number[count] %>			</td>

</tr>
								<%count++;}}}}%>
</table>
</strong></div></td>
        <td colspan="2">      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">      </tr>
    <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">      </tr>
    <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">      </tr>
    <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">
        <label></label>      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2"><div align="center">
          <input name="btn" align="middle" type="button" onclick="CheckAll()" value="Check All" tabindex="<%= ++tab %>"  />
        </div></td>
        <td colspan="2"><div align="center">
          <input name="btn2" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" tabindex="<%= ++tab %>" />
        </div></td>
      </tr>
      <tr height="30"><input type="hidden" name="checking" value="YES" />
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr><% } else{%><input type="hidden" name="checking" value="NO" /><%}%>
      <tr >
 
        <td colspan="2"><div align="center">
          <strong>
          <input type="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" class="button"/>
          </strong></div></td>
        <td colspan="2"><div align="center">
          <input type="submit" value="UPDATE" tabindex="<%= ++tab %>" class="button"/>
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

                <h3>About Despatch Section of RCMS-MDU</h3>
    <p>Update Parcel Number page Update the Latest and Associated parcel number with the despatch of Materials via Post and whenever infromation regarding parcel number is Required it displays it in the Required Format.</p>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

<!--
   End of footer type info
-->

</div>
</body>
<script type="text/javascript" src="js/general.js"></script>
<script>
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;

var parcel_number=document.frm_update_parcel1.text_parcel_number.value;
if (parcel_number==null || parcel_number=="" )
  {
  alert("Please Enter Parcel Number...");
  document.frm_update_parcel1.text_parcel_number.focus();
  return false;
  }
  var flag=document.frm_update_parcel1.checking.value;
	var check = 0;
	if(flag=="YES")
	{
		<%for (int v=0;v<course_dispatch.length;v++)
			{%>
			var blk = document.frm_update_parcel1.<%=course_dispatch[v]%>.length;
			for(w=0;w<blk;w++)
			{
				if(document.frm_update_parcel1.<%=course_dispatch[v]%>[w].checked == 1)
				check = 1;
			}
		<%}%>
		}
		else
		{
				if(document.frm_update_parcel1.pg_checkbox.checked == 1)
				check=1;
		}
	if(check==0)
	{
		alert("Please Select Course/Blocks to be Despatched...");
		return false;
	}
}
</script>
<script> 
function selection(obj)
{
	var str = obj.value;
	if(obj.checked == 1)
	{
		var x = document.getElementsByName(str);
		for(i=0;i<x.length;i++)
		{
			x[i].checked = 1;
		}	
	}
	if(obj.checked == 0)
	{
		var x = document.getElementsByName(str);
		for(i=0;i<x.length;i++)
		{
			x[i].checked = 0;
		}	
	}
}
function CheckAll()
{

		var crs = document.getElementsByName('checkit');
		for (c=0;c<crs.length;c++)
		{
			crs[c].checked = 1;
		}
		<% for (int i=0;i<course_dispatch.length;i++)
		{
				%>
		var count= document.frm_update_parcel1.<%=course_dispatch[i]%>.length;

		
		if(typeof count == 'undefined')
				{
					document.frm_update_parcel1.<%=course_dispatch[i]%>.checked=1;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_update_parcel1.<%=course_dispatch[i]%>[j].checked = 1;
					}
				}
	
		<%}%>
}//end of method CheckAll
function UncheckAll()
{
		var crs = document.getElementsByName('checkit');
		for (c=0;c<crs.length;c++)
		{
			crs[c].checked = 0;
		}
		<% for (int i=0;i<course_dispatch.length;i++)
		{
		%>
		var count = document.frm_update_parcel1.<%=course_dispatch[i]%>.length;
		if(typeof count == 'undefined')
				{
					document.frm_update_parcel1.<%=course_dispatch[i]%>.checked=0;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_update_parcel1.<%=course_dispatch[i]%>[j].checked = 0;
					}
				}
		<%}%>
}//end of method uncheckAll
</script>

</html>
<%
}
%>