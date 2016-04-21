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
<title>Despatch-By Post(PG)</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" /></head>
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

<body  onload="checked();total();">
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
      <li><a href="${pageContext.request.contextPath}/jsp/Home.jsp" title="HOME" accesskey="H" >							<%=home_menu.trim()%>		</a></li>
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
                          <%int[] dispatch_index	=	(int[])request.getAttribute("dispatch_index");%>
                          <%String[] student		=	(String[])request.getAttribute("student");%>                          
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_by_post_bulk_pg2" action="${pageContext.request.contextPath}/BYPOSTBULK_PG_SUBMIT" <%if(dispatch_index.length<student.length){%> onSubmit="return validateForm();"<%}%> method="post">

<div align="center"><strong>    <hr /><hr />DESPATCH OF PROGRAMME GUIDE<hr /><hr /></strong></div>
    <table width="464" height="825" border="0">

        <tr><%! int tab=0; %>
        <td width="144"><strong>Programme Code:</strong></td>
        <td>
<input name="mnu_prg_code" type="text" id="mnu_prg_code" value="<%=request.getParameter("prg_code")%>" readonly="true" class="greysize" /></td>
        <td>&nbsp;</td>
        </tr>
        <tr>
          <td><strong>Course Code:</strong></td>
          <td><input name="mnu_crs_code" type="text" id="mnu_crs_code" value="<%=request.getParameter("crs_code")%>" readonly="readonly" class="greysize"/></td>
          <td><div align="center"><strong>Available Quantity</strong></div></td>
        </tr>
        <tr>
        <td><strong>Session:</strong></td>
        <td><% String current_session=(String)request.getAttribute("current_session");%>
          <input name="text_session" type="text" id="text_session" value="<%=current_session.toUpperCase()%>" readonly="true" class="greysize" /></td>
        <td><div align="center"><strong>Of Programme Guide</strong></div></td>
      </tr>
      <tr>
        <td><strong>Medium</strong></td>
        <td><%String medium_display=null;
							try
							{rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>
<input name="text_medium_display" type="text" id="text_medium_display" value="<%=medium_display%>" readonly="true" class="greysize" /></td>
        <td><div align="center"><strong>
          <%int show=(Integer)request.getAttribute("available_qty"); %>
          <%= show %>
        </strong></div></td>
      </tr>
      <tr>
        <td><strong>Lot Number:</strong></td>
        <td colspan="2">
 <input name="text_lot" type="text" id="text_lot" value="<%=request.getParameter("lot")%>" readonly="true" class="greysize" /></td>
      </tr>
      <tr>
      <input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td><strong>Quantity</strong></td>
        <td colspan="2"><input name="text_qty" type="text" id="text_qty"  readonly="true" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)"/></td>
      </tr>
      <tr>
        <td><strong>Already Despatched:</strong></td>
        <td colspan="2">
 <input type="text" name="text_dispatched" id="text_dispatched" class="greysize"  value="<%=dispatch_index.length%>"/></td>
      </tr>
      
      <tr>
        <td><strong>Enrolment No:</strong></td>
        <td width="151"><div align="center"><strong>Name:</strong></div></td>
        <td width="155"><div align="center"><strong>Serial Number:</strong></div></td>
      </tr>
      <tr>
        <td>
<div id="layer1" style="position:absolute; width:458px; height:272px; overflow:auto;  layer-background-color: #FFFFFF; border: 10px #993300;">
                 <strong> <table border="0" cellspacing="0">


                          <%String[] name			=	(String[])request.getAttribute("name");%>
                          <%String[] serial_number	=	(String[])request.getAttribute("serial_number");%>

                          <%int start				=	(Integer)request.getAttribute("start");%>
                          <%int end					=	(Integer)request.getAttribute("end");%>
<% 
int length=Integer.parseInt(request.getParameter("length"));
int flag=0;%>					
<%System.out.println("length of student: "+student.length+" length of name: "+name.length+" length of serial_number: "+serial_number.length+"length of dispatch is: "+dispatch_index.length);%>

   <%

		if(dispatch_index.length!=0)
		{ 
   			for(int i = 0; i <start-1; i++)
   			{
  				if(i!=dispatch_index[flag])
  	{%>
   <tr>
   <td width="200">
   <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" align="middle"  value="<%=student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="110"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%}//end of if
			  else
	{%>
	<tr bgcolor="#FFCCFF" bordercolor="#99CCFF" style="padding:0">
	<td width="200">
       <input type="hidden" name="all_enr" value="<%=student[i]%>" />
    <input type="checkbox" name="enrno_dispatched" align="middle" checked="true" value="<%= student[i]%>" disabled="disabled"/><%= student[i]%></td>
    <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
    <td width="110"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%
				if(flag<dispatch_index.length-1)
				flag++;
				}//end of else
	}//end of for loop i=0 to start-1
	%>
   <%for(int i = start-1; i<end; i++)
   {
	   if(i!=dispatch_index[flag])
	{%>
   <tr>
   <td width="200">
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" checked="true" align="middle"  value="<%= student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="100"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%
	  }//end of if
	  else
	{%>
	<tr bgcolor="#FFCCFF" bordercolor="#99CCFF" style="padding:0">
	<td width="200">
       <input type="hidden" name="all_enr" value="<%=student[i]%>" />
    <input type="checkbox" name="enrno_dispatched" align="middle" checked="true" value="<%= student[i]%>" disabled="disabled"/><%= student[i]%></td>
	<td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
    <td width="110"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%
			if(flag<dispatch_index.length-1)
			   flag++;
	 }//end of else
	 }//end of for loop of i=start to end
	for(int i =end; i<length; i++)
	{
		   if(i!=dispatch_index[flag])
	{%>
   <tr>
   <td width="200">
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" align="middle"  value="<%= student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="100"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%
	  }//end of if
	  else
	{%>
	<tr bgcolor="#FFCCFF" bordercolor="#99CCFF" style="padding:0" >
	<td width="200">
       <input type="hidden" name="all_enr" value="<%=student[i]%>" />
    <input type="checkbox" name="enrno_dispatched" align="middle" checked="true" value="<%= student[i]%>" disabled="disabled"/><%= student[i]%></td>
	<td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
    <td width="110"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr>
	<%
			if(flag<dispatch_index.length-1)
			   flag++;
	 }//end of else
	}//end of for loop end to length		   
}//end of main if(dispatch_index.length<0)
else
{//if dispatch is null then this logic will work
 %>              
    <%for(int i = 0; i <start-1; i++)
	{%>
   <tr>
   <td width="200">
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" align="middle"  value="<%= student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="110"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr><% }%>
   <%for(int i =start-1; i <end; i++){%>
   <tr >
   <td width="200">
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" align="middle" checked="true"  value="<%= student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="100"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr><%}%>               
   <%for(int i=end; i <length; i++){%>
   <tr >
   <td width="200">
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
   <input type="checkbox" name="enrno" align="middle" value="<%= student[i]%>" onchange="disp()"/><%= student[i]%></td>
   <td width="250"><input type="hidden" name="name" value="<%= name[i]%>" /><%= name[i]%></td>
   <td width="100"><input type="hidden" name="serial" value="<%= serial_number[i]%>" /><%= serial_number[i]%></td>
               </tr><%}%>               

 <%}//end of else main
 %>              
</table></strong></div></td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
                          <input type="hidden" name="text_start" value="<%= start %>" />
                          <input type="hidden" name="text_end" value="<%= end %>" />
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td><div align="center">
          <input name="btn" align="middle" type="button" onclick="CheckAll()" value="Check All" tabindex="<%= ++tab %>" />
        </div></td>
        <td colspan="2"><div align="center">
          <input name="btn2" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" tabindex="<%= ++tab %>" />
        </div></td>
      </tr>
      <tr>
        <td><strong>Date:</strong></td>
<td colspan="2">
  <input type="text" name="text_date" id="datepicker" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" placeholder="Click to Select Date" onmouseout="mout(this)" onchange="upper(this)"/></td>
      </tr>
      <tr>
        <td><strong>Packet Type:</strong></td>
        <td colspan="2">
<input name="text_pkt_type" type="text" id="text_pkt_type" tabindex="<%= ++tab %>"  class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)" placeholder="Enter the Packet Type" onchange="upper(this)"/></td>
      </tr>
      <tr>
        <td><strong>Packet Weight:</strong></td>
        <td colspan="2">
<input name="text_pkt_wt" type="text" id="text_pkt_wt" tabindex="<%= ++tab %>"  class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Enter the Packet Weight"/>
          <strong>(In Grams)</strong></td>
      </tr>
      <tr>
        <td><strong>Challan Number:</strong></td>
        <td colspan="2">
<input name="text_chln_no" type="text" id="text_chln_no" tabindex="<%= ++tab %>" class="fieldsize" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="Enter the Challan Number"/></td>
      </tr>
      <tr>
        <td><strong>Remarks:</strong></td>
        <td colspan="2">
<input name="text_remarks" type="text" id="text_remarks" value="BY POST" readonly="true" class="greysize" /></td>
      </tr>
      <tr> 
        <td height="58"><div align="center">
          <strong>
          <input name="enter" type="reset" id="enter" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" class="button" />
          </strong></div></td>
          <% String flag_value=null;
		  if(dispatch_index.length<student.length){ flag_value="yes";%>      
  <td colspan="2"><div align="center">
<input name="enter" type="submit" id="enter" value="DESPATCH" tabindex="<%= ++tab %>"  class="button"/>
        </div></td>
        <%}else{%>
  <td colspan="2"><div align="center">
<input name="enter" type="submit" id="enter" value="BACK" tabindex="<%= ++tab %>"  class="button"/>
        </div></td>
        <%}%>        
        <input type="hidden" name="flag_for_button" value="<%=flag_value%>" />
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
				out.println(msg); %></h3></div>
				<p><strong>Total Students:&nbsp;<%= student.length %></strong></p>
				<p><strong>Available Stock:&nbsp;<%= show %></strong> </p>
	<p>&nbsp;</p>
    <div id="nav-supp"></div>
    <h3>&nbsp;</h3>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</body>

		    <link rel="stylesheet"    href="js/jquery-ui.css"    type="text/css" media="all"/>
		    <script src="js/jquery.min.js" type="text/javascript"></script>
		    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
    	    <script>   $(function() {   $( "#datepicker" ).datepicker();	});	</script>
    		<script type="text/javascript">
function disp()//method for displaying the number of checked checkboxes for the students called onchange event of the checkbox
{
					length=0;
					count = document.frm_by_post_bulk_pg2.enrno.length;
	    			for (i=0; i < count; i++) 
					{
		    			if(document.frm_by_post_bulk_pg2.enrno[i].checked == 1)
						length++;    
					}
				document.frm_by_post_bulk_pg2.text_qty.value=length;
}
function total()
{
					con=0;
					con= document.frm_by_post_bulk_pg2.enrno_dispatched.length;
					if(typeof con=='undefined')
					{
						document.frm_by_post_bulk_pg2.text_dispatched.value=1;
					}
					if(con>0)
					{alert(con+' students have been already dispatched');
					document.frm_by_post_bulk_pg2.text_dispatched.value=con;}
}
function checked()
{
					length=0;
					count = document.frm_by_post_bulk_pg2.enrno.length;
				    for (i=0; i < count; i++) 
					{
					    if(document.frm_by_post_bulk_pg2.enrno[i].checked == 1)
						length++;    
					}

			document.frm_by_post_bulk_pg2.text_qty.value=length;
}	</script>
<script type="text/javascript">
function validateForm()//Method for validating form fields before submitting
{

	
var date=document.frm_by_post_bulk_pg2.text_date.value;
var packet_type=document.frm_by_post_bulk_pg2.text_pkt_type.value;
var packet_weight=document.frm_by_post_bulk_pg2.text_pkt_wt.value;
var challan_no=document.frm_by_post_bulk_pg2.text_chln_no.value;
var flag_for=document.frm_by_post_bulk_pg2.flag_for_button.value;

//if(flag_for.equals("yes"))

if(date=="0" || date=="")
{
	alert("Please Enter Date..");
	document.frm_by_post_bulk_pg2.text_date.value="";
	document.frm_by_post_bulk_pg2.text_date.focus();
	return false;
	
}
else
{
	var passedDate = new Date(date);
	var currentDate= new Date();
	  if (passedDate > currentDate ) 
	  {
		   alert("Please Enter Current Date or Less than Current date");
			document.frm_by_post_bulk_pg2.text_date.focus();
		   return false;
	  }
}//end of else

if(packet_type=="0" || packet_type=="")
{
	alert("Please Enter Packet Type for the Material");
	document.frm_by_post_bulk_pg2.text_pkt_type.value="";
	document.frm_by_post_bulk_pg2.text_pkt_type.focus();
	return false;	
}
if(packet_weight=="" || packet_weight=="0")
{
	alert("Please Enter the Weight of the packet in Grams ...");
	document.frm_by_post_bulk_pg2.text_pkt_wt.value="";
	document.frm_by_post_bulk_pg2.text_pkt_wt.focus();
	return false;
}
if(challan_no==0 || challan_no=="" || challan_no.match(letters))
{
	alert("Please Enter Challan Number in Numbers Only...");
	document.frm_by_post_bulk_pg2.text_chln_no.value="";
	document.frm_by_post_bulk_pg2.text_chln_no.focus();
	return false;
}
//}//end of if(flag_for_button.equals("yes"))

}//end of method validateForm
</script>
<script> 
function CheckAll()
{
				count = document.frm_by_post_bulk_pg2.enrno.length;
				//alert(count);
				if(typeof count=='undefined')
				{
					document.frm_by_post_bulk_pg2.enrno.checked=1;
					document.frm_by_post_bulk_pg2.text_qty.value="1";
				}
				else
			    {
					for (i=0; i < count; i++) 
					{
    					if(document.frm_by_post_bulk_pg2.enrno[i].checked == 0)
    					{document.frm_by_post_bulk_pg2.enrno[i].checked = 1; }
    					else {document.frm_by_post_bulk_pg2.enrno[i].checked = 1;}
					}
					document.frm_by_post_bulk_pg2.text_qty.value=count;
				}
}
function UncheckAll()
{
				count = document.frm_by_post_bulk_pg2.enrno.length;
								//alert(count);
					document.frm_by_post_bulk_pg2.text_qty.value="0";								
    			if(typeof count=='undefined')
				{
					document.frm_by_post_bulk_pg2.enrno.checked=0;
				}
				else
			    {
					for (i=0; i < count; i++) 
					{
    					if(document.frm_by_post_bulk_pg2.enrno[i].checked == 1)
    					{document.frm_by_post_bulk_pg2.enrno[i].checked = 0; }
    					else {document.frm_by_post_bulk_pg2.enrno[i].checked = 0;}
					}
				}
}
</script>
</html>
<%
}
%>