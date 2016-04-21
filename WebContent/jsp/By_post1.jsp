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
<title>Despatch-By Post</title>
            <%String[] course			=	(String[])request.getAttribute("course");%>
            <%int[] blocks				=	(int[])request.getAttribute("blocks");%>
            <%int[] blocks_shadow		=	(int[])request.getAttribute("blocks_shadow");%>            
            
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/By_post.jsp" title="BY POST SINGLE" accesskey="O">				P<U>o</U>st Single Entry		</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/By_post_bulk1.jsp" title="BY POST BULK" accesskey="S">								Po<U>s</U>t Bulk Entry			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_office.jsp" title="SC OFFICE USE" accesskey="C">								S<U>C</U> Office Use			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_sc_students.jsp" title="SC STUDENTS" accesskey="F">								SC <U>F</U>or Students			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/To_rc.jsp" title="REGIONAL CENTRES" accesskey="L">									Regiona<U>l</U> Centres			</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Complementary.jsp" title="COMPLEMENTARY COPIES" accesskey="Y">						Complementar<U>y</U>			</a></li>
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_by_post1" action="${pageContext.request.contextPath}/BYPOSTSUBMIT" onSubmit="return validateForm();" method="post">
  <table width="464" border="0" cellspacing="0" >
      <tr><%! int tab=0; %>
      <td height="38" colspan="2"><strong>Enrolment Number:</strong></td>
      <td colspan="3"><strong><label>
 <input name="text_enr" type="text" id="text_enr" value="<%=request.getParameter("enrno")%>" readonly="true" class="greysize" /></label></strong></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Name Of the Student:</strong></td>
        <td colspan="3">
<input name="text_name" type="text" id="text_name" value="<%=request.getParameter("name")%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Session:</strong></td>
        <td colspan="3"><% String current_session=(String)request.getAttribute("current_session");%>
          <input name="text_session" type="text" id="text_session" value="<%=current_session.toUpperCase()%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Programme Code:</strong></td>
        <td colspan="3">
<input name="text_prog_code" type="text" id="text_prog_code" value="<%=request.getParameter("prog")%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Year/Semester:</strong></td>
        <td colspan="3">
<input name="text_year" type="text" id="text_year" value="<%=request.getParameter("year")%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
      <input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td colspan="2"><strong>Medium:</strong></td>
        <td colspan="3">
      						<%String medium_display=null;
							try
							{rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>        
<input name="text_medium_display" type="text" id="text_medium_display" value="<%= medium_display%>" readonly="true" class="greysize" /> </td>
      </tr></table><hr /><hr />
        <table width="464" border="0" cellspacing="0" >
      <tr>
      <td width="53" height="24"><div align="right"><strong>Blocks:</strong></div></td>
      <td width="147"><div align="right"><strong>Available Stock:</strong></div></td>
      <td width="111"><div align="center"><strong>Serial Number:</strong></div></td>
      <td colspan="2"><div align="center"><strong>Despatch Date:</strong></div></td>
      </tr>
      <tr>
      <td height="24" colspan="2">
<div id="layer1" style="position:absolute; width:463px; height:331px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;">
 <strong> 

            <%String[] course_block		=	(String[])request.getAttribute("course_block");%>
            <%String[] serial_number	=	(String[])request.getAttribute("serial_number");%>
            <%String[] dispatch			=	(String[])request.getAttribute("dispatch");%>
            <%String[] dispatch_date	=	(String[])request.getAttribute("dispatch_date");%>
            <%int[] stock				=	(int[])request.getAttribute("stock");%>            
            <%int index=0,flag=-1,count=0;%>
<table class="table" border="0" cellspacing="0">
				<%
				for(int i=0;i<course.length;i++) { 
                %>
                <input type="hidden" name="crs_code" value="<%=course[i]%>" />
                <tr bgcolor="#CCCCCC">
                    <td colspan="4"><input type="checkbox" name="checkit" value="<%= course[i]%>" onclick="selection(this)"/><%= course[i]%></td>
                </tr>

                <%
				for(int k = 1; k <= blocks[i]; k++) {
					if(dispatch.length != 0) {
						for(int j = 0; j < dispatch.length; j++) {
//							System.out.println(course_block[count]+"A "+dispatch[j]+"B");
							if(course_block[count].trim().equals(dispatch[j].trim())) {
                                flag = j;
                            }
//							System.out.println("flag="+flag);
						}
					if(flag<0) {
                %>
                <tr>
                    <td width="112" align="center"><input type="checkbox" name="<%= course[i] %>" value="<%= course_block[count]%>" /><%= "B"+k%></td>
                    <td width="84"><%= stock[count]%></td>
                    <td width="125" align="center"><%= serial_number[i]%></td>
                    <td width="111" align="center">--/--/----</td>
                </tr>
				<%
					}
					if(flag>=0) {
				%>
                <tr bgcolor="#99CCFF" bordercolor="#99CCFF" style="padding:0">
                    <td class="bright" width="112" align="center">
                        <input type="checkbox" name="crs_disabled" disabled="disabled" checked="checked" value="<%= course_block[count]%>" /><%="B" + k%>
                    </td>
                    <td class="bright" width="84"><%= stock[count]%></td>
                    <td class="bright" width="125" align="center"><%=serial_number[i]%></td>
                    <td class="bright" width="111" align="center"><%= dispatch_date[flag] %></td>
                </tr>
				<%	
					}//end of if(flag>=0)
					count++;
					flag=-1;
				}
				if(dispatch.length==0) {
			  	%>
                <tr>
                    <td width="112" align="center"><input type="checkbox" name="<%= course[i] %>"  value="<%= course_block[count]%>"/><%="B"+k%></td>
                    <td width="84"><%= stock[count]%></td>
                    <td width="125" align="center"><%= serial_number[i]%></td>
                    <td width="111" align="center">--/--/----</td>
                </tr>
				<%count++;	
				}					
				}
				}
				%>
            </table>
            </strong> </div></td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2"><div align="center"><strong>
          <input name="btn2" align="middle" type="button" onclick="CheckAll()" value="Check All" tabindex="<%= ++tab %>" />
        </strong></div></td>
        <td colspan="3"><div align="center">
          <input name="btn" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" tabindex="<%= ++tab %>" />
        </div></td>
      </tr>
      <tr>
       <%String pg_flag =null,pg_date=null;
	  int pg_stock=Integer.parseInt(request.getParameter("available_pg"));	   
		int pg_disabled=0;
		pg_flag=(String)request.getAttribute("pg_flag");
		pg_date=(String)request.getAttribute("pg_date"); %>
      <td height="38"><div align="right">
            <input type="hidden" name="pg_flag" value="<%=pg_flag%>" />
<input type="checkbox" name="program_guide" id="program_guide" value="<%=request.getParameter("prog")%>" tabindex="<%= ++tab %>" <% if(pg_flag.equals("YES") || pg_stock<1){pg_disabled=1;%> checked="checked" disabled="disabled"<%}%>/>
        </div></td>
      <td height="38"><strong>Programme Guide</strong></td>
      <td><strong>Available Sets:</strong></td>
      <td width="49"><%=request.getParameter("available_pg")%></td>
      <td width="94"><% if(pg_flag.equals("YES")){%>   <%= pg_date %>    <%}else{%>  <%= pg_date %>     <%}%></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Date:</strong></td>
        <td colspan="3">
<input name="text_date" type="text" id="datepicker" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Click to Select Date" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Packet Type:</strong></td>
        <td colspan="3">
<input name="text_pkt_type" type="text" id="text_pkt_type" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Enter the Type Of Packet" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Packet Weight:</strong></td>
        <td colspan="3">
<input name="text_pkt_wt" type="text" id="text_pkt_wt" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Enter the Weight of Packet" required/>
<strong>(In Grams)</strong></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Challan Number:</strong></td>
        <td colspan="3">
<input name="text_chln_no" type="text" id="text_chln_no" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Enter the Challan Number" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Express Parcel Number:</strong></td>
        <td colspan="3"><label>
<input type="text" name="text_express_number" id="text_express_number" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)" onchange="upper(this)" placeholder="Enter Express Parcel Number"/>
        </label></td>
      </tr>
      <tr>
        <td colspan="2"><strong>Remarks:</strong></td>
        <td colspan="3">
<input name="text_remarks" type="text" readonly="true" id="text_remarks" value="BY POST" class="greysize" ></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <strong>
          <input name="reset" type="reset" id="reset" class="button" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" />
          </strong></div></td>
        <td colspan="3"><div align="center">
          <input name="enter" type="submit" class="button" id="enter" value="DESPATCH" tabindex="<%= ++tab %>" onclick="submitting();" />
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
<h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS HOME</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Despatch.jsp">DESPATCH HOME</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Receive.jsp">RECEIVE HOME</a></li>
        <li><a href="#">REPORTS</a></li>
        <li><a href="#">ENQUIRY</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/Update_parcel_no.jsp">Update Parcel</a></li>        
      </ul>
    </div>
    <h3>ABOUT POST SINGLE ENTRY SYSTEM.....</h3>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
	    <link rel="stylesheet"    href="js/jquery-ui.css"    type="text/css" media="all"/>
    	<script src="js/jquery.min.js" type="text/javascript"></script>
    	<script src="js/jquery-ui.min.js" type="text/javascript"></script>
        <script> $(function() { $( "#datepicker" ).datepicker(); });	</script>
<script type="text/javascript">
function validateForm()
{
<% if (pg_disabled==1){%>
var check = 0;
<%for (int v=0;v<course.length;v++)
{if(blocks[v]!=blocks_shadow[v])
		{%>
		var blk = document.frm_by_post1.<%=course[v]%>.length;
		for(w=0;w<blk;w++)
		{
			if(document.frm_by_post1.<%=course[v]%>[w].checked == 1)
			check = 1;
		}
<%}}%>
if(check==0)
{
	alert("Please Select Course/Blocks to be Despatched...");
	return false;
}
<%}
else{%>
if (document.frm_by_post1.program_guide.checked == 0)
var check = 0;
<%for (int v=0;v<course.length;v++)
{if(blocks[v]!=blocks_shadow[v])
		{%>
		var blk = document.frm_by_post1.<%=course[v]%>.length;
		for(w=0;w<blk;w++)
		{
			if(document.frm_by_post1.<%=course[v]%>[w].checked == 1)
			check = 1;
		}
<%}}%>
if(check==0)
{
	alert("Please Select Course/Blocks to be despatched...");
	return false;
}
<%}%>

var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var date			=	document.frm_by_post1.text_date.value;
var packet_type		=	document.frm_by_post1.text_pkt_type.value;
var packet_weight	=	document.frm_by_post1.text_pkt_wt.value;
var challan_no		=	document.frm_by_post1.text_chln_no.value;
var check = 0;

if(date=="")
{
	alert("Please Select Date...");
	document.frm_by_post1.text_date.focus();
	return false;
}
else
{
	var passedDate = new Date(date);
	var currentDate= new Date();
	  if (passedDate > currentDate ) 
	  {
			alert("Please Enter Current Date or Less than Current date");
			document.frm_by_post1.text_date.focus();
		   return false;
	  }
}//end of else

if(packet_type==0 || packet_type=="")
{
	alert("Please Enter Packet Type");
	document.frm_by_post1.text_pkt_type.focus();
	return false;
}
if(packet_weight==0 || packet_weight=="" || packet_weight.match(letters))
{
	alert("Please Enter Weight of Packet in Grams Only...");
	document.frm_by_post1.text_pkt_wt.focus();
	return false;
}
if(challan_no==0 || challan_no=="" || challan_no.match(letters))
{
	alert("Please Enter Challan Number in Numbers Only...");
	document.frm_by_post1.text_chln_no.focus();
	return false;
}
}//end of mehtod validateForm
</script>
<script>
function CheckAll()
{

		var crs = document.getElementsByName('checkit');
		for (c=0;c<crs.length;c++)
		{
			crs[c].checked = 1;
		}
		<% for (int i=0;i<course.length;i++)
		{if(blocks[i]!=blocks_shadow[i])
		{%>
		var count= document.frm_by_post1.<%=course[i]%>.length;
	//	alert(count);
		
		if(typeof count == 'undefined')
				{
					document.frm_by_post1.<%=course[i]%>.checked=1;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_by_post1.<%=course[i]%>[j].checked = 1;
					}
				}
	
		<%}}%>
}//end of method CheckAll
function UncheckAll()
{
		var crs = document.getElementsByName('checkit');
		for (c=0;c<crs.length;c++)
		{
			crs[c].checked = 0;
		}
		<% for (int i=0;i<course.length;i++)
		{if(blocks[i]!=blocks_shadow[i])
		{
		%>
		var count = document.frm_by_post1.<%=course[i]%>.length;
		if(typeof count == 'undefined')
				{
					document.frm_by_post1.<%=course[i]%>.checked=0;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_by_post1.<%=course[i]%>[j].checked = 0;
					}
				}
		<%}}%>
}//end of method UncheckAll
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


function submitting()
{
				var express_parcel_number		=	document.frm_by_post1.text_express_number.value;
				if(express_parcel_number=="")
				{
					document.frm_by_post1.text_express_number.value="NA";
				}
}
</script>
</html>
<%
}
%>