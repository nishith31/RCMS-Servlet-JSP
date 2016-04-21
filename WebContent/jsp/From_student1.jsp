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
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" />
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
          <%int[] qtys				=	(int[])request.getAttribute("qtys");%>          
			
<title>Receive-MPDD</title>
<link rel="shortcut icon" href="imgs/favicon.ico" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
<script>
function validateForm()
{
var check = 0;
		<%for (int v=0;v<course.length;v++)
		{%>
			var blk = document.frm_studnt_receipt1.<%=course[v]%>.length;
			for(w=0;w<blk;w++)
			{
				if(document.frm_studnt_receipt1.<%=course[v]%>[w].checked == 1)
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
var date=document.frm_studnt_receipt1.txt_date.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;

  if(date=="" || date.match(letters))
  {
	alert("Please Select Date...");
	document.frm_studnt_receipt1.txt_date.focus();
	document.frm_studnt_receipt1.txt_date.value="";
	return false;
  }//end of if
  else
  {
		var passedDate = new Date(date);
		var currentDate= new Date();
	  	if (passedDate > currentDate ) 
	  	{
		   	alert("Please Enter Current Date or Less than Current date");
		   	document.frm_studnt_receipt1.txt_date.focus();
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_student.jsp" title="FROM STUDENT" accesskey="M">			Fro<U>m</U> Student				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">								From <U>O</U>thers				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
  <%String enrno			=	(String)request.getAttribute("enrno");%> 
  <%String student_name		=	(String)request.getAttribute("name");%> 
  <%String reg_code			=	(String)request.getAttribute("rc_code");%> 
  <%String prg_code			=	(String)request.getAttribute("prg_code");%>
  <%String current_session	=	(String)request.getAttribute("current_session");%>
  <%String medium			=	(String)request.getAttribute("medium");%>
  <%String date				=	(String)request.getAttribute("date");%>
  
<form name="frm_studnt_receipt1" action="${pageContext.request.contextPath}/RECEIVESTUDENTPARTIAL" method="post" onSubmit="return validateForm();">
    <table width="467" height="647" border="0">
    <tr>
        <td width="227"><div align="center"><strong>Enrolment Number:</strong></div></td>
        <td width="222"><input name="txt_enr" type="text" id="txt_enr" value="<%= enrno%>" class="greysize" readonly="readonly"/></td>
      </tr>
      <tr>
        <td width="227"><div align="center"><strong>Name:</strong></div></td>
        <td width="222"><input name="txt_name" type="text" id="txt_name" value="<%= student_name%>" class="greysize" readonly="readonly"/></td>
      </tr>  
      <tr><%! int tab=0; %>
        <td width="227"><div align="center"><strong>Programme Code:</strong></div></td>
        <td width="222">  
<input type="text" name="mnu_prg_code" id="mnu_prg_code" value="<%= prg_code %>" class="greysize" readonly="readonly"/></td>
      </tr>
      <tr>
        <td>
      
        <div id="layer1" style="position:absolute; width:463px; height:315px; overflow:auto; layer-background-color: #FFFFFF; border: 10px #993300;">
          <%int[] blocks			=	(int[])request.getAttribute("no_of_blocks");%>
          <table class="table" cellspacing="0">
            <%
				for(int i=0;i<course.length;i++)
				{%>
            <input type="hidden" name="crs_code" value="<%=course[i]%>" />
            <tr bgcolor="#CCCCCC" style="padding:0">
             <td width="45"><strong><%= course[i]%></strong></td>
             <td width="230"></td>
             <td width="180"></td>
           </tr>
           <tr>
             <td width="45"></td>
             <td width="230"><strong>Blocks</strong></td>
             <td width="180"><strong>Quantity:</strong></td>
            </tr>
           <%	String crs_blk=null;
		   		for(int j=1;j<=blocks[i];j++)
				{	crs_blk=""+course[i]+"B"+j;
					%>
            <tr>
              <td width="45"></td>
             <td width="230"><input type="checkbox" name="<%=course[i]%>" value="<%=crs_blk%>" checked="checked"><strong><%="B"+j%></strong></input></td>
             <td width="180"><input type="text" name="<%=crs_blk%>" id="textid<%= j %>" tabindex="<%= ++tab %>" value="<%=qtys[i]%>"/></td>
            </tr>
            <%	}//end of for loop j
				}//end of for loop i
				%>
          </table>
        </div>        </td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td><strong>Session:</strong></td>
        <td>
            <input name="txt_session" type="text" id="txt_session" value="<%=current_session%>" readonly="true" class="greysize"/></td>
      </tr>
      <tr>
      
        <input type="hidden" name="txt_medium" value="<%= medium %>" />
        <td><strong>Medium:</strong></td>
        <td><%String medium_display=null;
							try
							{
							rs=statement_empty.executeQuery("select medium_name from medium where medium='"+medium+"'");
							while(rs.next())
							medium_display=rs.getString(1);
							}
							catch(Exception o)
							{medium_display="EXCEPTION";}
						%>
            <input type="text" name="txt_medium_display" id="txt_medium_display" class="greysize" readonly="readonly" value="<%= medium_display.toUpperCase() %>" /></td>
      </tr>
      <tr>
        <td><strong>Date:</strong></td>
        <td><label>
          <input type="text" name="txt_date" id="txt_date" value="<%= date %>" class="greysize" readonly="readonly" />
        </label></td>
      </tr>
      <tr>
        <td><div align="center">
 <input name="reset" class="button" type="reset" id="reset" tabindex="<%=tab+2 %>" onclick="document.frm_studnt_receipt1.mnu_prg_code.focus();" value="CLEAR FIELDS" />
        </div></td>
        <td><div align="center">
 <input name="enter" class="button" type="submit" id="receive" tabindex="<%= ++tab %>" value="RECEIVE" />
        </div></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
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
     <h3>&nbsp;</h3>
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