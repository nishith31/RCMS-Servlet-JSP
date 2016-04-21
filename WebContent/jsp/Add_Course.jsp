<%@ page import="java.util.Date" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.net.InetAddress,java.net.UnknownHostException" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
String uname=null;
uname=(String)sess.getAttribute("admin_user");
if(sess==null || uname==null)
{
	String msg="Please Login As Admin to Access MDU System";
	request.setAttribute("msg",msg);
	request.getRequestDispatcher("login.jsp").forward(request,response);
}
else
{
	String rc_code=(String)sess.getAttribute("rc");
	uname=(String)sess.getAttribute("admin_user");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<meta http-equiv="Content-Language" content="en-us" />
		<meta name="description" content="Put a description of the page here" />
		<meta name="keywords" content="Put your keywords here" />
		<meta name="robots" content="index,follow" />
		<%  
			ResourceBundle rb=ResourceBundle.getBundle("NishithBundle",Locale.getDefault());
			String home_menu=rb.getString("admin_home_menu");
			String add_menu=rb.getString("admin_add_menu");				
			String update_menu=rb.getString("admin_update_menu");	
			String report_menu=rb.getString("admin_report_menu");	
			String driver=rb.getString("driver");
    		String url=rb.getString("connectionurl");
			String user_name=rb.getString("username");
			String pswd=rb.getString("password");
		%>
		<title>ADD COURSE</title>
		<link rel="shortcut icon" href="imgs/favicon.ico" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/general.js"></script>
		<link href="${pageContext.request.contextPath}/css/blu.css" rel="stylesheet" type="text/css" media="all" />
		<script type = "text/javascript">
			function validateForm()
			{
				var program 		= document.form_course.mnu_prg_code.value;
				var code			= document.form_course.text_course_code.value;
				var name			= document.form_course.text_course_name.value;
				var credit			= document.form_course.text_credit.value;
				var blocks			= document.form_course.text_no_of_block.value;
				var letters 		= /^[A-Za-z]+$/;
				var numbers 		= /^[0-9]+$/;
				if(program=="0" )
				{
					alert("PLEASE SELECT PROGRAMME CODE FIRST...");
					document.form_course.mnu_prg_code.focus();
					return false;
				}
				if(code=="" || code.match(numbers))
				{
					alert("PLEASE ENTER NEW COURSE CODE...");
					document.form_course.text_course_code.value="";
					document.form_course.text_course_code.focus();
					return false;
				}
				if(name=="" || name.match(numbers))
				{
					alert("PLEASE ENTER NEW COURSE NAME CORRECTLY ...");
					document.form_course.text_course_name.value="";
					document.form_course.text_course_name.focus();
					return false;
				}
				if(credit.length==0 || credit>20 || credit.match(letters))
				{
					alert("PLEASE ENTER COURSE CREDIT NOT EXCEEDING 20 ...");
					document.form_course.text_credit.value="";	
					document.form_course.text_credit.focus();
					return false;
				}
				if(blocks>15 || blocks.match(letters) || blocks==0 || blocks==null)
				{
					alert("PLEASE ENTER NUMBER OF BLOCKS NOT EXCEEDING 15 ...");
					document.form_course.text_no_of_block.value="";
					document.form_course.text_no_of_block.focus();
					return false;
				}
			}
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
		}//end of try blocks
		catch(Exception e)
		{		out.println("connection error"+e);	}//end of catch blocks
  	%>

	<body>
		<div id="container">
			<div id="banner">
    			<h1>RCMS-MDU ADMIN</h1>
    			<div id="nav-meta">
    				<ul>
        				<li style="color:#FFFFFF">RC:&nbsp;<%= rc_code%></li>
        				<li style="color:#FFFFFF">Welcome <%= uname%></li>
                		<li style="color:#FFFFFF"><a href="LogOut" title="CLICK TO LOG OUT" accesskey="Z">Log out</a></li>
					</ul>
    			</div>
  			</div>
  			<div id="nav-main">
    			<ul>
      				<li><a href="${pageContext.request.contextPath}/jsp/Admin_Welcome.jsp" accesskey="H"><%=home_menu.trim()%></a></li>
      				<li class="current"><a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  				<li><a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      				<li><a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    			</ul>
  			</div>
  			<div id="nav-section">
    			<ul>
					<li class="youarehere"><a href="${pageContext.request.contextPath}/jsp/Add_Course.jsp" accesskey="C">																		<U>C</U>OURSE			</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/Add_Program.jsp" accesskey="P">																						<U>P</U>ROGRAM			</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/Add_RC.jsp" accesskey="G">																								RE<U>G</U>IONAL CENTRE	</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/Add_SC.jsp" accesskey="S">																								<U>S</U>TUDY CENTRE		</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/Add_Medium.jsp" accesskey="E">																							M<U>E</U>DIUM			</a></li>   
					<li><a href="${pageContext.request.contextPath}/jsp/Session_Create.jsp" accesskey="N">																						SESSIO<U>N</U>			</a></li>
					<li><a href="${pageContext.request.contextPath}/jsp/Abbreviation_Page.jsp" title="CLICK TO CREATE SHORT NAME FOR LONG NAMES" accesskey="V">								ABBRE<U>V</U>IATION		</a></li> 
					<li><a href="${pageContext.request.contextPath}/jsp/Add_user.jsp" title="CLICK TO CREATE NEW USER ">																		USER					</a></li>
				</ul>
 			</div>

  <div id="content"><a name="contentstart" id="contentstart"></a>

<form name="form_course" action="${pageContext.request.contextPath}/ADDCOURSE" onSubmit="return validateForm();" method="post">
    <table width="468" height="339" border="0">
      <tr><%int tab=0;%>
        <td width="214"><strong><span class="style4">PROGRAMME CODE:</span></strong></td>
        <td width="244"><select name="mnu_prg_code" tabindex="<%= ++tab %>" class="fieldsize" autofocus >
          <option value = "0">SELECT PROGRAMME</option>
								<%int i=1;
								  try
									{
											rs=statement.executeQuery("select prg_code from program");
											while(rs.next())
												{
													out.println("<option value ="+rs.getString(1)+">"+rs.getString(1)+"</option>");
														i++;
												}
													}	
										catch(Exception e)
										{out.println("connection error"+e);}
									%>
        </select></td>
      </tr>
      <tr>
        <td><strong><span class="style4">NEW COURSE CODE: </span></strong></td>
        <td><input name="text_course_code" type="text" id="text_course_code" tabindex="<%= ++tab %>" class="fieldsize" placeholder="Enter New Course Code" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)" required/>
        <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" />
        </td>
      </tr>
      <tr>
        <td><strong><span class="style4">NEW COURSE NAME:</span></strong></td>
        <td>
<input name="text_course_name" type="text" id="text_course_name" tabindex="<%= ++tab %>" class="fieldsize" placeholder="Enter New Course Name" onchange="upper(this)" onmouseover="mover(this)"  onmouseout="mout(this)"/>
        </td>
      </tr>
      <tr>
        <td><strong><span class="style4">COURSE CREDIT:</span></strong></td>
        <td><input name="text_credit" type="text" id="text_credit" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" placeholder="Enter Credit for New Course" onmouseover="mover(this)"  onmouseout="mout(this)"/></td>
      </tr>
      <tr>
        <td><strong><span class="style4">NUMBER OF THE BLOCKS:</span></strong></td>
        <td>
<input name="text_no_of_block" type="text" id="text_no_of_block" tabindex="<%= ++tab %>" class="fieldsize" onchange="upper(this)" placeholder="Enter Number of Blocks" onmouseover="mover(this)"  onmouseout="mout(this)" required/>
        <img src="imgs/asterisk.gif" width="13" height="12" alt="Required!" />
        </td>
      </tr>
      <tr>
        <td><strong>MEDIUMS:</strong></td>
        <td><strong>INITIAL QUANTITY</strong></td>
      </tr>
        <%String check=null,temp=null;
				try
				{
				rs=statement_empty.executeQuery("select * from medium order by id asc");			
				while(rs.next())
				{check=rs.getString(1);
				temp=rs.getString(2);%>
    				<tr>  <td><strong><%=temp%></strong></td>
        			  <td>
 <input type="text" name="<%= check %>" class="fieldsize" onmouseover="mover(this)"  onmouseout="mout(this)" onchange="upper(this)" tabindex="<%= ++tab %>" placeholder="Quantity in <%=temp%> Medium"/></td>            
          </tr>
				<%}//end of while
				}
			catch(Exception e){out.println("excepiton is"+e);}%>
       <tr>
        <td><div align="center">
          <input name="reset" type="reset" class="button" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" onclick="document.form_course.mnu_prg_code.focus();"/>
        </div></td>
        <td><div align="center">
          <input name="enter" type="submit" id="enter" value="ADD COURSE" tabindex="<%= ++tab %>" class="button"/>
        </div></td>
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
                <%if(msg==null){%>
    <h3>Addition of New Course:</h3>
    <p>To Add a new Course to the Database you need to provide the details of the Course accurately as these details are used in the Application and any wrong information will decrease the Performance and each Course is uniquely identified by its Course code so Course with same Course code will not be accepted by the System.</p>
    <div id="nav-supp">
        <h3>Quick Access to</h3>
      <ul>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Add.jsp">Add Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Update.jsp">Updation Section</a></li>
        <li><a href="${pageContext.request.contextPath}/jsp/Admin_Report.jsp"> Material Entry</a></li>
      </ul>
    </div>
    <%}%>
    </div>
  <div id="info-site">
    <p id="info-company"><a href="${pageContext.request.contextPath}/jsp/Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="${pageContext.request.contextPath}/jsp/Privacy.jsp" target="_blank">PRIVACY</a> | <a href="${pageContext.request.contextPath}/jsp/Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>
</div>
</body>
</html>
<%}%>