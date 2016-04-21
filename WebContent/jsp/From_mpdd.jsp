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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<meta http-equiv="Content-Language" content="en-us" />
		<meta name="description" content="Put a description of the page here" />
		<meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
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
		<title>Receive-MPDD</title>
		<link rel="shortcut icon" href="imgs/favicon.ico" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
		<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
		<script type="text/javascript">
			function validateForm()
			{
				var letters = /^[A-Za-z]+$/;
				var program=document.frm_mpdd_receipt.mnu_prg_code.value;
				if (program==0)
				{
					alert("Please Select Program Code First..");
					document.frm_mpdd_receipt.mnu_prg_code.focus();
					return false;
				}
				var course			=	document.frm_mpdd_receipt.mnu_crs_code.value;
				var course2			=	document.frm_mpdd_receipt.mnu_crs_code2.value;
				var course3			=	document.frm_mpdd_receipt.mnu_crs_code3.value;
				var course4			=	document.frm_mpdd_receipt.mnu_crs_code4.value;
				var course5			=	document.frm_mpdd_receipt.mnu_crs_code5.value;
				var course6			=	document.frm_mpdd_receipt.mnu_crs_code6.value;
				var course7			=	document.frm_mpdd_receipt.mnu_crs_code7.value;
				var course8			=	document.frm_mpdd_receipt.mnu_crs_code8.value;
				var course9			=	document.frm_mpdd_receipt.mnu_crs_code9.value;
				var course10		=	document.frm_mpdd_receipt.mnu_crs_code10.value;
				if(course=="NONE" && course2=="NONE" && course3=="NONE" && course4=="NONE" && course5=="NONE" && course6=="NONE" && course7=="NONE" && course8=="NONE" && course9=="NONE" && course10=="NONE")
				{
					alert("PLEASE SELECT ANY ONE COURSE CODE ...");
					document.frm_mpdd_receipt.mnu_crs_code.focus();
					return false;
				}
				if((course==course2 && course!="NONE")|| (course==course3 && course!="NONE") || (course==course4 && course!="NONE") || (course==course5 && course!="NONE") || (course==course6 && course!="NONE") || (course==course7 && course!="NONE") || (course==course8 && course!="NONE") || (course==course9 && course!="NONE") || (course==course10 && course!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code.focus();
					return false;
				}
				if((course2==course && course2!="NONE")|| (course2==course3 && course2!="NONE") || (course2==course4 && course2!="NONE") || (course2==course5 && course2!="NONE") || (course2==course6 && course2!="NONE") || (course2==course7 && course2!="NONE") || (course2==course8 && course2!="NONE") || (course2==course9 && course2!="NONE") || (course2==course10 && course2!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code2.focus();
					return false;
				}

				if((course3==course && course3!="NONE")|| (course3==course2 && course3!="NONE") || (course3==course4 && course3!="NONE") || (course3==course5 && course3!="NONE") || (course3==course6 && course3!="NONE") || (course3==course7 && course3!="NONE") || (course3==course8 && course3!="NONE") || (course3==course9 && course3!="NONE") || (course3==course10 && course3!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code3.focus();
					return false;
				}

				if((course4==course && course4!="NONE")|| (course4==course2 && course4!="NONE") || (course4==course3 && course4!="NONE") || (course4==course5 && course4!="NONE") || (course4==course6 && course4!="NONE") || (course4==course7 && course4!="NONE") || (course4==course8 && course4!="NONE") || (course4==course9 && course4!="NONE") || (course4==course10 && course4!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code4.focus();
					return false;
				}

				if((course5==course && course5!="NONE")|| (course5==course2 && course5!="NONE") || (course5==course3 && course5!="NONE") || (course5==course4 && course5!="NONE") || (course5==course6 && course5!="NONE") || (course5==course7 && course5!="NONE") || (course5==course8 && course5!="NONE") || (course5==course9 && course5!="NONE") || (course5==course10 && course5!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code5.focus();
					return false;
				}

				if((course6==course && course6!="NONE")|| (course6==course2 && course6!="NONE") || (course6==course3 && course6!="NONE") || (course6==course4 && course6!="NONE") || (course6==course5 && course6!="NONE") || (course6==course7 && course6!="NONE") || (course6==course8 && course6!="NONE") || (course6==course9 && course6!="NONE") || (course6==course10 && course6!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code6.focus();
					return false;
				}

				if((course7==course && course7!="NONE")|| (course7==course2 && course7!="NONE") || (course7==course3 && course7!="NONE") || (course7==course4 && course7!="NONE") || (course7==course5 && course7!="NONE") || (course7==course6 && course7!="NONE") || (course7==course8 && course7!="NONE") || (course7==course9 && course7!="NONE") || (course7==course10 && course7!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code7.focus();
					return false;
				}

				if((course8==course && course8!="NONE")|| (course8==course2 && course8!="NONE") || (course8==course3 && course8!="NONE") || (course8==course4 && course8!="NONE") || (course8==course5 && course8!="NONE") || (course8==course6 && course8!="NONE") || (course8==course7 && course8!="NONE") || (course8==course9 && course8!="NONE") || (course8==course10 && course8!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code8.focus();
					return false;
				}

				if((course9==course && course9!="NONE")|| (course9==course2 && course9!="NONE") || (course9==course3 && course9!="NONE") || (course9==course4 && course9!="NONE") || (course9==course5 && course9!="NONE") || (course9==course6 && course9!="NONE") || (course9==course7 && course9!="NONE") || (course9==course8 && course9!="NONE") || (course9==course10 && course9!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code9.focus();
					return false;
				}

				if((course10==course && course10!="NONE")|| (course10==course2 && course10!="NONE") || (course10==course3 && course10!="NONE") || (course10==course4 && course10!="NONE") || (course10==course5 && course10!="NONE") || (course10==course6 && course10!="NONE") || (course10==course7 && course10!="NONE") || (course10==course8 && course10!="NONE") || (course10==course9 && course10!="NONE"))
				{
					alert("PLEASE DO NOT SELECT ONE COURSE MORE THAN ONE TIME ...");
					document.frm_mpdd_receipt.mnu_crs_code10.focus();
					return false;
				}

				var sets=document.frm_mpdd_receipt.txt_no_of_set.value;
				if ( (sets<1 || sets==null || sets.match(letters)) && course!="NONE" )
				{
					alert("PLEASE ENTER QUANTITY 1 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set.value="";
					document.frm_mpdd_receipt.txt_no_of_set.focus();
					return false;
				}
				var sets2=document.frm_mpdd_receipt.txt_no_of_set2.value;
				if ((sets2<1 || sets2==null || sets2.match(letters)) && course2!="NONE" )
				{
					alert("PLEASE ENTER QUANTITY 2 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set2.value="";
					document.frm_mpdd_receipt.txt_no_of_set2.focus();
					return false;
				}
				var sets3=document.frm_mpdd_receipt.txt_no_of_set3.value;
				if ((sets3<1 || sets3==null || sets3.match(letters)) && course3!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 3 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set3.value="";
					document.frm_mpdd_receipt.txt_no_of_set3.focus();
					return false;
				}

				var sets4=document.frm_mpdd_receipt.txt_no_of_set4.value;
				if ((sets4<1 || sets4==null || sets4.match(letters)) && course4!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 4 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set4.value="";
					document.frm_mpdd_receipt.txt_no_of_set4.focus();
					return false;
				}

				var sets5=document.frm_mpdd_receipt.txt_no_of_set5.value;
				if ((sets5<1 || sets5==null || sets5.match(letters)) && course5!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 5 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set5.value="";
					document.frm_mpdd_receipt.txt_no_of_set5.focus();
					return false;
				}

				var sets6=document.frm_mpdd_receipt.txt_no_of_set6.value;
				if ((sets6<1 || sets6==null || sets6.match(letters)) && course6!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 6 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set6.value="";
					document.frm_mpdd_receipt.txt_no_of_set6.focus();
					return false;
				}

				var sets7=document.frm_mpdd_receipt.txt_no_of_set7.value;
				if ((sets7<1 || sets7==null || sets7.match(letters)) && course7!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 7 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set7.value="";
					document.frm_mpdd_receipt.txt_no_of_set7.focus();
					return false;
				}

				var sets8=document.frm_mpdd_receipt.txt_no_of_set8.value;
				if ((sets8<1 || sets8==null || sets8.match(letters)) && course8!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 8 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set8.value="";
					document.frm_mpdd_receipt.txt_no_of_set8.focus();
					return false;
				}

				var sets9=document.frm_mpdd_receipt.txt_no_of_set9.value;
				if ((sets9<1 || sets9==null || sets9.match(letters)) && course9!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 9 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set9.value="";
					document.frm_mpdd_receipt.txt_no_of_set9.focus();
					return false;
				}

				var sets10=document.frm_mpdd_receipt.txt_no_of_set10.value;
				if ((sets10<1 || sets10==null || sets10.match(letters)) && course10!="NONE")
				{
					alert("PLEASE ENTER QUANTITY 10 IN NUMBERS ONLY..");
					document.frm_mpdd_receipt.txt_no_of_set10.value="";
					document.frm_mpdd_receipt.txt_no_of_set10.focus();
					return false;
				}
	
				var medium=document.frm_mpdd_receipt.txt_medium.value;
				if (medium==0)
				{
					alert("PLEASE SELECT MEDIUM..");
					document.frm_mpdd_receipt.txt_medium.focus();
					return false;
				}

				var date=document.frm_mpdd_receipt.txt_date.value;
				if (date==null || date=="")
				{
					alert("PLEASE SELECT DATE..");
					document.frm_mpdd_receipt.txt_date.value="";
					document.frm_mpdd_receipt.txt_date.focus();
					return false;
				}
				else
				{
					var passedDate = new Date(date);
					var currentDate= new Date();
					if (passedDate > currentDate ) 
					{
						alert("PLEASE ENTER CURRENT DATE OR LESS THAN CURRENT DATE");
						document.frm_mpdd_receipt.txt_date.focus();
						return false;
					}
				}//end of else
			}//end of method
		</script>
	</head>
	<%! 
		Connection connection=null;
		Statement statement=null,statement_empty=null;
		ResultSet rs=null;
	%>
	<%
		try
		{
			Class.forName(driver);
			connection=DriverManager.getConnection(url,user_name,pswd);
			statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
			statement_empty=connection.createStatement();				
					
		}
		catch(Exception e)
		{		
			out.println("connection error"+e);	
		}
  %>
	<body onLoad="fillCategory();document.frm_mpdd_receipt.mnu_prg_code.focus();" >

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
					<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/From_mpdd.jsp" title="FROM MPDD" accesskey="F">				<U>F</U>rom MPDD				</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/From_rc.jsp" title="FROM RC" accesskey="C">										From R<U>C</U>					</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/From_sc.jsp" title="FROM SC" accesskey="S">										From <U>S</U>C					</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/From_student.jsp" title="FROM STUDENT" accesskey="M">							Fro<U>m</U> Student				</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/From_others.jsp" title="FROM OTHERS" accesskey="O">								From <U>O</U>thers				</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/From_post.jsp" title="RETURN FROM POST" accesskey="N">							Post Retur<U>n</U>				</a></li>
				</ul>
			</div>
			<div id="content">
				<a name="contentstart" id="contentstart"></a>
				<form name="frm_mpdd_receipt" action="${pageContext.request.contextPath}/RECEIVEMPDD" method="post" onSubmit="submitting();return validateForm();">
					<table width="467" height="285" border="0">
						<tr>
							<%! int tab=0; %>
							<td height="36" colspan="2"><div align="center"><strong>PROGRAMME CODE:</strong></div></td>
							<td width="140">
								<select name="mnu_prg_code" onchange="SelectSubCat();SelectSubMedium()" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" autofocus>
									<option value="0">SELECT PROGRAMME</option>
								</select>
							</td>
							<td width="60">&nbsp;</td>
						</tr>
						<tr>
							<td width="109" height="36"><strong>COURSE CODE1:</strong></td>
							<td width="140">
								<select id="mnu_crs_code" name="mnu_crs_code" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY1:</strong></div></td>
							<td>
								<input name="txt_no_of_set" type="text" id="txt_no_of_set" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)" />
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE2:</strong></td>
							<td>
								<select id="mnu_crs_code2" name="mnu_crs_code2" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)">
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY2:</strong></div></td>
							<td>
								<input name="txt_no_of_set2" type="text" id="txt_no_of_set2" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE3:</strong></td>
							<td>
								<select id="mnu_crs_code3" name="mnu_crs_code3" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY3:</strong></div></td>
							<td>
								<input name="txt_no_of_set3" type="text" id="txt_no_of_set3"  class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE4:</strong></td>
							<td>
								<select id="mnu_crs_code4" name="mnu_crs_code4" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY4:</strong></div></td>
							<td>
								<input name="txt_no_of_set4" type="text" id="txt_no_of_set4" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE5:</strong></td>
							<td>
								<select id="mnu_crs_code5" name="mnu_crs_code5" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY5:</strong></div></td>
							<td>
								<input name="txt_no_of_set5" type="text" id="txt_no_of_set5" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE6:</strong></td>
							<td>
								<select id="mnu_crs_code6" name="mnu_crs_code6" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY6:</strong></div></td>
							<td>
								<input name="txt_no_of_set6" type="text" id="txt_no_of_set6" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
						<tr>
							<td height="36"><strong>COURSE CODE7:</strong></td>
							<td>
								<select id="mnu_crs_code7" name="mnu_crs_code7" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
									<option value="NONE">SELECT COURSE</option>
								</select>
							</td>
							<td><div align="center"><strong>QUANTITY7:</strong></div></td>
							<td>
								<input name="txt_no_of_set7" type="text" id="txt_no_of_set7" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
							</td>
						</tr>
					<tr>
						<td height="36"><strong>COURSE CODE8:</strong></td>
						<td>
							<select id="mnu_crs_code8" name="mnu_crs_code8" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
								<option value="NONE">SELECT COURSE</option>
							</select>
						</td>
						<td><div align="center"><strong>QUANTITY8:</strong></div></td>
						<td>
							<input name="txt_no_of_set8" type="text" id="txt_no_of_set8" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
						</td>
					</tr>
					<tr>
						<td height="36"><strong>COURSE CODE9:</strong></td>
						<td>
							<select id="mnu_crs_code9" name="mnu_crs_code9" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
								<option value="NONE">SELECT COURSE</option>
							</select>
						</td>
						<td><div align="center"><strong>QUANTITY9:</strong></div></td>
						<td>
							<input name="txt_no_of_set9" type="text" id="txt_no_of_set9" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
						</td>
					</tr>
					<tr>
						<td height="36"><strong>COURSE CODE10:</strong></td>
						<td>
							<select id="mnu_crs_code10" name="mnu_crs_code10" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)" >
								<option value="NONE">SELECT COURSE</option>
							</select>
						</td>
						<td><div align="center"><strong>QUANTITY10:</strong></div></td>
						<td>
							<input name="txt_no_of_set10" type="text" id="txt_no_of_set10" class="quantityfieldsize" tabindex="<%= ++tab %>" onmouseover="qmover(this)" onmouseout="qmout(this)"  onchange="upper(this)"/>
						</td>
					</tr>
					<tr>
						<%
							String	current_session=null;
							try
							{
								rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
								while(rs.next())
									current_session=rs.getString(1);
							}
							catch(Exception e)
							{
								out.println("connection error"+e);
							}
						%>
						<td height="37" colspan="2"><div align="center"><strong>SESSION:</strong></div></td>
						<td>
							<input name="txt_session" type="text" value="<%=current_session.toUpperCase()%>" readonly="true" class="greysize"  id="txt_session" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)"/>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td height="36" colspan="2"><div align="center"><strong>MEDIUM:</strong></div></td>
						<td>
							<select name="txt_medium" id="txt_medium" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)">
								<option value="0">SELECT MEDIUM</option>
							</select>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td height="35" colspan="2"><div align="center"><strong>DATE:</strong></div></td>
						<td>
							<input name="txt_date" type="text" id="datepicker" class="fieldsize" tabindex="<%= ++tab %>" onmouseover="mover(this)" onmouseout="mout(this)"  onchange="upper(this)" placeholder="CLICK TO SELECT DATE" required/>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">
							<label>
								<input type="radio" name="receipt_type" value="complete"  checked="checked" tabindex="<%= ++tab %>"/>
								<strong>COMPLETE RECEIPT</strong>
							</label>
						</td>
						<td colspan="2">
							<label>
								<input type="radio" name="receipt_type" value="partial" tabindex="<%= ++tab %>"/>
								<strong>PARTIAL RECEIPT</strong>
							</label>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<div align="center">
								<div align="center">
									<input name="reset" type="reset" id="reset" tabindex="<%= tab+2 %>" value="CLEAR FIELDS" onclick="document.frm_mpdd_receipt.mnu_prg_code.focus();" class="button" />
								</div>
							</div>
							<div align="left"></div>
						</td>
						<td colspan="2">
							<div align="center">
								<strong>
									<input name="enter" type="submit" id="enter"  tabindex="<%= ++tab %>" value="RECEIVE" class="button"/>
								</strong>
							</div>
						</td>
					</tr>
				</table>
			</form>
			<h1>&nbsp;</h1>
		</div>
		<div id="sidebar">
			<div id="blink1" class="highlight">
				<% 
					String msg=null;
					try
					{ 
						msg=(String)request.getAttribute("msg"); 
					}
					catch(Exception dd)
					{}
				%>
				<h3>
					<%
						if(msg!=null)
							out.println(msg); 
					%>
				</h3>
            </div>
			<h3>Quick Access To </h3>
			<div id="nav-supp">
				<ul>
					<li><a href="${pageContext.request.contextPath}/jsp/Home.jsp">RCMS-HOME</a></li>
				</ul>
			</div>
			<h3>&nbsp;</h3>
			<a href="${pageContext.request.contextPath}/jsp/From_mpdd_pg.jsp" title="Click for RECEIPT Program Guide ">
				<h1><img src="imgs/pg.jpg" alt="Click for Program Guide" width="160" height="190" /></h1>
			</a>
		</div>
		<div id="info-site">
			<p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
			<p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
		</div>
	</div>
	<script language="javascript" type="text/javascript">
		$(window).load(function() 
		{
			$('#loading').hide();
		});
	</script>
	<script language="javascript" type="text/javascript">
		$(window).load(function() 
		{
			$('#loading').hide();
		});
	</script>
	<script type="text/javascript">
		function fillCategory()
		{ 
			addOption(document.frm_mpdd_receipt.mnu_prg_code, "ALL", "ALL", "");
			// this function is used to fill the category list on load
			<%
				int i=1;
				String str[]=null;
				try
				{
					rs=statement.executeQuery("select prg_code from program");
					while(rs.next())
					{
			%>
			addOption(document.frm_mpdd_receipt.mnu_prg_code, "<%=rs.getString(1)%>", "<%=rs.getString(1)%>", "");
			<% 
						i++;
					}
					str=new String[i-1];
					rs.beforeFirst();
					int j=0;
					while(rs.next())
					{
						str[j]=new String(rs.getString(1).toString());
						j++;
					}
				}
				catch(Exception e)
				{
					out.println("connection error"+e);
				}
				//String str[]=new String[i-1];
				String khushi;
			%>

		}//end of method fillcategory()

		function SelectSubCat()
		{
			// ON selection of category this function will work
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code2);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code3);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code4);						
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code5);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code6);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code7);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code8);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code9);
			removeAllOptions(document.frm_mpdd_receipt.mnu_crs_code10);

			addOption(document.frm_mpdd_receipt.mnu_crs_code,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code2,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code3,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code4,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code5,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code6,"NONE", "SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code7,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code8,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code9,"NONE","SELECT COURSE","");
			addOption(document.frm_mpdd_receipt.mnu_crs_code10,"NONE","SELECT COURSE","");						
			<%
				try
				{
					ResultSet rs_course;
					for(int k=1;k<=str.length;k++)
					{
			%>
			if(document.frm_mpdd_receipt.mnu_prg_code.value == "<%=str[k-1]%>")
			{
				<% 
							rs_course=statement_empty.executeQuery("select crs_code from program_course where prg_code='"+str[k-1]+"'");
							int l=1;
							while(rs_course.next())
							{
								khushi=rs_course.getString(1);
				%>
				addOption(document.frm_mpdd_receipt.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
				addOption(document.frm_mpdd_receipt.mnu_crs_code2,"<%=khushi%>","<%=khushi%>");								
				addOption(document.frm_mpdd_receipt.mnu_crs_code3,"<%=khushi%>","<%=khushi%>");
				addOption(document.frm_mpdd_receipt.mnu_crs_code4,"<%=khushi%>","<%=khushi%>");	
				addOption(document.frm_mpdd_receipt.mnu_crs_code5,"<%=khushi%>","<%=khushi%>");
				addOption(document.frm_mpdd_receipt.mnu_crs_code6,"<%=khushi%>","<%=khushi%>");																																									
				addOption(document.frm_mpdd_receipt.mnu_crs_code7,"<%=khushi%>","<%=khushi%>");	
				addOption(document.frm_mpdd_receipt.mnu_crs_code8,"<%=khushi%>","<%=khushi%>");																										
				addOption(document.frm_mpdd_receipt.mnu_crs_code9,"<%=khushi%>","<%=khushi%>");	
				addOption(document.frm_mpdd_receipt.mnu_crs_code10,"<%=khushi%>","<%=khushi%>");																										
				<% 
								l++;
							}
				%>
			}//end of if
			<% 
								}//enf of for loop
								%>
								if(document.frm_mpdd_receipt.mnu_prg_code.value=="ALL")
								{
								<% 
									rs_course=statement_empty.executeQuery("select crs_code from course");
									int l=1;
									while(rs_course.next())
									{
									khushi=rs_course.getString(1);
								%>
								addOption(document.frm_mpdd_receipt.mnu_crs_code,"<%=khushi%>","<%=khushi%>");
									addOption(document.frm_mpdd_receipt.mnu_crs_code2,"<%=khushi%>","<%=khushi%>");								
										addOption(document.frm_mpdd_receipt.mnu_crs_code3,"<%=khushi%>","<%=khushi%>");
											addOption(document.frm_mpdd_receipt.mnu_crs_code4,"<%=khushi%>","<%=khushi%>");	
												addOption(document.frm_mpdd_receipt.mnu_crs_code5,"<%=khushi%>","<%=khushi%>");
												addOption(document.frm_mpdd_receipt.mnu_crs_code6,"<%=khushi%>","<%=khushi%>");																																									
											addOption(document.frm_mpdd_receipt.mnu_crs_code7,"<%=khushi%>","<%=khushi%>");	
										addOption(document.frm_mpdd_receipt.mnu_crs_code8,"<%=khushi%>","<%=khushi%>");																										
									addOption(document.frm_mpdd_receipt.mnu_crs_code9,"<%=khushi%>","<%=khushi%>");	
								addOption(document.frm_mpdd_receipt.mnu_crs_code10,"<%=khushi%>","<%=khushi%>");																										

								<% 
									l++;	}
								%>
								}//end of if all
								<%
									}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
								}

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

function SelectSubMedium(){
// ON selection of program this function will work
								removeAllOptions(document.frm_mpdd_receipt.txt_medium);
								addOption(document.frm_mpdd_receipt.txt_medium,"0", "SELECT MEDIUM", "");
								<%
								try{
									ResultSet rs_course;
									for(int k=1;k<=str.length;k++)
									{//rs_course=s.executeQuery("select medium_code from program_medium where prg_code='"+str[k-1]+"'");
								%>
								if(document.frm_mpdd_receipt.mnu_prg_code.value == "<%=str[k-1]%>")
								{
								<% 
								rs_course=statement_empty.executeQuery("select * from medium where medium in (select medium from program_medium where prg_code='"+str[k-1]+"')");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
									addOption(document.frm_mpdd_receipt.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if
								<% }%>
								if(document.frm_mpdd_receipt.mnu_prg_code.value=="ALL")
								{
								<%
									rs_course=statement_empty.executeQuery("select * from medium");
									int l=1;
									while(rs_course.next())
									{khushi=rs_course.getString(1);
								%>
								addOption(document.frm_mpdd_receipt.txt_medium,"<%=khushi%>","<%=rs_course.getString(2)%>");
								<% l++;	}%>
								}//end of if all
								<%}	
									catch(Exception e)
									{out.println("connection error"+e);}
								%>
}//end of method
</script>
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/js/jquery-ui.css"   type="text/css" media="all"/>
	<script src="${pageContext.request.contextPath}/js/jquery.min.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/js/jquery-ui.min.js" type="text/javascript"></script>
	<script>$(function() {  $( "#datepicker" ).datepicker();   });</script>
<script type="text/javascript">
function submitting()
{
	var sets		=	document.frm_mpdd_receipt.txt_no_of_set.value;
	var sets2		=	document.frm_mpdd_receipt.txt_no_of_set2.value;
	var sets3		=	document.frm_mpdd_receipt.txt_no_of_set3.value;
	var sets4		=	document.frm_mpdd_receipt.txt_no_of_set4.value;																					
	var sets5		=	document.frm_mpdd_receipt.txt_no_of_set5.value;									
	var sets6		=	document.frm_mpdd_receipt.txt_no_of_set6.value;										
	var sets7		=	document.frm_mpdd_receipt.txt_no_of_set7.value;
	var sets8		=	document.frm_mpdd_receipt.txt_no_of_set8.value;
	var sets9		=	document.frm_mpdd_receipt.txt_no_of_set9.value;																
	var sets10		=	document.frm_mpdd_receipt.txt_no_of_set10.value;												
var length=0;
	if(sets=="")
	{document.frm_mpdd_receipt.txt_no_of_set.value=length;}
	if(sets2=="")
	{document.frm_mpdd_receipt.txt_no_of_set2.value=length;}
	if(sets3=="")
	{document.frm_mpdd_receipt.txt_no_of_set3.value=length;}
	if(sets4=="")
	{document.frm_mpdd_receipt.txt_no_of_set4.value=length;}
	if(sets5=="")
	{document.frm_mpdd_receipt.txt_no_of_set5.value=length;}
	if(sets6=="")
	{document.frm_mpdd_receipt.txt_no_of_set6.value=length;}
	if(sets7=="")
	{document.frm_mpdd_receipt.txt_no_of_set7.value=length;}
	if(sets8=="")
	{document.frm_mpdd_receipt.txt_no_of_set8.value=length;}
	if(sets9=="")
	{document.frm_mpdd_receipt.txt_no_of_set9.value=length;}
	if(sets10=="")
	{document.frm_mpdd_receipt.txt_no_of_set10.value=length;}

}
</script>
</body>
</html>
<%}%>