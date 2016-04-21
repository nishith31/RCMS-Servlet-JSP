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
String first_timer=(String)request.getAttribute("first_timer");
System.out.println("first_timer received: "+first_timer);
int number_of_blocks=(Integer)request.getAttribute("number_of_blocks");
System.out.println("number of blocks received: "+number_of_blocks);

%>
    <% int initial_block=0;
	if(first_timer.equals("YES")){initial_block=number_of_blocks+1;}
	else
	{initial_block=(Integer)request.getAttribute("initial_block");
	System.out.println("initial blocks received: "+initial_block);
	} %>
   <% int block_number = initial_block-number_of_blocks; %><% System.out.println("block number received from jsp: "+block_number); %>

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
<title>Despatch-SC Students&nbsp;<%= block_number %>/<%= initial_block-1 %></title>
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
<body>
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
<form name="frm_sc2" action="${pageContext.request.contextPath}/BYSCSTUDENTSUBMIT" method="post" onsubmit="return validateForm()" >
    <table width="460"  border="0">
      <tr><%! int tab=0; %>
      
          <input type="hidden" name="initial_block" value="<%= initial_block %>" />
    <input type="hidden" name="number_of_blocks" value="<%= number_of_blocks %>" />

        <td colspan="2"><strong>STUDY CENTRE:</strong></td>
        <td><input name="txt_sc_code" type="text" value="<%=request.getParameter("sc_code")%>" class="greysize" readonly="readonly" id="txt_sc_code" /></td>
        <td><div align="center"><strong>Available Quantity:</strong></div></td>
      </tr>
      <tr>
        <td height="34" colspan="2"><strong>PROGRAMME CODE:</strong></td>
        <td><input name="txt_prog_code" type="text" value="<%=request.getParameter("prg_code")%>" class="greysize" readonly="readonly" id="txt_prog_code" /></td>
        <td><div align="center">
          <div align="center"><strong>Of BLOCK <%=block_number%></strong></div>
        </div></td>
      </tr>
      <tr>
        <td height="33" colspan="2"><strong>COURSE CODE:</strong></td>
        <td><input name="txt_crs_code" type="text" id="txt_crs_code" class="greysize" value="<%=request.getParameter("crs_code")%>" readonly="true"/></td>
        <td><div align="center"><strong><%int show=(Integer)request.getAttribute("available_qty"); %><%=show%></strong></div></td>
      </tr>
      <tr>
        <td height="31" colspan="2"><strong>BLOCK:</strong></td>
        <td colspan="2">
        <input type="hidden" name="block_name" value="<%= "B"+ block_number%>" />
        <input name="txt_crs_code2" type="text" id="txt_crs_code2" class="greysize" value="<%= "BLOCK"+ block_number%>" readonly="true"/></td>
      </tr>
      <tr>
        <td height="31" colspan="2"><strong>SESSION:</strong></td>
        <td colspan="2"><% String current_session=(String)request.getAttribute("current_session");%>
        <input name="txt_session" type="text" id="txt_session" class="greysize" value="<%=current_session.toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="30" colspan="2"><strong>YEAR/SEMESTER:</strong></td>
        <td colspan="2"><input name="txt_year" type="text" id="txt_year" class="greysize" value="<%=request.getParameter("year")%>" readonly="true" /></td>
      </tr>
      <tr><input type="hidden" name="txt_medium" value="<%=request.getParameter("medium")%>" />
        <td height="33" colspan="2"><strong>MEDIUM:</strong></td>
        <td colspan="2">
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
     <input name="txt_medium_display" type="text" id="txt_medium_display"  class="greysize" value="<%=medium_display.toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr>
        <td height="35" colspan="2"><strong>NUMBER OF SETS:</strong></td>
        <td colspan="2">
        <input name="txt_no_of_set" type="text" id="txt_no_of_set" class="fieldsize" value="<%=request.getParameter("sets")%>" readonly="true" /></td>
      </tr>
      <tr>
        <td width="135"><strong>Enrolment NO:</strong></td>
        <td width="37"><div align="right"><strong>NAME:</strong></div></td>
        <td width="142"><div align="right"><strong>DESPATCH DATE:</strong></div></td>
        <td width="128"><div align="right"><strong>DESPATCH MODE:</strong></div></td>
      </tr>
      <tr>
        <td height="27" colspan="2">
<div id="layer1" style="position:absolute; width:460px; height:240px; overflow:auto;  layer-background-color: #FFFFFF; border: 10px #993300;">
						<%String[] student				=	(String[])request.getAttribute("student");					%>
			      	    <%String[] name					=	(String[])request.getAttribute("name");						%>                        
                        <%String[] hidden_course		=	(String[])request.getAttribute("hidden_course");%>                                                  
						<%String[] dispatch_student		=	(String[])request.getAttribute("dispatch_student");			%>
						<%String[] dispatch_date		=	(String[])request.getAttribute("dispatch_date");			%>
						<%String[] dispatch_mode		=	(String[])request.getAttribute("dispatch_mode");			%>
						<%String[] dispatch_name		=	(String[])request.getAttribute("dispatch_name");			%>
						<%int index=0;
						System.out.println("Total students from jsp is: "+student.length);
						System.out.println("Total Despatched from jsp is: "+dispatch_student.length);

								System.out.println("student,name,Despatch student,Despatch date received from jsp");%>
<table border="0" cellspacing="0">
								<%if(dispatch_student.length!=0)
								{
								 for(int i=0;i<dispatch_student.length;i++)
								{
								%>
	<tr bgcolor="#FFCCFF" bordercolor="#99CCFF" style="padding:0">
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=dispatch_student[i]%>" />
<input type="checkbox" name="enrno_dispatched" align="middle" disabled="disabled" checked="checked" value="<%=dispatch_student[i]%>" /><%=dispatch_student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= dispatch_name[i]%>" /><%=dispatch_name[i] %></td><input type="hidden" name="hide_course" value="<%= hidden_course[i]%>" />
<td width="120" align="center"><%=dispatch_date[i] %></td>
<td width="90" align="center"><%=dispatch_mode[i]%></td>
</tr>
								<% } //end of for loop
									}//end of if
								%>
								<%for( int i = 0; i < student.length;i++ )
								{
									index=0;
			  					if(dispatch_student.length!=0)
			  					{
									for(int k=0;k<dispatch_student.length;k++)
									{
								  		if(student[i].equals(dispatch_student[k]))
								  		{
											index=1;
			  							}//end of if
									}//end of for loop
									if(index==0)
									{
								%>
<tr>
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
<input type="checkbox" name="enrno" align="middle" checked="checked" value="<%=student[i]%>" onchange="disp()"/><%=student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= name[i]%>" /><%=name[i] %></td><input type="hidden" name="hide_course" value="<%= hidden_course[i]%>" />
<td width="120" align="center">--/--/----</td>
<td width="90" align="center">XXXXXXXX</td>
</tr>
								<%	
									}//end fo if index==0					
								}//end of if(dispatch.length!=0 and index<dispatch.length)
			  					else
			  					{	
			  					%>
<tr>
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
<input type="checkbox" name="enrno" align="middle" checked="checked" value="<%=student[i]%>" onchange="disp()"/><%=student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= name[i]%>" /><%=name[i] %></td><input type="hidden" name="hide_course" value="<%= hidden_course[i]%>" />
<td width="120" align="center">--/--/----</td>
<td width="90" align="center">XXXXXXXX</td>
</tr>
								<%						
								}//end of else
								}//end of for loop
								%>
</table> </div></td>
        <td height="27" colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="231" colspan="4">&nbsp;</td>
                <input type="hidden" name="first_timer" value="NO" />
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="btn" align="middle" type="button" onclick="CheckAll()" value="Check All" <% if(first_timer.equals("YES")){ %> tabindex="<%= ++tab %>" <%}%>/>
        </div></td>
        <td colspan="2"><div align="center">
          <input name="btn2" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" <% if(first_timer.equals("YES")){ %> tabindex="<%= ++tab %>" <%}%>/>
        </div></td>
      </tr>
      <tr>
        <td height="41" colspan="2"><strong>DATE:</strong></td>
        <% String date_value=null;
if(first_timer.equals("NO")){ date_value=(String)request.getAttribute("date");} else{date_value="";}%>
        <td colspan="2">
 <input name="txt_date" type="text" id="datepicker" class="fieldsize" <% if(first_timer.equals("YES")){ %> tabindex="<%= ++tab %>"<%}%> value="<%= date_value %>" /></td>
      </tr><% 
  			String value=null;
  			if(number_of_blocks>1)
  			{
				 value="NEXT BLOCK"; 
			} 
		  else
		  {
		    value="FINISH";
		}%>
      <tr>
       <%if(dispatch_student.length<student.length){%>
      
        <td height="45" colspan="2"><div align="center">
          <input name="enter" type="submit" id="enter" value="SKIP" tabindex="<%= tab+2 %>" class="button" />
        </div></td>
        <td colspan="2"><div align="center"> <strong>
               

          <input name="enter" type="submit" id="enter" value="<%= value %>" tabindex="<%= ++tab %>" class="button"/>
          
        </strong></div></td>
        <%}
		else{%>
                <td height="45" colspan="4"><div align="center">  <input name="enter" type="submit" id="enter" value="SKIP" tabindex="<%=++tab%>" class="button" /></div></td>
        <%}%>
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
                <p><strong>Total Blocks:<%= initial_block-1 %></strong></p>
                <p><strong>Block to be Despatch:<%= block_number %></strong> </p>
                <p><strong>STEP NO:<%= block_number %>/<%= initial_block-1 %></strong></p>
                <h3>&nbsp;</h3>
  </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
    <link rel="stylesheet"
    href="js/jquery-ui.css"
    type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
   
    <script>        $(function() {
            $( "#datepicker" ).datepicker();
    frm_sc2    });
	</script>
<script> 
function CheckAll()
{
				count = document.frm_sc2.enrno.length;
				if(typeof count=='undefined')
				{
					document.frm_sc2.enrno.checked=1;
					document.frm_sc2.txt_no_of_set.value="1";					
				}
				else
			    {
					for (i=0; i < count; i++) 
					{
    					if(document.frm_sc2.enrno[i].checked == 0)
    					{document.frm_sc2.enrno[i].checked = 1; }
    					else {document.frm_sc2.enrno[i].checked = 1;}
					}
					document.frm_sc2.txt_no_of_set.value=count;					
				}
}
function UncheckAll()
{
				count = document.frm_sc2.enrno.length;
								//alert(count);
					document.frm_sc2.txt_no_of_set.value="0";													
    			if(typeof count=='undefined')
				{
					document.frm_sc2.enrno.checked=0;
				}
				else
			    {
					for (i=0; i < count; i++) 
					{
    					if(document.frm_sc2.enrno[i].checked == 1)
    					{document.frm_sc2.enrno[i].checked = 0; }
    					else {document.frm_sc2.enrno[i].checked = 0;}
					}
				}
}//end of uncheckAll method
function disp()//method for displaying the number of checked checkboxes for the students called onchange event of the checkbox
{
					length=0;
					count = document.frm_sc2.enrno.length;
	    			for (i=0; i < count; i++) 
					{
		    			if(document.frm_sc2.enrno[i].checked == 1)
						length++;    
					}
				document.frm_sc2.txt_no_of_set.value=length;
}

</script>
<script>
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
var date=document.frm_sc2.txt_date.value;
		/*		var total_box = document.frm_sc2.enrno.length;
				if(typeof total_box=='undefined')
				{
					if(document.frm_sc2.enrno.checked)
					var nishi='genius';
					else
					{alert("Please Select At least One Student");
					return false;}
				}
				else
				{var checked_course=0;
			    for (i=0; i < total_box; i++) 
				{
    				if(document.frm_sc2.enrno[i].checked == 1)
    				{ checked_course++;}
    			
				}
	if(checked_course==0)
	{
		alert("Please Select At least One Student");
		return false;
	}
	}*/
if (date==null || date=="" || date.match(letters))
{
	  alert("Please Select Date.....");
	  document.frm_sc2.txt_date.value="";
	  document.frm_sc2.txt_date.focus();
		  return false;
}
else
{
	var passedDate = new Date(date);
	var currentDate= new Date();
	  if (passedDate > currentDate ) 
	  {
			alert("Please Enter Current Date or Less than Current date");
			document.frm_sc2.txt_date.focus();
		   return false;
	  }
}//end of else

  
  }//end of method
</script>
</html>
<%
}
%>