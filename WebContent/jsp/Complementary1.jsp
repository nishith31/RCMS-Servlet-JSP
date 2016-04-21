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
          <%String[] course			=	(String[])request.getAttribute("courses");%>

<title>Despatch-Complementary</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script>
function validateForm()
{
var check = 0;
		<%for (int v=0;v<course.length;v++)
		{%>
			var blk = document.frm_complementary.<%=course[v]%>.length;
			for(w=0;w<blk;w++)
			{
				if(document.frm_complementary.<%=course[v]%>[w].checked == 1)
				check = 1;
			}
		<%}%>
		if(check==0)
		{
			alert("Please Select Blocks to be despatched...");
			return false;
		}	

		//logic for number of blocks to be auto-filled 0 if left unfilled by user 
		var flag = 0;
		<%for(int i=0;i<course.length;i++)
		{%>
		var no_of_set = document.getElementById('textid<%=i%>').value;
		if(no_of_set == "" || no_of_set == 0 || no_of_set < 0)
		{
			document.getElementById('textid<%=i%>').value=0;
		}
		else
		flag = 1;
		<%}%>
		if(flag == 0)
		{
			alert('Please Enter Number Of Sets To Be Despatched For The Course...');
			return false;
		}
//var person		=	document.frm_complementary.txt_name.value;
//var reference	=	document.frm_complementary.txt_rfrnc.value;		
var contact		=	document.frm_complementary.txt_cont_no.value;
var date=document.frm_complementary.txt_date.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
if(contact.match(letters) || contact.length!=10)
{
	alert("Please Enter 10 digit Phone number..");
	document.frm_complementary.txt_cont_no.focus();
	return false;
}

  if(date=="" || date.match(letters))
  {
	alert("Please Select Date...");
	document.frm_complementary.txt_date.focus();
	document.frm_complementary.txt_date.value="";
	return false;
  }//end of if
  else
  {
		var passedDate = new Date(date);
		var currentDate= new Date();
	  	if (passedDate > currentDate ) 
	  	{
		   	alert("Please Enter Current Date or Less than Current date");
		   	document.frm_complementary.txt_date.focus();
		   	return false;
	  	}
  }//end of else
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
<form name="frm_complementary" action="${pageContext.request.contextPath}/CHECKINGCOMPLEMENTARY" method="post" onSubmit="return validateForm();">
    <table width="467" height="647" border="0">
      
      <tr><%! int tab=0; %>
        <td width="227" colspan="2"><strong>PROGRAMME CODE :</strong></td>
        <td width="222" colspan="2">
<input type="text" name="mnu_prg_code" id="mnu_prg_code" value="<%= request.getParameter("prg_code").toUpperCase() %>" class="greysize" readonly="readonly"/></td>
      </tr>
        <tr>
        <td colspan="2">
        
        <div id="layer1" style="position:absolute; width:463px; height:315px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;">
          <%String[] course_block	=	(String[])request.getAttribute("course_block");%>
          <%int[] blocks			=	(int[])request.getAttribute("blocks");%>
          <%int[] stock				=	(int[])request.getAttribute("stock");%>
          <%int count=0;%>
          <table class="table" cellspacing="0">
            <%
				for(int i=0;i<course.length;i++)
				{%>
            <input type="hidden" name="crs_code" value="<%=course[i]%>" />
            <tr bgcolor="#CCCCCC" style="padding:0">
             <td width="166"><%= course[i]%></td>
             <td width="146"><strong>QUANTITY:</strong></td>
             <td width="139"><input type="text" name="txt_no_of_set" id="textid<%= i %>" tabindex="<%= ++tab %>"/></td>
           </tr>
           <tr>
             <td width="166"><strong>BLOCKS</strong></td>
             <td width="146"><strong>AVAILABLE STOCK:</strong></td>
             <td width="139"></td>
            </tr>
           <%
		   		for(int j=1;j<=blocks[i];j++)
				{%>
            <tr>
              <td width="166"><input type="checkbox" name="<%=course[i]%>" value="<%=course_block[count]%>" checked="checked"><%= "B"+j%></input></td>
             <td width="146"><%= stock[j-1]%></td>
             <td width="139"></td>
            </tr>
            <%count++;	}//end of for loop k
				}//end of for loop i
				%>
          </table>
        </div>        </td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2"><strong>SESSION :</strong></td>
        <td colspan="2"><%String current_session= (String)request.getAttribute("current_session"); %>
          <input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" readonly="true" class="greysize"/></td>
      </tr>
      <tr>
      <input type="hidden" name="txt_medium" value="<%= request.getParameter("medium")%>" />
        <td colspan="2"><strong>MEDIUM :</strong></td>
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
 <input type="text" name="txt_medium_display" id="txt_medium_display" class="greysize" readonly="readonly" value="<%= medium_display.toUpperCase() %>" /></td>
      </tr>      
      <tr>
        <td colspan="2"><strong>NAME OF THE PERSON:</strong></td>
        <td colspan="2">
<input name="txt_name" type="text" class="fieldsize" id="txt_name" tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" placeholder="Enter Name of Person" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>REFERENCE:</strong></td>
        <td colspan="2">
<input name="txt_rfrnc" type="text" class="fieldsize" id="txt_rfrnc" tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" placeholder="Enter the Reference Name" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>CONTACT NUMBER:</strong></td>
        <td colspan="2">
<input name="txt_cont_no" type="text" class="fieldsize" id="txt_cont_no" tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" placeholder="Enter Contact Number " required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>DATE:</strong></td>
        <td colspan="2">
<input name="txt_date" type="text" class="fieldsize" id="datepicker"  tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" placeholder="Click to Select Date" required/></td>
      </tr>
      <tr>
        <td colspan="2"><strong>PURPOSE:</strong></td>
        <td colspan="2">
<select name="mnu_prps" class="fieldsize" id="mnu_prps" tabindex="<%= ++tab %>"  onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)">
          <option value="PUBLICITY">PUBLICITY</option>
          <option value="RESEARCH">RESEARCH</option>
          <option value="LEARNING">LEARNING</option>
        </select></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
 <input name="reset" class="button" type="reset" id="reset" tabindex="<%=tab+2 %>" onclick="document.frm_complementary.mnu_prg_code.focus();" value="CLEAR FIELDS" />
        </div></td>
        <td colspan="2"><div align="center">
 <input name="enter" class="button" type="submit" id="DESPATCH" tabindex="<%= ++tab %>" value="Enter" />
        </div></td>
      </tr>
      <tr>
        <td colspan="2">&nbsp;</td>
        <td colspan="2">&nbsp;</td>
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
    
    <div id="nav-supp">
  
    </div>
    <h3>About COMPLEMENTARY </h3>
    <p>Whenever Regional Centre distributes study materials to other persons rather than learners it is treated as Complementary Despatch of Material and these transactions are of Despatch Nature as reducing the Inventory of Materials.</p>
    <h2>Note: A Contact Number can not be used twice for the Same Date for the Despatch.This is the Only Restriction for this Module.</h2>
  </div>

  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/jquery-ui.css" type="text/css" media="all"/>
    <script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() {  $( "#datepicker" ).datepicker();  });</script>
</html>
<%
}
%>