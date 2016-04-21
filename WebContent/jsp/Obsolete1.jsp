<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page session="false" %>
<%
HttpSession  sess=request.getSession(false);
if(sess==null)
{
String msg="Please Login to Access MDU";
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
<%int no_of_blocks=Integer.parseInt(request.getParameter("no_of_blocks")); %>
<input type="hidden" name="total_block" value="<%= no_of_blocks %>" />
<title>Damaged</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><link href="blu.css" rel="stylesheet" type="text/css" media="all" /><script type="text/javascript" src="js/general.js"></script>
<script type="text/javascript">
function validateForm()
{
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var date		=	document.frm_obsolete.txt_date.value;
var letters = /^[A-Za-z]+$/;
var numbers = /^[0-9]+$/;
var emailExp = /^[\w\-\.\+]+\@[a-zA-Z0-9\.\-]+\.[a-zA-z0-9]{2,4}$/;
if(date=="" || date.match(letters))
{
	alert("PLEASE SELECT DATE...");
	document.frm_obsolete.txt_date.focus();
	document.frm_obsolete.txt_date.value="";
	return false;
}//end of if
else
{
		var passedDate = new Date(date);
		var currentDate= new Date();
	  if (passedDate > currentDate ) 
	  {
		   alert("PLEASE ENTER CURRENT DATE OR LESS THAN CURRENT DATE");
		   document.frm_obsolete.txt_date.focus();
		   return false;
	  }
}//end of else

if(document.frm_obsolete.check.checked==true)
{
var remarks		=	document.frm_obsolete.write_remarks.value;
	if(remarks=="" || remarks=="Write Other Reason..")
	{
		alert("PLEASE WRITE REMARKS..");		
		document.frm_obsolete.write_remarks.value="";
		document.frm_obsolete.write_remarks.focus();		
		return false;
	}//end of if
}//end of if


}//end of method
function selection()
{
	if(document.frm_obsolete.check.checked==true)
	{
		document.frm_obsolete.write_remarks.disabled=false;
		document.frm_obsolete.mnu_remarks.disabled=true;
		document.frm_obsolete.write_remarks.style="background-color:#0099FF; ";
		document.frm_obsolete.mnu_remarks.style="background-color:#999999; ";
	}
	if(document.frm_obsolete.check.checked==false)
	{
		document.frm_obsolete.write_remarks.disabled=true;
		document.frm_obsolete.mnu_remarks.disabled=false;
		document.frm_obsolete.mnu_remarks.style="background-color:#0099FF; ";
		document.frm_obsolete.write_remarks.style="background-color:#999999; ";
	}


}//end of method selection
function upper()
{
	var str=document.frm_obsolete.write_remarks.value;
	document.frm_obsolete.write_remarks.value=str.toUpperCase();
}

</script></head>
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

<body onLoad="fillCategory();document.frm_obsolete.mnu_prg_code.focus();document.frm_obsolete.write_remarks.disabled=true;">
<form name="frm_obsolete" action="BYOBSOLETESUBMIT" method="post" onsubmit="return validateForm();">
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
      <li>						<a href="Home.jsp" title="HOME"  accesskey="H">						<%=home_menu.trim()%></a>			</li>
      <li >						<a href="Despatch.jsp" title="DESPATCH" accesskey="D">				<%=dispatch_menu.trim()%></a>		</li>
	  <li>						<a href="Receive.jsp" title="RECEIPT" accesskey="R">				<%=receive_menu.trim()%></a>		</li>
      <li class="current">		<a href="Obsolete.jsp" title="DAMAGED MATERIALS" accesskey="G">		<%=obsolete_menu.trim()%></a>		</li>
      <li>						<a href="Enquiry.jsp" title="ENQUIRY" accesskey="E">				<%= enquiry_menu %></a>				</li>
      <li>						<a href="Report.jsp" title="REPORT" accesskey="P">					<%= report_menu %></a>				</li>
     <li>						<a href="Update.jsp" title="UPDATE" accesskey="U">					<%= update_menu %></a>				</li>
    </ul>
  </div>
  <div id="nav-section">
    <ul><br />
    </ul>
  </div>
  <div id="content"><a name="contentstart" id="contentstart"></a>
 			</ul>
    <table width="441" border="0">
      <tr height="30"><%! int tab=0; %>
      <%// int no_of_blocks=Integer.parseInt(request.getParameter("no_of_blocks")); %>
        <td ><strong>PROGRAMME CODE:</strong></td>
        <td><input type="text"  name="mnu_prg_code" class="greysize"  readonly="readonly" value="<%= request.getParameter("prg_code") %>" ></td>
      </tr>
      <tr height="30">
        <td><strong>COURSE CODE:</strong></td>
        <td><input type="text" readonly="readonly" name="mnu_crs_code" class="greysize"  value="<%= request.getParameter("crs_code") %>"></td>
      </tr>
      <tr height="30">
        <td ><strong>SESSION:</strong></td>
        <td>
          <input name="txt_session" type="text" id="txt_session" class="greysize" value="<%=request.getParameter("current_session").toUpperCase()%>" readonly="true" /></td>
      </tr>
      <tr height="30"><input type="hidden" value="<%= request.getParameter("medium") %>" name="medium" />
        <td ><strong>MEDIUM:</strong></td>
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

        
        <td><input type="text" name="txtmedium" class="greysize" value="<%=medium_display%>" ></td>
      </tr>
      </table><hr /><hr />
          <table width="441" border="0">
      <tr height="30">
        <td><strong>BLOCKS:</strong></td>
        <td><strong>NUMBER OF BLOCKS:</strong></td>
      </tr>
      <% for(int index=1;index<=no_of_blocks;index++)
	  {
	   %>
      <tr height="30">
        <td><strong>BLOCK<%= index %></strong></td>
        <td><input name="blocks" class="fieldsize" type="text" id="textid<%= index %>" tabindex="<%= ++tab %>" placeholder="Enter Quantity of Block<%=index%>" /></td>
      </tr>
      <% } %>
      <tr height="30">
        <td><strong>DATE:</strong></td>
        <td><input name="txt_date" class="fieldsize" type="text" id="datepicker" tabindex="<%= ++tab %>" placeholder="CLICK TO SELECT DATE" required/></td>
      </tr>
      <tr height="30">
        <td  rowspan="3"><strong>REMARKS:</strong></td>
        <td><select name="mnu_remarks" id="mnu_remarks" class="fieldsize" tabindex="<%= ++tab %>">
          <option value="NOT USABLE">NOT USABLE</option>
          <option value="WASTED">WASTED</option>
          <option value="COURSE DISCONTINUED">COURSE DISCONTINUED</option>
          <option value="OLD SYLLABUS">OLD SYLLABUS</option>
        </select></td>
        </tr>
      <tr height="30">
        <td> 
          <div align="justify">
            <input type="checkbox" name="check" id="check" onclick="selection();" tabindex="<%= ++tab %>" />
          OR</div></td>
      </tr>
      <tr height="30">
        <td><strong>
            <input type="text" name="write_remarks" id="write_remarks" class="fieldsize" onchange="upper();" tabindex="<%= ++tab %>" placeholder="Write Other Remarks"/>
            </strong></td>
      </tr>
      <tr><input type="hidden" name="remarks" value="" />
        <td><div align="center">
          <input name="reset" type="reset" class="button" id="reset" value="CLEAR FIELDS" tabindex="<%= tab+2 %>" onclick="document.frm_obsolete.mnu_prg_code.focus();" />
        </div></td>
        <td><div align="center">
          <input name="enter" type="submit" class="button" id="enter" value="OBSOLETE" onclick="return remarksvalue();" tabindex="<%= ++tab %>"/>
        </div></td>
      </tr>
    </table>
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
        <li><a href="Home.jsp">RCMS HOME</a></li>
        <li><a href="Despatch.jsp">DESPATCH HOME</a></li>
        <li><a href="Receive.jsp">RECEIVE HOME</a></li>
        <li><a href="day.jsp">DAY CALCULATOR APP</a></li>
        <li><a href="Update_parcel_no.jsp">PARCEL NUMBER UPDATE</a></li>
      </ul>
    </div>
    <h3>ABOUT DAMAGED SECTION:</h3>
    <p>The Materials which are Damaged Due to Various reasons are going to affect the Inventory of materials as it will be subtracted from the inventory.All the Transactions related to the Damaged Materials are entered in the System through this Page.</p>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>
</form>
	    <link rel="stylesheet" href="js/jquery-ui.css"  type="text/css" media="all"/>
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
    <script>       $(function() {       $( "#datepicker" ).datepicker();       });	</script>
    <script>
	function remarksvalue()
	{
		if(document.frm_obsolete.check.checked==false)
		{
			document.frm_obsolete.remarks.value=document.frm_obsolete.mnu_remarks.value;
		}
		else	
		{
			document.frm_obsolete.remarks.value=document.frm_obsolete.write_remarks.value;
		}
		//logic for number of blocks to be auto-filled 0 if left unfilled by user 
		var flag = 0;
		<%for(int i=1;i<=no_of_blocks;i++)
		{%>
		var blk_no = document.getElementById('textid<%=i%>').value;
		if(blk_no == "" || blk_no == 0 || blk_no < 0)
		{
			document.getElementById('textid<%=i%>').value=0;
		}
		else
		flag = 1;
		<%}%>
		if(flag == 0)
		{
			alert('Please Enter Number Of Blocks To Be Obsoleted for At Least One Block');
			return false;
		}
		else
		return true;

}//end of method remarksvalue
</script>
</body>
</html>
<%
}
%>