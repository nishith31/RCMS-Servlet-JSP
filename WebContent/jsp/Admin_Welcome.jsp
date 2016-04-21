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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" /><meta http-equiv="Content-Language" content="en-us" />
<meta name="description" content="Put a description of the page here" /><meta name="keywords" content="Put your keywords here" /><meta name="robots" content="index,follow" />
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
<title>RCMS ADMIN HOME</title>
<link rel="shortcut icon" href="imgs/favicon.ico" /><script type="text/javascript" src="js/general.js"></script><link href="blu.css" rel="stylesheet" type="text/css" media="all" />
</head>
<%! Connection connection=null;
Statement statement=null,statement_empty=null;
ResultSet rs=null;%>
<%
 try		{
				Class.forName(driver);
				connection=DriverManager.getConnection(url,user_name,pswd);
				statement=connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);				
//				statement_empty=connection.createStatement();				
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
      <li class="current">		<a href="Admin_Welcome.jsp" accesskey="H">							<%=home_menu.trim()%>				</a></li>
      <li >						<a href="Admin_Add.jsp" accesskey="D">								<%=add_menu.trim()%>				</a></li>
	  <li>						<a href="Admin_Update.jsp" accesskey="U">							<%=update_menu.trim()%>				</a></li>
      <li>						<a href="Admin_Report.jsp" accesskey="R">							<%=report_menu.trim()%>				</a></li>
    </ul>
  </div>
  <div id="nav-section">
    <ul><br />
    </ul>
  </div>

  <div id="content"><a name="contentstart" id="contentstart"></a>
    <h1>Home Page </h1>
    <h2>Important Information About RC MDU System</h2>
    <p>	<%!
		 String current_session=null; 
		int total_students=0;
		int total_courses=0;
		int total_program=0;
		int total_rc=0;
		int total_sc=0;
	%>

 	<%
      try
	  {
		rs=statement.executeQuery("select TOP 1 session_name from sessions_"+rc_code+" order by id DESC");
			while(rs.next())
				current_session=rs.getString(1);

		rs=statement.executeQuery("select count(*) from student_"+current_session+"_"+rc_code+"");
			while(rs.next())
				total_students=rs.getInt(1);

		rs=statement.executeQuery("select count(*) from course");
			while(rs.next())
				total_courses=rs.getInt(1);
				
		rs=statement.executeQuery("select count(*) from program");
			while(rs.next())
				total_program=rs.getInt(1);

		rs=statement.executeQuery("select count(*) from study_centre");
			while(rs.next())
				total_sc=rs.getInt(1);

		rs=statement.executeQuery("select count(*) from regional_centre");
			while(rs.next())
				total_rc=rs.getInt(1);
		

		}//end of try blocks
		catch(Exception e)
		{
			out.println("connection error"+e);
		}//end of catch blocks
	%>
    <strong>Current Session is:</strong> &nbsp;<strong><%= current_session.toUpperCase() %></strong><br/>
    <strong>Number of Students in the Session : &nbsp;&nbsp;<%=total_students%>
    <br />
    Number of Courses Available : &nbsp;&nbsp;<%=total_courses%></strong>
    <br />
<strong>    Number of Programs Available : &nbsp;&nbsp;<%=total_program%></strong>
<br />
<strong>    Number of STUDY CENTRES Affliated   : &nbsp;&nbsp;<%=total_sc%></strong>
<br />
<strong>    Number of REGIONAL CENTRES PRESENT : &nbsp;&nbsp;<%=total_rc%></strong>

    </p>
	<ul>
		<li><a href="complete_list">See the Complete list of students in the Session</a></li>
		<li><a href="https://order.kagi.com/?WC4">Know the Most Popular Program in the RC</a></li>
	</ul>
	<p>&nbsp;</p>
    <h2>How to Use this Software:</h2>
	<p>To use this Application just click on the appropriate links as per your need.</p>
	<p>Click on <strong>Despatch</strong> tab to manage all the Despatch related transactions, and <strong>Receive</strong>
    tab to manage all the Receive materials related transactions.</p>
  </div>


  <div id="sidebar">
   				<div id="blink1" class="highlight">
				<% String msg=null;
				try{ msg=(String)request.getAttribute("msg"); }catch(Exception dd){}%>
				<h3><%if(msg!=null)
				out.println(msg); %></h3>
                </div>



                <h3>About the RCMS-MDU:</h3>
    <p>The main idea behind this application is to maintain the Material Inventory of the Regional Centres in an Efficient Way.</p>
    </div>

  <div id="info-site">
    <p id="info-company"><a href="Copyright.jsp" target="_blank">COPYRIGHT</a> | <a href="Privacy.jsp" target="_blank">PRIVACY</a> | <a href="Home.jsp">HOME</a></p>
    <p id="info-standards"><a href="http://www.ignou.ac.in/" target="_blank">[IGNOU]</a></p>
  </div>

</div>


<STYLE type="text/css">
<!--
.css1
{
   position: absolute;
   top: 0px;
   left: 0px;
   width: 16px;
   height: 16px;
   font-family: Arial,sans-serif;
   font-size: 16px;
   text-align: center;
   font-weight: bold;
}

.css2
{
   position: absolute;
   top: 0px;
   left: 0px;
   width: 12px;
   height: 12px;
   font-family: Arial,sans-serif;
   font-size: 12px;
   text-align: center;
}
//-->
</STYLE>

<SCRIPT language="JavaScript" type="text/javascript">

//Silly Clock - http://www.btinternet.com/~kurt.grigg/javascript

var dCol = '#ff0000'; //date colour.
var fCol = '#ff0000'; //face colour.
var sCol = '#0000ff'; //seconds colour.
var mCol = '#ff0000'; //minutes colour.
var hCol = '#ff0000'; //hours colour.

var del = 0.6;        //follow mouse speed.
var rep = 50;         //run speed (setTimeout).

var theDays = new Array("SUNDAY","MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY");
var theMonths = new Array("JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER");
var r,h,w;
var d = document;
var my = 10;
var mx = 10;
var timer = null;
var vis = true;
var ofy = -7;
var ofx = -3;
var ofst = 70;
var date = new Date();
var day = date.getDate();
var year = date.getYear();
 if (year < 2000) year = year+1900; 

var dt = " " + theDays[date.getDay()] + " " + day + " " + theMonths[date.getMonth()] + " " + year;
var todaysDate = dt.split("");
var tdlen = todaysDate.length;

var clockFace = "3 4 5 6 7 8 9 10 11 12 1 2";
var cfa = clockFace.split(" ");
var cflen = cfa.length;

var _h = "...";
var hourfin = _h.split("");
var hlen = hourfin.length;

var _m = "....";
var minfin = _m.split("");
var mlen = minfin.length;

var _s = ".....";
var secfin = _s.split("");
var slen = secfin.length;

var dims = 40;
var Q1 = 360/cflen;
var Q2 = 360/todaysDate.length;
var handlen = dims/5.5;
var dy=new Array();
var dx=new Array();
var zy=new Array();
var zx=new Array();
var theSeconds = new Array();
var theMinutes = new Array(); 
var theHours = new Array();
var theDial = new Array(); 
var theDate = new Array();

var sum = tdlen + cflen + hlen + mlen + slen + 1;
for (i = 0; i < sum; i++){
dy[i] = 0;
dx[i] = 0;
zy[i] = 0;
zx[i] = 0;
}

var pix = "px";
var domWw = (typeof window.innerWidth == "number");
var domSy = (typeof window.pageYOffset == "number");
var idx = d.getElementsByTagName('div').length;

var isButton = (document.getElementById("clockcontrol"));

if (isButton)
var controlButton = document.getElementById("clockcontrol");

if (domWw) r = window;
else{ 
  if (d.documentElement && 
  typeof d.documentElement.clientWidth == "number" && 
  d.documentElement.clientWidth != 0)
  r = d.documentElement;
 else{ 
  if (d.body && 
  typeof d.body.clientWidth == "number")
  r = d.body;
 }
}

for (i=0; i < tdlen; i++){
 document.write('<div id="_date'+(idx+i)+'" class="css2" style="color:'+dCol+'">'+todaysDate[i]+'<\/div>');
}

for (i=0; i < cflen; i++){
 document.write('<div id="_face'+(idx+i)+'" class="css2" style="color:'+fCol+'">'+cfa[i]+'<\/div>');
}

for (i=0; i < hlen; i++){
 document.write('<div id="_hours'+(idx+i)+'" class="css1" style="color:'+hCol+'">'+hourfin[i]+'<\/div>');
}

for (i=0; i < mlen; i++){
 document.write('<div id="_minutes'+(idx+i)+'" class="css1" style="color:'+mCol+'">'+minfin[i]+'<\/div>');
}

for (i=0; i < slen; i++){
 document.write('<div id="_seconds'+(idx+i)+'" class="css1" style="color:'+sCol+'">'+secfin[i]+'<\/div>');
}


function winsize(){
var oh,sy,ow,sx,rh,rw;
if (domWw){
  if (d.documentElement && d.defaultView && 
  typeof d.defaultView.scrollMaxY == "number"){
  oh = d.documentElement.offsetHeight;
  sy = d.defaultView.scrollMaxY;
  ow = d.documentElement.offsetWidth;
  sx = d.defaultView.scrollMaxX;
  rh = oh-sy;
  rw = ow-sx;
 }
 else{
  rh = r.innerHeight;
  rw = r.innerWidth;
 }
h = rh; 
w = rw;
}
else{
h = r.clientHeight; 
w = r.clientWidth;
}
}


function scrl(yx){
var y,x;
if (domSy){
 y = r.pageYOffset;
 x = r.pageXOffset;
 }
else{
 y = r.scrollTop;
 x = r.scrollLeft;
 }
return (yx == 0)?y:x;
}


function OnOff(){
if (vis){ 
 vis = false;
 controlButton.value = "Clock On";
 }
else{ 
 vis = true;
 controlButton.value = "Clock Off";
 Delay();
 }
kill();
}


function kill(){
if (vis) 
 mouseControl(true);
else 
 mouseControl(false);
} 


function mouseControl(needed){
if (window.addEventListener){
 if (needed){
  document.addEventListener("mousemove",mouse,false);
 }
 else{ 
  document.removeEventListener("mousemove",mouse,false);
 }
}  
if (window.attachEvent){
 if (needed){
  document.attachEvent("onmousemove",mouse);
 }
 else{ 
  document.detachEvent("onmousemove",mouse);
 }
}
}


function mouse(e){
var msy = (domSy)?window.pageYOffset:0;
if (!e) e = window.event;    
 if (typeof e.pageY == "number"){
  my = e.pageY + ofst - msy;
  mx = e.pageX + ofst;
 }
 else{
  my = e.clientY + ofst - msy;
  mx = e.clientX + ofst;
 }
if (!vis) kill();
}


function theClock(){
var time = new Date();

var secs = time.getSeconds();
var secOffSet = secs - 15;
if (secs < 15){ 
 secOffSet = secs+45;
}
var sec = Math.PI * (secOffSet/30);

var mins = time.getMinutes();
var minOffSet = mins - 15;
if (mins < 15){ 
 minOffSet = mins+45;
}
var min = Math.PI * (minOffSet/30);

var hrs = time.getHours();
if (hrs > 12){
 hrs -= 12;
}
var hrOffSet = hrs - 3;
if (hrs < 3){ 
 hrOffSet = hrs+9;
}
var hr = Math.PI * (hrOffSet/6) + Math.PI * time.getMinutes()/360;

for (i=0; i < slen; i++){
 theSeconds[i].top = dy[tdlen + cflen + hlen + mlen + i] + ofy + (i * handlen) * Math.sin(sec) + scrl(0) + pix;
 theSeconds[i].left = dx[tdlen + cflen + hlen + mlen + i] + ofx + (i * handlen) * Math.cos(sec) + pix;
 }

for (i=0; i < mlen; i++){
 theMinutes[i].top = dy[tdlen + cflen + hlen + i] + ofy + (i * handlen) * Math.sin(min) + scrl(0) + pix;
 theMinutes[i].left = dx[tdlen + cflen + hlen + i] + ofx + (i * handlen) * Math.cos(min) + pix;
 }

for (i=0; i < hlen; i++){
 theHours[i].top = dy[tdlen + cflen + i] + ofy + (i * handlen) * Math.sin(hr) + scrl(0) + pix;
 theHours[i].left = dx[tdlen + cflen + i] + ofx + (i * handlen) * Math.cos(hr) + pix;
 }

for (i=0; i < cflen; i++){
 theDial[i].top = dy[tdlen + i] + dims * Math.sin(i * Q1 * Math.PI/180) + scrl(0) + pix;
 theDial[i].left = dx[tdlen + i] + dims * Math.cos(i * Q1 * Math.PI/180) + pix;
 }

for (i=0; i < tdlen; i++){
 theDate[i].top = dy[i] + dims * 1.5 * Math.sin(-sec + i * Q2 * Math.PI/180) + scrl(0) + pix;
 theDate[i].left = dx[i] + dims * 1.5 * Math.cos(-sec + i * Q2 * Math.PI/180) + pix;
 }
if (!vis) clearTimeout(timer);
}


function Delay(){
if (!vis){
 dy[0]=-100;
 dx[0]=-100;
}
else{
 zy[0]=Math.round(dy[0]+=((my)-dy[0])*del);
 zx[0]=Math.round(dx[0]+=((mx)-dx[0])*del);
}
for (i=1; i < sum; i++){
 if (!vis){
  dy[i]=-100;
  dx[i]=-100;
 }
 else{
  zy[i]=Math.round(dy[i]+=(zy[i-1]-dy[i])*del);
  zx[i]=Math.round(dx[i]+=(zx[i-1]-dx[i])*del);
 }
if (dy[i-1] >= h-80) dy[i-1]=h-80;
if (dx[i-1] >= w-80) dx[i-1]=w-80;
}
timer = setTimeout(Delay,rep);
theClock();
}


function init(){
for (i=0; i < tdlen; i++){
 theDate[i] = document.getElementById("_date"+(idx+i)).style;
}
for (i=0; i < cflen; i++){
 theDial[i] = document.getElementById("_face"+(idx+i)).style; 
}
for (i=0; i < hlen; i++){
 theHours[i] = document.getElementById("_hours"+(idx+i)).style;
}
for (i=0; i < mlen; i++){
 theMinutes[i] = document.getElementById("_minutes"+(idx+i)).style; 
}
for (i=0; i < slen; i++){
 theSeconds[i] = document.getElementById("_seconds"+(idx+i)).style;         
}
winsize();
mouseControl(true);
Delay();
}

init();

</SCRIPT>
</body>
</html>
<%}%>