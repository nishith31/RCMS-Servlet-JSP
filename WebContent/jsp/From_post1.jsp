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
<title>Post Return</title>
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
//				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
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
      <li><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">								From <U>O</U>thers				</a></li>
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">		Post Retur<U>n</U>				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
  <form name="frm_post_receipt" action="${pageContext.request.contextPath}/POSTRETURNSUBMIT" onsubmit="return validateForm()" method="post">
    <table width="470" border="0">
      <tr height="30"><%! int tab=0; %>
        <td colspan="2"><strong>Name:</strong></td>
        <td width="27">&nbsp;</td>
        <td width="37">&nbsp;</td>
        <td colspan="2">
<input type="text" name="text_name" id="text_name" value="<%= request.getParameter("name") %>" class="greysize" readonly="readonly"/></td>
        <td>&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2"><strong>Enrolment Number:</strong></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2">
<input type="text" name="text_enr" id="text_enr" value="<%= request.getParameter("enrno") %>" class="greysize" readonly="readonly"/></td>
        <td>&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2"><strong>Programme Code:</strong></td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td colspan="2">
 <input type="text" name="text_prg_code" id="text_prg_code" value="<%= request.getParameter("prg_code") %>" class="greysize" readonly="readonly"/></td>
        <td>&nbsp;</td>
      </tr>
      <tr height="30">
        <td  colspan="2"><strong>Session:</strong></td>
        <td>&nbsp;</td>
        <td><% String current_session=(String)request.getAttribute("current_session"); %></td>
        <td colspan="2">
 <input name="txt_session" type="text" value="<%= current_session.toUpperCase() %>" id="txt_session" class="greysize" readonly="readonly"/></td>
        <td>&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="2"><strong>Medium:</strong></td>
        <td>&nbsp;</td>
        <input type="hidden" name="text_medium" value="<%=request.getParameter("medium")%>" />
        <td>&nbsp;</td>
              						<%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+request.getParameter("medium")+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>

        <td colspan="2">
<input type="text" name="text_medium_display" id="text_medium_display" value="<%=medium_display%>" class="greysize" readonly="readonly"/></td>
        <td>&nbsp;</td>

								<%String course_dispatch[]		=	new String[0];%>     </tr>
      <tr height="30">
        <td><div align="right"><strong>Blocks:</strong></div></td>
        <td><div align="right"><strong>Packet</strong></div></td>
        <td><strong>:</strong></td>
        <td><strong>Parcel</strong></td>
        <td width="43"><strong>No:</strong></td>
        <td><strong>Challan No:</strong></td>
        <td><strong>Despatch Date:</strong></td>
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
      <tr>
        <td width="67"><input type="checkbox" name="pg_checkbox" value="<%= request.getParameter("prg_code") %>" /><strong>PG</strong></td>
        <td width="69"><strong><%= pg_packet_type %></strong></td>
        <td colspan="3"><strong><%= pg_parcel_number%></strong></td><input type="hidden" name="pg_express" value="<%= pg_parcel_number%>" />
        <td width="95"><strong><%= pg_challan_number%></strong></td>
        <td width="102"><strong><%= pg_date %></strong></td><input type="hidden" name="pg_date" value="<%= pg_date%>" />
        <input type="hidden" name="pg_medium" value="<%= pg_medium%>" />
      </tr><%}  %>
            <%  String course_flag=(String)request.getAttribute("course_flag");%>
	<input type="hidden" name="course_flag"	  value="<%=course_flag%>" />            
	 <% if(course_flag=="YES"){ %>
            
      <tr>
        <td height="24" colspan="4">
<div id="layer1" style="position:absolute; width:470px; height:386px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;"><strong>
<table border="0">
								<%course_dispatch		=	(String[])request.getAttribute("course_dispatch");%>
                                <%String course_block[]			=	(String[])request.getAttribute("course_block");%>
								<%String date_dispatch[]		=	(String[])request.getAttribute("date_dispatch");%>
                                <%String medium[]				=	(String[])request.getAttribute("medium");%>
								<%String challan_number[]		=	(String[])request.getAttribute("challan_number");%>
								<%String packet_type[]			=	(String[])request.getAttribute("packet_type");%>
								<%String parcel_number[]		=	(String[])request.getAttribute("parcel_number");%>
                                <% int index=0; int len=0; int count=0; %>
<% request.setAttribute("course_dispatch",course_dispatch);%><%request.setAttribute("date_dispatch",date_dispatch);%><%request.setAttribute("challan_number",challan_number);%>
<% request.setAttribute("packet_type",packet_type); %>                                
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
<tr>
<td width="120">	<input type="checkbox" name="<%=course_dispatch[i]%>" value="<%= course_block[index] %>" />				<%= block_check %>			</td>
<td width="70">																									<%= packet_type[count] %>				</td>
<td width="120">																								<%= parcel_number[count] %>			</td>
<td width="100">																								<%= challan_number[count] %>			</td>
<td width="110" align="left">																					<%= date_dispatch[count] %>				</td>
</tr>
								<%count++;}}}}%>
</table>
</strong></div></td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="24" colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="35" colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="35" colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="35" colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr>
        <td height="35" colspan="4">&nbsp;</td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr height="30">
        <td colspan="4"><div align="center">
          <input name="btn" align="middle" type="button" onclick="CheckAll()" value="Check All" tabindex="<%= ++tab %>"  />
        </div></td>
        <td colspan="3"><div align="center">
          <input name="btn2" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" tabindex="<%= ++tab %>" />
        </div></td>
      </tr><% } %>
      <tr>
        <td colspan="4"><strong>Date:</strong></td>
        <td colspan="3">
<input name="txt_date" type="text" class="fieldsize" id="datepicker" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="CLICK TO SELECT DATE" required/></td>
      </tr>
      <tr height="30">
        <td colspan="4"><strong>Reason Of Return:</strong></td>
        <td colspan="3">
        <select name="txt_reason" id="txt_reason" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" class="fieldsize">
        <option value="ADDRESS NOT FOUND">ADDRESS NOT FOUND</option>
        <option value="WRONG ADDRESS">WRONG ADDRESS</option>
        <option value="NO RESPONSE">NO RESPONSE</option>
        <option value="ADDRESS CHANGED">ADDRESS CHANGED</option>
        </select>        </td>
      </tr>
      <tr>
        <td height="64" colspan="4"><div align="center">
          <strong>
          <input name="reset" type="reset" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" class="button" onclick="document.frm_post_receipt.mnu_prg_code.focus();" />
          </strong></div></td>
        <td colspan="3"><div align="center">
          <input name="enter" class="button" type="submit" id="enter" value="RECEIVE" tabindex="<%= ++tab %>" />
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
      </ul>
    </div>
    <h3>&nbsp;</h3>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</body>
<link rel="stylesheet"  href="${pageContext.request.contextPath}/js/jquery-ui.css"    type="text/css" media="all"/>
<script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
<script>        $(function() {            $( "#datepicker" ).datepicker();  });</script>
<script>
function validateForm()
{
	var check = 0;
	 <% if(course_flag=="YES"){ %>
	<%for (int v=0;v<course_dispatch.length;v++)
		{%>
		var blk = document.frm_post_receipt.<%=course_dispatch[v]%>.length;
		for(w=0;w<blk;w++)
		{
			if(document.frm_post_receipt.<%=course_dispatch[v]%>[w].checked == 1)
			check = 1;
		}
	<%}%>
	if(check==0)
	{
		alert("Please Select Course/Blocks to be despatched...");
		return false;
	}
	<%}%>
	var date=document.frm_post_receipt.txt_date.value;
					
	if(date=="")
	{
		alert("Please Select Date...");
		document.frm_post_receipt.txt_date.focus();
		return false;
	}
	else
	{
		var passedDate = new Date(date);
		var currentDate= new Date();
	  	if (passedDate > currentDate ) 
	  	{
		 	alert("Please Enter Current Date or Less than Current date");
			document.frm_post_receipt.txt_date.focus()
		   	return false;
	  	}
	}//end of else
}
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
		var count= document.frm_post_receipt.<%=course_dispatch[i]%>.length;

		
		if(typeof count == 'undefined')
				{
					document.frm_post_receipt.<%=course_dispatch[i]%>.checked=1;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_post_receipt.<%=course_dispatch[i]%>[j].checked = 1;
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
		var count = document.frm_post_receipt.<%=course_dispatch[i]%>.length;
		if(typeof count == 'undefined')
				{
					document.frm_post_receipt.<%=course_dispatch[i]%>.checked=0;
				}
				else
			    {
					for (j=0; j < count; j++) 
					{
    					document.frm_post_receipt.<%=course_dispatch[i]%>[j].checked = 0;
					}
				}
		<%}%>
}//end of method uncheckAll

</script>


</html>
<%
}
%>