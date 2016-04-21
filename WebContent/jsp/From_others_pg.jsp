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
<title>Receive-Others(PG)</title>
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var program			=	document.form_others.mnu_prg_code.value;
	var program2			=	document.form_others.mnu_prg_code2.value;
if(program=="NONE" && program2=="NONE")
{
	alert("PLEASE SELECT ANY ONE PROGRAMME CODE ...");
	document.form_others.mnu_prg_code.focus();
	return false;
}
if(program==program2 && program!="NONE")
{
	alert("PLEASE DO NOT SELECT ONE PROGRAMME MORE THAN ONE TIME ...");
	document.form_others.mnu_prg_code.focus();
	return false;
}

if(program2==program && program2!="NONE")
{
	alert("PLEASE DO NOT SELECT ONE PROGRAMME MORE THAN ONE TIME ...");
	document.form_others.mnu_prg_code2.focus();
	return false;
}

var m			=	document.form_others.txt_medium.value;
	if (m=="NONE" && program!="NONE" )
	{
		alert("PLEASE SELECT MEDIUM FOR PROGRAMME ONE..");
		document.form_others.txt_medium.focus();
		return false;
	}

var sets=document.form_others.text_qty.value;
	if ( (sets<1 || sets==null || sets.match(letters)) && program!="NONE" )
	{
		alert("PLEASE ENTER QUANTITY 1 IN NUMBERS ONLY..");
		document.form_others.text_qty.value="";
		document.form_others.text_qty.focus();
		return false;
	}

var m2			=	document.form_others.txt_medium2.value;
	if (m2=="NONE" && program2!="NONE" )
	{
		alert("PLEASE SELECT MEDIUM FOR PROGRAMME TWO..");
		document.form_others.txt_medium2.focus();
		return false;
	}

var sets2=document.form_others.text_qty2.value;
	if ( (sets2<1 || sets2==null || sets2.match(letters)) && program2!="NONE" )
	{
		alert("PLEASE ENTER QUANTITY 2 IN NUMBERS ONLY..");
		document.form_others.text_qty2.value="";
		document.form_others.text_qty2.focus();
		return false;
	}
  var date=document.form_others.txt_date.value;  
  if (date=="" || date==null || date=="0" || date==" ")
  {
  alert("PLEASE SELECT DATE..");
  document.form_others.txt_date.value="";
  document.form_others.txt_date.focus();
  return false;
  }
  else
  {
	var passedDate = new Date(date);
	var currentDate= new Date();
		  if (passedDate > currentDate ) 
		  {
			alert("PLEASE ENTER CURRENT DATE OR LESS THAN CURRENT DATE");
			document.form_others.txt_date.focus();
			return false;
		  }
  }//end of else

var receive_from			=	document.form_others.receive_from.value;
if(receive_from=="" || receive_from==null || receive_from.match(numbers))
{
alert("PLEASE ENTER RECEIVER'S NAME IN WORD");
document.form_others.receive_from.value="";
document.form_others.receive_from.focus();
return false;
}
}//end of validateForm() method
</script>
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
            <li style="color:#FFFFFF"><a href="LogOut" accesskey="Z">Log Out</a></li>
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
      <li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">			From <U>O</U>thers				</a></li>
      <li><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
      <div align="center"><strong>  RECEIPT OF PROGRAMME GUIDE<hr /><hr /></strong></div>
<form name="form_others" action="${pageContext.request.contextPath}/RECEIVE_PG_OTHERS" onsubmit="return validateForm();" method="post">
<%! int tab=0; %>
    <table width="467" border="0">
      <tr height="30">
        <td colspan="2"><div align="center"><strong>PROGRAMME CODE:</strong></div></td>
        <td width="253" colspan="2">
<select id="mnu_prg_code" name="mnu_prg_code" onchange="SelectSubMedium()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" autofocus>
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
      </tr>
        <tr height="30">
        <td colspan="2"><div align="center"><strong>MEDIUM:</strong></div></td>
        <td colspan="2"><select name="txt_medium" id="txt_medium" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="NONE">SELECT MEDIUM</option>
        </select></td>
      </tr>
      <tr height="30">
        <td colspan="2"><div align="center"><strong>QUANTITY:</strong></div></td>
        <td colspan="2"><input type="text" name="text_qty" id="text_qty" tabindex="<%= ++tab %>" placeholder="ENTER THE QUANTITY" /></td>
      </tr>
      </table>
      <hr /><hr />
          <table width="467" border="0">
      <tr height="30">
        <td colspan="2"><div align="center"><strong>PROGRAMME CODE2:</strong></div></td>
        <td width="257" colspan="2">
<select id="mnu_prg_code2" name="mnu_prg_code2" onchange="SelectSubMedium2()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  >
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
      </tr>
        <tr height="30">
        <td colspan="2"><div align="center"><strong>MEDIUM2:</strong></div></td>
        <td colspan="2"><select name="txt_medium2" id="txt_medium2" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="NONE">SELECT MEDIUM</option>
        </select></td>
      </tr>
      <tr height="30">
        <td colspan="2"><div align="center"><strong>QUANTITY2:</strong></div></td>
        <td colspan="2"><input type="text" name="text_qty2" id="text_qty2" tabindex="<%= ++tab %>" placeholder="ENTER THE QUANTITY" /></td>
      </tr>        
      </table>
      <hr />
                <table width="467" border="0">
      <tr height="30">
        <td  colspan="2"><div align="center"><strong>SESSION:</strong></div></td>
        <td width="258" colspan="2"><%!String current_session=null; %>
          <%
      		try
	  		{
				rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
				while(rs.next())
					current_session=rs.getString(1);
			}//end of try blocks
			catch(Exception e)
			{
				out.println("connection error"+e);
			}//end of catch blocks
		 %>
          <input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="true" /></td>
      </tr>
      
      <tr height="30">
        <td colspan="2"><div align="center"><strong>DATE:</strong></div></td>
        <td colspan="2">
<input name="txt_date" type="text" placeholder="CLICK TO SELECT DATE" class="fieldsize" id="datepicker" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required /></td>
      </tr>
      <tr height="30">
        <td colspan="2"><div align="center"><strong>RECEIVED FROM:</strong></div></td>
        <td colspan="2">
<input name="receive_from" type="text" placeholder="Receiving Source" class="fieldsize" id="receive_from" tabindex="<%= ++tab %>" onchange="upper(this)" onmouseover="mover(this)" onmouseout="mout(this)" required/></td>
      </tr>
      <tr>
        <td colspan="2"><div align="center">
          <input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" class="button" onclick="document.frm_others.mnu_prg_code.focus();" value="CLEAR FIELDS" />
        </div></td>
        <td colspan="2"><div align="center">
          <input type="submit" name="submit" value="RECEIVE" tabindex="<%= ++tab %>" class="button"/>
        </div></td>`      </tr>
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
    <%if(msg==null)
	{%>
    <h3>ABOUT RECEIVE OTHERS</h3>
      Whenever RC Receives any Material from any Other source Rather than all the regular receiving sources than those transactions are managed by this page, like receiving of material from any staff or from any visitor.
      <%}%></div>
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
    <script>       $(function() { $( "#datepicker" ).datepicker();   });</script>
    <script type="text/javascript">
function fillCategory()
{ 
 // this function is used to fill the category list on load
								<%
									int i=1;
									String program=null;
									try
									{
									 rs=statement.executeQuery("select * from program");
										while(rs.next())
										{program=rs.getString(1);
								%>
								addOption(document.form_others.mnu_prg_code,"<%=program%>","<%=program%>","");
								addOption(document.form_others.mnu_prg_code2,"<%=program%>","<%=program%>","");								
								<% 
										i++;
										}
									}
									catch(Exception e)
									{out.println("connection error"+e);}
									String str[]=new String[i-1];
								%>
								<%
									try
									{
										ResultSet rs1=statement.executeQuery("select * from program");
										int j=0;
										while(rs1.next())
										{str[j]=new String(rs1.getString(1).toString());
										j++;}
									}	
									catch(Exception e)
									{out.println("connection error"+e);}
									String khushi;
								%>
							
}//end of method fillcategory

function removeAllOptions(selectbox)
{
	var i;
	for(i=selectbox.options.length-1;i>=0;i--)
	{
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
								removeAllOptions(document.form_others.txt_medium);
								addOption(document.form_others.txt_medium,"NONE", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.form_others.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
								rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
									addOption(document.form_others.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method SUBMEDIUM
function SelectSubMedium2()
{
// ON selection of program this function will work
								removeAllOptions(document.form_others.txt_medium2);
								addOption(document.form_others.txt_medium2,"NONE", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.form_others.mnu_prg_code2.value == "<%=str[k-1]%>")
								{
								<% 
								rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
									addOption(document.form_others.txt_medium2,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method SUBMEDIUM2

</script> 
</html>
<%
}
%>