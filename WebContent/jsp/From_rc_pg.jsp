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
<script type="text/javascript" src="js/general.js"></script>
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
<title>Receive-RC(PG)</title>
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var rc=document.frm_rc_receipt.mnu_reg_code.value;
if (rc=="0")
  {
  alert("PLEASE SELECT REGIONAL CENTRE CODE FIRST...");
  document.frm_rc_receipt.mnu_reg_code.focus();
  return	 false;
  }
var program			=	document.frm_rc_receipt.mnu_prg_code.value;
	var program2			=	document.frm_rc_receipt.mnu_prg_code2.value;
var program3			=	document.frm_rc_receipt.mnu_prg_code3.value;
if(program=="NONE" && program2=="NONE" && program3=="NONE")
{
	alert("PLEASE SELECT ANY ONE PROGRAMME CODE ...");
	document.frm_rc_receipt.mnu_prg_code.focus();
	return false;
}
if((program==program2 && program!="NONE")|| (program==program3 && program!="NONE"))
{
	alert("PLEASE DO NOT SELECT ONE PROGRAMME MORE THAN ONE TIME ...");
	document.frm_rc_receipt.mnu_prg_code.focus();
	return false;
}

if((program2==program && program2!="NONE")|| (program2==program3 && program2!="NONE"))
{
	alert("PLEASE DO NOT SELECT ONE PROGRAMME MORE THAN ONE TIME ...");
	document.frm_rc_receipt.mnu_prg_code2.focus();
	return false;
}

if((program3==program && program3!="NONE")|| (program3==program2 && program3!="NONE"))
{
	alert("PLEASE DO NOT SELECT ONE PROGRAMME MORE THAN ONE TIME ...");
	document.frm_rc_receipt.mnu_prg_code3.focus();
	return false;
}
var m			=	document.frm_rc_receipt.txt_medium.value;
	if (m=="NONE" && program!="NONE" )
	{
		alert("PLEASE SELECT MEDIUM FOR PROGRAMME ONE..");
		document.frm_rc_receipt.txt_medium.focus();
		return false;
	}

var sets=document.frm_rc_receipt.text_qty.value;
	if ( (sets<1 || sets==null || sets.match(letters)) && program!="NONE" )
	{
		alert("PLEASE ENTER QUANTITY 1 IN NUMBERS ONLY..");
		document.frm_rc_receipt.text_qty.value="";
		document.frm_rc_receipt.text_qty.focus();
		return false;
	}

var m2			=	document.frm_rc_receipt.txt_medium2.value;
	if (m2=="NONE" && program2!="NONE" )
	{
		alert("PLEASE SELECT MEDIUM FOR PROGRAMME TWO..");
		document.frm_rc_receipt.txt_medium2.focus();
		return false;
	}

var sets2=document.frm_rc_receipt.text_qty2.value;
	if ( (sets2<1 || sets2==null || sets2.match(letters)) && program2!="NONE" )
	{
		alert("PLEASE ENTER QUANTITY 2 IN NUMBERS ONLY..");
		document.frm_rc_receipt.text_qty2.value="";
		document.frm_rc_receipt.text_qty2.focus();
		return false;
	}
var m3			=	document.frm_rc_receipt.txt_medium3.value;
	if (m3=="NONE" && program3!="NONE" )
	{
		alert("PLEASE SELECT MEDIUM FOR PROGRAMME THREE..");
		document.frm_rc_receipt.txt_medium3.focus();
		return false;
	}

var sets3=document.frm_rc_receipt.text_qty3.value;
	if ( (sets3<1 || sets3==null || sets3.match(letters)) && program3!="NONE" )
	{
		alert("PLEASE ENTER QUANTITY 3 IN NUMBERS ONLY..");
		document.frm_rc_receipt.text_qty3.value="";
		document.frm_rc_receipt.text_qty3.focus();
		return false;
	}

  var date=document.frm_rc_receipt.txt_date.value;  
  if (date=="" || date==null || date=="0" || date==" ")
  {
  alert("PLEASE SELECT DATE..");
  document.frm_rc_receipt.txt_date.value="";
  document.frm_rc_receipt.txt_date.focus();
  return false;
  }
  else
  {
	var passedDate = new Date(date);
	var currentDate= new Date();
		  if (passedDate > currentDate ) 
		  {
			alert("PLEASE ENTER CURRENT DATE OR LESS THAN CURRENT DATE");
			document.frm_rc_receipt.txt_date.focus();
			return false;
		  }
  }//end of else

}//end of method
</script>
<link rel="shortcut icon" href="imgs/favicon.ico" /><link href="blu.css" rel="stylesheet" type="text/css" media="all" /></head>
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

<body onLoad="fillCategory();document.frm_rc_receipt.mnu_reg_code.focus();">
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
      <li ><a href="Home.jsp" title="HOME" accesskey="H" >							<%= home_menu %>		</a></li>
      <li><a href="Despatch.jsp" title="DESPATCH" accesskey="D">					<%= dispatch_menu %>	</a></li>
	  <li class="current"><a href="Receive.jsp" title="RECEIPT" accesskey="R">		<%= receive_menu %>		</a></li>
      <li><a href="Obsolete.jsp" title="DAMAGED MATERIAL" accesskey="G">			<%= obsolete_menu %>	</a></li>
      <li><a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">						<%= enquiry_menu %>		</a></li>
      <li><a href="Report.jsp" title="REPORT" accesskey="P">						<%= report_menu %>		</a></li>
     <li><a href="Update.jsp" title="UPDATE" accesskey="U">							<%= update_menu %>		</a></li>
    </ul>
  </div>

  <div id="nav-section">
    <ul>
      <li><a href="From_mpdd.jsp" title="FROM MPDD" accesskey="F">									<U>F</U>rom MPDD				</a></li>
      <li class="youarehere"><a href="From_rc.jsp" title="FROM RC" accesskey="C">					From R<U>C</U>					</a></li>
      <li><a href="From_sc.jsp" title="FROM SC" accesskey="S">										From <U>S</U>C					</a></li>
      <li><a href="From_student.jsp" title="FROM STUDENT" accesskey="M">							Fro<U>m</U> Student				</a></li>
      <li><a href="From_others.jsp" title="FROM OTHERS" accesskey="O">								From <U>O</U>thers				</a></li>
      <li><a href="From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
<form name="frm_rc_receipt" action="RECEIVE_PG_RC"  onsubmit="return validateForm();" method="post">
<div align="center"><strong>  RECEIPT OF PROGRAMME GUIDE<hr /><hr /></strong></div>
    <table width="472"  border="0">
      <tr><%! int tab=0; %>
        <td height="29" colspan="2"><div align="center"><strong>REGIONAL CENTRE:</strong></div></td>
        <td width="234">
 <select name="mnu_reg_code" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" autofocus>
          <option value = "0">SELECT  RC</option>
          									<%int m=1;
		  										try
													{
													rs=statement.executeQuery("select * from regional_centre where reg_code <>  '"+rc_code+"'");
													while(rs.next())
													{
													out.println("<option value ="+rs.getString(1)+">"+rs.getString(2)+"</option>");
													m++;
													}
													}	
												catch(Exception e)
													{out.println("connection error"+e);}
											%>
        </select></td>
        </tr></table>
<hr /><hr />        
    <table width="472" border="0">        
      <tr>
        <td height="28" colspan="2"><div align="center"><strong>PROGRAMME CODE:</strong></div></td>
        <td>
<select name="mnu_prg_code" onchange="SelectSubMedium()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
        </tr>
            <tr>
        <td height="24" colspan="2"><div align="center"><strong>MEDIUM:</strong></div></td>
        <td>
 <select name="txt_medium" id="txt_medium" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="NONE">SELECT MEDIUM</option>
        </select></td>
        </tr>
      <tr>
        <td height="30" colspan="2"><div align="center"><strong>QUANTITY:</strong></div></td>
        <td><input type="text" name="text_qty" id="text_qty" tabindex="<%= ++tab %>" placeholder="ENTER THE QUANTITY" /></td>
        </tr>        
        </table>
        <hr /><hr />
               
      <table width="472" border="0">        
      <tr>
        <td height="30" colspan="2"><div align="center"><strong>PROGRAMME CODE2:</strong></div></td>
        <td>
<select name="mnu_prg_code2" onchange="SelectSubMedium2()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
        </tr>
      
      <tr>
        <td height="26" colspan="2"><div align="center"><strong>MEDIUM2:</strong></div></td>
        <td><select name="txt_medium2" id="txt_medium2" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="NONE">SELECT MEDIUM</option>
        </select></td>
        </tr>
      <tr>
        <td height="32" colspan="2"><div align="center"><strong>QUANTITY2:</strong></div></td>
        <td><input type="text" name="text_qty2" id="text_qty2" tabindex="<%= ++tab %>" placeholder="ENTER THE QUANTITY" /></td>
        </tr>        </table><hr /><hr />
                    <table width="472" border="0">        
      <tr>
        <td height="32" colspan="2"><div align="center"><strong>PROGRAMME CODE3:</strong></div></td>
        <td>
<select name="mnu_prg_code3" onchange="SelectSubMedium3()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
          <option value="NONE">SELECT PROGRAMME</option>
        </select></td>
        </tr>
      
      <tr>
        <td height="24" colspan="2"><div align="center"><strong>MEDIUM3:</strong></div></td>
        <td><select name="txt_medium3" id="txt_medium3" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
          <option value="NONE">SELECT MEDIUM</option>
        </select></td>
        </tr>
      <tr>
        <td height="28" colspan="2"><div align="center"><strong>QUANTITY3:</strong></div></td>
        <td><input type="text" name="text_qty3" id="text_qty3" tabindex="<%= ++tab %>" placeholder="ENTER THE QUANTITY" /></td>
        </tr>        </table>
        <hr />
        
                    <table width="472" border="0">        
      <tr>
        <td height="24" colspan="2"><div align="center"><strong>SESSION:</strong></div></td>
        <td><%!String current_session=null; %>
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
<input name="txt_session" type="text" id="txt_session" value="<%=current_session.toUpperCase()%>" class="greysize" readonly="readonly" /></td>
		</tr>
      
      <tr>
        <td height="24" colspan="2"><div align="center"><strong>DATE:</strong></div></td>
        <td>
 <input name="txt_date" type="text" placeholder="CLICK TO SELECT DATE" id="datepicker" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" required/>
  </td>
        </tr>     
      <tr>
        <td height="52" colspan="2"><div align="center">
 <input name="reset" type="reset" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" onclick="document.frm_rc_receipt.mnu_reg_code.focus();" class="button"/>
        </div> </td>
        <td><div align="center">
          <input name="enter" type="submit" id="enter" value="RECEIVE" tabindex="<%= ++tab %>" class="button" />
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
    <%if(msg==null){%>
    <h3>For Quick Access to </h3>

      <ul>
        <li><a href="Home.jsp">RCMS-HOME</a></li>
      </ul>
    <%}%>  
    </div>
      </div>
  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
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
								addOption(document.frm_rc_receipt.mnu_prg_code,"<%=program%>","<%=program%>","");
								addOption(document.frm_rc_receipt.mnu_prg_code2,"<%=program%>","<%=program%>","");								
								addOption(document.frm_rc_receipt.mnu_prg_code3,"<%=program%>","<%=program%>","");																
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
function SelectSubMedium()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_rc_receipt.txt_medium);
								addOption(document.frm_rc_receipt.txt_medium, "NONE", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_rc_receipt.mnu_prg_code.value == "<%=str[k-1]%>")
							{<% rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_rc_receipt.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
							<% }%>	
								<%
								}	
								catch(Exception e)
								{out.println("connection error"+e);}
								%>
}//end of method
function SelectSubMedium2()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_rc_receipt.txt_medium2);
								addOption(document.frm_rc_receipt.txt_medium2, "NONE", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_rc_receipt.mnu_prg_code2.value == "<%=str[k-1]%>")
							{<% rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_rc_receipt.txt_medium2,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
							<% }%>	
								<%
								}	
								catch(Exception e)
								{out.println("connection error"+e);}
								%>
}//end of method
function SelectSubMedium3()
{
// ON selection of program this function will work
								removeAllOptions(document.frm_rc_receipt.txt_medium3);
								addOption(document.frm_rc_receipt.txt_medium3, "NONE", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{
								%>
								if(document.frm_rc_receipt.mnu_prg_code3.value == "<%=str[k-1]%>")
							{<% rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_rc_receipt.txt_medium3,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
							<% }%>	
								<%
								}	
								catch(Exception e)
								{out.println("connection error"+e);}
								%>
}//end of method
</script>
	    <link rel="stylesheet"  href="js/jquery-ui.css"   type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() {            $( "#datepicker" ).datepicker();        });	</script>
</html>
<%}%>