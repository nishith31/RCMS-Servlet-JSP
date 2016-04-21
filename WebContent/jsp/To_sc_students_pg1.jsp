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
<title>Despatch-SC Students(PG)</title>
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
     <li><a href="${pageContext.request.contextPath}/jsp/" title="UPDATE" accesskey="U">							<%= update_menu %>			</a></li>
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
<form name="frm_sc2" action="${pageContext.request.contextPath}/BYSCSTUDENT_PG_SUBMIT" onsubmit="return validateForm()" method="post" >
  <div align="center"><strong>    <hr /><hr /><U>DESPATCH OF PROGRAMME GUIDE TO STUDY CENTRE</U><hr /><hr /></strong></div>
    <table width="460" border="0">
      <tr height="32"><%! int tab=0; %>
      
        <td colspan="2"><strong>Study Centre Code:</strong></td>
        <td><input name="txt_sc_code" type="text" value="<%=request.getParameter("sc_code")%>" class="greysize" readonly="true" id="txt_sc_code" /></td>
        <td><div align="center"><strong>Available Quantity:</strong></div></td>
      </tr>
      <tr height="32">
        <td colspan="2"><strong>Programme Code:</strong></td>
        <td><input name="txt_prog_code" type="text" value="<%=request.getParameter("prg_code")%>" class="greysize" readonly="true" id="txt_prog_code" /></td>
        <td><div align="center">
          <div align="center"><strong>Of Program Guide</strong></div>
        </div></td>
      </tr>
      <tr height="32">
        <td colspan="2"><strong>Course Code:</strong></td>
        <td><input name="txt_crs_code" type="text" id="txt_crs_code" class="greysize" value="<%=request.getParameter("crs_code")%>" readonly="true"/></td>
        <td><div align="center"><strong>
          <%int show=(Integer)request.getAttribute("available_qty"); %> <%= show %></strong></div></td>
      </tr>
      <tr height="32">
        <td colspan="2"><strong>Session:</strong></td>
        <td colspan="2"><% String current_session=(String)request.getAttribute("current_session");%>
        <input name="txt_session" type="text" id="txt_session" class="greysize" value="<%=current_session.toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr height="32">
        <td colspan="2"><strong>Year/Semester:</strong></td>
    <td colspan="2"><input name="txt_year" type="text" id="txt_year" class="greysize" value="<%=request.getParameter("year")%>" readonly="true" /></td>
      </tr>
      <tr height="32"><input type="hidden" name="txt_medium" value="<%=request.getParameter("medium")%>" />
        <td colspan="2"><strong>Medium:</strong></td>
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
      <tr height="32">
        <td colspan="2"><strong>Number of Sets:</strong></td>
        <td colspan="2">
        <input name="txt_no_of_set" type="text" id="txt_no_of_set" class="fieldsize" value="<%=request.getParameter("sets")%>" readonly="true" /></td>
      </tr>
      <tr height="32">
        <td width="135"><strong>Enrolment NO:</strong></td>
        <td width="37"><div align="right"><strong>Name:</strong></div></td>
        <td width="142"><div align="right"><strong>Despatch Date:</strong></div></td>
        <td width="128"><div align="right"><strong>Despatch Mode:</strong></div></td>
      </tr>
      <tr height="32">
        <td  colspan="2">
<div id="layer1" style="position:absolute; width:460px; height:240px; overflow:auto;  layer-background-color: #FFFFFF; border: 10px #993300;">
						<%String[] student				=	(String[])request.getAttribute("student");					%>
			      	    <%String[] name					=	(String[])request.getAttribute("name");						%>                        
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
	<tr bgcolor="#FFCCFF" bordercolor="#99CCFF" style="padding:0" height="32">
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=dispatch_student[i]%>" />
<input type="checkbox" name="enrno_dispatched" align="middle" disabled="disabled" checked="checked" value="<%=dispatch_student[i]%>" /><%=dispatch_student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= dispatch_name[i]%>" /><strong><%=dispatch_name[i] %></strong></td>
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
<tr height="32">
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
<input type="checkbox" name="enrno" align="middle" checked="checked" value="<%=student[i]%>" onchange="disp()"/><%=student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= name[i]%>" /><strong><%=name[i]%></strong></td>
<td width="120" align="center">--/--/----</td>
<td width="90" align="center">XXXXXXXX</td>
</tr>
								<%	
									}//end fo if index==0					
								}//end of if(dispatch.length!=0 and index<dispatch.length)
			  					else
			  					{	
			  					%>
<tr height="32">
<td width="110"><strong>
      <input type="hidden" name="all_enr" value="<%=student[i]%>" />
<input type="checkbox" name="enrno" align="middle" checked="checked" value="<%=student[i]%>" onchange="disp()"/><%=student[i] %></strong></td>
<td width="140"><input type="hidden" name="name" value="<%= name[i]%>" /><strong><%=name[i]%></strong></td>
<td width="120" align="center">--/--/----</td>
<td width="90" align="center">XXXXXXXX</td>
</tr>
								<%						
								}//end of else
								}//end of for loop
								%>
</table> </div></td>
        <td  colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td height="231" colspan="4">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="btn" align="middle" type="button" onclick="CheckAll()" value="Check All" tabindex="<%= ++tab %>"/>
        </div></td>
        <td colspan="2"><div align="center">
          <input name="btn2" align="middle" type="button" onclick="UncheckAll()" value="Uncheck All" tabindex="<%= ++tab %>"/>
        </div></td>
      </tr>
      <tr height="32">
        <td  colspan="2"><strong>Date:</strong></td>
        <td colspan="2">
 <input name="txt_date" type="text" id="datepicker" class="fieldsize" tabindex="<%= ++tab %>" /></td>
      </tr>
      <tr>
         <td height="45" colspan="2"><div align="center">
          <input name="enter" type="reset" id="enter" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" class="button" />
        </div></td><%if(dispatch_student.length<student.length){%>      
        <td colspan="2"><div align="center"> <strong>               
          <input name="enter" type="submit" id="enter" value="DESPATCH" tabindex="<%= ++tab %>" class="button"/>          
        </strong></div></td><%}else{%>
                <td colspan="2"><div align="center"> <strong>               
          <input name="enter" type="submit" id="enter" value="BACK" tabindex="<%= ++tab %>" class="button"/>          
        </strong></div></td>
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
                <p><strong>Total Students:&nbsp;<%=student.length%></strong></p>
                <p><strong>Stock:&nbsp;<%= show%></strong> </p>
                <h3>&nbsp;</h3>
  </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
    <link rel="stylesheet"
    href="${pageContext.request.contextPath}/js/jquery-ui.css"
    type="text/css" media="all"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
   
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